unit JabberProtoUnit;

interface

uses
  Windows, MainUnit, SysUtils, JvTrayIcon, Dialogs, OverbyteIcsWSocket,
  ChatUnit, MmSystem, Forms, ComCtrls, Messages, Classes, IcqContactInfoUnit,
  Code, VarsUnit, Graphics, CategoryButtons, rXML, JvZLibMultiple,
  OverbyteIcsMD5, OverbyteIcsMimeUtils;

var
  Jabber_LoginUIN: string = '';
  Jabber_LoginPassword: string = '';
  Jabber_ServerAddr: string = 'jabber.ru';
  Jabber_ServerPort: string = '5222';
  Jabber_Reconnect: boolean = false;
  Jabber_myBeautifulSocketBuffer: string;
  //--���� ������ ������
  Jabber_Connect_Phaze: boolean = false;
  Jabber_HTTP_Connect_Phaze: boolean = false;
  Jabber_BosConnect_Phaze: boolean = false;
  Jabber_Work_Phaze: boolean = false;
  Jabber_Offline_Phaze: boolean = true;
  //--���� ������ �����

function JabberDIGESTMD5_Auth(User, Host, Password, nonce, cnonce: string): string;
procedure Jabber_GoOffline;

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
  Result := Format('<response xmlns=''urn:ietf:params:xml:ns:xmpp-sasl''>%S</response>', [Str]);
end;

procedure Jabber_GoOffline;
//var
//  i, ii: integer;
begin
  {//--��������� ������ ������ ������ ����������� � ������ ������
  with MainForm.JvTimerList do
  begin
    Events[5].Enabled := false;
    Events[7].Enabled := false;
  end;
  //--���� ���������� ����� �������� ��������� ICQ, �� ��������� ��� ��������
  if Assigned(IcqOptionsForm) then
  begin
    with IcqOptionsForm do
    begin
      NoAutoAuthRadioButton.Enabled := false;
      YesAutoAuthRadioButton.Enabled := false;
      ShowWebAwareCheckBox.Enabled := false;
      ICQUINEdit.Enabled := true;
      ICQUINEdit.Color := clWindow;
      PassEdit.Enabled := true;
      PassEdit.Color := clWindow;
    end;
  end;
  //--���������� ���� ������� � �������� ������ �������
  ICQ_Connect_Phaze := false;
  ICQ_HTTP_Connect_Phaze := false;
  ICQ_BosConnect_Phaze := false;
  ICQ_Work_Phaze := false;
  ICQ_Offline_Phaze := true;
  ICQ_SSI_Phaze := false;
  ICQ_myBeautifulSocketBuffer := EmptyStr;
  ICQ_HexPkt := EmptyStr;
  //--�������� ���������� ���������
  ICQ_Online_IP := EmptyStr;
  ICQ_MyUIN_RegTime := EmptyStr;
  ICQ_MyIcon_Hash := EmptyStr;
  ICQ_UpdatePrivateGroup_Code := EmptyStr;
  ICQ_CollSince := EmptyStr;
  ICQ_SendMess := EmptyStr;
  ICQ_OnlineTime := EmptyStr;
  ICQ_AwayMess := EmptyStr;
  ICQ_RecMess := EmptyStr;
  ICQ_LastActive := EmptyStr;
  //--���� ����� ���������, �� �������� ����� "�� ��������"
  if MainForm.ICQWSocket.State = wsConnected then
    MainForm.ICQWSocket.SendStr(Hex2Text('2A04' + IntToHex(ICQ_Seq1, 4) + '0000'));
  //--��������� �����
  MainForm.ICQWSocket.Close;
  //--������ ������ � �������� ������� �������
  ICQ_CurrentStatus := 9;
  MainForm.ICQToolButton.ImageIndex := ICQ_CurrentStatus;
  MainForm.ICQTrayIcon.IconIndex := ICQ_CurrentStatus;
  //--������������ � ���� ������� ICQ ������ �������
  for i := 0 to MainForm.ICQPopupMenu.Items.Count - 1 do
  begin
    if MainForm.ICQPopupMenu.Items.Items[i].Tag = 999 then
    begin
      MainForm.ICQPopupMenu.Items.Items[i].Default := true;
      Break;
    end;
  end;
  //--���������� ������ ��������� � �� � �������
  with MainForm.ContactList do
  begin
    for i := 0 to Categories.Count - 1 do
    begin
      if Categories[i].GroupId = 'NoCL' then Continue;
      for ii := 0 to Categories[i].Items.Count - 1 do
      begin
        if (Categories[i].Items[ii].Status = 9) and
          (Categories[i].Items[ii].ImageIndex = 9) then Continue
        else
        begin
          Categories[i].Items[ii].Status := 9;
          Categories[i].Items[ii].ImageIndex := 9;
        end;
        Categories[i].Items[ii].ImageIndex1 := -1;
        //--�� ������������ ���������
        Application.ProcessMessages;
      end;
    end;
  end;
  //--���������������� ������� ���� ���� �� ��� � ������ ����������
  MainForm.ContactList.Enabled := true;
  //--������� ��������� ������-��������� � ������� ���������� ��
  with MainForm.ContactList do
  begin
    for i := 0 to Categories.Count - 1 do
    begin
      if (Categories[i].GroupId = '0000') or (Categories[i].GroupId = 'NoCL') or
        (Categories[i].Items.Count = 0) then Continue;
      Categories[i].Caption := Categories[i].GroupCaption + ' - ' + '0' + GroupInv + IntToStr(Categories[i].Items.Count);
    end;
  end;
  //--���� ���� ���� ����������, ���������� ������ �� �������� � �������
  if Assigned(ChatForm) then
  begin
    with ChatForm.ChatPageControl do
    begin
      if Visible then
      begin
        for i := 0 to PageCount - 1 do
        begin
          if Pages[i].ImageIndex = 9 then Continue
          else
          begin
            Pages[i].Tag := 9;
            Pages[i].ImageIndex := 9;
          end;
          //--�� ������������ ���������
          Application.ProcessMessages;
        end;
      end;
    end
  end;
  //--��������� ������� ���������, �� ��� �� � ������
  MainForm.ZipHistory;}
end;

end.

