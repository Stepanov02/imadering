unit JabberProtoUnit;

interface

uses
  Windows, MainUnit, SysUtils, JvTrayIcon, Dialogs, OverbyteIcsWSocket,
  ChatUnit, MmSystem, Forms, ComCtrls, Messages, Classes, IcqContactInfoUnit,
  Code, VarsUnit, Graphics, CategoryButtons, rXML, JvZLibMultiple,
  OverbyteIcsMD5, OverbyteIcsMimeUtils, JabberOptionsUnit, RosterUnit;

var
  Jabber_BuffPkt: string = '';
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
  JabberPriority: string = '30';
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
  IqTypeGet: string = '<iq type=''get'' id=''imadering_%d''>';
  FRootTag: string = 'stream:stream';
  Iq_Roster: string = 'jabber:iq:roster';
  JmessHead: string = '<message type=''chat'' to=''%s'' id=''%d''>';

function JabberDIGESTMD5_Auth(User, Host, Password, nonce, cnonce: string): string;
procedure Jabber_GoOffline;
function Jabber_SetBind: string;
function Jabber_SetSession: string;
function Jabber_GetRoster: string;
function Jabber_SetStatus(jStatus: integer): string;
procedure Jabber_ParseRoster(XmlData: string);
procedure Jabber_ParseFeatures(XmlData: string);
procedure Jabber_ParseIQ(XmlData: string);
procedure Jabber_SendMessage(mJID, Msg: string);

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
  Jabber_BuffPkt := EmptyStr;
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

function Jabber_GetRoster: string;
begin
  Result := Format(IqTypeGet, [Jabber_Seq]) + '<query xmlns=''jabber:iq:roster''/></iq>';
  //--����������� ������� ��������� jabber �������
  Inc(Jabber_Seq);
end;

function Jabber_SetStatus(jStatus: integer): string;
var
  st: string;
begin
  //--��������� ������ ������
  case jStatus of
    29: st := '<show>away</show>';
    32: st := '<show>dnd</show><x xmlns=''qip:x:status'' value=''8''/>';
    33: st := '<show>dnd</show>';
    34: st := '<show>xa</show>';
    35: st := '<show>away</show><x xmlns=''qip:x:status'' value=''10''/>';
    36: st := '<show>chat</show>';
    37: st := '<x xmlns=''qip:x:status'' value=''5''/>';
    38: st := '<x xmlns=''qip:x:status'' value=''4''/>';
    39: st := '<x xmlns=''qip:x:status'' value=''6''/>';
    40: st := '<x xmlns=''qip:x:status'' value=''7''/>';
  else st := '';
  end;
  //--��������� �����
  Result := '<presence><priority>' + JabberPriority + '</priority>' +
    '<c xmlns=''http://jabber.org/protocol/caps'' node=''http://imadering.com/caps'' ver=''0.5.0.0''/>' +
    st + '</presence>';
end;

procedure Jabber_ParseRoster(XmlData: string);
var
  cnt, i: integer;
  ListItemD: TListItem;
begin
  cnt := 0;
  //--�������������� XML
  with TrXML.Create() do
  try
    begin
      Text := XmlData;
      if OpenKey('query') then
      try
        cnt := GetKeyCount('item');
      finally
        CloseKey();
      end;
      //--��������� ������ �������� Jabber
      //--�������� ��������� ������� ��������� � ������
      RosterForm.RosterJvListView.Items.BeginUpdate;
      for i := 0 to cnt - 1 do
      begin
        if OpenKey('query\item', false, i) then
        try
          ListItemD := RosterForm.RosterJvListView.Items.Add;
          ListItemD.Caption := ReadString('jid');
          ListItemD.SubItems.Add(ReadString('name'));
          ListItemD.SubItems.Add('');
          ListItemD.SubItems.Add(ReadString('subscription'));
          //--��������� ���� ������
          OpenKey('group', false, 0);
          ListItemD.SubItems.Strings[1] := GetKeyText;
          ListItemD.SubItems.Add('Jabber');
        finally
          CloseKey();
        end;
        //--������������� ����
        Application.ProcessMessages;
      end;
      //--����������� ��������� ������� ��������� � ������
      RosterForm.RosterJvListView.Items.EndUpdate;
      //--��������� ��������� �������
      RosterForm.UpdateFullCL;
    end;
  finally
    Free();
  end;
end;

procedure Jabber_ParseFeatures(XmlData: string);
begin
  //--�������������� XML
  with TrXML.Create() do
  try
    begin
      Text := XmlData;
      if OpenKey('stream:features\bind') then
      try
        //--������������� bind
        MainForm.JabberWSocket.SendStr(UTF8Encode(Jabber_SetBind));
      finally
        CloseKey();
      end;
      if OpenKey('stream:features\session') then
      try
        //--������������� session
        MainForm.JabberWSocket.SendStr(UTF8Encode(Jabber_SetSession));
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
  end;
end;

procedure Jabber_ParseIQ(XmlData: string);
begin
  //--�������������� XML
  with TrXML.Create() do
  try
    begin
      Text := XmlData;
      if OpenKey('iq\session') then
      try
        begin
          //--����������� ������ ���������
          MainForm.JabberWSocket.SendStr(UTF8Encode(Jabber_GetRoster));
          //--������������� ������
          MainForm.JabberWSocket.SendStr(UTF8Encode(Jabber_SetStatus(Jabber_CurrentStatus)));
        end;
      finally
        CloseKey();
      end
      else if OpenKey('iq\query') then
      try
        begin
          //--��������� ������ �������� Jabber
          if ReadString('xmlns') = Iq_Roster then Jabber_ParseRoster(GetKeyXML);
        end;
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
  end;
end;

procedure Jabber_SendMessage(mJID, Msg: string);
var
  m: string;
begin
  //--���������� ��������� ��� jabber ��������
  m := Format(JmessHead, [mJID, Jabber_Seq]) + '<body>' + Msg + '</body></message>';
  MainForm.JabberWSocket.SendStr(UTF8Encode(m));
  //--����������� ������� ��������� jabber �������
  Inc(Jabber_Seq);
end;

end.

