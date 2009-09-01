{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit SettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvPageList, JvExControls, ExtCtrls, ButtonGroup, StdCtrls, Buttons,
  rXml, OverbyteIcsWndControl, OverbyteIcsWSocket, OverbyteIcsHttpProt,
  Registry, ComCtrls, JvLabel, Mask, JvExMask, JvToolEdit;

type
  TSettingsForm = class(TForm)
    SettingButtonGroup: TButtonGroup;
    PagesPanel: TPanel;
    JvPageList1: TJvPageList;
    JvStandardPage1: TJvStandardPage;
    JvStandardPage2: TJvStandardPage;
    JvStandardPage3: TJvStandardPage;
    JvStandardPage4: TJvStandardPage;
    JvStandardPage5: TJvStandardPage;
    CancelBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    ApplyBitBtn: TBitBtn;
    GeneralOptionGroupBox: TGroupBox;
    CLWindowGroupBox: TGroupBox;
    ChatFormGroupBox: TGroupBox;
    EventsGroupBox: TGroupBox;
    GroupBox5: TGroupBox;
    ProxyAddressEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ProxyPortEdit: TEdit;
    ProxyTypeComboBox: TComboBox;
    Label3: TLabel;
    ProxyVersionComboBox: TComboBox;
    Label4: TLabel;
    ProxyAuthCheckBox: TCheckBox;
    ProxyLoginEdit: TEdit;
    ProxyPasswordEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    ProxyShowPassCheckBox: TCheckBox;
    ProxyEnableCheckBox: TCheckBox;
    NTLMCheckBox: TCheckBox;
    GroupBox6: TGroupBox;
    ReconnectCheckBox: TCheckBox;
    HideInTrayProgramStartCheckBox: TCheckBox;
    StartOnWinStartCheckBox: TCheckBox;
    AutoUpdateCheckBox: TCheckBox;
    TransparentGroupBox: TGroupBox;
    HeadTextGroupBox: TGroupBox;
    CLOptionsGroupBox: TGroupBox;
    AlwaylTopCheckBox: TCheckBox;
    TransparentTrackBar: TTrackBar;
    TransparentNotActiveCheckBox: TCheckBox;
    AutoHideCLCheckBox: TCheckBox;
    AutoHideClEdit: TEdit;
    HeaderTextEdit: TEdit;
    JvStandardPage6: TJvStandardPage;
    JvStandardPage7: TJvStandardPage;
    JvStandardPage8: TJvStandardPage;
    JvStandardPage9: TJvStandardPage;
    JvStandardPage10: TJvStandardPage;
    JvStandardPage11: TJvStandardPage;
    JvStandardPage12: TJvStandardPage;
    JvStandardPage13: TJvStandardPage;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    ProtocolsGroupBox: TGroupBox;
    ProtocolsListView: TListView;
    AddProtoBitBtn: TBitBtn;
    SettingsProtoBitBtn: TBitBtn;
    DeleteProtoBitBtn: TBitBtn;
    ProfileGroupBox: TGroupBox;
    jdeProfilePath: TJvDirectoryEdit;
    jlaPath: TJvLabel;
    procedure FormCreate(Sender: TObject);
    procedure SettingButtonGroupButtonClicked(Sender: TObject; Index: Integer);
    procedure CancelBitBtnClick(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure ApplyBitBtnClick(Sender: TObject);
    procedure ProxyAuthCheckBoxClick(Sender: TObject);
    procedure ProxyShowPassCheckBoxClick(Sender: TObject);
    procedure ProxyEnableCheckBoxClick(Sender: TObject);
    procedure ProxyAddressEditChange(Sender: TObject);
    procedure ProxyTypeComboBoxSelect(Sender: TObject);
    procedure TransparentTrackBarChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure AutoHideClEditKeyPress(Sender: TObject; var Key: Char);
    procedure AutoHideClEditExit(Sender: TObject);
    procedure AddProtoBitBtnClick(Sender: TObject);
    procedure DeleteProtoBitBtnClick(Sender: TObject);
    procedure ProtocolsListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SettingButtonGroupKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ProtocolsListViewClick(Sender: TObject);
    procedure ProtocolsListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SettingsProtoBitBtnClick(Sender: TObject);
    procedure ProtocolsListViewDblClick(Sender: TObject);
    procedure jdeProfilePathChange(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSettings;
    procedure TranslateForms;
  public
    { Public declarations }
    procedure ApplySettings;
    procedure ApplyProxyHttpClient(HttpClient: THttpCli);
    procedure ApplyProxySocketClient(SocketClient: TWSocket);
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses
  MainUnit, VarsUnit, TypInfo, IcqOptionsUnit, Code;

procedure DoAppToRun(RunName, AppName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    WriteString(RunName, AppName);
    CloseKey;
    Free;
  end;
end;

function IsAppInRun(RunName: string): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
    Result := ValueExists(RunName);
    CloseKey;
    Free;
  end;
end;

procedure DelAppFromRun(RunName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    if ValueExists(RunName) then DeleteValue(RunName);
    CloseKey;
    Free;
  end;
end;

procedure TSettingsForm.LoadSettings;
var
  ListItemD: TListItem;
begin
  //--��������� ��������� �� xml �����
  if FileExists(ProfilePath + SettingsFileName) then
  begin
    with TrXML.Create() do
    try
      LoadFromFile(ProfilePath + SettingsFileName);
      //--��������� � ���������� ��������� ������
      if OpenKey('settings\proxy\address') then
      try
        ProxyAddressEdit.Text := ReadString('host');
        ProxyPortEdit.Text := ReadString('port');
      finally
        CloseKey();
      end;
      if OpenKey('settings\proxy\type') then
      try
        ProxyTypeComboBox.ItemIndex := ReadInteger('type-index');
        ProxyVersionComboBox.ItemIndex := ReadInteger('version-index');
      finally
        CloseKey();
      end;
      if OpenKey('settings\proxy\auth') then
      try
        ProxyAuthCheckBox.Checked := ReadBool('auth-enable');
        ProxyLoginEdit.Text := ReadString('login');
        ProxyPasswordEdit.Text := Decrypt(ReadString('password'), PassKey);
        NTLMCheckBox.Checked := ReadBool('ntlm-auth');
      finally
        CloseKey();
      end;
      if OpenKey('settings\proxy\main') then
      try
        ProxyEnableCheckBox.Checked := ReadBool('enable');
        ProxyEnableCheckBoxClick(nil);
      finally
        CloseKey();
      end;
      //------------------------------------------------------------------------
      //--��������� � ���������� ������ ���������
      if OpenKey('settings\main\hide-in-tray-program-start') then
      try
        //--��������� ������ �������� � ����
        HideInTrayProgramStartCheckBox.Checked := ReadBool('value');
        //--��������� ���������� ��� ������ Windows
        StartOnWinStartCheckBox.Checked := IsAppInRun('IMadering');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\auto-update-check') then
      try
        //--��������� ��������� ������� ����� ������ ��� �������
        AutoUpdateCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\always-top') then
      try
        //--��������� ������ ���� ����
        AlwaylTopCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\transparent-value') then
      try
        //--��������� ��������� ������������ ������ ���������
        TransparentTrackBar.Position := ReadInteger('value');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\transparent-active') then
      try
        //--��������� ������������ ����������� ���� ������ ���������
        TransparentNotActiveCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\auto-hide-cl') then
      try
        //--��������� ����������� ������ ���������
        AutoHideCLCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\auto-hide-cl-value') then
      try
        //--��������� ����������� ������ ���������
        AutoHideCLEdit.Text := ReadString('value');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\header-cl-form') then
      try
        //--��������� ��������� ���� ������ ���������
        HeaderTextEdit.Text := ReadString('text');
      finally
        CloseKey();
      end;
      if OpenKey('settings\main\reconnect') then
      try
        //--��������� �������������� ��� ������� ����������
        ReconnectCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;
    finally
      Free();
    end;
  end;
  //----------------------------------------------------------------------------
  //--������������� ������� ���������� ����������
  ProtocolsListView.Clear;
  ProtocolsListView.Items.BeginUpdate;
  //--��������� ICQ ��������
  ListItemD := ProtocolsListView.Items.Add;
  ListItemD.Checked := MainForm.ICQToolButton.Visible;
  if Assigned(IcqOptionsForm) then ListItemD.Caption := 'ICQ: ' + IcqOptionsForm.ICQUINEdit.Text
  else ListItemD.Caption := 'ICQ:';
  ListItemD.ImageIndex := 81;
  //--��������� MRA ��������
  ListItemD := ProtocolsListView.Items.Add;
  ListItemD.Checked := MainForm.MRAToolButton.Visible;
  ListItemD.Caption := 'MRA:';
  ListItemD.ImageIndex := 66;
  //--��������� Jabber ��������
  ListItemD := ProtocolsListView.Items.Add;
  ListItemD.Checked := MainForm.JabberToolButton.Visible;
  ListItemD.Caption := 'Jabber:';
  ListItemD.ImageIndex := 43;
  ProtocolsListView.Items.EndUpdate;
end;

procedure TSettingsForm.ApplySettings;
begin
  //--�������� ����
  ProfilePath := jdeProfilePath.Text;

  //--������ ����������� �����
  ForceDirectories(ProfilePath + 'Profile');
  ForceDirectories(ProfilePath + 'Profile\History');
  ForceDirectories(ProfilePath + 'Profile\Avatars');
  ForceDirectories(ProfilePath + 'Profile\Contacts');
  //--��������� ��������� ������
  with MainForm do
  begin
    //--HTTP ����� ��� ���������� ���������
    if UpdateHttpClient.State <> httpConnected then
    begin
      UpdateHttpClient.Abort;
      ApplyProxyHttpClient(UpdateHttpClient);
    end;
    //--HTTP ����� ��� ������ MRA ���������
    if MRAAvatarHttpClient.State <> httpConnected then
    begin
      MRAAvatarHttpClient.Abort;
      ApplyProxyHttpClient(MRAAvatarHttpClient);
    end;
    //--����� ��� ��������� ICQ
    if ICQWSocket.State <> wsConnected then
    begin
      ICQWSocket.Abort;
      ApplyProxySocketClient(ICQWSocket);
    end;
    //--����� ��� ������ ICQ
    if ICQAvatarWSocket.State <> wsConnected then
    begin
      ICQAvatarWSocket.Abort;
      ApplyProxySocketClient(ICQAvatarWSocket);
    end;
    //--����� ��� ��������� MRA
    if MRAWSocket.State <> wsConnected then
    begin
      MRAWSocket.Abort;
      ApplyProxySocketClient(MRAWSocket);
    end;
    //--����� ��� �������� Jabber
    if JabberWSocket.State <> wsConnected then
    begin
      JabberWSocket.Abort;
      ApplyProxySocketClient(JabberWSocket);
    end;
  end;
  //----------------------------------------------------------------------------
  //--��������� ����� ���������
  //--���� "��������� ��� ������ �������", �� ������ ��� � �������
  if StartOnWinStartCheckBox.Checked then DoAppToRun('IMadering', MyPath + 'Imadering.exe')
  else DelAppFromRun('IMadering');
  //--��������� ��������� ��� ������ ���������
  if AlwaylTopCheckBox.Checked then MainForm.FormStyle := fsStayOnTop
  else MainForm.FormStyle := fsNormal;
  //--��������� ��������� ������������
  if TransparentTrackBar.Position > 0 then
  begin
    RoasterAlphaBlend := true;
    MainForm.AlphaBlend := true;
    RoasterAlphaValue := 255 - TransparentTrackBar.Position;
  end
  else
  begin
    RoasterAlphaBlend := false;
    MainForm.AlphaBlend := false;
    MainForm.AlphaBlendValue := 255;
    RoasterAlphaValue := 255;
  end;
  AlphaBlendInactive := TransparentNotActiveCheckBox.Checked;
  //--��������� ��������� ����������� ������ ���������
  MainForm.JvTimerList.Events[6].Enabled := AutoHideCLCheckBox.Checked;
  MainForm.JvTimerList.Events[6].Interval := (StrToInt(AutoHideCLEdit.Text) * 1000);
  //--��������� ��������� ��������� ���� ������ ���������
  MainForm.Caption := HeaderTextEdit.Text;
  //----------------------------------------------------------------------------
  //--���������� ���������
  if ApplyBitBtn.Enabled then
  begin
    if not NoReSave then //--���� ��������� ���������� ��������
    begin
      with TrXML.Create() do
      try
        if FileExists(ProfilePath + SettingsFileName) then LoadFromFile(ProfilePath + SettingsFileName);
        //--���������� ��������� ������
        if OpenKey('settings\proxy\main', True) then
        try
          WriteBool('enable', ProxyEnableCheckBox.Checked);
        finally
          CloseKey();
        end;
        if OpenKey('settings\proxy\address', True) then
        try
          WriteString('host', ProxyAddressEdit.Text);
          WriteString('port', ProxyPortEdit.Text);
        finally
          CloseKey();
        end;
        if OpenKey('settings\proxy\type', True) then
        try
          WriteString('type', ProxyTypeComboBox.Text);
          WriteInteger('type-index', ProxyTypeComboBox.ItemIndex);
          WriteString('version', ProxyVersionComboBox.Text);
          WriteInteger('version-index', ProxyVersionComboBox.ItemIndex);
        finally
          CloseKey();
        end;
        if OpenKey('settings\proxy\auth', True) then
        try
          WriteBool('auth-enable', ProxyAuthCheckBox.Checked);
          WriteString('login', ProxyLoginEdit.Text);
          WriteString('password', Encrypt(ProxyPasswordEdit.Text, PassKey));
          WriteBool('ntlm-auth', NTLMCheckBox.Checked);
        finally
          CloseKey();
        end;
        //----------------------------------------------------------------------
        //--��������� ������ �������� � ����
        if OpenKey('settings\main\hide-in-tray-program-start', True) then
        try
          WriteBool('value', HideInTrayProgramStartCheckBox.Checked);
        finally
          CloseKey();
        end;
        //--��������� ��������������� ��� ������� ����������
        if OpenKey('settings\main\reconnect', True) then
        try
          WriteBool('value', ReconnectCheckBox.Checked);
        finally
          CloseKey();
        end;
        //--��������� ��������� ������� ����� ������ ��� �������
        if OpenKey('settings\main\auto-update-check', True) then
        try
          WriteBool('value', AutoUpdateCheckBox.Checked);
        finally
          CloseKey();
        end;
        //--��������� ������ ���� ����
        if OpenKey('settings\main\always-top', True) then
        try
          WriteBool('value', AlwaylTopCheckBox.Checked);
        finally
          CloseKey();
        end;
        //--��������� ��������� ������������ ������ ���������
        if OpenKey('settings\main\transparent-value', True) then
        try
          WriteInteger('value', TransparentTrackBar.Position);
        finally
          CloseKey();
        end;
        //--��������� ������������ ����������� ���� ������ ���������
        if OpenKey('settings\main\transparent-active', True) then
        try
          WriteBool('value', TransparentNotActiveCheckBox.Checked);
        finally
          CloseKey();
        end;
        //--��������� ����������� ������ ���������
        if OpenKey('settings\main\auto-hide-cl', True) then
        try
          WriteBool('value', AutoHideCLCheckBox.Checked);
        finally
          CloseKey();
        end;
        if OpenKey('settings\main\auto-hide-cl-value', True) then
        try
          WriteString('value', AutoHideCLEdit.Text);
        finally
          CloseKey();
        end;
        //--��������� ��������� ���� ������ ���������
        if OpenKey('settings\main\header-cl-form', True) then
        try
          WriteString('text', HeaderTextEdit.Text);
        finally
          CloseKey();
        end;
        SaveToFile(ProfilePath + SettingsFileName);
      finally
        Free();
      end;
    end;
  end;
  //--������������ ������ ���������� ��������
  ApplyBitBtn.Enabled := false;
end;

procedure TSettingsForm.AutoHideClEditExit(Sender: TObject);
begin
  //--���� ���� ������, �� ������ �� �������
  if AutoHideClEdit.Text = EmptyStr then AutoHideClEdit.Text := '10';
end;

procedure TSettingsForm.AutoHideClEditKeyPress(Sender: TObject; var Key: Char);
const
  ValidAsciiChars = ['0'..'9'];
begin
  //--������ ���, ��� ������� ����� ������ �����
  if (not (Key in ValidAsciiChars)) and (Key <> #8) then Key := #0;
end;

procedure TSettingsForm.CancelBitBtnClick(Sender: TObject);
begin
  //--��������� ���� ��������
  Close;
end;

procedure TSettingsForm.DeleteProtoBitBtnClick(Sender: TObject);
begin
  //--� ������� ������� ��������� � �������� ������
  ShowMessage(DevelMess);
end;

procedure TSettingsForm.OKBitBtnClick(Sender: TObject);
begin
  //--��������� ���������
  NoReSave := false;
  ApplySettings;
  //--��������� ���� ��������
  Close;
end;

procedure TSettingsForm.AddProtoBitBtnClick(Sender: TObject);
begin
  //--� ������� ��������� ��������� � �������� ������
  ShowMessage(DevelMess);
end;

procedure TSettingsForm.ApplyBitBtnClick(Sender: TObject);
begin
  //--��������� ���������
  NoReSave := false;
  ApplySettings;
end;

procedure TSettingsForm.SettingButtonGroupButtonClicked(Sender: TObject;
  Index: Integer);
begin
  //--�������� �������� �������� ������������� ��������� �������
  if Index <= JvPageList1.PageCount then JvPageList1.ActivePageIndex := Index;
end;

procedure TSettingsForm.SettingButtonGroupKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  //--�������� �������� �������� ������������� ��������� �������
  if SettingButtonGroup.ItemIndex <= JvPageList1.PageCount then JvPageList1.ActivePageIndex := SettingButtonGroup.ItemIndex;
end;

procedure TSettingsForm.SettingsProtoBitBtnClick(Sender: TObject);
begin
  //--��������� ���� ��������� ���������� ���������
  if ProtocolsListView.Selected.Index = 0 then MainForm.ICQSettingsClick(self)
  else if ProtocolsListView.Selected.Index = 1 then MainForm.MRASettingsClick(self)
  else if ProtocolsListView.Selected.Index = 2 then MainForm.JabberSettingsClick(self);
end;

procedure TSettingsForm.ProtocolsListViewClick(Sender: TObject);
begin
  //--��������� ���������� � ����������� ����������
  //--ICQ
  if (not ProtocolsListView.Items[0].Checked) and (MainForm.ICQToolButton.Visible) then
    MainForm.ICQEnable(false)
  else if (ProtocolsListView.Items[0].Checked) and (not MainForm.ICQToolButton.Visible) then
    MainForm.ICQEnable(true);
  //--MRA
  if (not ProtocolsListView.Items[1].Checked) and (MainForm.MRAToolButton.Visible) then
    MainForm.MRAEnable(false)
  else if (ProtocolsListView.Items[1].Checked) and (not MainForm.MRAToolButton.Visible) then
    MainForm.MRAEnable(true);
  //--Jabber
  if (not ProtocolsListView.Items[2].Checked) and (MainForm.JabberToolButton.Visible) then
    MainForm.JabberEnable(false)
  else if (ProtocolsListView.Items[2].Checked) and (not MainForm.JabberToolButton.Visible) then
    MainForm.JabberEnable(true);
end;

procedure TSettingsForm.ProtocolsListViewDblClick(Sender: TObject);
begin
  //--���� ������� ���� �� ��������� ���� ����� ��� � ��� ��������
  ProtocolsListViewClick(self);
end;

procedure TSettingsForm.ProtocolsListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //--���� �������� ������ �� �������� � ��������� ���������, �� ��������� ������� �� ����� �� �������
  if key = 32 then ProtocolsListViewClick(self);
end;

procedure TSettingsForm.ProtocolsListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  //--���������� ��� ������������ ������ �������� ���������
  if Selected then SettingsProtoBitBtn.Enabled := true
  else SettingsProtoBitBtn.Enabled := false;
end;

procedure TSettingsForm.ProxyAddressEditChange(Sender: TObject);
begin
  //--���������� ������ ���������
  ApplyBitBtn.Enabled := true;
end;

procedure TSettingsForm.ProxyAuthCheckBoxClick(Sender: TObject);
begin
  //--��������� ���������� ����������� �� ������
  if ProxyAuthCheckBox.Checked then
  begin
    ProxyLoginEdit.Enabled := true;
    ProxyLoginEdit.Color := clWindow;
    ProxyPasswordEdit.Enabled := true;
    ProxyPasswordEdit.Color := clWindow;
    NTLMCheckBox.Enabled := true;
  end
  else
  begin
    ProxyLoginEdit.Enabled := false;
    ProxyLoginEdit.Color := clBtnFace;
    ProxyPasswordEdit.Enabled := false;
    ProxyPasswordEdit.Color := clBtnFace;
    NTLMCheckBox.Enabled := false;
  end;
  //--���������� ������ ���������� ��������
  ApplyBitBtn.Enabled := true;
end;

procedure TSettingsForm.ProxyEnableCheckBoxClick(Sender: TObject);
begin
  //--��������� ������������� ������
  if ProxyEnableCheckBox.Checked then
  begin
    ProxyAddressEdit.Enabled := true;
    ProxyAddressEdit.Color := clWindow;
    ProxyPortEdit.Enabled := true;
    ProxyPortEdit.Color := clWindow;
    ProxyTypeComboBox.Enabled := true;
    ProxyTypeComboBox.Color := clWindow;
    ProxyVersionComboBox.Enabled := true;
    ProxyVersionComboBox.Color := clWindow;
    ProxyAuthCheckBox.Enabled := true;
    if ProxyAuthCheckBox.Checked then
    begin
      ProxyLoginEdit.Enabled := true;
      ProxyLoginEdit.Color := clWindow;
      ProxyPasswordEdit.Enabled := true;
      ProxyPasswordEdit.Color := clWindow;
      NTLMCheckBox.Enabled := true;
    end;
    ProxyShowPassCheckBox.Enabled := true;
  end
  else
  begin
    ProxyAddressEdit.Enabled := false;
    ProxyAddressEdit.Color := clBtnFace;
    ProxyPortEdit.Enabled := false;
    ProxyPortEdit.Color := clBtnFace;
    ProxyTypeComboBox.Enabled := false;
    ProxyTypeComboBox.Color := clBtnFace;
    ProxyVersionComboBox.Enabled := false;
    ProxyVersionComboBox.Color := clBtnFace;
    ProxyAuthCheckBox.Enabled := false;
    if ProxyAuthCheckBox.Checked then
    begin
      ProxyLoginEdit.Enabled := false;
      ProxyLoginEdit.Color := clBtnFace;
      ProxyPasswordEdit.Enabled := false;
      ProxyPasswordEdit.Color := clBtnFace;
      NTLMCheckBox.Enabled := false;
    end;
    ProxyShowPassCheckBox.Enabled := false;
  end;
  //--���������� ������ ���������� ��������
  ApplyBitBtn.Enabled := true;
end;

procedure TSettingsForm.ProxyShowPassCheckBoxClick(Sender: TObject);
begin
  //--���������� ������ ������ � ������
  if ProxyShowPassCheckBox.Checked then ProxyPasswordEdit.PasswordChar := #0
  else ProxyPasswordEdit.PasswordChar := '*';
end;

procedure TSettingsForm.ProxyTypeComboBoxSelect(Sender: TObject);
begin
  //--������������� ��������� ���� ������
  case ProxyTypeComboBox.ItemIndex of
    0: ProxyPortEdit.Text := '80';
    1: ProxyPortEdit.Text := '443';
  else ProxyPortEdit.Text := EmptyStr;
  end;
end;

procedure TSettingsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //--���������� ����������� �������� ������������ ������ ���������
  MainForm.AlphaBlendValue := RoasterAlphaValue;
  MainForm.AlphaBlend := RoasterAlphaBlend;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  //--��������� ���������
  LoadSettings;
  ProxyTypeComboBox.OnSelect := ProxyTypeComboBoxSelect;
  //--������������� �������
  TranslateForms;
  //--������������ ������ ���������� ��������
  ApplyBitBtn.Enabled := false;
  //--���� � �������
  jdeProfilePath.Text := ProfilePath;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  //--������������� ������ ����
  MainForm.AllImageList.GetIcon(2, Icon);
  //--������������� ������ �� ������
  MainForm.AllImageList.GetBitmap(3, CancelBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(6, ApplyBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(140, OKBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(186, AddProtoBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(2, SettingsProtoBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(139, DeleteProtoBitBtn.Glyph);
  //--�������������� ������� ���������� ���������
  LoadSettings;
  ProxyTypeComboBox.OnSelect := ProxyTypeComboBoxSelect;
  //--������������ ������ ���������� ��������
  ApplyBitBtn.Enabled := false;
  //--���������� �� ������ �������
  JvPageList1.ActivePageIndex := 0;
  SettingButtonGroup.ItemIndex := 0;
end;

procedure TSettingsForm.jdeProfilePathChange(Sender: TObject);
begin
  //--���������� ������ ���������
  ApplyBitBtn.Enabled := true;
end;

procedure SetStringPropertyIfExists(AComp: TComponent; APropName: string;
  AValue: string);
var
  PropInfo: PPropInfo;
  TK: TTypeKind;
begin
  PropInfo := GetPropInfo(AComp.ClassInfo, APropName);
  if PropInfo <> nil then
  begin
    TK := PropInfo^.PropType^.Kind;
    if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
      SetStrProp(AComp, PropInfo, AValue);
  end;
end;

procedure TSettingsForm.TransparentTrackBarChange(Sender: TObject);
begin
  //--���������� ������ ���������
  ApplyBitBtn.Enabled := true;
  //--���������� ����� ������������ � ������ ���������
  MainForm.AlphaBlend := true;
  MainForm.AlphaBlendValue := 255 - TransparentTrackBar.Position;
end;

procedure TSettingsForm.TranslateForms;
var
  i: integer;
begin
  //--��������� ������� ���������� ���������
  if CurrentLang <> EmptyStr then
  begin
    if FileExists(MyPath + 'Langs\' + CurrentLang + '.xml') then begin

      with TrXML.Create() do try

        LoadFromFile(MyPath + 'Langs\' + CurrentLang + '.xml');
        //--��������� ������� ����
        for i := 0 to MainForm.ComponentCount - 1 do begin
          if OpenKey('settings\main-form\' + MainForm.Components[i].Name) then try
            SetStringPropertyIfExists(MainForm.Components[i], 'Hint', '<b>' + ReadString('hint') + '</b>');
          finally
            CloseKey();
          end;
        end;
      finally
        Free();
      end;
    end;
  end;
end;

procedure TSettingsForm.ApplyProxyHttpClient(HttpClient: THttpCli);
begin
  with HttpClient do
  begin
    //--��������� ��������� ������
    if ProxyEnableCheckBox.Checked then
    begin
      //--������ �������
      RequestVer := ProxyVersionComboBox.Text;
      //--HTTP � HTTPS ��� ������
      if (ProxyTypeComboBox.ItemIndex = 0) or (ProxyTypeComboBox.ItemIndex = 1) then
      begin
        //--���������� ��� SOCKS ������
        SocksLevel := EmptyStr;
        //--���������� ����� SOCKS ������ � ����
        SocksServer := EmptyStr;
        SocksPort := EmptyStr;
        //--���������� ����������� SOCKS ������
        SocksAuthentication := socksNoAuthentication;
        SocksUsercode := EmptyStr;
        SocksPassword := EmptyStr;
        //--��������� ����� HTTP ������ � ����
        Proxy := ProxyAddressEdit.Text;
        ProxyPort := ProxyPortEdit.Text;
        //--��������� ����������� �� HTTP ������
        if ProxyAuthCheckBox.Checked then
        begin
          ProxyAuth := httpAuthBasic;
          if NTLMCheckBox.Checked then ProxyAuth := httpAuthNtlm;
          ProxyUsername := ProxyLoginEdit.Text;
          ProxyPassword := ProxyPasswordEdit.Text;
        end
        else
        begin
          //--���������� ����������� HTTP ������
          ProxyAuth := httpAuthNone;
          ProxyUsername := EmptyStr;
          ProxyPassword := EmptyStr;
        end;
      end
      else
      begin
        //--���������� ����� HTTP ������ � ����
        Proxy := EmptyStr;
        ProxyPort := '80';
        //--���������� ����������� HTTP ������
        ProxyAuth := httpAuthNone;
        ProxyUsername := EmptyStr;
        ProxyPassword := EmptyStr;
        //--SOCKS4, SOCKS4A � SOCKS5 ��� ������
        case ProxyTypeComboBox.ItemIndex of
          2: SocksLevel := '4';
          3: SocksLevel := '4A';
          4: SocksLevel := '5';
        end;
        //--��������� ����� SOCKS ������ � ����
        SocksServer := ProxyAddressEdit.Text;
        SocksPort := ProxyPortEdit.Text;
        //--��������� ����������� �� SOCKS ������
        if ProxyAuthCheckBox.Checked then
        begin
          SocksAuthentication := socksAuthenticateUsercode;
          SocksUsercode := ProxyLoginEdit.Text;
          SocksPassword := ProxyPasswordEdit.Text;
        end
        else
        begin
          //--���������� ����������� SOCKS ������
          SocksAuthentication := socksNoAuthentication;
          SocksUsercode := EmptyStr;
          SocksPassword := EmptyStr;
        end;
      end;
    end
    else
    begin
      //--���������� ������ ��������
      RequestVer := '1.0';
      //--���������� ����� HTTP ������ � ����
      Proxy := EmptyStr;
      ProxyPort := '80';
      //--���������� ����������� HTTP ������
      ProxyAuth := httpAuthNone;
      ProxyUsername := EmptyStr;
      ProxyPassword := EmptyStr;
      //--���������� ��� SOCKS ������
      SocksLevel := EmptyStr;
      //--���������� ����� SOCKS ������ � ����
      SocksServer := EmptyStr;
      SocksPort := EmptyStr;
      //--���������� ����������� SOCKS ������
      SocksAuthentication := socksNoAuthentication;
      SocksUsercode := EmptyStr;
      SocksPassword := EmptyStr;
    end;
  end;
end;

procedure TSettingsForm.ApplyProxySocketClient(SocketClient: TWSocket);
begin
  with SocketClient do
  begin
    //--��������� ��������� ������
    if ProxyEnableCheckBox.Checked then
    begin
      //--HTTP � HTTPS ��� ������
      if (ProxyTypeComboBox.ItemIndex = 0) or (ProxyTypeComboBox.ItemIndex = 1) then
      begin
        //--���������� ��� SOCKS ������
        SocksLevel := '5';
        //--���������� ����� SOCKS ������ � ����
        SocksServer := EmptyStr;
        SocksPort := EmptyStr;
        //--���������� ����������� SOCKS ������
        SocksAuthentication := socksNoAuthentication;
        SocksUsercode := EmptyStr;
        SocksPassword := EmptyStr;
        //--������ ����, ��� ��� ������ ������� ����� ����� HTTP ������
        HttpProxy_Enable := true;
        //--��������� ����� HTTP ������ � ����
        HttpProxy_Address := ProxyAddressEdit.Text;
        HttpProxy_Port := ProxyPortEdit.Text;
        //--��������� ����������� �� HTTP ������
        if ProxyAuthCheckBox.Checked then
        begin
          HttpProxy_Auth := true;
          HttpProxy_Login := ProxyLoginEdit.Text;
          HttpProxy_Password := ProxyPasswordEdit.Text;
        end
        else
        begin
          //--���������� ����������� HTTP ������
          HttpProxy_Auth := false;
          HttpProxy_Login := EmptyStr;
          HttpProxy_Password := EmptyStr;
        end;
      end
      else
      begin
        //--������� ����, ��� ��� ������ ������� ����� ����� HTTP ������
        HttpProxy_Enable := false;
        //--���������� ����� HTTP ������ � ����
        HttpProxy_Address := EmptyStr;
        HttpProxy_Port := EmptyStr;
        //--���������� ����������� HTTP ������
        HttpProxy_Auth := false;
        HttpProxy_Login := EmptyStr;
        HttpProxy_Password := EmptyStr;
        //--SOCKS4, SOCKS4A � SOCKS5 ��� ������
        case ProxyTypeComboBox.ItemIndex of
          2: SocksLevel := '4';
          3: SocksLevel := '4A';
          4: SocksLevel := '5';
        end;
        //--��������� ����� SOCKS ������ � ����
        SocksServer := ProxyAddressEdit.Text;
        SocksPort := ProxyPortEdit.Text;
        //--��������� ����������� �� SOCKS ������
        if ProxyAuthCheckBox.Checked then
        begin
          SocksAuthentication := socksAuthenticateUsercode;
          SocksUsercode := ProxyLoginEdit.Text;
          SocksPassword := ProxyPasswordEdit.Text;
        end
        else
        begin
          //--���������� ����������� SOCKS ������
          SocksAuthentication := socksNoAuthentication;
          SocksUsercode := EmptyStr;
          SocksPassword := EmptyStr;
        end;
      end;
    end
    else
    begin
      //--������� ����, ��� ��� ������ ������� ����� ����� HTTP ������
      HttpProxy_Enable := false;
      //--���������� ����� HTTP ������ � ����
      HttpProxy_Address := EmptyStr;
      HttpProxy_Port := EmptyStr;
      //--���������� ����������� HTTP ������
      HttpProxy_Auth := false;
      HttpProxy_Login := EmptyStr;
      HttpProxy_Password := EmptyStr;
      //--���������� ��� SOCKS ������
      SocksLevel := '5';
      //--���������� ����� SOCKS ������ � ����
      SocksServer := EmptyStr;
      SocksPort := EmptyStr;
      //--���������� ����������� SOCKS ������
      SocksAuthentication := socksNoAuthentication;
      SocksUsercode := EmptyStr;
      SocksPassword := EmptyStr;
    end;  
  end;
end;

end.

