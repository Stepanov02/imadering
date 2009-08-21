unit JabberProtoUnit;

interface

uses
  Windows, MainUnit, SysUtils, JvTrayIcon, Dialogs, OverbyteIcsWSocket,
  ChatUnit, MmSystem, Forms, ComCtrls, Messages, Classes, IcqContactInfoUnit,
  Code, VarsUnit, Graphics, CategoryButtons, rXML, JvZLibMultiple,
  OverbyteIcsMD5, OverbyteIcsMimeUtils, JabberOptionsUnit;

var
  Jabber_LoginUIN: string = '';
  Jabber_LoginPassword: string = '';
  Jabber_ServerAddr: string = 'jabber.ru';
  Jabber_ServerPort: string = '5222';
  Jabber_Reconnect: boolean = false;
  Jabber_KeepAlive: boolean = true;
  Jabber_myBeautifulSocketBuffer: string;
  Jabber_CurrentStatus: integer = 30;
  Jabber_CurrentStatus_bac: integer = 30;
  Jabber_Seq: word = 0;
  JabberResurs: string = 'IMadering';
  //--���� ������ ������
  Jabber_Connect_Phaze: boolean = false;
  Jabber_HTTP_Connect_Phaze: boolean = false;
  Jabber_Work_Phaze: boolean = false;
  Jabber_Offline_Phaze: boolean = true;
  //--���� ������ �����
  StreamHead: string = '<?xml version=''1.0'' encoding=''UTF-8''?>' +
  '<stream:stream to=''%s'' xmlns=''jabber' +
    ':client'' xmlns:stream=''http://etherx.jabber.org/streams'' xm' +
    'l:lang=''ru'' version=''1.0''>';
  IqTypeSet: string = '<iq type=''set'' id=''imadering_%d''>';

function JabberDIGESTMD5_Auth(User, Host, Password, nonce, cnonce: string): string;
procedure Jabber_GoOffline;
function Jabber_SetBind: string;
function Jabber_SetSession: string;

implementation

uses
  UtilsUnit;

function GenResponse(UserName, realm, digest_uri, Pass, nonce, cnonce: string): string;
const
  nc = '00000001';
  gop = 'auth';
var
  A2, HA1, HA2, sJID: string;
  Razdel: Byte;
  Context: TMD5Context;
  DigestJID: TMD5Digest;
  DigestHA1: TMD5Digest;
  DigestHA2: TMD5Digest;
  DigestResponse: TMD5Digest;
begin
  Razdel := Ord(':');
  //--��������� �1 �� ������� RFC 2831
  sJID := format('%S:%S:%S', [username, realm, Pass]);
  MD5Init(Context);
  MD5UpdateBuffer(Context, PByteArray(@sJID[1]), Length(sJID));
  MD5Final(DigestJID, Context);
  MD5Init(Context);
  MD5UpdateBuffer(Context, PByteArray(@DigestJID), SizeOf(TMD5Digest));
  MD5UpdateBuffer(Context, @Razdel, SizeOf(Razdel));
  MD5UpdateBuffer(Context, PByteArray(@nonce[1]), Length(nonce));
  MD5UpdateBuffer(Context, @Razdel, SizeOf(Razdel));
  MD5UpdateBuffer(Context, PByteArray(@cnonce[1]), Length(cnonce));
  MD5Final(DigestHA1, Context);
  //--��������� �2 �� ������� RFC 2831
  A2 := format('AUTHENTICATE:%S', [digest_uri]);
  MD5Init(Context);
  MD5UpdateBuffer(Context, PByteArray(@A2[1]), Length(A2));
  MD5Final(DigestHA2, Context);
  //--��������� RESPONSE �� ������� RFC 2831
  HA1 := LowerCase(PacketToHex(@DigestHA1, SizeOf(TMD5Digest)));
  HA2 := LowerCase(PacketToHex(@DigestHA2, SizeOf(TMD5Digest)));
  MD5Init(Context);
  MD5UpdateBuffer(Context, PByteArray(@HA1[1]), Length(HA1));
  MD5UpdateBuffer(Context, @Razdel, SizeOf(Razdel));
  MD5UpdateBuffer(Context, PByteArray(@nonce[1]), Length(nonce));
  MD5UpdateBuffer(Context, @Razdel, SizeOf(Razdel));
  MD5UpdateBuffer(Context, PByteArray(@nc[1]), Length(nc));
  MD5UpdateBuffer(Context, @Razdel, SizeOf(Razdel));
  MD5UpdateBuffer(Context, PByteArray(@cnonce[1]), Length(cnonce));
  MD5UpdateBuffer(Context, @Razdel, SizeOf(Razdel));
  MD5UpdateBuffer(Context, PByteArray(@gop[1]), Length(gop));
  MD5UpdateBuffer(Context, @Razdel, SizeOf(Razdel));
  MD5UpdateBuffer(Context, PByteArray(@HA2[1]), Length(HA2));
  MD5Final(DigestResponse, Context);
  Result := LowerCase(PacketToHex(@DigestResponse, SizeOf(TMD5Digest)))
end;

function JabberDIGESTMD5_Auth(User, Host, Password, nonce, cnonce: string): string;
var
  Str, Response: string;
begin
{ username   - ��� JIDNode
  realm      - ���� ������
  nonce      - ���������� ������ ���������� ��� ����� ��������
  cnonce     - 64 ��� ���������� ���������
  digest-uri - �������� ������ � �������� ����� ����� �� �����������, ���������� �� ����� � ���� ���������
  response   - ������ (���������� �� 32 ���� HEX -  �����������) }
  //--�������� ������
  Response := GenResponse(User, Host, 'xmpp/' + host, Password, nonce, cnonce);
  //--��������� ������ � ������� UTF-8
  Str := UTF8Encode(Format('username="%s",realm="%s",nonce="%s",cnonce="%s",nc=00000001,' +
    'qop=auth,digest-uri="xmpp/%s",charset=utf-8,response=%s', [User, Host, nonce, cnonce, host, Response]));
  //--������� ������ ���������� Base64
  Str := Base64Encode(Str);
  Result := Format('<response xmlns=''urn:ietf:params:xml:ns:xmpp-sasl''>%s</response>', [Str]);
end;

procedure Jabber_GoOffline;
var
  i, ii: integer;
begin
  //--��������� ������ ������
  with MainForm.JvTimerList do
  begin
    Events[9].Enabled := false;
  end;
  //--���� ���������� ����� �������� ��������� Jabber, �� ��������� ��� ��������
  if Assigned(JabberOptionsForm) then
  begin
    with JabberOptionsForm do
    begin
      JabberJIDEdit.Enabled := true;
      JabberJIDEdit.Color := clWindow;
      PassEdit.Enabled := true;
      PassEdit.Color := clWindow;
    end;
  end;
  //--���������� ���� ������� � �������� ������ �������
  Jabber_Connect_Phaze := false;
  Jabber_HTTP_Connect_Phaze := false;
  Jabber_Work_Phaze := false;
  Jabber_Offline_Phaze := true;
  Jabber_myBeautifulSocketBuffer := EmptyStr;
  Jabber_Seq := 0;
  //--���� ����� ���������, �� �������� ����� "�� ��������"
  with MainForm do
  begin
    if JabberWSocket.State = wsConnected then JabberWSocket.SendStr('</stream:stream>');
    //--��������� �����
    JabberWSocket.Abort;
    //--������ ������ � �������� ������� �������
    Jabber_CurrentStatus := 30;
    JabberToolButton.ImageIndex := Jabber_CurrentStatus;
    JabberTrayIcon.IconIndex := Jabber_CurrentStatus;
    //--������������ � ���� ������� Jabber ������ �������
    JabberStatusOffline.Default := true;
  end;
  //--���������� ������ ��������� � �� � �������
  with MainForm.ContactList do
  begin
    for i := 0 to Categories.Count - 1 do
    begin
      if Categories[i].GroupType = 'Jabber' then
      begin
        if (Categories[i].GroupId = 'NoCL') or (Categories[i].Items.Count = 0) then Continue;
        //--������� ��������� ������-��������� � ������� ���������� ��
        Categories[i].Caption := Categories[i].GroupCaption + ' - ' + '0' + GroupInv + IntToStr(Categories[i].Items.Count);
        //--������� �������
        for ii := 0 to Categories[i].Items.Count - 1 do
        begin
          if (Categories[i].Items[ii].Status = 30) and
            (Categories[i].Items[ii].ImageIndex = 30) then Continue
          else
          begin
            Categories[i].Items[ii].Status := 30;
            Categories[i].Items[ii].ImageIndex := 30;
          end;
          Categories[i].Items[ii].ImageIndex1 := -1;
          //--�� ������������ ���������
          Application.ProcessMessages;
        end;
      end;
    end;
  end;
  //--���������������� ������� ���� ���� �� ��� � ������ ����������
  MainForm.ContactList.Enabled := true;
  //--���� ���� ���� ����������, ���������� ������ �� �������� � �������
  if Assigned(ChatForm) then
  begin
    with ChatForm.ChatPageControl do
    begin
      if Visible then
      begin
        for i := 0 to PageCount - 1 do
        begin
          if Pages[i].Tag = 30 then Continue
          else if (Pages[i].Tag > 27) and (Pages[i].Tag < 41) then
          begin
            Pages[i].Tag := 30;
            Pages[i].ImageIndex := 30;
          end;
          //--�� ������������ ���������
          Application.ProcessMessages;
        end;
      end;
    end
  end;
  //--��������� ������� ���������, �� ��� �� � ������
  MainForm.ZipHistory;
end;

function Jabber_SetBind: string;
begin
  Result := Format(IqTypeSet, [Jabber_Seq]) + '<bind xmlns=''urn:ietf:params:xml:ns:xmpp-bind''>' +
    '<resource>' + JabberResurs + '</resource></bind></iq>';
  //--����������� ������� ��������� jabber �������
  Inc(Jabber_Seq);
end;

function Jabber_SetSession: string;
begin
  Result := Format(IqTypeSet, [Jabber_Seq]) + '<session xmlns=''urn:ietf:params:xml:ns:xmpp-session''/>' +
    '</iq>';
  //--����������� ������� ��������� jabber �������
  Inc(Jabber_Seq);
end;

end.

