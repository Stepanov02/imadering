{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, CategoryButtons, ExtCtrls, Menus, ImgList,
  JvTimerList, OverbyteIcsWndControl, OverbyteIcsWSocket, OverbyteIcsHttpProt,
  rXML, JvHint, IdBaseComponent, IdThreadComponent, StrUtils,
  OverbyteIcsMimeUtils, StdCtrls;

type
  TMainForm = class(TForm)
    ContactList: TCategoryButtons;
    ToolBar2: TToolBar;
    MainToolButton: TToolButton;
    ICQToolButton: TToolButton;
    ICQTrayIcon: TTrayIcon;
    TrayPopupMenu: TPopupMenu;
    AllImageList: TImageList;
    JvTimerList: TJvTimerList;
    MainPopupMenu: TPopupMenu;
    CloseProgram: TMenuItem;
    HideInTray: TMenuItem;
    N3: TMenuItem;
    CloseProgramTray: TMenuItem;
    N1: TMenuItem;
    SettingsTray: TMenuItem;
    N2: TMenuItem;
    MRATrayIcon: TTrayIcon;
    JabberTrayIcon: TTrayIcon;
    ICQWSocket: TWSocket;
    MRAWSocket: TWSocket;
    JabberWSocket: TWSocket;
    ICQAvatarWSocket: TWSocket;
    UpdateHttpClient: THttpCli;
    MRAToolButton: TToolButton;
    JabberToolButton: TToolButton;
    AboutIMadering: TMenuItem;
    OpenSettings: TMenuItem;
    HideInTrayTray: TMenuItem;
    OpenTest: TMenuItem;
    ContactListPopupMenu: TPopupMenu;
    ICQPopupMenu: TPopupMenu;
    MRAPopupMenu: TPopupMenu;
    JabberPopupMenu: TPopupMenu;
    ICQStatusOffline: TMenuItem;
    N6: TMenuItem;
    ICQStatusInvisibleForAll: TMenuItem;
    ICQStatusInvisible: TMenuItem;
    ICQStatusOnline: TMenuItem;
    N7: TMenuItem;
    ICQStatusDND: TMenuItem;
    ICQStatusOccupied: TMenuItem;
    ICQStatusNA: TMenuItem;
    ICQStatusAway: TMenuItem;
    ICQStatusLunch: TMenuItem;
    N8: TMenuItem;
    ICQStatusWork: TMenuItem;
    ICQStatusHome: TMenuItem;
    ICQStatusDepres: TMenuItem;
    ICQStatusEvil: TMenuItem;
    ICQStatusFFC: TMenuItem;
    ICQXStatus: TMenuItem;
    N11: TMenuItem;
    N9: TMenuItem;
    ICQSettings: TMenuItem;
    MRAStatusOffline: TMenuItem;
    N10: TMenuItem;
    JabberStatusOffline: TMenuItem;
    N12: TMenuItem;
    JabberStatusOnline: TMenuItem;
    MRAStatusInvisible: TMenuItem;
    MRAStatusOnline: TMenuItem;
    N13: TMenuItem;
    MRAStatusDND: TMenuItem;
    MRAStatusAway: TMenuItem;
    N14: TMenuItem;
    MRAStatusFFC: TMenuItem;
    N15: TMenuItem;
    MRAXStatus: TMenuItem;
    N16: TMenuItem;
    MRASettings: TMenuItem;
    N17: TMenuItem;
    JabberSettings: TMenuItem;
    SoundOnOffToolButton: TToolButton;
    OnlyOnlineContactsToolButton: TToolButton;
    N19: TMenuItem;
    StatusTray: TMenuItem;
    ContactPopupMenu: TPopupMenu;
    CheckUpdate: TMenuItem;
    RightICQPopupMenu: TPopupMenu;
    UnstableICQStatus: TMenuItem;
    OpenGroupsCL: TMenuItem;
    CloseGroupsCL: TMenuItem;
    N5: TMenuItem;
    AddNewGroupCL: TMenuItem;
    RenemeGroupCL: TMenuItem;
    DeleteGroupCL: TMenuItem;
    N20: TMenuItem;
    SearchInCL: TMenuItem;
    N18: TMenuItem;
    AddNewContactCL: TMenuItem;
    SendMessageForContact: TMenuItem;
    CheckStatusContact: TMenuItem;
    N21: TMenuItem;
    AnketaContact: TMenuItem;
    HistoryContact: TMenuItem;
    CopyAccountContact: TMenuItem;
    N22: TMenuItem;
    EditContact: TMenuItem;
    DeleteContact: TMenuItem;
    N23: TMenuItem;
    NextContactMenu: TMenuItem;
    GrandAuthContact: TMenuItem;
    SendAddContact: TMenuItem;
    DelYourSelfContact: TMenuItem;
    SendInviteContact: TMenuItem;
    N24: TMenuItem;
    ZipHistoryThread: TIdThreadComponent;
    OpenHistory: TMenuItem;
    OpenTraffic: TMenuItem;
    MRAAvatarHttpClient: THttpCli;
    RightMRAPopupMenu: TPopupMenu;
    RightJabberPopupMenu: TPopupMenu;
    JabberStatusInvisible: TMenuItem;
    JabberStatusDND: TMenuItem;
    N25: TMenuItem;
    JabberStatusOccupied: TMenuItem;
    JabberXStatus: TMenuItem;
    N4: TMenuItem;
    JabberStatusNA: TMenuItem;
    JabberStatusAway: TMenuItem;
    JabberStatusLunch: TMenuItem;
    JabberStatusWork: TMenuItem;
    N26: TMenuItem;
    JabberStatusHome: TMenuItem;
    JabberStatusDepression: TMenuItem;
    JabberStatusEvil: TMenuItem;
    JabberStatusFFC: TMenuItem;
    RosterMainMenu: TMenuItem;
    UnstableMRAStatus: TMenuItem;
    UnstableJabberStatus: TMenuItem;
    SearchInCLMainMenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure JvTimerListEvents0Timer(Sender: TObject);
    procedure CloseProgramClick(Sender: TObject);
    procedure HintMaxTime(Sender: TObject);
    procedure MainToolButtonClick(Sender: TObject);
    procedure OpenSettingsClick(Sender: TObject);
    procedure ICQTrayIconClick(Sender: TObject);
    procedure OpenTestClick(Sender: TObject);
    procedure AboutIMaderingClick(Sender: TObject);
    procedure UpdateHttpClientDocBegin(Sender: TObject);
    procedure UpdateHttpClientDocEnd(Sender: TObject);
    procedure JvTimerListEvents2Timer(Sender: TObject);
    procedure ICQSettingsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ICQXStatusClick(Sender: TObject);
    procedure ICQToolButtonClick(Sender: TObject);
    procedure MRAToolButtonClick(Sender: TObject);
    procedure JabberToolButtonClick(Sender: TObject);
    procedure MRAXStatusClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SoundOnOffToolButtonClick(Sender: TObject);
    procedure OnlyOnlineContactsToolButtonClick(Sender: TObject);
    procedure TrayPopupMenuPopup(Sender: TObject);
    procedure ICQTrayIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ICQStatusOnlineClick(Sender: TObject);
    procedure ICQStatusOfflineClick(Sender: TObject);
    procedure ICQWSocketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure ICQWSocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure ICQWSocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure MRASettingsClick(Sender: TObject);
    procedure JabberSettingsClick(Sender: TObject);
    procedure CheckUpdateClick(Sender: TObject);
    procedure MainToolButtonContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ICQToolButtonContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MRAToolButtonContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure JabberToolButtonContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ContactListHotButton(Sender: TObject; const Button: TButtonItem);
    procedure ContactListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ContactListButtonClicked(Sender: TObject;
      const Button: TButtonItem);
    procedure SendMessageForContactClick(Sender: TObject);
    procedure JvTimerListEvents1Timer(Sender: TObject);
    procedure CheckStatusContactClick(Sender: TObject);
    procedure AnketaContactClick(Sender: TObject);
    procedure HistoryContactClick(Sender: TObject);
    procedure CopyAccountContactClick(Sender: TObject);
    procedure OpenGroupsCLClick(Sender: TObject);
    procedure CloseGroupsCLClick(Sender: TObject);
    procedure AddNewGroupCLClick(Sender: TObject);
    procedure RenemeGroupCLClick(Sender: TObject);
    procedure DeleteGroupCLClick(Sender: TObject);
    procedure SearchInCLClick(Sender: TObject);
    procedure AddNewContactCLClick(Sender: TObject);
    procedure EditContactClick(Sender: TObject);
    procedure DeleteContactClick(Sender: TObject);
    procedure GrandAuthContactClick(Sender: TObject);
    procedure SendAddContactClick(Sender: TObject);
    procedure DelYourSelfContactClick(Sender: TObject);
    procedure SendInviteContactClick(Sender: TObject);
    procedure UnstableICQStatusClick(Sender: TObject);
    procedure ZipHistoryThreadRun(Sender: TIdThreadComponent);
    procedure OpenHistoryClick(Sender: TObject);
    procedure OpenTrafficClick(Sender: TObject);
    procedure UpdateHttpClientSendEnd(Sender: TObject);
    procedure MRAAvatarHttpClientSendEnd(Sender: TObject);
    procedure MRAAvatarHttpClientDocEnd(Sender: TObject);
    procedure ICQWSocketSendData(Sender: TObject; BytesSent: Integer);
    procedure UpdateHttpClientDocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure JabberWSocketSendData(Sender: TObject; BytesSent: Integer);
    procedure JabberWSocketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure JabberWSocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure JabberWSocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure JvTimerListEvents4Timer(Sender: TObject);
    procedure JvTimerListEvents3Timer(Sender: TObject);
    procedure JvTimerListEvents5Timer(Sender: TObject);
    procedure JvTimerListEvents6Timer(Sender: TObject);
    procedure JvTimerListEvents7Timer(Sender: TObject);
    procedure JvTimerListEvents8Timer(Sender: TObject);
    procedure JabberStatusOfflineClick(Sender: TObject);
    procedure JabberStatusOnlineClick(Sender: TObject);
    procedure ICQWSocketSocksError(Sender: TObject; Error: Integer;
      Msg: string);
    procedure JabberWSocketSocksError(Sender: TObject; Error: Integer;
      Msg: string);
    procedure UpdateHttpClientSocksError(Sender: TObject; Error: Integer;
      Msg: string);
    procedure UpdateHttpClientSessionClosed(Sender: TObject);
    procedure MRAAvatarHttpClientSessionClosed(Sender: TObject);
    procedure ICQWSocketError(Sender: TObject);
    procedure ICQWSocketSessionAvailable(Sender: TObject; ErrCode: Word);
    procedure ICQWSocketSocksConnected(Sender: TObject; ErrCode: Word);
    procedure UpdateHttpClientSocksConnected(Sender: TObject; ErrCode: Word);
    procedure MRAAvatarHttpClientSocksConnected(Sender: TObject; ErrCode: Word);
    procedure MRAAvatarHttpClientSocksError(Sender: TObject; Error: Integer;
      Msg: string);
    procedure JabberWSocketError(Sender: TObject);
    procedure JabberWSocketSessionAvailable(Sender: TObject; ErrCode: Word);
    procedure JabberWSocketSocksConnected(Sender: TObject; ErrCode: Word);
    procedure JvTimerListEvents9Timer(Sender: TObject);
    procedure RosterMainMenuClick(Sender: TObject);
    procedure JvTimerListEvents11Timer(Sender: TObject);
    procedure ContactListSelectedItemChange(Sender: TObject;
      const Button: TButtonItem);
    procedure JvTimerListEvents12Timer(Sender: TObject);
    procedure JabberXStatusClick(Sender: TObject);
    procedure ContactListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    ButtonInd: integer;
    lastClick: Tdatetime;
    procedure LoadImageList(ImgList: TImageList; FName: string);
    procedure LoadMainFormSettings;
    procedure MainFormHideInTray;
    procedure AppActivate(Sender: TObject);
    procedure AppDeactivate(Sender: TObject);
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession); message WM_QueryEndSession;
  public
    { Public declarations }
    RoasterGroup: TButtonCategory;
    RoasterButton: TButtonItem;
    procedure SaveMainFormSettings;
    procedure ICQEnable(OnOff: boolean);
    procedure MRAEnable(OnOff: boolean);
    procedure JabberEnable(OnOff: boolean);
    procedure OpenFromTrayMessage(hUIN: string);
    procedure ZipHistory;
    procedure FormShowInWorkArea(xForm: TForm);
    procedure FormSetInWorkArea(xForm: TForm);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  VarsUnit, SettingsUnit, AboutUnit, UtilsUnit, IcqOptionsUnit, IcqXStatusUnit,
  MraXStatusUnit, FirstStartUnit, IcqProtoUnit, IcqContactInfoUnit,
  MraOptionsUnit, JabberOptionsUnit, ChatUnit, SmilesUnit, IcqReqAuthUnit,
  HistoryUnit, Code, CLSearchUnit, TrafficUnit, UpdateUnit,
  JabberProtoUnit, MraProtoUnit, RosterUnit;

procedure TMainForm.FormShowInWorkArea(xForm: TForm);
var
  FCursor: TPoint;
begin
  //--��������� ������� ���� �� ������� �������
  GetCursorPos(FCursor);
  with xForm do
  begin
    Top := FCursor.Y - (Height div 2);
    Left := FCursor.X - (Width div 2);
    //--���������� �� ��������� �� ���� �� ��������� ������
    if Top < Screen.WorkAreaTop then Top := Screen.WorkAreaTop;
    if Left + Width > (Screen.WorkAreaLeft + Screen.WorkAreaWidth) then
      Left := (Screen.WorkAreaLeft + Screen.WorkAreaWidth) - Width;
    if Left < Screen.WorkAreaLeft then Left := Screen.WorkAreaLeft;
    //--���������� ���� ���. �������
    Show;
  end;
end;

procedure TMainForm.FormSetInWorkArea(xForm: TForm);
begin
  with xForm do
  begin
    //--���������� �� ��������� �� ���� �� ��������� ������
    if Top < Screen.WorkAreaTop then Top := Screen.WorkAreaTop;
    if Top + Height > (Screen.WorkAreaTop + Screen.WorkAreaHeight) then
      Top := (Screen.WorkAreaTop + Screen.WorkAreaHeight) - Height;
    if Left + Width > (Screen.WorkAreaLeft + Screen.WorkAreaWidth) then
      Left := (Screen.WorkAreaLeft + Screen.WorkAreaWidth) - Width;
    if Left < Screen.WorkAreaLeft then Left := Screen.WorkAreaLeft;
  end;
end;

procedure TMainForm.ZipHistory;
var
  ListF: TStringList;
  i: integer;
  zFile: string;
begin
  //--� ����� ��������� � ����� ��������� ���������� ������� ���������
  //� ������� � � ��������� � ����
  //--������ ����������� �����
  ForceDirectories(MyPath + 'Profile\History\Unzip');
  //--������ ��������� ���� ��� �����
  ListF := TStringList.Create;
  try
    try
      with RosterForm.RosterJvListView do
      begin
        for i := 0 to Items.Count - 1 do
        begin
          if (Items[i].SubItems[17] = 'X') and (Items[i].SubItems[13] <> EmptyStr) then
          begin
            //--���������� � ���� ������� ����� ��������
            ListF.Text := Items[i].SubItems[13];
            //--��������� ���� �� ��������� �������
            zFile := MyPath + 'Profile\History\Unzip\' + Items[i].SubItems[3] + '_History.htm';
            ListF.SaveToFile(zFile);
            //--������� ����
            ListF.Clear;
            //--��������� � ���� ���� � �����
            ListF.Add(zFile);
            //--������� ���� ���� � ����� � ��� �� ����������
            Zip_File(ListF, MyPath + 'Profile\History\' + Items[i].SubItems[3] + '_' + Items[i].Caption + '.z');
            //--������� �������� ����
            if FileExists(zFile) then DeleteFile(zFile);
            //--������� � ����� �������� ���� � ������������ �������
            Items[i].SubItems[17] := EmptyStr;
          end;
        end;
      end;
    except
    end;
  finally
    ListF.Free;
  end;
  //--������� ���������� �������� ��������� ������ �������
  if DirectoryExists(MyPath + 'Profile\History\Unzip') then RemoveDir(MyPath + 'Profile\History\Unzip');
  //--������������� ����� ����� ������ ���� ����������� ������ � ��������
  ZipHistoryThread.Stop;
end;

procedure TMainForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
  //--���� ������� �����������, �� �� ��������� � ���������
  ProgramCloseCommand := true;
  Msg.Result := 1;
end;

procedure TMainForm.ZipHistoryThreadRun(Sender: TIdThreadComponent);
begin
  //--��������� ���������� ��������� � ������
  MainForm.ZipHistory;
end;

procedure TMainForm.ICQEnable(OnOff: boolean);
begin
  if OnOff then
  begin
    //--�������������� ���� �������� ��������� ICQ
    if not Assigned(IcqOptionsForm) then IcqOptionsForm := TIcqOptionsForm.Create(self);
    //--������ ������ � ���� ��������� � � ����
    ICQTrayIcon.Visible := true;
    ICQToolButton.Visible := true;
  end
  else
  begin
    //--������ ������ � ���� ��������� � � ����
    ICQTrayIcon.Visible := false;
    ICQToolButton.Visible := false;
    //--������������ ���� �������� ��������� ICQ
    if Assigned(IcqOptionsForm) then FreeAndNil(IcqOptionsForm);
  end;
end;

procedure TMainForm.MRAAvatarHttpClientDocEnd(Sender: TObject);
begin
  //--������ ���������� http ������ �� ����� ������
  if MRAAvatarHttpClient.RcvdStream <> nil then
  begin
    //--����������� ���������� ��������� �������
    TrafRecev := TrafRecev + MRAAvatarHttpClient.RcvdCount;
    AllTrafRecev := AllTrafRecev + MRAAvatarHttpClient.RcvdCount;
    if Assigned(TrafficForm) then OpenTrafficClick(nil);
    //--������������ ��������� MRA �������

    //--������������ ���� ������
    MRAAvatarHttpClient.RcvdStream.Free;
    MRAAvatarHttpClient.RcvdStream := nil;
  end;
end;

procedure TMainForm.MRAAvatarHttpClientSendEnd(Sender: TObject);
begin
  //--����������� ���������� ���������� �������
  TrafSend := TrafSend + MRAAvatarHttpClient.SentCount;
  AllTrafSend := AllTrafSend + MRAAvatarHttpClient.SentCount;
  if Assigned(TrafficForm) then OpenTrafficClick(nil);
end;

procedure TMainForm.MRAAvatarHttpClientSessionClosed(Sender: TObject);
begin
  //--������������ ��������� ������ � ������ http ������
  if (MRAAvatarHttpClient.StatusCode = 0) or (MRAAvatarHttpClient.StatusCode >= 400) then
  begin
    DAShow(ErrorHead, ErrorHttpClient(MRAAvatarHttpClient.StatusCode), EmptyStr, 134, 2, 0);
  end;
end;

procedure TMainForm.MRAAvatarHttpClientSocksConnected(Sender: TObject;
  ErrCode: Word);
begin
  //--���� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
  end;
end;

procedure TMainForm.MRAAvatarHttpClientSocksError(Sender: TObject;
  Error: Integer; Msg: string);
begin
  //--���� �������� ������, �� �������� �� ����
  if Error <> 0 then
  begin
    DAShow(ErrorHead, Msg, EmptyStr, 134, 2, 0);
  end;
end;

procedure TMainForm.MRAEnable(OnOff: boolean);
begin
  if OnOff then
  begin
    //--�������������� ���� �������� ��������� MRA
    if not Assigned(MraOptionsForm) then MraOptionsForm := TMraOptionsForm.Create(self);
    //--������ ������ � ���� ��������� � � ����
    MRATrayIcon.Visible := true;
    MRAToolButton.Visible := true;
  end
  else
  begin
    //--������ ������ � ���� ��������� � � ����
    MRATrayIcon.Visible := false;
    MRAToolButton.Visible := false;
    //--������������ ���� �������� ��������� MRA
    if Assigned(MraOptionsForm) then FreeAndNil(MraOptionsForm);
  end;
end;

procedure TMainForm.MRASettingsClick(Sender: TObject);
begin
  //--��������� ��������� ���� MRA ���������
  if not Assigned(MraOptionsForm) then MraOptionsForm := TMraOptionsForm.Create(self);
  //--���������� ����
  if MraOptionsForm.Visible then ShowWindow(MraOptionsForm.Handle, SW_RESTORE);
  MraOptionsForm.Show;
end;

procedure TMainForm.JabberEnable(OnOff: boolean);
begin
  if OnOff then
  begin
    //--�������������� ���� �������� ��������� Jabber
    if not Assigned(JabberOptionsForm) then JabberOptionsForm := TJabberOptionsForm.Create(self);
    //--������ ������ � ���� ��������� � � ����
    JabberTrayIcon.Visible := true;
    JabberToolButton.Visible := true;
  end
  else
  begin
    //--������ ������ � ���� ��������� � � ����
    JabberTrayIcon.Visible := false;
    JabberToolButton.Visible := false;
    //--������������ ���� �������� ��������� Jabber
    if Assigned(JabberOptionsForm) then FreeAndNil(JabberOptionsForm);
  end;
end;

procedure TMainForm.JabberSettingsClick(Sender: TObject);
begin
  //--��������� ��������� ���� Jabber ���������
  if not Assigned(JabberOptionsForm) then JabberOptionsForm := TJabberOptionsForm.Create(self);
  //--���������� ����
  if JabberOptionsForm.Visible then ShowWindow(JabberOptionsForm.Handle, SW_RESTORE);
  JabberOptionsForm.Show;
end;

procedure TMainForm.JabberStatusOfflineClick(Sender: TObject);
begin
  //--������ ICQ �������� � �������
  Jabber_GoOffline;
  Jabber_Reconnect := false;
end;

procedure TMainForm.JabberStatusOnlineClick(Sender: TObject);
begin
  //--���� ����� Jabber ��� ������ ������, �� ������� ���� �������� ��� �� �����
  if (Jabber_LoginUIN = EmptyStr) or (Jabber_LoginPassword = EmptyStr) then
  begin
    //--���������� ��������� �� ���� ������
    DAShow(InformationHead, JabberAccountInfo_1, EmptyStr, 133, 3, 0);
    //--��������� ��������� ICQ
    JabberSettingsClick(self);
    //--������ ������ � ���� ����� ������ ��� ������
    with JabberOptionsForm do
    begin
      if (JabberJIDEdit.CanFocus) and (JabberJIDEdit.Text = EmptyStr) then JabberJIDEdit.SetFocus
      else if (PassEdit.CanFocus) and (PassEdit.Text = EmptyStr) then PassEdit.SetFocus;
    end;
    //--������� �� ����
    Exit;
  end;
  //--������ ��������� ������ � ���� ����������
  TMenuItem(Sender).Default := true;
  //--������ ������ ��� ���������
  Jabber_CurrentStatus := TMenuItem(Sender).ImageIndex;
  //--������ �������� �������� ������� ��� ���������
  Jabber_CurrentStatus_bac := ICQ_CurrentStatus;
  //--������ ������ ������� � ���� � � ����
  if not Jabber_Offline_Phaze then
  begin
    JabberToolButton.ImageIndex := Jabber_CurrentStatus;
    JabberTrayIcon.IconIndex := Jabber_CurrentStatus;
  end;
  //--������������ � Jabber �������
  if Jabber_Offline_Phaze then
  begin
    try
      //--������ ������ ������� � ���� � � ����
      JabberToolButton.ImageIndex := 168;
      JabberTrayIcon.IconIndex := 168;
      //--��������� �������� ������ � ������ ICQ
      if Assigned(JabberOptionsForm) then
      begin
        with JabberOptionsForm do
        begin
          JabberJIDEdit.Enabled := false;
          JabberJIDEdit.Color := clBtnFace;
          PassEdit.Enabled := false;
          PassEdit.Color := clBtnFace;
        end;
      end;
      //--���������� ���� �������� � ������� Jabber
      Jabber_Connect_Phaze := true;
      Jabber_HTTP_Connect_Phaze := false;
      Jabber_Work_Phaze := false;
      Jabber_Offline_Phaze := false;
      //--��������� ����� ������ �������� Jabber
      JvTimerList.Events[3].Enabled := true;
      //--������������� ��������� ������
      JabberWSocket.Proto := 'tcp';
      //--������������� ��������� ������
      if HttpProxy_Enable then
      begin
        JabberWSocket.Addr := HttpProxy_Address;
        JabberWSocket.Port := HttpProxy_Port;
      end
      else
      begin
        JabberWSocket.Addr := Jabber_ServerAddr;
        JabberWSocket.Port := Jabber_ServerPort;
      end;
      //--������������� ���������
      Update;
      //--���������� �����
      JabberWSocket.Connect;
    except
    end;
  end;
  //--�������� ����� �� ��������
  if (not Jabber_Connect_Phaze) and (not Jabber_Offline_Phaze) then
    JabberWSocket.SendStr(UTF8Encode(Jabber_SetStatus(Jabber_CurrentStatus)));
end;

procedure TMainForm.HintMaxTime(Sender: TObject);
begin
  //--������ ����������� ��������� �����������
  Application.HintHidePause := MaxInt;
end;

procedure TMainForm.HistoryContactClick(Sender: TObject);
begin
  //--��������� ���� �������
  if not Assigned(HistoryForm) then HistoryForm := THistoryForm.Create(self);
  //--��������� ���� ������� ��� �������� ����
  HistoryForm.LoadHistoryFromFile(ContactList.SelectedItem.UIN);
  //--���������� ����
  if HistoryForm.Visible then ShowWindow(HistoryForm.Handle, SW_RESTORE);
  HistoryForm.Show;
end;

procedure TMainForm.UpdateHttpClientDocBegin(Sender: TObject);
begin
  //--������ ���� ������ ��� ����� http ������
  UpdateHttpClient.RcvdStream := TMemoryStream.Create;
end;

procedure TMainForm.UpdateHttpClientDocData(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
  //--���� ��� ����������� ����� ������, �� ������� � ��������� �����
  if UpdateHttpClient.Tag = 2 then
  begin
    UpdateHttpClient.CloseAsync;
    UpdateHttpClient.Abort;
  end;
  //--���������� ������� ��������� ������
  if Assigned(UpdateForm) then
  begin
    with UpdateForm do
    begin
      if UpdateHttpClient.ContentLength > -1 then
      begin
        LoadSizeLabel.Caption := '�������: ' + FloatToStrF(UpdateHttpClient.RcvdCount / 1000, ffFixed, 7, 1) + ' ��';
        DownloadProgressBar.Max := UpdateHttpClient.ContentLength;
        DownloadProgressBar.Position := UpdateHttpClient.RcvdCount;
      end;
      //--��������� ����� � �������� ����� ������ ���������
      Update;
    end;
  end;
end;

procedure TMainForm.UpdateHttpClientDocEnd(Sender: TObject);
var
  list: TStringList;
  ver, bild, mess: string;

  procedure ShowUpdateNote;
  begin
    //--���� ����� �� ����������, �� ������ �
    if not Assigned(IcqReqAuthForm) then IcqReqAuthForm := TIcqReqAuthForm.Create(self);
    //--������ ������ � ����� �� ���������� ���������
    IcqReqAuthForm.UpDateVersion(mess);
    //--���������� ����
    IcqReqAuthForm.Show;
    //--������� ���� �� ����� �������� ����, ������ ������ � ��� � ����
    SetForeGroundWindow(IcqReqAuthForm.Handle);
  end;

begin
  //--������ ���������� http ������ �� ����� ������
  if UpdateHttpClient.RcvdStream <> nil then
  begin
    //--����������� ���������� ��������� �������
    TrafRecev := TrafRecev + UpdateHttpClient.RcvdCount;
    AllTrafRecev := AllTrafRecev + UpdateHttpClient.RcvdCount;
    if Assigned(TrafficForm) then OpenTrafficClick(nil);
    //--���������� ���������� ������� ��� ������ �� �����
    case UpdateHttpClient.Tag of
      0:
        begin
          //--������ ��������� ����
          list := TStringList.Create;
          try
            try
              //--�������� ������� ������ ������ � ����� ������
              UpdateHttpClient.RcvdStream.Position := 0;
              //--������ ������ � ����
              list.LoadFromStream(UpdateHttpClient.RcvdStream);
              //--��������� ������ � �����
              if list.Text > EmptyStr then
              begin
                ver := IsolateTextString(list.Text, '<v>', '</v>');
                bild := IsolateTextString(list.Text, '<b>', '</b>');
                mess := IsolateTextString(list.Text, '<m>', '</m>');
                //--���������� ���������� ���������� ��� ��������������
                UpdateVersionPath := Format(UpdateVersionPath, [ver, bild]);
                //--���������� ����������� ���� � ����������� � ����� ������
                if (ver <> EmptyStr) and (bild <> EmptyStr) then
                begin
                  //--���� ������ �� ����� ���� �������
                  if StrToInt(ver) > Update_Version then
                  begin
                    DAShow(InformationHead, NewVersionIMaderingYES1, EmptyStr, 133, 3, 100000000);
                    ShowUpdateNote;
                  end
                  //--���� ������ ����, �� ������ ���� �������
                  else if StrToInt(bild) > StrToInt(Parse('.', InitBuildInfo, 4)) then
                  begin
                    DAShow(InformationHead, NewVersionIMaderingYES2, EmptyStr, 133, 3, 100000000);
                    ShowUpdateNote;
                  end
                  else if not UpdateAuto then DAShow(InformationHead, NewVersionIMaderingNO, EmptyStr, 133, 0, 100000000);
                end
                else if not UpdateAuto then DAShow(InformationHead, NewVersionIMaderingNO, EmptyStr, 133, 0, 100000000);
              end;
            except
            end;
          finally
            list.Free;
          end;
        end;
      1:
        begin
          if Assigned(UpdateForm) then
          begin
            with UpdateForm do
            begin
              //--������ ���� � ������ ��� ����� ����� ����������
              UpdateFile := TMemoryStream.Create;
              try
                try
                  //--�������� ������� ������ ������ � ����� ������
                  UpdateHttpClient.RcvdStream.Position := 0;
                  //--������ ������ � ����
                  UpdateFile.LoadFromStream(UpdateHttpClient.RcvdStream);
                  //--����������� � �������� ������� ����� ����������
                  InfoMemo.Lines.Add(UpDateLoadL);
                  InfoMemo.Lines.Add(UpDateUnL);
                  //--��������������� ���� Imadering.exe
                  if FileExists(MyPath + 'Imadering.exe') then RenameFile(MyPath + 'Imadering.exe', MyPath + 'Imadering.old');
                  //--��������� ��������� ����������
                  UnZip_Stream(UpdateFile, MyPath);
                  //--������� ���������� �� ��������� ����������
                  InfoMemo.Lines.Add(UpDateOKL);
                  AbortBitBtn.Enabled := false;
                except
                end;
              finally
                //--���������� ���� ������
                FreeAndNil(UpdateFile);
              end;
            end;
          end;
        end;
      2:
        begin
          //--������ �� ������ � �������
        end;
    end;
    //--������������ ���� ������
    UpdateHttpClient.RcvdStream.Free;
    UpdateHttpClient.RcvdStream := nil;
  end;
end;

procedure TMainForm.ICQSettingsClick(Sender: TObject);
begin
  //--��������� ���� �������� ICQ ���������
  if not Assigned(IcqOptionsForm) then IcqOptionsForm := TIcqOptionsForm.Create(self);
  //--���������� ����
  if IcqOptionsForm.Visible then ShowWindow(IcqOptionsForm.Handle, SW_RESTORE);
  IcqOptionsForm.Show;
end;

procedure TMainForm.ICQStatusOfflineClick(Sender: TObject);
begin
  //--������ ICQ �������� � �������
  ICQ_GoOffline;
  ICQ_Reconnect := false;
end;

procedure TMainForm.ICQStatusOnlineClick(Sender: TObject);
begin
  //--���� ����� ICQ ��� ������ ������, �� ������� ���� �������� ��� �� �����
  if (ICQ_LoginUIN = EmptyStr) or (ICQ_LoginPassword = EmptyStr) then
  begin
    //--���������� ��������� �� ���� ������
    DAShow(InformationHead, ICQAccountInfo_1, EmptyStr, 133, 3, 0);
    //--��������� ��������� ICQ
    ICQSettingsClick(self);
    //--������ ������ � ���� ����� ������ ��� ������
    with IcqOptionsForm do
    begin
      if (ICQUINEdit.CanFocus) and (ICQUINEdit.Text = EmptyStr) then ICQUINEdit.SetFocus
      else if (PassEdit.CanFocus) and (PassEdit.Text = EmptyStr) then PassEdit.SetFocus;
    end;
    //--������� �� ����
    Exit;
  end;
  //--������ ��������� ������ � ���� ����������
  TMenuItem(Sender).Default := true;
  //--������ ������ ��� ���������
  ICQ_CurrentStatus := TMenuItem(Sender).ImageIndex;
  //--������ �������� �������� ������� ��� ���������
  ICQ_CurrentStatus_bac := ICQ_CurrentStatus;
  //--������ ������ �������� � ���� � � ����
  if not ICQ_Offline_Phaze then
  begin
    ICQTrayIcon.IconIndex := ICQ_CurrentStatus;
    ICQToolButton.ImageIndex := ICQ_CurrentStatus;
  end;
  //--��������� ������ ������������ ���� �� �������
  if JvTimerList.Events[4].Enabled then
  begin
    JvTimerList.Events[4].Enabled := false;
    UnstableICQStatus.Checked := false;
  end;
  //--������������ � ICQ �������
  if ICQ_Offline_Phaze then
  begin
    try
      //--������ ������ ����������� � ���� � � ����
      ICQTrayIcon.IconIndex := 168;
      ICQToolButton.ImageIndex := 168;
      //--��������� �������� ������ � ������ ICQ
      if Assigned(IcqOptionsForm) then
      begin
        with IcqOptionsForm do
        begin
          ICQUINEdit.Enabled := false;
          ICQUINEdit.Color := clBtnFace;
          PassEdit.Enabled := false;
          PassEdit.Color := clBtnFace;
        end;
      end;
      //--���������� ���� �������� � ������� ICQ
      ICQ_Connect_Phaze := true;
      ICQ_HTTP_Connect_Phaze := false;
      ICQ_BosConnect_Phaze := false;
      ICQ_Work_Phaze := false;
      ICQ_Offline_Phaze := false;
      //--��������� ����� ������ �������� ICQ
      JvTimerList.Events[3].Enabled := true;
      //--������������� ��������� ������
      ICQWSocket.Proto := 'tcp';
      //--������������� ��������� ������
      if HttpProxy_Enable then
      begin
        ICQWSocket.Addr := HttpProxy_Address;
        ICQWSocket.Port := HttpProxy_Port;
      end
      else
      begin
        ICQWSocket.Addr := ICQ_LoginServerAddr;
        ICQWSocket.Port := ICQ_LoginServerPort;
      end;
      //--������������� ���������
      Update;
      //--���������� �����
      ICQWSocket.Connect;
    except
    end;
  end;
  if (not ICQ_Connect_Phaze) and (not ICQ_BosConnect_Phaze) and (not ICQ_Offline_Phaze) then
    SendFLAP('2', ICQ_CreateShortStatusPkt);
end;

procedure TMainForm.ICQToolButtonClick(Sender: TObject);
begin
  //--��������� ���� ��� ���� ���������
  Popup(ICQToolButton, ICQPopupMenu);
end;

procedure TMainForm.ICQToolButtonContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  //--��������� ���� ��� ���� ���������
  Popup(ICQToolButton, RightICQPopupMenu);
end;

procedure TMainForm.MainFormHideInTray;
begin
  //--���������� ��� ����������� ������� ����
  if Visible then
  begin
    Hide;
    HideInTrayTray.Caption := RestoreFromTrayStr;
    HideInTrayTray.ImageIndex := 5;
  end
  else
  begin
    Show;
    SetForeGroundWindow(Application.MainForm.Handle);
    HideInTrayTray.Caption := HideInTrayStr;
    HideInTrayTray.ImageIndex := 4;
  end;
end;

procedure TMainForm.OpenFromTrayMessage(hUIN: string);
label
  x;
var
  mUIN: string;
begin
  if hUIN <> EmptyStr then
  begin
    mUIN := hUIN;
    goto x;
  end;
  //--���� ������ �������� ��������� ������, �� �������� ���� � �������
  if InMessList.Count = 0 then
  begin
    ICQTrayIcon.Tag := 0;
    MRATrayIcon.Tag := 0;
    JabberTrayIcon.Tag := 0;
    Exit;
  end;
  //-�������� ������� ������ ����������� ��������� � ������ ���� ������
  mUIN := InMessList.Strings[InMessList.Count - 1];
  //--���� ��� ����� ������, �� �������
  if mUIN = EmptyStr then Exit;
  x: ;
  //--��������� ��� � ���� ���������
  RosterForm.OpenChatPage(mUIN);
end;

procedure TMainForm.ICQTrayIconClick(Sender: TObject);
begin
  //--����������� ������� ���� � ���� ��� ������������� ���� ��� ��� �������
  if ICQTrayIcon.Tag = 0 then MainFormHideInTray
  else OpenFromTrayMessage(EmptyStr);
end;

procedure TMainForm.ICQTrayIconMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //--���������� ����� �������� ������ ���� � ����
  if Button = mbRight then TrayProtoClickMenu := LowerCase((Sender as TTrayIcon).Name);
end;

procedure TMainForm.ICQWSocketDataAvailable(Sender: TObject; ErrCode: Word);
label
  x, z;
var
  Pkt, HexPkt, SubPkt: string;
  PktLen, Len, ProxyErr: integer;
begin
  //--�������� ��������� �� ������� ������ � ������
  Pkt := ICQWSocket.ReceiveStr;
  //--���� ��� ��������� ������ �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    ICQ_GoOffline;
  end;
  //--HTTP ������ �������
  if (HttpProxy_Enable) and ((ICQ_Connect_Phaze) or (ICQ_BosConnect_Phaze)) and (not ICQ_HTTP_Connect_Phaze) then
  begin
    //--������� ������ � ����������� �����
    ICQ_myBeautifulSocketBuffer := ICQ_myBeautifulSocketBuffer + Pkt;
    //--���� ��� ������ ����������� �� ������, �� �������
    if pos(#13#10 + #13#10, ICQ_myBeautifulSocketBuffer) = 0 then Exit;
    //--�������� �� ������ ������ ������ ���������� �� ������
    Pkt := chop(#13#10 + #13#10, ICQ_myBeautifulSocketBuffer);
    //--�������� ������ ������
    ProxyErr := 0;
    //--���� ����� ������������� � ������ ��������� ����������,
    //�� ���������� ���� ����������� ����� http ������
    if AnsiStartsStr('HTTPS/1.0 200', pkt) or AnsiStartsStr('HTTPS/1.1 200', pkt)
      or AnsiStartsStr('HTTP/1.0 200', pkt) or AnsiStartsStr('HTTP/1.1 200', pkt) then
    begin
      ICQ_HTTP_Connect_Phaze := true;
    end
    else
      //--�������� �� ������� ������
      if AnsiStartsStr('HTTP/1.0 407', pkt) then
      begin
        ProxyErr := 1;
        DAShow(ErrorHead, ProxyConnectErrL1, EmptyStr, 134, 2, 0);
      end
      else
      begin
        ProxyErr := 2;
        DAShow(ErrorHead, ProxyConnectErrL2, EmptyStr, 134, 2, 0);
      end;
    //--�������� �� ������ ����� � ������� ICQ
    Pkt := ICQ_myBeautifulSocketBuffer;
    //--������� �����
    ICQ_myBeautifulSocketBuffer := EmptyStr;
    //--���� � ������ � ������ ���� ������, �� ������ � �������
    if ProxyErr <> 0 then
    begin
      ICQ_GoOffline;
      Exit;
    end;
  end;
  //--���� ������ ���� ������ ����� ����, ������� �� ���� :)
  if Length(Pkt) = 0 then Exit;
  //--����������� ���������� ��������� �������
  TrafRecev := TrafRecev + Length(Pkt);
  AllTrafRecev := AllTrafRecev + Length(Pkt);
  if Assigned(TrafficForm) then OpenTrafficClick(nil);
  //--����������� ������ �� ��������� ������� � HEX ������ � ����������
  //�� � ������������ ������ ���������� ����� ��������������� ������
  ICQ_HexPkt := ICQ_HexPkt + Text2Hex(Pkt);
  //--���� ������ � ������ �������
  if ((ICQ_HexPkt > EmptyStr) and (HexToInt(LeftStr(ICQ_HexPkt, 2)) <> $2A)) or
    ((Length(ICQ_HexPkt) > 2) and ((HexToInt(ICQ_HexPkt[3] + ICQ_HexPkt[4]) = $0)
    or (HexToInt(ICQ_HexPkt[3] + ICQ_HexPkt[4]) > $05))) then
  begin
    //--���� � ������ ���� ������, �� ���������� ������� � ������� ��������� �� ������
    DAShow(ErrorHead, ParsingPktError, EmptyStr, 134, 2, 0);
    ICQ_GoOffline;
    Exit;
  end;
  //--���� ����� ��� ��������, �� � ������ ���� ��� ������, �� ������������ ����
  //��� �������� ���� ������ �� ������� ���������� ������ ������ ������
  x: ;
  //--��������� ���� �� � ������ ���� ���� ����� �����
  if (Length(ICQ_HexPkt) >= ICQ_FLAP_HEAD_SIZE) and (Length(ICQ_HexPkt) >= ICQ_FLAP_HEAD_SIZE + ICQ_BodySize1) or
    ((HexToInt(ICQ_HexPkt[3] + ICQ_HexPkt[4]) = $04) and (ICQ_BodySize1 = 0)) then
  begin
    //--�������� �� ������ ���� ����� �����
    HexPkt := NextData(ICQ_HexPkt, ICQ_FLAP_HEAD_SIZE + ICQ_BodySize1);
    //--��������� ����� ������ ���� ��� ������ ������ ����
    if Length(HexPkt) > 0 then
    begin
      //--��� ��� ������ �������� �� ������ ������ ICQ ��������� �� ����� $2A
      if HexToInt(NextData(HexPkt, 2)) = $2A then
      begin
        //--������� ����� ����� � ������
        case HexToInt(NextData(HexPkt, 2)) of
          $01:
            begin
              //--���������� Seq (�������)
              NextData(HexPkt, 4);
              //--����� ������ ������ � ����������� � � ���� ��� HEX �������
              PktLen := HexToInt(NextData(HexPkt, 4));
              PktLen := PktLen * 2;
              //--�������� ���� ������
              SubPkt := NextData(HexPkt, PktLen);
              //--���� AOL ������� ����������� � �� � ���� ����������� � �������
              if (ICQ_Connect_Phaze) and (SubPkt = '00000001') then
              begin
                //--���� �������� ������� "������" + ���-�� ����� � ���������
                SendFLAP('1', '00000001' + '8003000400100000');
                //--�������� ������� ��� �����
                SendFLAP('2', '00170006000000000000' + '0001' +
                  IntToHex(Length(ICQ_LoginUIN), 4) + Text2Hex(ICQ_LoginUIN));
                //--������� �� �������� ������� ������ � ������
                goto z;
              end;
              //--���� ��� ��� ����������� � ��������� icq �������
              if (ICQ_BosConnect_Phaze) and (SubPkt = '00000001') then
              begin
                //--�������� ������� ��������� �� ����� ������� ��� ����������� (�����)
                SendFLAP('1', ICQ_CliCookiePkt(ICQ_Bos_Cookie));
              end;
            end;
          $02:
            begin
              //--���������� Seq (�������)
              NextData(HexPkt, 4);
              //--����� ������ ������ � ����������� � � ���� ��� HEX �������
              PktLen := HexToInt(NextData(HexPkt, 4));
              PktLen := PktLen * 2;
              //--�������� ���� ������
              SubPkt := NextData(HexPkt, PktLen);
              //--������� ����� ������ � ������
              case HexToInt(NextData(SubPkt, 4)) of
                $0001:
                  begin
                    //--������� ����� ��������� � ������
                    case HexToInt(NextData(SubPkt, 4)) of
                      $0003:
                        begin
                          if ICQ_BosConnect_Phaze then
                          begin
                            //--������� ������ ICQ � �������
                            RosterForm.ClearContacts('Icq');
                            //--���� ������, ��� � ��� ����� (��������� ������) ������ ���������
                            NewKL := true;
                            ICQ_CL_Count := 0;
                            //--�������� ������� ����� � ����������� ��� ��� ������
                            SendFLAP('2', ICQ_CliFamilyPkt);
                          end;
                        end;
                      $0005:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ������� ������� icq ������
                          ICQ_Parse_0105(SubPkt);
                        end;
                      $0013:
                        begin
                          //--���� ���� ����������� ��� � ��������� �������
                          if ICQ_BosConnect_Phaze then
                          begin
                            //--�������� ����������� ������ ������ ��� ������������� �����������
                            SendFLAP('2', '00010008000000000008' + '00010002000300040005');
                            SendFLAP('2', '0001000E00000000000E');
                            SendFLAP('2', '00130002000000000002' + '000b0002000F');
                            SendFLAP('2', '001300050000344A0005' + '4A32107F003D');
                            SendFLAP('2', '00020002000000000002');
                            SendFLAP('2', '00030002000000000002' + '000500020003');
                            SendFLAP('2', '00040004000000000004');
                            SendFLAP('2', '00090002000000000002');
                          end;
                        end;
                      $000F:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ������ ����� � ����� ����������� � ��������
                          ICQ_Parse_010F(SubPkt);
                        end;
                      $0021:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--�������� ������ Hash ������ ��������
                          if NextData(SubPkt, 4) = '0001' then
                          begin
                            //--���������� ���������� 01
                            NextData(SubPkt, 2);
                            //--����� ������ Hash
                            Len := HexToInt(NextData(SubPkt, 2));
                            Len := Len * 2;
                            //--�������� Hash
                            ICQ_MyIcon_Hash := NextData(SubPkt, Len);
                          end;
                        end;
                    end;
                  end;
                $0002:
                  begin
                    case HexToInt(NextData(SubPkt, 4)) of
                      $0006:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ������ ����� � ��������
                          ICQ_UserOnline_030B(SubPkt, true);
                        end;
                    end;
                  end;
                $0004:
                  begin
                    case HexToInt(NextData(SubPkt, 4)) of
                      $0007:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ���������� �� ��������
                          ICQ_ReqMessage_0407(SubPkt);
                        end;
                      $0014:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ������������ � ������ ��������� ���������
                          ICQ_UserSentTyping_0414(SubPkt);
                        end;
                      $000C:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ���������� � �������� ������ ��������� ��������
                          ICQ_SRV_MSGACK_ADVANCED(SubPkt, false);
                        end;
                      $000B:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ���������� � �������� ������ ��������� ���������
                          ICQ_SRV_MSGACK_ADVANCED(SubPkt, true);
                        end;
                    end;
                  end;
                $0003:
                  begin
                    case HexToInt(NextData(SubPkt, 4)) of
                      $000A:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ����������� �������� ��������
                          ICQ_UserUnkStatus_030A(SubPkt);
                        end;
                      $000B:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ������ ����� � ��������
                          ICQ_UserOnline_030B(SubPkt, false);
                        end;
                      $000C:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� � ������� ����� � ��������
                          ICQ_UserOffline_030C(SubPkt);
                        end;
                    end;
                  end;
                $0013:
                  begin
                    case HexToInt(NextData(SubPkt, 4)) of
                      $0001:
                        begin
                          //--���� ���� ���������� ��������
                          if ICQ_Add_Contact_Phaze then
                          begin
                            //--������������ ���� � ������� ��������� �� ������ � ��������� ��������� �����
                            ICQ_AddEnd;
                            ICQ_Add_Contact_Phaze := false;
                            ICQ_SSI_Phaze := false;
                            DAShow(ErrorHead, AddContactError, EmptyStr, 134, 2, 0);
                          end else
                            //--���� ���� ���������� ������
                            if ICQ_Add_Group_Phaze then
                            begin
                              //--������������ ���� � ������� ��������� �� ������ � ��������� ��������� �����
                              ICQ_AddEnd;
                              ICQ_Add_Group_Phaze := false;
                              ICQ_SSI_Phaze := false;
                              DAShow(ErrorHead, AddGroupError, EmptyStr, 134, 2, 0);
                            end else
                              //--���� ���� �������� ������
                              if ICQ_Group_Delete_Phaze then
                              begin
                                //--������������ ���� � ������� ��������� �� ������ � ��������� ��������� �����
                                ICQ_AddEnd;
                                ICQ_Group_Delete_Phaze := false;
                                ICQ_SSI_Phaze := false;
                                DAShow(ErrorHead, DelGroupError, EmptyStr, 134, 2, 0);
                              end;
                        end;
                      $0006:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� �� ������� ���������
                          if ICQ_Parse_1306(SubPkt) then
                          begin
                            //--����������� ���� ���� �����������!
                            ICQ_ReqInfo_New_Pkt(ICQ_LoginUIN);
                            //--�������� ������������� ��������� ������ � ����������
                            SendFLAP('2', '00130007000000000007');
                            //--�������� �������������� ������ ����
                            SendFLAP('2', ICQ_CliSetFirstOnlineInfoPkt('IMadering', EmptyStr, EmptyStr, EmptyStr, EmptyStr, EmptyStr));
                            //--�������� ��������� �����������
                            SendFLAP('2', ICQ_CliSetICBMparametersPkt);
                            //--�������� ������ ����� �� ��������
                            SendFLAP('2', ICQ_CliSetFirstStatusPkt);
                            //--�������� ����������� ��������� �������
                            SendFLAP('2', ICQ_CliClientReadyPkt);
                            //--�������� ����������� ����� ��������� �� AIM
                            SendFLAP('2', '00040010000000040010');
                            //--�������� �������� ������
                            SendFLAP('2', ICQ_CreateShortStatusPkt);
                            //--���� ��� ���� ���. ������ �� �������� ������ ��������� ����������� ���. ������� ��� � ICQ 6
                            if ICQ_X_CurrentStatus > 0 then
                            begin
                              SendFLAP('2', ICQ_CliSetFirstOnlineInfoPkt('IMadering', EmptyStr, ICQ_X_CurrentStatus_Cap, EmptyStr, EmptyStr, EmptyStr));
                              ICQ_SetInfoP;
                              ICQ_SetStatusXText(ICQ_X_CurrentStatus_Text, ICQ_X_CurrentStatus_Code);
                            end;
                            //--�������� ���� ������
                            ICQ_Connect_Phaze := false;
                            ICQ_HTTP_Connect_Phaze := false;
                            ICQ_BosConnect_Phaze := false;
                            ICQ_Work_Phaze := true;
                            ICQ_Offline_Phaze := false;
                            //--��������� ����� �������������� ���� �� ��� � ��� ������!
                            ICQ_Reconnect := false;
                            //--��������� ������ ������� ���� �������
                            if ICQ_KeepAlive then JvTimerList.Events[5].Enabled := true;
                          end;
                        end;
                      $000E:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� ������������� �������� �� ������� ���������
                          ICQ_Parse_130E_UpdateAck(SubPkt);
                        end;
                    end;
                  end;
                $0015:
                  begin
                    case HexToInt(NextData(SubPkt, 4)) of
                      $0003:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--���������� ������ � ������� ������ � UIN ����������
                          NextData(SubPkt, 20);
                          case HexToInt(NextData(SubPkt, 4)) of
                            $DA07:
                              begin
                                //--���������� ��� ������ � ��������
                                NextData(SubPkt, 4);
                                //--��������� ����� � ����� ��� ������� UIN
                                ICQ_Parse_SNAC_1503(SubPkt);
                              end;
                          end;
                        end;
                    end;
                  end;
                $0017:
                  begin
                    case HexToInt(NextData(SubPkt, 4)) of
                      $0007:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--����� ������ ������ � ����������� � � ���� ��� HEX �������
                          Len := HexToInt(NextData(SubPkt, 4));
                          Len := Len * 2;
                          //--�������� ����� � ������� MD5 ����������
                          SendFLAP('2', ICQ_MD5CliLoginPkt(Hex2Text(NextData(SubPkt, Len))));
                        end;
                      $0003:
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--��������� ����� �� ������� ������ ��� TLV
                          while Length(SubPkt) > 0 do
                          begin
                            case HexToInt(NextData(SubPkt, 4)) of
                              $0008: //--TLV � ������� �����������
                                begin
                                  Len := HexToInt(NextData(SubPkt, 4));
                                  Len := Len * 2;
                                  DAShow(ErrorHead, ICQ_NotifyAuthCookieError(NextData(SubPkt, Len)), EmptyStr, 134, 2, 0);
                                  ICQ_GoOffline;
                                end;
                              $0005: //--TLV � ������� ��� �������� � ��������� �������
                                begin
                                  Len := HexToInt(NextData(SubPkt, 4));
                                  Len := Len * 2;
                                  Bos_Addr := Hex2Text(NextData(SubPkt, Len));
                                  ICQ_Bos_IP := Parse(':', Bos_Addr, 1);
                                  ICQ_Bos_Port := Parse(':', Bos_Addr, 2);
                                end;
                              $0006: //--TLV � ����� ��� �������� � ��������� �������
                                begin
                                  Len := HexToInt(NextData(SubPkt, 4));
                                  Len := Len * 2;
                                  ICQ_Bos_Cookie := NextData(SubPkt, Len);
                                end
                            else
                              begin
                                //--���� ����� �������� ������ TLV, �� ���������� ��
                                Len := HexToInt(NextData(SubPkt, 4));
                                Len := Len * 2;
                                NextData(SubPkt, Len);
                              end;
                            end;
                          end;
                        end;
                    end;
                  end;
              end;
            end;
          $04:
            begin
              //--���������� Seq (�������)
              NextData(HexPkt, 4);
              //--����� ������ ������
              PktLen := HexToInt(NextData(HexPkt, 4));
              //--���� ������ ������ ����, �� ��������� ����� � ��������
              if PktLen = 0 then
              begin
                //--���� ����� ��� ���������, �� �������� "��������"
                if ICQWSocket.State = wsConnected then ICQWSocket.SendStr(Hex2Text('2A04' + IntToHex(ICQ_Seq1, 4) + '0000'));
                //--����������� ��� ������� ������� �� ����
                Inc(ICQ_Seq1);
                //--��������� ����� � ��� ���� �� ���������
                ICQWSocket.Close;
                ICQWSocket.WaitForClose;
                //--���� ��� ���� ���������� ��������
                if ICQ_Connect_Phaze then
                begin
                  try
                    //--���������� ���� �������� � ��������� �������
                    ICQ_Connect_Phaze := false;
                    ICQ_BosConnect_Phaze := true;
                    ICQ_HTTP_Connect_Phaze := false;
                    //--������������� ���������
                    ICQWSocket.Proto := 'tcp';
                    if HttpProxy_Enable then
                    begin
                      ICQWSocket.Addr := HttpProxy_Address;
                      ICQWSocket.Port := HttpProxy_Port;
                    end
                    else
                    begin
                      ICQWSocket.Addr := ICQ_Bos_IP;
                      ICQWSocket.Port := ICQ_Bos_Port;
                    end;
                    //--�������� ����������� � ��������� �������
                    ICQWSocket.Connect;
                  except
                  end;
                end;
              end
              else
              begin
                //--���� ������ ������ ������ ����, �� ����������� � �����
                PktLen := PktLen * 2;
                //--�������� ���� ������
                SubPkt := NextData(HexPkt, PktLen);
                //--���� ������ ��� TLV
                case HexToInt(NextData(SubPkt, 4)) of
                  $0009: //--TLV � ����� ������
                    begin
                      //--������� ��������� � ���, ��� ��� ����� ������������ ��� �� ������
                      DAShow(ErrorHead, ICQxUIN, EmptyStr, 134, 2, 100000000);
                      //--��������� ����� �������
                      ICQ_GoOffline;
                    end;
                end;
              end;
            end
        else
          //--���� ����� ������ ������ ������, �� ��������� � ������ ������ �����
          goto z;
        end;
      end
      else
      begin
        //--���� ��������� ����� ������ �� ����������,
        //�� ������� ��������� �� ������ ������� � ������� � �������
        DAShow(ErrorHead, ParsingPktError, EmptyStr, 134, 2, 0);
        ICQ_GoOffline;
        Exit;
      end;
    end;
    //--���� � ����� ������� ������ � ��� ��� �������� ������, �� ������������ ��� �������� ������
    z: ;
    if Length(ICQ_HexPkt) > 0 then goto x;
  end;
end;

procedure TMainForm.ICQWSocketSendData(Sender: TObject; BytesSent: Integer);
begin
  //--����������� ���������� ���������� �������
  TrafSend := TrafSend + BytesSent;
  AllTrafSend := AllTrafSend + BytesSent;
  if Assigned(TrafficForm) then OpenTrafficClick(nil);
end;

procedure TMainForm.ICQWSocketSessionAvailable(Sender: TObject; ErrCode: Word);
begin
  //--���� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    ICQ_GoOffline;
  end;
end;

procedure TMainForm.ICQWSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  //--���� ��� ���������� �������� ������, �� �������� �� ����
  if (not ICQ_Connect_Phaze) and (not ICQ_Offline_Phaze) then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    ICQ_GoOffline;
    //--���� ����� ����������������, �� ���������� ���� ������
    ICQ_Reconnect := true;
  end;
end;

procedure TMainForm.ICQWSocketSessionConnected(Sender: TObject; ErrCode: Word);
var
  http_data, http_login: string;
begin
  //--���� ��� ����������� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    ICQ_GoOffline;
  end;
  //--HTTP ������ �������
  if HttpProxy_Enable then
  begin
    //--���������� �����
    if ICQ_Connect_Phaze then http_data := ICQ_LoginServerAddr + ':' + ICQ_LoginServerPort
    else http_data := ICQ_Bos_IP + ':' + ICQ_Bos_Port;
    //--���� ����������� �� ������
    if HttpProxy_Auth then
    begin
      http_login := Base64Encode(HttpProxy_Login + ':' + HttpProxy_Password);
      http_login := 'Authorization: Basic ' + http_login + #13#10 +
        'Proxy-authorization: Basic ' + http_login + #13#10;
    end;
    //--��������� �������� ������ ��� http ������
    http_data := 'CONNECT ' + http_data + ' HTTP/1.0' + #13#10 +
      'User-agent: Mozilla/4.08 [en] (WinNT; U)' + #13#10 +
      http_login + #13#10;
    //--�������� ������ ��� ������
    ICQWSocket.sendStr(http_data);
  end;
end;

procedure TMainForm.ICQWSocketSocksConnected(Sender: TObject; ErrCode: Word);
begin
  //--���� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    ICQ_GoOffline;
  end;
end;

procedure TMainForm.ICQWSocketSocksError(Sender: TObject; Error: Integer;
  Msg: string);
begin
  //--���� �������� ������, �� �������� �� ����
  if Error <> 0 then
  begin
    DAShow(ErrorHead, Msg, EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    ICQ_GoOffline;
  end;
end;

procedure TMainForm.ICQXStatusClick(Sender: TObject);
begin
  //--��������� ���� ������ ��������������� �������
  if not Assigned(IcqXStatusForm) then IcqXStatusForm := TIcqXStatusForm.Create(self);
  //--���������� ����� ������� �������
  FormShowInWorkArea(IcqXStatusForm);
end;

procedure TMainForm.JabberToolButtonClick(Sender: TObject);
begin
  //--��������� ���� ��� ���� ���������
  Popup(JabberToolButton, JabberPopupMenu);
end;

procedure TMainForm.JabberToolButtonContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  //--��������� ���� ��� ���� ���������
  Popup(JabberToolButton, RightJabberPopupMenu);
end;

procedure TMainForm.JabberWSocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  Pkt, challenge: string;
  ProxyErr, CntPkt, i: integer;
begin
  CntPkt := 0;
  //--�������� ��������� �� ������� ������ � ������
  Pkt := DecodeStr(JabberWSocket.ReceiveStr);
  //--���� ��� ��������� ������ �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    Jabber_GoOffline;
  end;
  //--HTTP ������ �������
  if (HttpProxy_Enable) and (Jabber_Connect_Phaze) and (not Jabber_HTTP_Connect_Phaze) then
  begin
    //--������� ������ � ����������� �����
    Jabber_myBeautifulSocketBuffer := Jabber_myBeautifulSocketBuffer + Pkt;
    //--���� ��� ������ ����������� �� ������, �� �������
    if pos(#13#10 + #13#10, Jabber_myBeautifulSocketBuffer) = 0 then Exit;
    //--�������� �� ������ ������ ������ ���������� �� ������
    Pkt := chop(#13#10 + #13#10, Jabber_myBeautifulSocketBuffer);
    //--�������� ������ ������
    ProxyErr := 0;
    //--���� ����� ������������� � ������ ��������� ����������,
    //�� ���������� ���� ����������� ����� http ������
    if AnsiStartsStr('HTTPS/1.0 200', pkt) or AnsiStartsStr('HTTPS/1.1 200', pkt)
      or AnsiStartsStr('HTTP/1.0 200', pkt) or AnsiStartsStr('HTTP/1.1 200', pkt) then
    begin
      Jabber_HTTP_Connect_Phaze := true;
    end
    else
      //--�������� �� ������� ������
      if AnsiStartsStr('HTTP/1.0 407', pkt) then
      begin
        ProxyErr := 1;
        DAShow(ErrorHead, ProxyConnectErrL1, EmptyStr, 134, 2, 0);
      end
      else
      begin
        ProxyErr := 2;
        DAShow(ErrorHead, ProxyConnectErrL2, EmptyStr, 134, 2, 0);
      end;
    //--�������� �� ������ ����� � ������� Jabber
    Pkt := Jabber_myBeautifulSocketBuffer;
    //--������� �����
    Jabber_myBeautifulSocketBuffer := EmptyStr;
    //--���� � ������ � ������ ���� ������, �� ������ � �������
    if ProxyErr <> 0 then
    begin
      Jabber_GoOffline;
      Exit;
    end;
  end;
  //--���� ������ ���� ������ ����� ����, ������� �� ���� :)
  if Length(Pkt) = 0 then Exit;
  //--����������� ���������� ��������� �������
  TrafRecev := TrafRecev + Length(Pkt);
  AllTrafRecev := AllTrafRecev + Length(Pkt);
  if Assigned(TrafficForm) then OpenTrafficClick(nil);
  //--��������� ����� ��������� ������
  if Pkt = ('</' + FRootTag + '>') then Jabber_GoOffline;
  //--������������ ������ ������� �� ������ � �������� ������� ������
  Jabber_BuffPkt := Jabber_BuffPkt + Pkt;
  repeat
    Pkt := GetFullTag(Jabber_BuffPkt);
    if Pkt <> EmptyStr then
    begin
      if (Pkt[2] <> '?') and (Pkt[2] <> '!') and (BMSearch(0, Pkt, FRootTag) = -1) then
      begin
        //--���� ��� ������ ����������� � ������� ������
        if Jabber_Connect_Phaze then
        begin
          //--���� �������� ����������� DIGEST-MD5
          if BMSearch(0, Pkt, '>DIGEST-MD5<') > -1 then
            //--�������� ������ challenge
            JabberWSocket.SendStr(UTF8Encode('<auth xmlns=''urn:ietf:params:xml:ns:xmpp-sasl'' mechanism=''DIGEST-MD5''/>'))
          //--���� ������� ����� challenge, �� �������������� ��� � �������� �����������
          else if BMSearch(0, Pkt, '</challenge>') > -1 then
          begin
            //--�������� ������ challenge �� ������ � ��������������
            challenge := Base64Decode(IsolateTextString(Pkt, '>', '</challenge>'));
            //--�������� �� challenge ���� nonce
            challenge := IsolateTextString(challenge, 'nonce="', '"');
            //--���� challenge ������, �� ������ �� ��� ��������������
            if challenge = EmptyStr then JabberWSocket.SendStr(UTF8Encode('<response xmlns=''urn:ietf:params:xml:ns:xmpp-sasl''/>'))
            else
              //--�������� ����� � ������������
              JabberWSocket.SendStr(JabberDIGESTMD5_Auth(Jabber_LoginUIN,
                Jabber_ServerAddr, Jabber_LoginPassword, challenge, GetRandomHexBytes(32)));
          end
          else if BMSearch(0, Pkt, '<not-authorized') > -1 then
          begin
            //--���������� ���������, ��� ����������� �� �������� � ��������� �����
            DAShow(ErrorHead, JabberLoginErrorL, EmptyStr, 134, 2, 0);
            Jabber_GoOffline;
          end
          else if BMSearch(0, Pkt, '<success') > -1 then
          begin
            //--���������� ������ � ������ ��������
            JabberWSocket.SendStr(UTF8Encode(Format(StreamHead, [Jabber_ServerAddr])));
            //--���������� ����� ������ ��� Jabber
            Jabber_Connect_Phaze := false;
            Jabber_HTTP_Connect_Phaze := false;
            Jabber_Work_Phaze := true;
            Jabber_Offline_Phaze := false;
            //--��������� ����� �������������� ���� �� ��� � ��� ������!
            Jabber_Reconnect := false;
            //--��������� ������ ������� ���� �������
            if Jabber_KeepAlive then JvTimerList.Events[9].Enabled := true;
            //--�������
            //--������� ������ Jabber � �������
            RosterForm.ClearContacts('Jabber');
            Exit;
          end;
        end;
        //--��������� ������ ������� ���� jabber
        if Jabber_Work_Phaze then
        begin
          //--��������� � STREAM ��� ���������� ��������� �������� ����� ��������
          Pkt := '<istream>' + Pkt + '</istream>';
          //--�������������� XML
          with TrXML.Create() do
          try
            begin
              //--��������� ����� � ������ xml
              Text := Pkt;
              //--�������� ������ �� ��������� ��������� �������
              if OpenKey('istream') then
              try
                CntPkt := GetKeyCount();
              finally
                CloseKey();
              end;
              for i := 0 to CntPkt - 1 do
              begin
                if OpenKey('istream\stream:features', false, i) then
                try
                  Jabber_ParseFeatures(GetKeyXML);
                finally
                  CloseKey();
                end
                //--������ ������ iq
                else if OpenKey('istream\iq', false, i) then
                try
                  Jabber_ParseIQ(GetKeyXML);
                finally
                  CloseKey();
                end
                //--������ ������ presence
                else if OpenKey('istream\presence', false, i) then
                try
                  Jabber_ParsePresence(GetKeyXML);
                finally
                  CloseKey();
                end
                else if OpenKey('istream\message', false, i) then
                try
                  Jabber_ParseMessage(GetKeyXML);
                finally
                  CloseKey();
                end;
              end;
            end;
          finally
            Free();
          end;
        end;
      end;
    end;
  until ((Pkt = '') or (Jabber_BuffPkt = ''));
end;

procedure TMainForm.JabberWSocketError(Sender: TObject);
begin
  //--���������� ������ ������
  DAShow(ErrorHead, ICQ_NotifyConnectError(WSocket_WSAGetLastError), EmptyStr, 134, 2, 0);
  //--���������� ����� �������
  Jabber_GoOffline;
end;

procedure TMainForm.JabberWSocketSendData(Sender: TObject; BytesSent: Integer);
begin
  //--����������� ���������� ���������� �������
  TrafSend := TrafSend + BytesSent;
  AllTrafSend := AllTrafSend + BytesSent;
  if Assigned(TrafficForm) then OpenTrafficClick(nil);
end;

procedure TMainForm.JabberWSocketSessionAvailable(Sender: TObject;
  ErrCode: Word);
begin
  //--���� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    Jabber_GoOffline;
  end;
end;

procedure TMainForm.JabberWSocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
  //--���� ��� ���������� �������� ������, �� �������� �� ����
  if not Jabber_Offline_Phaze then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    Jabber_GoOffline;
    //--���� ����� ����������������, �� ���������� ���� ������
    Jabber_Reconnect := true;
  end;
end;

procedure TMainForm.JabberWSocketSessionConnected(Sender: TObject;
  ErrCode: Word);
var
  http_data, http_login: string;
begin
  //--���� ��� ����������� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    Jabber_GoOffline;
  end;
  //--HTTP ������ �������
  if HttpProxy_Enable then
  begin
    //--���������� �����
    if Jabber_Connect_Phaze then http_data := Jabber_ServerAddr + ':' + Jabber_ServerPort;
    //--���� ����������� �� ������
    if HttpProxy_Auth then
    begin
      http_login := Base64Encode(HttpProxy_Login + ':' + HttpProxy_Password);
      http_login := 'Authorization: Basic ' + http_login + #13#10 +
        'Proxy-authorization: Basic ' + http_login + #13#10;
    end;
    //--��������� �������� ������ ��� http ������
    http_data := 'CONNECT ' + http_data + ' HTTP/1.0' + #13#10 +
      'User-agent: Mozilla/4.08 [en] (WinNT; U)' + #13#10 +
      http_login + #13#10;
    //--�������� ������ ��� ������
    JabberWSocket.sendStr(http_data);
  end;
  //--�������� ������ ������ ������ � ��������
  JabberWSocket.SendStr(UTF8Encode(Format(StreamHead, [Jabber_ServerAddr])));
end;

procedure TMainForm.JabberWSocketSocksConnected(Sender: TObject; ErrCode: Word);
begin
  //--���� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    Jabber_GoOffline;
  end;
end;

procedure TMainForm.JabberWSocketSocksError(Sender: TObject; Error: Integer;
  Msg: string);
begin
  //--���� �������� ������, �� �������� �� ����
  if Error <> 0 then
  begin
    DAShow(ErrorHead, Msg, EmptyStr, 134, 2, 0);
    //--���������� ����� �������
    Jabber_GoOffline;
  end;
end;

procedure TMainForm.JabberXStatusClick(Sender: TObject);
begin
  //--��������� ���� ������ ��������������� �������
  if not Assigned(IcqXStatusForm) then IcqXStatusForm := TIcqXStatusForm.Create(self);
  //--���������� ����� ������� �������
  FormShowInWorkArea(IcqXStatusForm);
end;

procedure TMainForm.JvTimerListEvents0Timer(Sender: TObject);
begin
  //--���������� ������� ���� ���������
  MainForm.Show;
  //--������� ���� �� ����� �������� ����, ������ ������ � ��� � ����
  SetForeGroundWindow(Application.MainForm.Handle);
  //--���� ��� ������ ����� ��������� �� ��������� ���� ��������� ��������� ����������
  if not FirstStart then
  begin
    //--��� �������� ���� ��������� �������������
    Update;
    //--����� ���������� ���� ��������� ��������� ����������
    FirstStartForm := TFirstStartForm.Create(self);
    FirstStartForm.Show;
  end;
end;

procedure TMainForm.JvTimerListEvents11Timer(Sender: TObject);
begin
  //--������������ ������
  RosterForm.UpdateFullCL;
end;

procedure TMainForm.JvTimerListEvents12Timer(Sender: TObject);
begin
  //--�������������� ������ � ���� ������ ����� � ���� � ������
  ICQTrayIcon.Refresh;
  MRATrayIcon.Refresh;
  JabberTrayIcon.Refresh;
end;

procedure TMainForm.JvTimerListEvents1Timer(Sender: TObject);
{var
  i, t: integer;
  YesMsgICQ, YesMsgJabber, GroupRoasterMsg: boolean;
  RosterItem: TListItem;
  CLItem: TButtonItem;
  ChatItem: TTabSheet;}
begin
  //--������� �� ������� ����� ��� ����� ��������� �� �����������
  //� ���������� ������ �������� ���������
  //--�������� ������� �����
  {YesMsgICQ := false;
  YesMsgJabber := false;
  GroupRoasterMsg := false;}
  //--��������� � ��������� �������� ��������� � ������� ��������� � ��
  {if Assigned(RosterForm) then
  begin
    with RosterForm.RosterJvListView do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        //--���� ����� ������ � ��
        CLItem := RosterForm.ReqCLContact(Items[i].Caption);
        //--���� ����� ������ � ����
        ChatItem := RosterForm.ReqChatPage(Items[i].Caption);
        //--���� ������� ����� � ������, �� ���������� ��� ������� �����
        if Items[i].SubItems[18] <> '0' then
        begin
          t := StrToInt(Items[i].SubItems[18]);
          Dec(t);
          Items[i].SubItems[18] := IntToStr(t);
          //--���������� ������ ����� � ��
          if CLItem <> nil then CLItem.ImageIndex := 228;
          //--���������� ������ ����� � ����
          if ChatItem <> nil then ChatItem.ImageIndex := 228;
        end
        //--���� ������� ����� � �������, �� ���������� ��� ������� �����
        else if Items[i].SubItems[19] <> '0' then
        begin
          t := StrToInt(Items[i].SubItems[19]);
          Dec(t);
          Items[i].SubItems[19] := IntToStr(t);
          //--���������� ������ ����� � ��
          if CLItem <> nil then CLItem.ImageIndex := 229;
          //--���������� ������ ����� � ����
          if ChatItem <> nil then ChatItem.ImageIndex := 229;
        end
        //--���� ������� �������� ��� ��������� � ����� ������ ������ ����� ������
        else if Items[i].SubItems[35] <> '0' then
        begin
          //--��������� �������� ��������� ������� ������ ���������
          t := StrToInt(Items[i].SubItems[35]);
          Dec(t);
          Items[i].SubItems[35] := IntToStr(t);
          //--���������� ������ ������ ��������� � ��
          if CLItem <> nil then CLItem.ImageIndex := 161;
          //--���������� ������ ������ ��������� � ����
          if ChatItem <> nil then ChatItem.ImageIndex := 161;
        end
        else
          begin
            //--���������� ������ ������� � ��
            if CLItem <> nil then
            begin
              CLItem.Status := StrToInt(Items[i].SubItems[6]);
              CLItem.ImageIndex := CLItem.Status;
            end;
            //--���������� ������ ������� � ����
            if ChatItem <> nil then
            begin
              ChatItem.Tag := StrToInt(Items[i].SubItems[6]);
              ChatItem.ImageIndex := ChatItem.Tag;
            end;
          end;
      end;
    end;








  {//--��������� � ��������� �������� ��������� � ������� ���������
  with MainForm.ContactList do
  begin
    for i := 0 to Categories.Count - 1 do
    begin
      for ii := 0 to Categories[i].Items.Count - 1 do
      begin
        //--���� ������� �������� ��� ��������� � ����� ������ ������ ����� ������
        if (Categories[i].Items[ii].Typing) and (Categories[i].Items[ii].TypingTime < 60) then
        begin
          Categories[i].Items[ii].ImageIndex := 161;
          Categories[i].Items[ii].TypingTime := Categories[i].Items[ii].TypingTime + 1;
        end
        else
        begin
          //--���� �� ��������, �� �������� ����� ������ ��������� ���������
          Categories[i].Items[ii].TypingTime := 0;
          Categories[i].Items[ii].Typing := false;
          //--���� ����� ���� ��� ���� ������������� ��������� �� ����� ��������
          if Categories[i].Items[ii].Msg then
          begin
            //--���� ������ ��������� ��� ������������, �� ������ � �� ������,
            //���� ��������, �� �� ������ ���������
            if Categories[i].Items[ii].ImageIndex = 165 then
              Categories[i].Items[ii].ImageIndex := Categories[i].Items[ii].Status
            else Categories[i].Items[ii].ImageIndex := 165;
            //--������ �����, ��� � ���� ������ ���� ������� �������� � �����������
            if Categories[i].Items[ii].ContactType = 'Icq' then YesMsgICQ := true
            else if Categories[i].Items[ii].ContactType = 'Jabber' then YesMsgJabber := true;
            //--���� ������ �������, �� ������ �� ���� ���
            if (Categories[i].Collapsed) and (not GroupRoasterMsg) then
            begin
              if Categories[i].TextColor = clBlack then Categories[i].TextColor := clRed
              else Categories[i].TextColor := clBlack;
              GroupRoasterMsg := true;
            end;
            //--���� ������ �� �������, �� ������ � ����� ������
            if not Categories[i].Collapsed then Categories[i].TextColor := clBlack;
          end
          else
          begin
            //--���� ����� ��������� ����, �� ��������� �� �� ���������
            //� ������� �������, ���� ���, �� ����������� �
            if Categories[i].Items[ii].ImageIndex <> Categories[i].Items[ii].Status then
              Categories[i].Items[ii].ImageIndex := Categories[i].Items[ii].Status;
            //--���� ��� ��������� ������, �� ������ ����� ������ ������
            if ((not YesMsgICQ) and (not YesMsgJabber)) and (not GroupRoasterMsg) then Categories[i].TextColor := clBlack;
          end;
        end;
      end;
    end;
  end;}
  //--������ �������� ��������� �� �������� ���� ����
   { if Assigned(ChatForm) then
    begin
      with ChatForm.ChatPageControl do
      begin
        for i := 0 to PageCount - 1 do
        begin
        //--���� ������� �������� ��� ��������� � ����� ������ ������ ����� ������
          if (Pages[i].Margins.Top = 1) and (Pages[i].Margins.Right < 60) then
          begin
          //--���� �������� ������� ��������� � UIN
            if Pages[i].HelpKeyword = ChatForm.InfoPanel2.Caption then
            begin
            //--������ ��������� � ������ ������
              ChatForm.NotifyPanel.Font.Color := clBlue;
              ChatForm.NotifyPanel.Caption := TypingTextL;
            end
            else Pages[i].ImageIndex := 161;
            Pages[i].Margins.Right := Pages[i].Margins.Right + 1;
          end
          else
          begin
          //--���� �� ��������, �� �������� ����� ������ ��������� ���������
            Pages[i].Margins.Top := 0;
            Pages[i].Margins.Right := 0;
          //--���� �������� ������� ��������� � UIN
            if Pages[i].HelpKeyword = ChatForm.InfoPanel2.Caption then
            begin
            //--���������� ��������� � ������ ������
              ChatForm.NotifyPanel.Font.Color := clWindowText;
              ChatForm.NotifyPanel.Caption := '...';
            end;
          //--���� ����� ���� ��� ���� ������������� ��������� �� ����� ��������
            if Pages[i].Margins.Left = 1 then
            begin
            //--���� ������ ��������� ��� ������������, �� ������ � �� ������,
            //���� ��������, �� �� ������ ���������
              if Pages[i].ImageIndex = 165 then Pages[i].ImageIndex := Pages[i].Tag
              else Pages[i].ImageIndex := 165;
            //--������� �������� �� 1 ������������
              Sleep(1);
            //--���� ���� ���� �� �������, �� ������ ��� ������� �� ������ �����
              if not ChatForm.Active then FormFlash(ChatForm.Handle);
            end
          //--���� ����� ��������� ����, �� ��������� �� �� ���������
          //� ������� �������, ���� ���, �� ����������� �
            else if Pages[i].ImageIndex <> Pages[i].Tag then Pages[i].ImageIndex := Pages[i].Tag;
          end;
        end;
      end;
    end;
  //--���� �� ������� ������ ������ ����������, �� ����� ������ �������� ���������
    if not JvTimerList.Events[3].Enabled then
    begin
    //--���� ���� ������������� ��������� � �� � � ������ ������� �������� ���������
      if (YesMsgICQ) and (InMessList.Count > 0) then
      begin
      //--������ ���� � ����, ��� ���� ��������� ��� ��������
        ICQTrayIcon.Tag := 1;
      //--���� ������ ��������� ��� ������������, �� ������ � �� ������,
      //���� ��������, �� �� ������ ���������
        if ICQTrayIcon.IconIndex = 165 then ICQTrayIcon.IconIndex := ICQ_CurrentStatus
        else ICQTrayIcon.IconIndex := 165;
      end
      else
      begin
      //--���������� ����������� ������ ��������� � ���� ��� ICQ
        ICQTrayIcon.Tag := 0;
        ICQTrayIcon.IconIndex := ICQ_CurrentStatus;
      end;
    //--���� ���� ������������� ��������� � �� � � ������ ������� �������� ���������
      if (YesMsgJabber) and (InMessList.Count > 0) then
      begin
      //--������ ���� � ����, ��� ���� ��������� ��� ��������
        JabberTrayIcon.Tag := 1;
      //--���� ������ ��������� ��� ������������, �� ������ � �� ������,
      //���� ��������, �� �� ������ ���������
        if JabberTrayIcon.IconIndex = 165 then JabberTrayIcon.IconIndex := Jabber_CurrentStatus
        else JabberTrayIcon.IconIndex := 165;
      end
      else
      begin
      //--���������� ����������� ������ ��������� � ���� ��� ICQ
        JabberTrayIcon.Tag := 0;
        JabberTrayIcon.IconIndex := Jabber_CurrentStatus;
      end;
    end;}
  //end;
end;


procedure TMainForm.JvTimerListEvents2Timer(Sender: TObject);
begin
  //--������ ���� - ������������ ����������� ��������� ���� ����� ������ ����
  if Sender = nil then UpdateAuto := false
  else UpdateAuto := true;
  //--���������� ����� ���� �� ����� ��� �� ������ ��� �����
  UpdateHttpClient.Abort;
  //--������ ���� �������
  UpdateHttpClient.Tag := 0;
  //--��������� �������� ���������� ��������� �� �����
  try
    UpdateHttpClient.URL := 'http://imadering.googlecode.com/files/version.txt';
    UpdateHttpClient.GetASync;
  except
  end;
end;

procedure TMainForm.JvTimerListEvents3Timer(Sender: TObject);
var
  NoStopTimer: boolean;
begin
  NoStopTimer := false;
  //--���������� �������� ������ ����������� � ������� ICQ
  if (ICQ_Connect_Phaze) or (ICQ_BosConnect_Phaze) then
  begin
    NoStopTimer := true;
    if ICQTrayIcon.IconIndex <> 168 then
    begin
      ICQTrayIcon.IconIndex := 168;
      ICQToolButton.ImageIndex := 168;
    end
    else
    begin
      ICQTrayIcon.IconIndex := 169;
      ICQToolButton.ImageIndex := 169;
    end;
  end
  else
  begin
    ICQToolButton.ImageIndex := ICQ_CurrentStatus;
    ICQTrayIcon.IconIndex := ICQ_CurrentStatus;
  end;
  //--���������� �������� ������ ����������� � ������� Jabber
  if Jabber_Connect_Phaze then
  begin
    NoStopTimer := true;
    if JabberTrayIcon.IconIndex <> 168 then
    begin
      JabberTrayIcon.IconIndex := 168;
      JabberToolButton.ImageIndex := 168;
    end
    else
    begin
      JabberTrayIcon.IconIndex := 169;
      JabberToolButton.ImageIndex := 169;
    end;
  end
  else
  begin
    JabberToolButton.ImageIndex := Jabber_CurrentStatus;
    JabberTrayIcon.IconIndex := Jabber_CurrentStatus;
  end;
  //--������������� ������
  if not NoStopTimer then JvTimerList.Events[3].Enabled := false;
end;

procedure TMainForm.JvTimerListEvents4Timer(Sender: TObject);
begin
  //--���� ������� ���������, �� ��������� ������ � �������
  if not UnstableICQStatus.Checked then
  begin
    JvTimerList.Events[4].Enabled := false;
    //--���������� ������� �������� �������
    ICQ_CurrentStatus := ICQ_CurrentStatus_bac;
    //--�������� �������� ����� �������
    SendFLAP('2', ICQ_CreateShortStatusPkt);
    Exit;
  end;
  //--��� ������ ICQ (����������� ����� ��������� � ����������� ����� ���������)
  if ICQ_Work_Phaze then
  begin
    if ICQ_CurrentStatus <> 11 then ICQ_CurrentStatus := 11
    else ICQ_CurrentStatus := ICQ_CurrentStatus_bac;
    //--�������� �������� ����� �������
    SendFLAP('2', ICQ_CreateShortStatusPkt);
  end;
end;

procedure TMainForm.JvTimerListEvents5Timer(Sender: TObject);
begin
  //--���� �� ���������� ������� ���� ICQ, �� ��������� ������
  if not ICQ_Work_Phaze then
  begin
    JvTimerList.Events[5].Enabled := false;
    Exit;
  end;
  //--�������� ����� � ������ ������ 60 ��������
  SendFlap('5', '0000003C');
  //--�������� ���� ��� ������� ������ ICQ
  if ICQ_Avatar_Work_Phaze then SendFLAP_Avatar('5', '0000003C');
end;

procedure TMainForm.JvTimerListEvents6Timer(Sender: TObject);
begin
  //--�������� ���� ������ ��������� �� ������� ������� �����������
  Hide;
end;

procedure TMainForm.JvTimerListEvents7Timer(Sender: TObject);
begin
  //--������ ����� �� ���������� ����� ������� ����� �������� ���� ����
  if not Assigned(SmilesForm) then SmilesForm := TSmilesForm.Create(nil);
end;

procedure TMainForm.JvTimerListEvents8Timer(Sender: TObject);
begin
  //--��������� ���������� ������ ������ � ���������� �������
  //--���� ����� ���������� � �� ��������, �� ��������� ���
  if ZipHistoryThread.Terminated then ZipHistoryThread.Start;
end;

procedure TMainForm.JvTimerListEvents9Timer(Sender: TObject);
begin
  //--���� �� ���������� ������� ���� Jabber, �� ��������� ������
  if not Jabber_Work_Phaze then
  begin
    JvTimerList.Events[9].Enabled := false;
    Exit;
  end;
  //--�������� ����� � ������ ������ 60 ��������
  JabberWSocket.SendStr(Utf8Encode(' ' + #09 + ' '));
end;

procedure TMainForm.LoadImageList(ImgList: TImageList; FName: string);
var
  i, Count: integer;
  img1, img2: TBitmap;
begin
  //--������ ��������� ������
  img1 := TBitmap.Create;
  img2 := TBitmap.Create;
  img1.Height := 16;
  img1.Width := 16;
  img2.Height := 16;
  img2.Width := 16;
  try
    if FileExists(FName) then
    begin
      //--���� ���� � �������� ����, �� ��������� ���
      img1.LoadFromFile(FName);
      //--��������� ��������� ������ � �����
      Count := img1.Width div 16;
      //--��������� �� ����� ������ � ���� ������ � ����������� ������������ ����
      for i := 0 to Count do
      begin
        img2.Canvas.CopyRect(Rect(0, 0, 16, 16), Img1.Canvas,
          Bounds(i * 16, 0, 16, 16));
        ImgList.AddMasked(img2, clFuchsia);
      end;
    end;
  finally
    img1.Free;
    img2.Free;
  end;
end;

procedure TMainForm.MainToolButtonClick(Sender: TObject);
begin
  //--��������� ���� ��� ���� ���������
  Popup(MainToolButton, MainPopupMenu);
end;

procedure TMainForm.MainToolButtonContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  //--���������� ���������� ����������� ����
  MainToolButtonClick(Sender);
end;

procedure TMainForm.MRAToolButtonClick(Sender: TObject);
begin
  //--��������� ���� ��� ���� ���������
  Popup(MRAToolButton, MRAPopupMenu);
end;

procedure TMainForm.MRAToolButtonContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  //--��������� ���� ��� ���� ���������
  Popup(MRAToolButton, RightMRAPopupMenu);
end;

procedure TMainForm.MRAXStatusClick(Sender: TObject);
begin
  //--��������� ���� ������ ��������������� �������
  if not Assigned(MraXStatusForm) then MraXStatusForm := TMraXStatusForm.Create(self);
  //--���������� ����� ������� �������
  FormShowInWorkArea(MraXStatusForm);
end;

procedure TMainForm.CheckStatusContactClick(Sender: TObject);
begin
  //--��������� ������ ��������
  if ContactList.SelectedItem <> nil then
  begin
    //--���� ������� ICQ
    if ContactList.SelectedItem.ContactType = 'Icq' then
    begin
      if ICQ_Work_Phaze then ICQ_ReqStatus0215(ContactList.SelectedItem.UIN)
      else DAShow(AlertHead, OnlineAlert, EmptyStr, 133, 3, 0);
    end;
  end;
end;

procedure TMainForm.CheckUpdateClick(Sender: TObject);
begin
  //--��������� �������� ���������� ��������� �� �����
  JvTimerListEvents2Timer(nil);
end;

procedure TMainForm.OpenTrafficClick(Sender: TObject);
begin
  //--���������� ���� �������
  if not Assigned(TrafficForm) then TrafficForm := TTrafficForm.Create(self);
  //--���������� ������� ������� �������� �� ��� ������
  TrafficForm.Edit1.Text := FloatToStrF(TrafRecev / 1000, ffFixed, 18, 3) + ' �� | ' +
    FloatToStrF(TrafSend / 1000, ffFixed, 18, 3) + ' �� | ' + DateTimeToStr(SesDataTraf);
  //--���������� ������� ������� �������� �����
  TrafficForm.Edit2.Text := FloatToStrF(AllTrafRecev / 1000000, ffFixed, 18, 3) + ' �� | ' +
    FloatToStrF(AllTrafSend / 1000000, ffFixed, 18, 3) + ' �� | ' + AllSesDataTraf;
  //--���������� ����
  if not TrafficForm.Visible then TrafficForm.Show;
end;

procedure TMainForm.OpenTestClick(Sender: TObject);
begin
  //--����� ��� ������� ������

end;

procedure TMainForm.OnlyOnlineContactsToolButtonClick(Sender: TObject);
begin
  //--���������� ������� � ���������� ��������� ������ ���. ����. ������� ���������
  if OnlyOnlineContactsToolButton.Down then
  begin
    OnlyOnlineContactsToolButton.ImageIndex := 137;
    OnlyOnlineContactsToolButton.Hint := OnlyOnlineOn;
    RosterForm.UpdateFullCL;
  end
  else
  begin
    OnlyOnlineContactsToolButton.ImageIndex := 138;
    OnlyOnlineContactsToolButton.Hint := OnlyOnlineOff;
    RosterForm.UpdateFullCL;
  end;
end;

procedure TMainForm.OpenSettingsClick(Sender: TObject);
begin
  //--��������� ���� � ����������� ���������
  if not Assigned(SettingsForm) then SettingsForm := TSettingsForm.Create(self);
  //--���������� ����
  if SettingsForm.Visible then ShowWindow(SettingsForm.Handle, SW_RESTORE);
  SettingsForm.Show;
end;

procedure TMainForm.RenemeGroupCLClick(Sender: TObject);
begin
  ShowMessage(DevelMess);
end;

procedure TMainForm.RosterMainMenuClick(Sender: TObject);
begin
  //--��������� ���� ������ ���������
  if RosterForm.Visible then ShowWindow(RosterForm.Handle, SW_RESTORE);
  RosterForm.Show;
end;

procedure TMainForm.AboutIMaderingClick(Sender: TObject);
begin
  //--��������� ���� � ���������
  if not Assigned(AboutForm) then AboutForm := TAboutForm.Create(self);
  //--���������� ����
  if AboutForm.Visible then ShowWindow(AboutForm.Handle, SW_RESTORE);
  AboutForm.Show;
end;

procedure TMainForm.CloseGroupsCLClick(Sender: TObject);
var
  i: integer;
begin
  //--��������� ��� ������ � ������� �����
  for i := 0 to MainForm.ContactList.Categories.Count - 1 do
    MainForm.ContactList.Categories[i].Collapsed := true;
end;

procedure TMainForm.CloseProgramClick(Sender: TObject);
begin
  //--��������� ���������
  ProgramCloseCommand := true;
  Close;
end;

procedure TMainForm.ContactListButtonClicked(Sender: TObject;
  const Button: TButtonItem);
var
  diff: TdateTime;
begin
  //--�������� ����� �������� �����
  diff := now - lastClick;
  //--���������� ����� �������� �����
  lastClick := now;
  //--���� �� ������� ��������� ������� ����, �� �������� ��������� ���� ���� � ���� ���������
  if (diff < dblClickTime) and (ButtonInd = Button.Index) then
  begin
    //--������ ������ ������ �������� �� ��� ������
    Button.ImageIndex := Button.Status;
    //--��������� ��� � ���� ���������
    RosterForm.OpenChatPage(Button.UIN);
  end;
  //--���������� ������ ������
  ButtonInd := Button.Index;
end;

procedure TMainForm.ContactListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  FCursor: TPoint;
begin
  //--��������� ��������
  Handled := true;
  //--��������� ������ � ������� ���������� �������
  RoasterGroup := ContactList.GetCategoryAt(MousePos.X, MousePos.Y);
  //--�������� ������� �� ������� ��� ������ ���� ����
  ContactList.FocusedItem := nil;
  ContactList.SelectedItem := RoasterButton;
  //--�������� ���������� �������
  GetCursorPos(FCursor);
  //--���� ������ ��, �� ������� ���� ��������
  if RoasterButton <> nil then
  begin
    //--���������� ��� ������������ ������ ��� ����� �������� ������ ����
    //--��� ICQ
    if RoasterButton.ContactType = 'Icq' then
    begin
      DelYourSelfContact.Visible := true;
      CheckStatusContact.Visible := true;
      GrandAuthContact.Visible := true;
      SendAddContact.Visible := true;
    end
    //--��� Jabber
    else if RoasterButton.ContactType = 'Jabber' then
    begin
      DelYourSelfContact.Visible := false;
      CheckStatusContact.Visible := false;
      GrandAuthContact.Visible := false;
      SendAddContact.Visible := false;
    end
    //--��� MRA
    else if RoasterButton.ContactType = 'Mra' then
    begin
      DelYourSelfContact.Visible := false;
      CheckStatusContact.Visible := false;
      GrandAuthContact.Visible := false;
      SendAddContact.Visible := false;
    end;
    //--���������� ����
    ContactPopupMenu.Popup(FCursor.X, FCursor.Y);
  end
  else
  begin
    //--���� ������ ���� ��� �� ������, �� ������������ � ���������
    //� ���������� ��� ������������ ������ ������ ���� ������� �����
    with ContactList do
    begin
      //--���� ���� ��� �� ������, �� ������������ � ���������
      if RoasterGroup <> nil then
      begin
        //--���������� ��������� ��������� ������ ������
        RosterForm.ResetGroupSelected;
        //--������������ ��������� ������� ������
        RoasterGroup.GroupSelected := true;
        ShareUpdateCategory(RoasterGroup);
        //--��������� �������� ���� ��� ������
        RenemeGroupCL.Visible := true;
        DeleteGroupCL.Visible := true;
      end
      else
      begin
        //--���� ���� �� �� ������, �� ������� ��������� �� ���� ���������� �����
        RosterForm.ResetGroupSelected;
        //--��������� �������� ���� ��� ������
        RenemeGroupCL.Visible := false;
        DeleteGroupCL.Visible := false;
      end;
    end;
    //--���������� ����
    ContactListPopupMenu.Popup(FCursor.X, FCursor.Y);
  end;
end;

procedure TMainForm.ContactListHotButton(Sender: TObject;
  const Button: TButtonItem);
begin
  //--��� ����������� �� ������� �� ���������� ���������
  if Button <> nil then RoasterButton := Button
  else RoasterButton := nil;
end;

procedure TMainForm.ContactListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //--��������� ������� ��� ������� ������� ����
  if Button = mbMiddle then
  begin
    //--�������� ������� �� ������� ��� ������ ���� ����
    ContactList.FocusedItem := nil;
    ContactList.SelectedItem := RoasterButton;
    //--��������� ���������� � ��������
    AnketaContactClick(self);
  end;
end;

procedure TMainForm.ContactListSelectedItemChange(Sender: TObject;
  const Button: TButtonItem);
begin
  //--���������� ��������� ��������� ������ ��� ����� �� ������ ��������
  RosterForm.ResetGroupSelected;
end;

procedure TMainForm.CopyAccountContactClick(Sender: TObject);
begin
  //--�������� ��� ������� ������ �������� � ����� ������
  if ContactList.SelectedItem <> nil then SetClipboardText(Handle, ContactList.SelectedItem.UIN);
end;

procedure TMainForm.DeleteContactClick(Sender: TObject);
{label
  x;
var
  i, ii, G, z, zz, cnt: integer;}
begin
  (*//--���� ������ �� ������� ��� ��������, �� �������
  if ContactList.SelectedItem <> nil then
  begin
    //--������� ������� �� ������ ���������
    //--��������� �� ���� �� ������� ���������
    MainForm.Enabled := false;
    try
      //--������� ������ ������������� �������� ��������
      if MessageBox(Handle, PChar(Format(DellContactL, [ContactList.SelectedItem.Caption])), PChar((Sender as TMenuItem).Hint),
        MB_TOPMOST or MB_YESNO or MB_ICONQUESTION) = 6 then
      begin

      end;


      {//--���� ����� �� ������ �������������, �� �������� �������� ��������
      if i = 6 then
      begin
        with ContactList do
        begin
        //--��������� ������ � ���� ���� �������
          for z := 0 to Categories.Count - 1 do
          begin
            for zz := 0 to Categories[z].Items.Count - 1 do
            begin
            //--���� ����� �������
              if Categories[z].Items[zz].UIN = ContactList.SelectedItem.UIN then
              begin
              //--���� ��� ������� �� ������ ���������, �� ������� ��� ��� ���������
                if Categories[z].Items[zz].GroupId = '0000' then
                begin
                //--���������� ����� ��� �������� �������� �� ������ �� �������
                  ICQ_DeleteTempContact(Categories[z].Items[zz].UIN, Categories[z].Items[zz].Idd,
                    Categories[z].Items[zz].iType, Categories[z].Items[zz].TimeId);
                //--���������� ������ ������
                  G := Categories[z].Items[zz].Category.Index;
                //--������� ������� �������� �� ������
                  Categories[z].Items[zz].Destroy;
                //--���� � ������ ������ ��� ���������, �� ������� �
                  if Categories[G].Items.Count = 0 then Categories[G].Destroy;
                end
              //--���� ������� �� ������ "�� � ������"
                else if Categories[z].Items[zz].GroupId = 'NoCL' then
                begin
                //--���������� ������ ������
                  G := Categories[z].Items[zz].Category.Index;
                //--������� ������� �������� �� ������
                  Categories[z].Items[zz].Destroy;
                //--���� � ������ ������ ��� ���������, �� ������� �
                  if Categories[G].Items.Count = 0 then Categories[G].Destroy;
                end
              //--����� ������� ������� ��� ��������
                else
                begin
                //--���������� ����� ��� �������� �������� �� ������ �� �������
                  ICQ_DeleteContact(Categories[z].Items[zz].UIN, Categories[z].Items[zz].GroupId,
                    Categories[z].Items[zz].Idd, Categories[z].Items[zz].Caption,
                    Categories[z].Items[zz].Mobile, Categories[z].Items[zz].Email,
                    Categories[z].Items[zz].Note);
                //--������� ������� �������� �� ������
                  Categories[z].Items[zz].Destroy;
                end;
              //--������� �� ������
                goto x;
              end;
            end;
          end;
          x: ;
        //--��������� ���������� ���������� ��������� � �������
          with MainForm.ContactList do
          begin
            for i := 0 to Categories.Count - 1 do
            begin
              if (Categories[i].GroupId = '0000') or (Categories[i].GroupId = 'NoCL') or
                (Categories[i].Items.Count = 0) then Categories[i].Caption := Categories[i].GroupCaption + ' - ' +
                IntToStr(Categories[i].Items.Count)
              else
              begin
                cnt := Categories[i].Items.Count;
                for ii := 0 to Categories[i].Items.Count - 1 do
                  case Categories[i].Items[ii].Status of
                    9, 80, 214: dec(cnt);
                  end;
                Categories[i].Caption := Categories[i].GroupCaption + ' - ' + IntToStr(cnt) + GroupInv + IntToStr(Categories[i].Items.Count);
              end;
            end;
          end;
        end;
      end;}
    finally
      //--� ����� ������ ���������������� ���� ���������
      MainForm.Enabled := true;
    end;
  end;*)
end;

procedure TMainForm.DeleteGroupCLClick(Sender: TObject);
begin
  ShowMessage(DevelMess);
end;

procedure TMainForm.DelYourSelfContactClick(Sender: TObject);
begin
  if ContactList.SelectedItem <> nil then
  begin
    //--��������� ���� ���������
    MainForm.Enabled := false;
    try
      //--������� ������ �� ������������� ��������
      if MessageBox(Handle, PChar(Format(DellYourSelfL,
        [ContactList.SelectedItem.Caption])), PChar((Sender as TMenuItem).Hint),
        MB_TOPMOST or MB_YESNO or MB_ICONQUESTION) = 6 then
        if ICQ_Work_Phaze then ICQ_DellMyFromCL(ContactList.SelectedItem.UIN)
        else DAShow(AlertHead, OnlineAlert, EmptyStr, 133, 3, 0);
    finally
      //--���������������� ���� ���������
      MainForm.Enabled := true;
    end;
  end;
end;

procedure TMainForm.EditContactClick(Sender: TObject);
begin
  ShowMessage(DevelMess);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  //--��������� ������������ ���� ��� ����������
  if RoasterAlphaBlend then
    if AlphaBlendInactive then AlphaBlendValue := 255;
  //--���������� ������ ����������� ���� ��� ���������� ����
  if JvTimerList.Events[6].Enabled then
  begin
    JvTimerList.Events[6].Enabled := false;
    JvTimerList.Events[6].Enabled := true;
  end;
  //--������� ��� ���� � ���� � ���������� ���� ���� (��� ������ ���������)
  if Assigned(ChatForm) then if ChatForm.Active then ChatForm.FormActivate(self);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--��������� ��������� ����
  SaveMainFormSettings;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //--������ ���� �� ����������� ���������, � ����������� ��� � ����
  if not ProgramCloseCommand then
  begin
    CanClose := false;
    MainFormHideInTray;
  end
  else
  begin
    //--��������� ��� ��������� � �������
    if not ICQ_Offline_Phaze then ICQ_GoOffline;
    if not Jabber_Offline_Phaze then Jabber_GoOffline;
    //if not MRA_Offline_Phaze then MRA_GoOffline;
    //--��������� HTTP ������
    UpdateHttpClient.Abort;
    MRAAvatarHttpClient.Abort;
    //--���������� ������ �������
    if Assigned(AccountToNick) then FreeAndNil(AccountToNick);
    if Assigned(SmilesList) then FreeAndNil(SmilesList);
    if Assigned(InMessList) then FreeAndNil(InMessList);
    if Assigned(NoAvatar) then FreeAndNil(NoAvatar);
    if Assigned(OutMessage2) then FreeAndNil(OutMessage2);
    if Assigned(OutMessage3) then FreeAndNil(OutMessage3);
    if Assigned(SmilesForm) then FreeAndNil(SmilesForm);
    //--������������� �������
    JvTimerList.Active := false;
    //--���� ����� ������ ������� �� ����������� ���, �� ��� ��� ���������
    while not ZipHistoryThread.Terminated do Sleep(10);
    //--������ ������� ��������� ����� ������ ��������� ��� ����������� ��� ������� ���������
    if RosterForm.RosterJvListView.Items.Count > 0 then
      RosterForm.RosterJvListView.SaveToFile(MyPath + 'Profile\ContactList.dat');
  end;
end;

procedure TMainForm.AddNewContactCLClick(Sender: TObject);
begin
  ShowMessage(DevelMess);
end;

procedure TMainForm.AddNewGroupCLClick(Sender: TObject);
begin
  ShowMessage(DevelMess);
end;

procedure TMainForm.AnketaContactClick(Sender: TObject);
begin
  //--���������� ���������� � ��������
  if ContactList.SelectedItem <> nil then
  begin
    if not Assigned(IcqContactInfoForm) then IcqContactInfoForm := TIcqContactInfoForm.Create(self);
    //--����������� UIN ���� �������� ����� ��������
    IcqContactInfoForm.ReqUIN := ContactList.SelectedItem.UIN;
    //--��������� ���������� � ���
    IcqContactInfoForm.LoadUserUnfo;
    //--���������� ����
    if IcqContactInfoForm.Visible then ShowWindow(IcqContactInfoForm.Handle, SW_RESTORE);
    IcqContactInfoForm.Show;
  end;
end;

procedure TMainForm.AppActivate(Sender: TObject);
begin
  FormActivate(self);
end;

procedure TMainForm.AppDeactivate(Sender: TObject);
begin
  FormDeactivate(self);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //--����� ���� ������ �������� ���������
  MyPath := ExtractFilePath(Application.ExeName);
  //--�������� ������ ����� � ����������� ��� ���������� ��������
  SettingsForm := TSettingsForm.Create(self);
  SettingsForm.ApplySettings;
  //--�������� ������ ��� ���������
  LoadImageList(AllImageList, MyPath + 'Icons\' + CurrentIcons + '\icons.bmp');
  //--������������� ������ ����
  AllImageList.GetIcon(1, Icon);
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  //--������ ����������� ��������� �������������
  Application.HintHidePause := MaxInt;
  Application.OnHint := HintMaxTime;
  //--������� ���������� ������ ��������� �������� ���������� � ����
  AllImageList.GetIcon(9, ICQTrayIcon.Icon);
  AllImageList.GetIcon(23, MRATrayIcon.Icon);
  AllImageList.GetIcon(30, JabberTrayIcon.Icon);
  //--��������� ��������� ����
  LoadMainFormSettings;
  if AllSesDataTraf = EmptyStr then AllSesDataTraf := DateTimeToStr(now);
  //--���� ��� ������ ����� ���������, �� �� ��������� ��������� ICQ ��������
  if not FirstStart then ICQEnable(true);
  //--���� ������������� ��������� ����� ������ ��� ������
  if SettingsForm.AutoUpdateCheckBox.Checked then JvTimerList.Events[2].Enabled := true;
  //--��������� ����������� ������� ��������� � �����������
  Application.OnActivate := AppActivate;
  Application.OnDeactivate := AppDeactivate;
  //--������ ���� ����������� � ����� ������
  ScreenSnap := true;
  //--������ ����������� �����
  AccountToNick := TStringList.Create;
  InMessList := TStringList.Create;
  SmilesList := TStringList.Create;
  if FileExists(MyPath + 'Profile\' + 'Nicks.txt') then AccountToNick.LoadFromFile(MyPath + 'Profile\' + 'Nicks.txt');
  if FileExists(MyPath + '\Smilies\' + CurrentSmiles + '\smilies.txt') then
    SmilesList.LoadFromFile(MyPath + '\Smilies\' + CurrentSmiles + '\smilies.txt');
  //--��������� ���� �� ������ ���� ����� ����������, ���� ����, �� �������
  if FileExists(MyPath + 'Imadering.old') then DeleteFile(MyPath + 'Imadering.old');
  //--���� �� ������� ����������� �������� � ���� �� ���������� ������� ����
  if not SettingsForm.HideInTrayProgramStartCheckBox.Checked then JvTimerList.Events[0].Enabled := true;
  //--� ���� ������ ���� �������
  MainForm.JvTimerList.Events[7].Enabled := true;
  //--�������������� ���������� ������� ������ ���������� ������� ������
  SesDataTraf := now;
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  //--�������� ������������ ���� ��� ������������
  if RoasterAlphaBlend then
    if AlphaBlendInactive then AlphaBlendValue := RoasterAlphaValue;
  //--���� ������� ������ (���� � ����)
  if Assigned(SmilesForm) then
    if SmilesForm.Visible then SmilesForm.Close;
end;

procedure TMainForm.GrandAuthContactClick(Sender: TObject);
begin
  //--��������� �������� ��� ��� ���������� ������� �� ����������� ���
  if ContactList.SelectedItem <> nil then
  begin
    if ICQ_Work_Phaze then ICQ_SendGrandAuth(ContactList.SelectedItem.UIN)
    else DAShow(AlertHead, OnlineAlert, EmptyStr, 133, 3, 0);
  end;
end;

procedure TMainForm.LoadMainFormSettings;
begin
  //--�������������� XML
  with TrXML.Create() do
  try
    //--��������� ���������
    if FileExists(MyPath + SettingsFileName) then
    begin
      LoadFromFile(MyPath + SettingsFileName);
      //--��������� ������� ����
      if OpenKey('settings\forms\mainform\position') then
      try
        Top := ReadInteger('top');
        Left := ReadInteger('left');
        Height := ReadInteger('height');
        Width := ReadInteger('width');
        //--���������� �� ��������� �� ���� �� ��������� ������
        FormSetInWorkArea(self);
      finally
        CloseKey();
      end;
      //--��������� ��������� ������ ������
      if OpenKey('settings\forms\mainform\sounds-on-off') then
      try
        if ReadBool('value') then
        begin
          SoundOnOffToolButton.ImageIndex := 136;
          SoundOnOffToolButton.Down := true;
          SoundOnOffToolButton.Hint := SoundOnHint;
        end;
      finally
        CloseKey();
      end;
      //--��������� ��������� ������ ������ ������
      if OpenKey('settings\forms\mainform\only-online-on-off') then
      try
        if ReadBool('value') then
        begin
          OnlyOnlineContactsToolButton.ImageIndex := 137;
          OnlyOnlineContactsToolButton.Down := true;
          OnlyOnlineContactsToolButton.Hint := OnlyOnlineOn;
        end;
      finally
        CloseKey();
      end;
      //--��������� ��� �� ������ �����
      if OpenKey('settings\forms\mainform\first-start') then
      try
        FirstStart := ReadBool('value');
      finally
        CloseKey();
      end;
      //--��������� ��������� ���������
      if OpenKey('settings\forms\mainform\proto-select') then
      try
        ICQEnable(ReadBool('icq'));
        MRAEnable(ReadBool('mra'));
        JabberEnable(ReadBool('jabber'));
      finally
        CloseKey;
      end;
      //--��������� ������ �������
      if OpenKey('settings\traffic') then
      try
        AllTrafSend := ReadFloat('send');
        AllTrafRecev := ReadFloat('recev');
        AllSesDataTraf := ReadString('start-date');
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
  end;
end;

procedure TMainForm.SaveMainFormSettings;
begin
  //--������ ����������� �����
  ForceDirectories(MyPath + 'Profile');
  //--��������� ��������� ��������� �������� ���� � xml
  with TrXML.Create() do
  try
    if FileExists(MyPath + SettingsFileName) then LoadFromFile(MyPath + SettingsFileName);
    //--��������� ������� ����
    if OpenKey('settings\forms\mainform\position', True) then
    try
      WriteInteger('top', Top);
      WriteInteger('left', Left);
      WriteInteger('height', Height);
      WriteInteger('width', Width);
    finally
      CloseKey();
    end;
    //--��������� ���� ���. ����.
    if OpenKey('settings\forms\mainform\sounds-on-off', True) then
    try
      WriteBool('value', SoundOnOffToolButton.Down);
    finally
      CloseKey();
    end;
    //--��������� ���������� ������ ������ ���. ����.
    if OpenKey('settings\forms\mainform\only-online-on-off', True) then
    try
      WriteBool('value', OnlyOnlineContactsToolButton.Down);
    finally
      CloseKey();
    end;
    //--���������� ��� ������ ������ ��������� ��� ��������� � ����������
    //���� ��������� ���������� ������ �� ����� ��� �������
    if OpenKey('settings\forms\mainform\first-start', True) then
    try
      WriteBool('value', true);
    finally
      CloseKey();
    end;
    //--��������� �������� ���������
    if OpenKey('settings\forms\mainform\proto-select', True) then
    try
      WriteBool('icq', ICQToolButton.Visible);
      WriteBool('mra', MRAToolButton.Visible);
      WriteBool('jabber', JabberToolButton.Visible);
    finally
      CloseKey();
    end;
    //--��������� ������
    if OpenKey('settings\traffic', True) then
    try
      WriteFloat('send', AllTrafSend);
      WriteFloat('recev', AllTrafRecev);
      WriteString('start-date', AllSesDataTraf);
    finally
      CloseKey();
    end;
    //--���������� ��� ����
    SaveToFile(MyPath + SettingsFileName);
  finally
    Free();
  end;
end;

procedure TMainForm.SearchInCLClick(Sender: TObject);
begin
  //--��������� ���� ������ ��������� � ���������� �����
  if not Assigned(CLSearchForm) then CLSearchForm := TCLSearchForm.Create(self);
  //--���������� ����
  if CLSearchForm.Visible then ShowWindow(CLSearchForm.Handle, SW_RESTORE);
  CLSearchForm.Show;
end;

procedure TMainForm.SendAddContactClick(Sender: TObject);
begin
  //--���������� ����� "��� ��������"
  if ContactList.SelectedItem <> nil then
  begin
    if ICQ_Work_Phaze then ICQ_SendYouAdded(ContactList.SelectedItem.UIN)
    else DAShow(AlertHead, OnlineAlert, EmptyStr, 133, 3, 0);
  end;
end;

procedure TMainForm.SendInviteContactClick(Sender: TObject);
begin
  ShowMessage(DevelMess);
end;

procedure TMainForm.SendMessageForContactClick(Sender: TObject);
begin
  //--�������� ������� ����� �� ������ ��
  if ContactList.SelectedItem <> nil then
  begin
    //--������ ������� ���� �� ��������
    ContactListButtonClicked(self, ContactList.SelectedItem);
    ContactListButtonClicked(self, ContactList.SelectedItem);
  end;
end;

procedure TMainForm.SoundOnOffToolButtonClick(Sender: TObject);
begin
  //--���������� ������� � ���������� ��������� ������ ���. ����. ������
  if SoundOnOffToolButton.Down then
  begin
    SoundOnOffToolButton.ImageIndex := 136;
    SoundOnOffToolButton.Hint := SoundOnHint;
  end
  else
  begin
    SoundOnOffToolButton.ImageIndex := 135;
    SoundOnOffToolButton.Hint := SoundOffHint;
  end;
end;

procedure TMainForm.TrayPopupMenuPopup(Sender: TObject);
var
  I: integer;
begin
  //--���������� ����� �������� � ���� ������ ��� ���� � ���������
  //��������������� ������ � ��� ��� ������������� �� ����� ���� ������ �������
  if TrayProtoClickMenu = 'icqtrayicon' then
  begin
    StatusTray.ImageIndex := ICQToolButton.ImageIndex;
    //--������� ������ �������
    StatusTray.Clear;
    //--��������� ������� �������� �� ��������� ICQ ����
    with StatusTray do
    begin
      for I := 0 to ICQPopupMenu.Items.Count - 1 do
      begin
        Add(NewItem(ICQPopupMenu.Items[I].Caption, 0, False, True, ICQPopupMenu.Items[I].OnClick, 0, 'MenuItem' + IntToStr(I)));
        //--��������� ������ ��� ������ ����
        Items[I].ImageIndex := ICQPopupMenu.Items[I].ImageIndex;
        //--��������� ��������� ��� ������ ����
        Items[I].Default := ICQPopupMenu.Items[I].Default;
      end;
    end;
  end
  else if TrayProtoClickMenu = 'mratrayicon' then
  begin
    StatusTray.ImageIndex := MRAToolButton.ImageIndex;
    //--������� ������ �������
    StatusTray.Clear;
    //--��������� ������� �������� �� ��������� ICQ ����
    with StatusTray do
    begin
      for I := 0 to MRAPopupMenu.Items.Count - 1 do
      begin
        Add(NewItem(MRAPopupMenu.Items[I].Caption, 0, False, True, MRAPopupMenu.Items[I].OnClick, 0, 'MenuItem' + IntToStr(I)));
        //--��������� ������ ��� ������ ����
        Items[I].ImageIndex := MRAPopupMenu.Items[I].ImageIndex;
        //--��������� ��������� ��� ������ ����
        Items[I].Default := MRAPopupMenu.Items[I].Default;
      end;
    end;
  end
  else if TrayProtoClickMenu = 'jabbertrayicon' then
  begin
    StatusTray.ImageIndex := JabberToolButton.ImageIndex;
    //--������� ������ �������
    StatusTray.Clear;
    //--��������� ������� �������� �� ��������� ICQ ����
    with StatusTray do
    begin
      for I := 0 to JabberPopupMenu.Items.Count - 1 do
      begin
        Add(NewItem(JabberPopupMenu.Items[I].Caption, 0, False, True, JabberPopupMenu.Items[I].OnClick, 0, 'MenuItem' + IntToStr(I)));
        //--��������� ������ ��� ������ ����
        Items[I].ImageIndex := JabberPopupMenu.Items[I].ImageIndex;
        //--��������� ��������� ��� ������ ����
        Items[I].Default := JabberPopupMenu.Items[I].Default;
      end;
    end;
  end;
end;

procedure TMainForm.UnstableICQStatusClick(Sender: TObject);
begin
  //--���������� ��� ������������ ������ ������������� �������
  if not UnstableICQStatus.Checked then
  begin
    UnstableICQStatus.Checked := true;
    JvTimerList.Events[4].Enabled := true;
  end
  else UnstableICQStatus.Checked := false;
end;

procedure TMainForm.OpenGroupsCLClick(Sender: TObject);
var
  i: integer;
begin
  //--��������� ��� ������ � ������� �����
  for i := 0 to MainForm.ContactList.Categories.Count - 1 do
    MainForm.ContactList.Categories[i].Collapsed := false;
end;

procedure TMainForm.OpenHistoryClick(Sender: TObject);
begin
  //--��������� ������ ���� ������� ���������
  if not Assigned(HistoryForm) then HistoryForm := THistoryForm.Create(self);
  //--���������� ����
  if HistoryForm.Visible then ShowWindow(HistoryForm.Handle, SW_RESTORE);
  HistoryForm.Show;
end;

procedure TMainForm.UpdateHttpClientSendEnd(Sender: TObject);
begin
  //--����������� ���������� ���������� �������
  TrafSend := TrafSend + UpdateHttpClient.SentCount;
  AllTrafSend := AllTrafSend + UpdateHttpClient.SentCount;
  if Assigned(TrafficForm) then OpenTrafficClick(nil);
end;

procedure TMainForm.UpdateHttpClientSessionClosed(Sender: TObject);
begin
  //--������������ ��������� ������ � ������ http ������
  if (UpdateHttpClient.StatusCode = 0) or (UpdateHttpClient.StatusCode >= 400) then
  begin
    DAShow(ErrorHead, ErrorHttpClient(UpdateHttpClient.StatusCode), EmptyStr, 134, 2, 0);
  end;
end;

procedure TMainForm.UpdateHttpClientSocksConnected(Sender: TObject;
  ErrCode: Word);
begin
  //--���� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
  end;
end;

procedure TMainForm.UpdateHttpClientSocksError(Sender: TObject; Error: Integer;
  Msg: string);
begin
  //--���� �������� ������, �� �������� �� ����
  if Error <> 0 then
  begin
    DAShow(ErrorHead, Msg, EmptyStr, 134, 2, 0);
  end;
end;

procedure TMainForm.ICQWSocketError(Sender: TObject);
begin
  //--���������� ������ ������
  DAShow(ErrorHead, ICQ_NotifyConnectError(WSocket_WSAGetLastError), EmptyStr, 134, 2, 0);
  //--���������� ����� �������
  ICQ_GoOffline;
end;

initialization
  RegisterHtHints;

end.

