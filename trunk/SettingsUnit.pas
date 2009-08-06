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
  Registry, ComCtrls;

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
  private
    { Private declarations }
    procedure LoadSettings;
    procedure TranslateForms;
  public
    { Public declarations }
    procedure ApplySettings;
    procedure ApplyProxyHttpClient(HttpClient: THttpCli);
  end;

var
  SettingsForm: TSettingsForm;
  NoReSave: boolean = false;

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
  //--��������� � ���������� ��������� ������
  if FileExists(MyPath + SettingsFileName) then begin
    With TrXML.Create() do try
      LoadFromFile(MyPath + SettingsFileName);

      If OpenKey('settings\proxy\address') then try
        ProxyAddressEdit.Text := ReadString('host');
        ProxyPortEdit.Text := ReadString('port');
      finally
        CloseKey();
      end;

      If OpenKey('settings\proxy\type') then try
        ProxyTypeComboBox.ItemIndex := ReadInteger('type-index');
        ProxyVersionComboBox.ItemIndex := ReadInteger('version-index');
      finally
        CloseKey();
      end;

      if OpenKey('settings\proxy\auth') then try
        ProxyAuthCheckBox.Checked := ReadBool('auth-enable');
        ProxyLoginEdit.Text := ReadString('login');
        ProxyPasswordEdit.Text := Decrypt(ReadString('password'), PassKey);
        NTLMCheckBox.Checked := ReadBool('ntlm-auth');
      finally
        CloseKey();
      end;

      if OpenKey('settings\proxy\main') then try
        ProxyEnableCheckBox.Checked := ReadBool('enable');
        ProxyEnableCheckBoxClick(nil);
      finally
        CloseKey();
      end;

    finally
      Free();
    end;
  end;
  //----------------------------------------------------------------------------
  //--��������� � ���������� ������ ���������
  With TrXML.Create() do try
    if FileExists(MyPath + SettingsFileName) then begin
      LoadFromFile(MyPath + SettingsFileName);

      if OpenKey('settings\main\hide-in-tray-program-start') then try
        //--��������� ������ �������� � ����
        HideInTrayProgramStartCheckBox.Checked := ReadBool('value');
        //--��������� ���������� ��� ������ Windows
        StartOnWinStartCheckBox.Checked := IsAppInRun('IMadering');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\auto-update-check') then try
        //--��������� ��������� ������� ����� ������ ��� �������
        AutoUpdateCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\always-top') then try
        //--��������� ������ ���� ����
        AlwaylTopCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\transparent-value') then try
        //--��������� ��������� ������������ ������ ���������
        TransparentTrackBar.Position := ReadInteger('value');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\transparent-active') then try
        //--��������� ������������ ����������� ���� ������ ���������
        TransparentNotActiveCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\auto-hide-cl') then try
        //--��������� ����������� ������ ���������
        AutoHideCLCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\auto-hide-cl-value') then try
        //--��������� ����������� ������ ���������
        AutoHideCLEdit.Text := ReadString('value');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\header-cl-form') then try
        //--��������� ��������� ���� ������ ���������
        HeaderTextEdit.Text := ReadString('text');
      finally
        CloseKey();
      end;

      if OpenKey('settings\main\reconnect') then try
        //--��������� �������������� ��� ������� ����������
        ReconnectCheckBox.Checked := ReadBool('value');
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
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
  //--������ ����������� �����
  ForceDirectories(MyPath + 'Profile');
  ForceDirectories(MyPath + 'Profile\History');
  ForceDirectories(MyPath + 'Profile\Avatars');
  ForceDirectories(MyPath + 'Profile\Contacts');
  //--��������� ��������� ������
  if ProxyEnableCheckBox.Checked then
  begin
    //--������ �������
    MainForm.UpdateHttpClient.RequestVer := ProxyVersionComboBox.Text;
    //--HTTP � HTTPS ��� ������
    if (ProxyTypeComboBox.ItemIndex = 0) or (ProxyTypeComboBox.ItemIndex = 1) then
    begin
      //--���������� ��� SOCKS ������
      MainForm.UpdateHttpClient.SocksLevel := EmptyStr;
      //--���������� ����� SOCKS ������ � ����
      MainForm.UpdateHttpClient.SocksServer := EmptyStr;
      MainForm.UpdateHttpClient.SocksPort := EmptyStr;
      //--���������� ����������� SOCKS ������
      MainForm.UpdateHttpClient.SocksAuthentication := socksNoAuthentication;
      MainForm.UpdateHttpClient.SocksUsercode := EmptyStr;
      MainForm.UpdateHttpClient.SocksPassword := EmptyStr;
      //--��������� ����� HTTP ������ � ����
      MainForm.UpdateHttpClient.Proxy := ProxyAddressEdit.Text;
      MainForm.UpdateHttpClient.ProxyPort := ProxyPortEdit.Text;
      //--��������� ����������� �� HTTP ������
      if ProxyAuthCheckBox.Checked then
      begin
        MainForm.UpdateHttpClient.ProxyAuth := httpAuthBasic;
        if NTLMCheckBox.Checked then MainForm.UpdateHttpClient.ProxyAuth := httpAuthNtlm;
        MainForm.UpdateHttpClient.ProxyUsername := ProxyLoginEdit.Text;
        MainForm.UpdateHttpClient.ProxyPassword := ProxyPasswordEdit.Text;
      end
      else
      begin
        //--���������� ����������� HTTP ������
        MainForm.UpdateHttpClient.ProxyAuth := httpAuthNone;
        MainForm.UpdateHttpClient.ProxyUsername := EmptyStr;
        MainForm.UpdateHttpClient.ProxyPassword := EmptyStr;
      end;
    end
    else
    begin
      //--���������� ����� HTTP ������ � ����
      MainForm.UpdateHttpClient.Proxy := EmptyStr;
      MainForm.UpdateHttpClient.ProxyPort := '80';
      //--���������� ����������� HTTP ������
      MainForm.UpdateHttpClient.ProxyAuth := httpAuthNone;
      MainForm.UpdateHttpClient.ProxyUsername := EmptyStr;
      MainForm.UpdateHttpClient.ProxyPassword := EmptyStr;
      //--SOCKS4, SOCKS4A � SOCKS5 ��� ������
      case ProxyTypeComboBox.ItemIndex of
        2: MainForm.UpdateHttpClient.SocksLevel := '4';
        3: MainForm.UpdateHttpClient.SocksLevel := '4A';
        4: MainForm.UpdateHttpClient.SocksLevel := '5';
      end;
      //--��������� ����� SOCKS ������ � ����
      MainForm.UpdateHttpClient.SocksServer := ProxyAddressEdit.Text;
      MainForm.UpdateHttpClient.SocksPort := ProxyPortEdit.Text;
      //--��������� ����������� �� SOCKS ������
      if ProxyAuthCheckBox.Checked then
      begin
        MainForm.UpdateHttpClient.SocksAuthentication := socksAuthenticateUsercode;
        MainForm.UpdateHttpClient.SocksUsercode := ProxyLoginEdit.Text;
        MainForm.UpdateHttpClient.SocksPassword := ProxyPasswordEdit.Text;
      end
      else
      begin
        //--���������� ����������� SOCKS ������
        MainForm.UpdateHttpClient.SocksAuthentication := socksNoAuthentication;
        MainForm.UpdateHttpClient.SocksUsercode := EmptyStr;
        MainForm.UpdateHttpClient.SocksPassword := EmptyStr;
      end;
    end;
  end
  else
  begin
    //--���������� ������ ��������
    MainForm.UpdateHttpClient.RequestVer := '1.0';
    //--���������� ����� HTTP ������ � ����
    MainForm.UpdateHttpClient.Proxy := EmptyStr;
    MainForm.UpdateHttpClient.ProxyPort := '80';
    //--���������� ����������� HTTP ������
    MainForm.UpdateHttpClient.ProxyAuth := httpAuthNone;
    MainForm.UpdateHttpClient.ProxyUsername := EmptyStr;
    MainForm.UpdateHttpClient.ProxyPassword := EmptyStr;
    //--���������� ��� SOCKS ������
    MainForm.UpdateHttpClient.SocksLevel := EmptyStr;
    //--���������� ����� SOCKS ������ � ����
    MainForm.UpdateHttpClient.SocksServer := EmptyStr;
    MainForm.UpdateHttpClient.SocksPort := EmptyStr;
    //--���������� ����������� SOCKS ������
    MainForm.UpdateHttpClient.SocksAuthentication := socksNoAuthentication;
    MainForm.UpdateHttpClient.SocksUsercode := EmptyStr;
    MainForm.UpdateHttpClient.SocksPassword := EmptyStr;
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
  MainForm.JvTimerList.Events[8].Enabled := AutoHideCLCheckBox.Checked;
  MainForm.JvTimerList.Events[8].Interval := (StrToInt(AutoHideCLEdit.Text) * 1000);
  //--��������� ��������� ��������� ���� ������ ���������
  MainForm.Caption := HeaderTextEdit.Text;



  //----------------------------------------------------------------------------

  G_ProxyEnabled := ProxyEnableCheckBox.Checked;
  G_ProxyHost := ProxyAddressEdit.Text;
  G_ProxyPort := ProxyPortEdit.Text;
  G_ProxyType := ProxyTypeComboBox.Text;
  G_ProxyVersion := ProxyVersionComboBox.Text;
  G_ProxyTypeIndex := ProxyTypeComboBox.ItemIndex;
  G_ProxyVersionIndex := ProxyVersionComboBox.ItemIndex;
  G_ProxyAuthorize := ProxyAuthCheckBox.Checked;
  G_ProxyLogin := ProxyLoginEdit.Text;
  G_ProxyPassword := ProxyPasswordEdit.Text;
  G_ProxyNTLM := NTLMCheckBox.Checked;

  //--���������� ���������
  if ApplyBitBtn.Enabled then
  begin
    //--���������� ��������� ������
    if not NoReSave then begin
      With TrXML.Create() do try
        if FileExists(MyPath + SettingsFileName) then
          LoadFromFile(MyPath + SettingsFileName);
        if OpenKey('settings\proxy\main', True) then try
          WriteBool('enable', ProxyEnableCheckBox.Checked);
        finally
          CloseKey();
        end;

        if OpenKey('settings\proxy\address', True) then try
          WriteString('host', ProxyAddressEdit.Text);
          WriteString('port', ProxyPortEdit.Text);
        finally
          CloseKey();
        end;

        if OpenKey('settings\proxy\type', True) then try
          WriteString('type', ProxyTypeComboBox.Text);
          WriteInteger('type-index', ProxyTypeComboBox.ItemIndex);
          WriteString('version', ProxyVersionComboBox.Text);
          WriteInteger('version-index', ProxyVersionComboBox.ItemIndex);
        finally
          CloseKey();
        end;

        if OpenKey('settings\proxy\auth', True) then try
          WriteBool('auth-enable', ProxyAuthCheckBox.Checked);
          WriteString('login', ProxyLoginEdit.Text);
          WriteString('password', Encrypt(ProxyPasswordEdit.Text, PassKey));
          WriteBool('ntlm-auth', NTLMCheckBox.Checked);
        finally
          CloseKey();
        end;

        SaveToFile(MyPath + SettingsFileName);
      finally
        Free();
      end;
      //--��������� ���������
      With TrXML.Create() do try
      if FileExists(MyPath + SettingsFileName) then
        LoadFromFile(MyPath + SettingsFileName);
        //--��������� ������ �������� � ����
        if OpenKey('settings\main\hide-in-tray-program-start', True) then try
          WriteBool('value', HideInTrayProgramStartCheckBox.Checked);
        finally
          CloseKey();
        end;

        //--��������� ��������������� ��� ������� ����������
        if OpenKey('settings\main\reconnect', True) then try
          WriteBool('value', ReconnectCheckBox.Checked);
        finally
          CloseKey();
        end;

        //--��������� ��������� ������� ����� ������ ��� �������
        if OpenKey('settings\main\auto-update-check', True) then try
          WriteBool('value', AutoUpdateCheckBox.Checked);
        finally
          CloseKey();
        end;

        //--��������� ������ ���� ����
        if OpenKey('settings\main\always-top', True) then try
          WriteBool('value', AlwaylTopCheckBox.Checked);
        finally
          CloseKey();
        end;

        //--��������� ��������� ������������ ������ ���������
        if OpenKey('settings\main\transparent-value', True) then try
          WriteInteger('value', TransparentTrackBar.Position);
        finally
          CloseKey();
        end;

        //--��������� ������������ ����������� ���� ������ ���������
        if OpenKey('settings\main\transparent-active', True) then try
          WriteBool('value', TransparentNotActiveCheckBox.Checked);
        finally
          CloseKey();
        end;

        //--��������� ����������� ������ ���������
        if OpenKey('settings\main\auto-hide-cl', True) then try
          WriteBool('value', AutoHideCLCheckBox.Checked);
        finally
          CloseKey();
        end;

        if OpenKey('settings\main\auto-hide-cl-value', True) then try
          WriteString('value', AutoHideCLEdit.Text);
        finally
          CloseKey();
        end;

        //--��������� ��������� ���� ������ ���������
        if OpenKey('settings\main\header-cl-form', True) then try
          WriteString('text', HeaderTextEdit.Text);
        finally
          CloseKey();
        end;

        SaveToFile(MyPath + SettingsFileName);
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

      With TrXML.Create() do try

        LoadFromFile(MyPath + 'Langs\' + CurrentLang + '.xml');
        //--��������� ������� ����
        for i := 0 to MainForm.ComponentCount - 1 do begin
          If OpenKey('settings\main-form\' + MainForm.Components[i].Name) then try
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
  {with HttpClient do
  begin
    //--��������� ��������� ������
    if ProxyEnableCheckBox.Checked then
    begin
      //--������ �������
      RequestVer := ProxyVersionComboBox.Text;
      //--HTTP � HTTPS ��� ������
      if (ProxyTypeComboBox = 0) or (ProxyTypeComboBox = 1) then
      begin
        //--���������� ��� SOCKS ������
        SocksLevel := '';
        //--���������� ����� SOCKS ������ � ����
        SocksServer := '';
        SocksPort := '';
        //--���������� ����������� SOCKS ������
        SocksAuthentication := socksNoAuthentication;
        SocksUsercode := '';
        SocksPassword := '';
        //--��������� ����� HTTP ������ � ����
        Proxy := ProxyAddresEdit;
        ProxyPort := ProxyPortEdit;
        //--��������� ����������� �� HTTP ������
        if ProxyAuthCheckBox then
        begin
          ProxyAuth := httpAuthBasic;
          if NTLMCheckBox then ProxyAuth := httpAuthNtlm;
          ProxyUsername := ProxyLoginEdit;
          ProxyPassword := ProxyPasswordEdit;
        end
        else
        begin
          //--���������� ����������� HTTP ������
          ProxyAuth := httpAuthNone;
          ProxyUsername := '';
          ProxyPassword := '';
        end;
      end
      else
      begin
        //--���������� ����� HTTP ������ � ����
        Proxy := '';
        ProxyPort := '80';
        //--���������� ����������� HTTP ������
        ProxyAuth := httpAuthNone;
        ProxyUsername := '';
        ProxyPassword := '';
        //--SOCKS4, SOCKS4A � SOCKS5 ��� ������
        case ProxyTypeComboBox of
          2: SocksLevel := '4';
          3: SocksLevel := '4A';
          4: SocksLevel := '5';
        end;
        //--��������� ����� SOCKS ������ � ����
        SocksServer := ProxyAddresEdit;
        SocksPort := ProxyPortEdit;
        //--��������� ����������� �� SOCKS ������
        if ProxyAuthCheckBox then
        begin
          SocksAuthentication := socksAuthenticateUsercode;
          SocksUsercode := ProxyLoginEdit;
          SocksPassword := ProxyPasswordEdit;
        end
        else
        begin
          //--���������� ����������� SOCKS ������
          SocksAuthentication := socksNoAuthentication;
          SocksUsercode := '';
          SocksPassword := '';
        end;
      end;
    end
    else
    begin
      //--���������� ������ ��������
      RequestVer := '1.0';
      //--���������� ����� HTTP ������ � ����
      Proxy := '';
      ProxyPort := '80';
      //--���������� ����������� HTTP ������
      ProxyAuth := httpAuthNone;
      ProxyUsername := '';
      ProxyPassword := '';
      //--���������� ��� SOCKS ������
      SocksLevel := '';
      //--���������� ����� SOCKS ������ � ����
      SocksServer := '';
      SocksPort := '';
      //--���������� ����������� SOCKS ������
      SocksAuthentication := socksNoAuthentication;
      SocksUsercode := '';
      SocksPassword := '';
    end;
  end;}
end;

end.

