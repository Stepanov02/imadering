{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit JabberProtoUnit;

interface

uses
  Windows, MainUnit, SysUtils, JvTrayIcon, Dialogs, OverbyteIcsWSocket,
  ChatUnit, MmSystem, Forms, ComCtrls, Messages, Classes, IcqContactInfoUnit,
  UnitCrypto, VarsUnit, Graphics, CategoryButtons, rXML, JvZLibMultiple,
  OverbyteIcsMD5, OverbyteIcsMimeUtils, JabberOptionsUnit, RosterUnit;

const
  CONST_Jabber_DefaultServerSSLPort: string = '5223';
  CONST_Jabber_DefaultServerNoSecurePort: string = '5222';

var
  Jabber_UseSSL: boolean = False;
  Jabber_BuffPkt: string = '';
  Jabber_JID: string = '';
  Jabber_LoginUIN: string = '';
  Jabber_LoginPassword: string = '';
  Jabber_ServerAddr: string = '';
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
  JPlainMechanism: string = '<auth xmlns=''urn:ietf:params:xml:ns:xmpp-sasl'' mechanism=''PLAIN''>%s</auth>';
  JSessionId: string;

function JabberDIGESTMD5_Auth(User, Host, Password, nonce, cnonce: string): string;
function JabberPlain_Auth: string;
procedure Jabber_GoOffline;
function Jabber_SetBind: string;
function Jabber_SetSession: string;
function Jabber_GetRoster: string;
function Jabber_SetStatus(jStatus: integer): string;
procedure Jabber_ParseRoster(XmlData: string);
procedure Jabber_ParseFeatures(XmlData: string);
procedure Jabber_ParseIQ(XmlData: string);
procedure Jabber_ParsePresence(XmlData: string);
procedure Jabber_ParseMessage(XmlData: string);
procedure Jabber_SendMessage(mJID, Msg: string);

implementation

uses
  UtilsUnit, UnitLogger, UnitPluginObserver, UnitPluginInterface;

{$REGION 'Plugin Events'}

procedure StringToPWide(sStr: string; var Data: PWideChar);
var
  iSize: integer;
  iNewSize: integer;
begin
  iSize := Length(sStr) + 1;
  iNewSize := iSize * 2;

  MultiByteToWideChar(CP_ACP, 0, PAnsiChar(sStr), iSize, Data, iNewSize);
end;

procedure NotifyPluginDisconnect;
var
  Param: PDisconnectParams;
begin
  //--��������� �������� � ������������
  New(Param);
  with Param^ do
  begin
    cSize := SizeOf(TDisconnectParams);
    ErrorCode := 1;
    Server := 'INSERT ADDRESS HERE!';
    Port := StrToIntDef(Jabber_ServerPort, 0);
    IsSSLActive := Cardinal(Jabber_UseSSL);
  end;
  PluginObserver.Notify(eDisconnect, pJabber, Param);
  Dispose(Param);
end;

{$ENDREGION}


function JabberPlain_Auth: string;
var
  uu, upass, ujid, c, buff: string;
begin
  try
    //--����������� � UTF-8
    ujid := UTF8Encode(Jabber_JID);
    uu := UTF8Encode(Jabber_LoginUIN);
    upass := UTF8Encode(Jabber_LoginPassword);
    //--���������� � ������ ��������� ������
    buff := ujid + ''#0 + uu + ''#0 + upass;
    //--�������� � ������
    c := Base64Encode(buff);
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(e);
  end;
  Result := c;
end;

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
  Param: PAuthorizationParams;
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

  New(Param);
  with Param^ do begin
    cSize := SizeOf(TAuthorizationParams);
    UserLogin := PWideChar(User);
    Server := PWideChar(Jabber_ServerAddr);
    Port := StrToIntDef(Jabber_ServerPort, 0);
    IsSSLActive := Cardinal(Jabber_UseSSL);
  end;
  PluginObserver.Notify(eAuthorization, pJabber, Param);
  Dispose(Param);
end;

procedure Jabber_GoOffline;
var
  i: Integer;
begin
  //--��������� ������ ������
  MainForm.UnstableJabberStatus.Checked := false;
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
  //--���������� ���� ��������� ������ ������ �������
  ZipThreadStop := true;
  //--���� ����� ������ ������� �� ����������� ���, �� ��� ��� ���������
  while not MainForm.ZipHistoryThread.Terminated do Sleep(10);
  //--��������� ������� ���������, �� ��� �� � ������
  ZipThreadStop := false;
  MainForm.ZipHistory;
  //--�������� ������� � ���������� � �������
  with RosterForm.RosterJvListView do
  begin
    for i := 0 to Items.Count - 1 do
    begin
      if Items[i].SubItems[3] = 'Jabber' then
      begin
        if Items[i].SubItems[6] <> '42' then Items[i].SubItems[6] := '30';
        Items[i].SubItems[7] := '-1';
        Items[i].SubItems[8] := '-1';
        Items[i].SubItems[13] := '';
        Items[i].SubItems[15] := '';
        Items[i].SubItems[16] := '';
        Items[i].SubItems[18] := '0';
        Items[i].SubItems[19] := '0';
        Items[i].SubItems[35] := '0';
      end;
    end;
  end;
  //--��������� ��������� �������
  RosterForm.UpdateFullCL;

  //--�������� ��������� ��������
  NotifyPluginDisconnect;
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
  //--���������� Id ��� ������� ������ (google talk)
  JSessionId := Format('imadering_%d', [Jabber_Seq]);
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
          //--��������������� ��� ��������
          RosterForm.RosterItemSetFull(ListItemD);
          //--��������� ���������
          ListItemD.SubItems[0] := ReadString('name');
          if ListItemD.SubItems[0] = EmptyStr then
            ListItemD.SubItems[0] := ListItemD.Caption;
          ListItemD.SubItems[2] := ReadString('subscription');
          //--��������� ���� ������
          OpenKey('group', false, 0);
          ListItemD.SubItems[1] := GetKeyText;
          if ListItemD.SubItems[1] = EmptyStr then
            ListItemD.SubItems[1] := JabberNullGroup;
          ListItemD.SubItems[3] := 'Jabber';
          ListItemD.SubItems[6] := '30';
        finally
          CloseKey();
        end;
      end;
    end;
  finally
    Free();
    //--����������� ��������� ������� ��������� � ������
    RosterForm.RosterJvListView.Items.EndUpdate;
  end;
  //--��������� ��������� �������
  CollapseGroupsRestore := true;
  RosterForm.UpdateFullCL;
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
      end
      else
      //--����� ����� ���� ������� ������ �� google talk
      if OpenKey('iq') then
      try
        begin
          if (ReadString('type') = 'result') and (ReadString('id') = JSessionId) then
          begin
            //--����������� ������ ���������
            MainForm.JabberWSocket.SendStr(UTF8Encode(Jabber_GetRoster));
            //--������������� ������
            MainForm.JabberWSocket.SendStr(UTF8Encode(Jabber_SetStatus(Jabber_CurrentStatus)));
          end;
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
  Param: PContactWriteMessageParams;
begin
  //--���������� ��������� ��� jabber ��������
  m := Format(JmessHead, [mJID, Jabber_Seq]) + '<body>' + Msg + '</body></message>';
  MainForm.JabberWSocket.SendStr(UTF8Encode(m));
  //--����������� ������� ��������� jabber �������
  Inc(Jabber_Seq);

  New(Param);
  with Param^ do begin
    cSize := SizeOf(TContactWriteMessageParams);
    FromContactID := PWideChar(WideString(Jabber_JID));
    FromContactCaption := PWideChar(WideString(Jabber_LoginUIN));
    ToContactID := PWideChar(WideString(mJID));
    ToContactCaption := PWideChar(WideString(mJID));
    MessageText := PWideChar(WideString(Msg));
    Direction := mdFROMme;
  end;
  PluginObserver.Notify(eWriteMessage, pJabber, Param);
  Dispose(Param);
end;

procedure Jabber_ParsePresence(XmlData: string);
var
  pJID: string;
  RosterItem: TListItem;
begin
  //--�������������� XML
  with TrXML.Create() do
  try
    begin
      Text := XmlData;
      if OpenKey('presence') then
      try
        begin
          pJID := ReadString('from');
          if pJID <> EmptyStr then
          begin
            //--�������� ������
            pJID := Parse('/', pJID, 1);
            //--���� ��� ������ � �������
            RosterItem := RosterForm.ReqRosterItem(pJID);
            if RosterItem <> nil then
            begin
              //--���������� ��������� ���� ������
              with RosterItem do
              begin
                if ReadString('type') = 'unavailable' then
                begin
                  SubItems[18] := '0';
                  if (SubItems[6] <> '30') and (SubItems[6] <> '41') and
                    (SubItems[6] <> '42') then SubItems[19] := '20'
                  else SubItems[19] := '0';
                  SubItems[6] := '30';
                end
                else
                begin
                  if SubItems[6] = '30' then SubItems[18] := '20'
                  else SubItems[18] := '0';
                  SubItems[19] := '0';
                  SubItems[6] := '28';
                end;
                //--��������� ������ �������� ������� �������
                MainForm.JvTimerList.Events[11].Enabled := false;
                MainForm.JvTimerList.Events[11].Enabled := true;
              end;
            end;
          end;
        end;
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
  end;
end;

procedure Jabber_ParseMessage(XmlData: string);
var
  pJID, InMsg, Nick, Mess, msgD, PopMsg: string;
  RosterItem: TListItem;
  Param: PContactWriteMessageParams;
begin
  //--���� ���� ��������� �� ���� �������, �� ������ ���
  if not Assigned(ChatForm) then ChatForm := TChatForm.Create(MainForm);
  //--�������������� XML
  with TrXML.Create() do
  try
    begin
      Text := XmlData;
      if OpenKey('message') then
      try
        begin
          pJID := ReadString('from');
          OpenKey('body', false, 0);
          InMsg := GetKeyText;
          if (pJID <> EmptyStr) and (InMsg <> EmptyStr) then
          begin
            //--�������� ������
            if BMSearch(0, pJID, '/') > -1 then pJID := Parse('/', pJID, 1);
            //--������������ ���������
            Mess := InMsg;
            CheckMessage_BR(Mess);
            ChatForm.CheckMessage_ClearTag(Mess);
            PopMsg := Mess;
            CheckMessage_BR(Mess);
            DecorateURL(Mess);
            //--���� ��� ������ � �������
            RosterItem := RosterForm.ReqRosterItem(pJID);
            if RosterItem <> nil then
            begin
              //--���������� ��������� ��������� � ���� ������
              with RosterItem do
              begin
                //--��� �������� �� �������
                Nick := SubItems[0];
                //--���� ���������
                msgD := Nick + ' [' + DateTimeChatMess + ']';
                //--���������� ������� � ���� ������� ���� �� ��� ������ � ������ ���������
                SubItems[15] := PopMsg;
                SubItems[17] := 'X';
                SubItems[35] := '0';
                //--��������� ������� � ��� ������
                RosterForm.AddHistory(RosterItem, msgD, Mess);
              end;
            end
            else //--���� ����� ������� �� ������ � �������, �� ��������� ���
            begin
              //--���� ��� �� ����� � �������, �� ���� ��� � �����-���� �����
              Nick := SearchNickInCash('Jabber', pJID);
              //--���� ���������
              msgD := Nick + ' [' + DateTimeChatMess + ']';
              //--���� ������ "�� � ������" � �������
              RosterItem := RosterForm.ReqRosterItem('NoCL');
              if RosterItem = nil then //--���� ������ �� �����
              begin
                //--��������� ����� ������ � ������
                RosterItem := RosterForm.RosterJvListView.Items.Add;
                RosterItem.Caption := 'NoCL';
                //--��������������� ��� ��������
                RosterForm.RosterItemSetFull(RosterItem);
                RosterItem.SubItems[1] := NoInListGroupCaption;
              end;
              //--��������� ���� ������� � ������
              RosterItem := RosterForm.RosterJvListView.Items.Add;
              with RosterItem do
              begin
                Caption := pJID;
                //--��������������� ��� ��������
                RosterForm.RosterItemSetFull(RosterItem);
                //--��������� ���������
                SubItems[0] := Nick;
                SubItems[1] := 'NoCL';
                SubItems[2] := 'none';
                SubItems[3] := 'Jabber';
                SubItems[6] := '214';
                SubItems[15] := PopMsg;
                SubItems[17] := 'X';
                SubItems[35] := '0';
                //--��������� ������� � ��� ������
                RosterForm.AddHistory(RosterItem, msgD, Mess);
              end;
            end;
            //--��������� ��������� � ������� ���
            if ChatForm.AddMessInActiveChat(Nick, PopMsg, pJID, msgD, Mess) then
              RosterItem.SubItems[36] := EmptyStr;

            New(Param);
            with Param^ do begin
              cSize := SizeOf(TContactWriteMessageParams);
              FromContactID := PWideChar(WideString(pJID));
              FromContactCaption := PWideChar(WideString(Nick));
              ToContactID := PWideChar(WideString(Jabber_JID));
              ToContactCaption := PWideChar(WideString(Jabber_LoginUIN));
              MessageText := PWideChar(WideString(Mess));
              Direction := mdTOme;
            end;
            PluginObserver.Notify(eWriteMessage, pJabber, Param);
            Dispose(Param);
          end;
        end;
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
  end;
end;

end.

