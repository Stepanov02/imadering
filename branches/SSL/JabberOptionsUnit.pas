{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit JabberOptionsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ButtonGroup, ExtCtrls, ComCtrls, JvPageList,
  JvExControls, rXML;

type
  TJabberOptionsForm = class(TForm)
    CancelButton: TBitBtn;
    ApplyButton: TBitBtn;
    OKButton: TBitBtn;
    JabberOptionButtonGroup: TButtonGroup;
    OptionPanel: TPanel;
    OptionJvPageList: TJvPageList;
    AccountPage: TJvStandardPage;
    AccountGroupBox: TGroupBox;
    RegNewAccountLabel: TLabel;
    ICQUINLabel: TLabel;
    PassLabel: TLabel;
    JabberJIDEdit: TEdit;
    PassEdit: TEdit;
    ShowPassCheckBox: TCheckBox;
    SavePassCheckBox: TCheckBox;
    DeleteAccountLabel: TLabel;
    JIDonserverLabel: TLabel;
    AccountOptionGroupBox: TGroupBox;
    ServerPage: TJvStandardPage;
    ProxyPage: TJvStandardPage;
    OptionPage: TJvStandardPage;
    RosterPage: TJvStandardPage;
    AnketaPage: TJvStandardPage;
    HomePage: TJvStandardPage;
    WorkPage: TJvStandardPage;
    PersonalPage: TJvStandardPage;
    ParamsPage: TJvStandardPage;
    JCustomServerHostEdit: TLabeledEdit;
    JCustomServerPortEdit: TLabeledEdit;
    JUseCustomServerSettingsCheckBox: TCheckBox;
    JUseSSLCheckBox: TCheckBox;
    ConnectionGroupBox: TGroupBox;
    ConnectionOptionGroupBox: TGroupBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JIDonserverLabelMouseEnter(Sender: TObject);
    procedure JIDonserverLabelMouseLeave(Sender: TObject);
    procedure JabberSomeEditChange(Sender: TObject);
    procedure PassEditClick(Sender: TObject);
    procedure ShowPassCheckBoxClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure JabberOptionButtonGroupButtonClicked(Sender: TObject;
      Index: Integer);
    procedure JUseCustomServerSettingsCheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSettings;
    procedure LoadAccountSettings(SettingsXml: TrXML);
    procedure LoadConnectionSettings(SettingsXml: TrXML);
    procedure UpdateJabberSettings;
    procedure SaveSettingsJabberAccount(SettingsXml: TrXML);
    procedure SaveSettingsJabberConnection(SettingsXml: TrXML);
  public
    { Public declarations }
    procedure ApplySettings;
    procedure TranslateForm;
  end;

var
  JabberOptionsForm: TJabberOptionsForm;

implementation

{$R *.dfm}

uses
  MainUnit, JabberProtoUnit, UnitCrypto, SettingsUnit, UtilsUnit, VarsUnit,
  RosterUnit;

resourcestring
  StrSettingsJabberConnection = 'settings\jabber\connection';
  StrSettingsJabberAccount = 'settings\jabber\account';
  StrKeyUseCustomServerSettings = 'use_custom_server';
  StrKeyUseSSL = 'UseSSL';
  StrKeyServerHost = 'server_host';
  StrKeyServerPort = 'server_port';
  StrKeyLogin = 'login';
  StrKeySavePassword = 'save-password';
  StrKeyPassword = 'password';
  StrPassMask = '----------------------';

procedure TJabberOptionsForm.ApplyButtonClick(Sender: TObject);
begin
  //--��������� ���������
  ApplySettings;
end;

//--APPLY SETTINGS--------------------------------------------------------------

procedure TJabberOptionsForm.ApplySettings;
var
  SettingsXml: TrXML;
begin

  //--��������� ��������� Jabber ���������
  UpdateJabberSettings;
  //----------------------------------------------------------------------------
  SettingsXml := TrXML.Create;
  //--���������� ��������� Jabber ��������� � ����
  //with TrXML.Create() do
  try
    if FileExists(ProfilePath + SettingsFileName) then SettingsXml.LoadFromFile(ProfilePath + SettingsFileName);

    //��������� ���������
    SaveSettingsJabberAccount(SettingsXml);
    SaveSettingsJabberConnection(SettingsXml);

    SettingsXml.SaveToFile(ProfilePath + SettingsFileName);
  finally
    FreeAndNil(SettingsXml);
  end;
  //--������������ ������ ���������� ��������
  ApplyButton.Enabled := false;
end;

//--LOAD SETTINGS---------------------------------------------------------------

procedure TJabberOptionsForm.LoadSettings;
var
  SettingsXml: TrXML;
begin
  //--�������������� XML
  SettingsXml := TrXML.Create;
  try
    if FileExists(ProfilePath + SettingsFileName) then
    begin
      SettingsXml.LoadFromFile(ProfilePath + SettingsFileName);

      //--��������� ������ ������
      LoadAccountSettings(SettingsXml);

      //��������� ��������� �����������
      LoadConnectionSettings(SettingsXml);
    end;
  finally
    FreeAndNil(SettingsXml);
  end;
end;

procedure TJabberOptionsForm.TranslateForm;
begin
  //--��������� ����� �� ������ �����

end;

procedure TJabberOptionsForm.SaveSettingsJabberConnection(SettingsXml: TrXML);
begin
  with SettingsXml do
  if OpenKey(StrSettingsJabberConnection, true) then
    try
      WriteBool(StrKeyUseCustomServerSettings, JUseCustomServerSettingsCheckBox.Checked);
      WriteBool(StrKeyUseSSL, JUseSSLCheckBox.Checked);
      WriteString(StrKeyServerHost, JCustomServerHostEdit.Text);
      WriteString(StrKeyServerPort, JCustomServerPortEdit.Text);
    finally
      CloseKey;
    end;
end;

procedure TJabberOptionsForm.SaveSettingsJabberAccount(SettingsXml: TrXML);
begin
  with SettingsXml do
  if OpenKey(StrSettingsJabberAccount, True) then
    try
      WriteString(StrKeyLogin, JabberJIDEdit.Text);
      WriteBool(StrKeySavePassword, SavePassCheckBox.Checked);
      if (SavePassCheckBox.Checked) and (PassEdit.Text <> StrPassMask) then
        WriteString(StrKeyPassword, EncryptString(PassEdit.Hint, PasswordByMac))
      else WriteString(StrKeyPassword, EmptyStr);
      //--��������� ������
      if PassEdit.Text <> EmptyStr then PassEdit.Text := StrPassMask;
    finally
      CloseKey;
    end;
end;

procedure TJabberOptionsForm.UpdateJabberSettings;
begin
  //--����������� �������� ����
  //Jabber �����
  JabberJIDEdit.Text := Trim(JabberJIDEdit.Text);
  JabberJIDEdit.Text := exNormalizeScreenName(JabberJIDEdit.Text);
  //Server Host
  JCustomServerHostEdit.Text := Trim(JCustomServerHostEdit.Text);
  JCustomServerHostEdit.Text := exNormalizeScreenName(JCustomServerHostEdit.Text);
  //Server Port
  JCustomServerPortEdit.Text := Trim(JCustomServerPortEdit.Text);
  JCustomServerPortEdit.Text := exNormalizeScreenName(JCustomServerPortEdit.Text);
  //--��������� ������ ������ � ���������
  if JabberJIDEdit.Enabled then
  begin
    if JabberJIDEdit.Text <> Jabber_JID then
      RosterForm.ClearJabberClick(self);
    //--������� ��������
    Jabber_JID := JabberJIDEdit.Text;
    if PassEdit.Text <> StrPassMask then
    begin
      PassEdit.Hint := PassEdit.Text;
      Jabber_LoginPassword := PassEdit.Hint;
    end;
  end;
  //��������� ��������� ����������
  Jabber_UseSSL := JUseSSLCheckBox.Checked;
  if JUseSSLCheckBox.Checked then
  begin
    Jabber_ServerPort := CONST_Jabber_DefaultServerSSLPort;
  end else begin
    Jabber_ServerPort := CONST_Jabber_DefaultServerNoSecurePort;
  end;

  if JUseCustomServerSettingsCheckBox.Checked then
  begin
    Jabber_ServerAddr := JCustomServerHostEdit.Text;
    Jabber_ServerPort := JCustomServerPortEdit.Text;
  end;
end;

procedure TJabberOptionsForm.LoadConnectionSettings(SettingsXml: TrXML);
begin
  with SettingsXml do
  if OpenKey(StrSettingsJabberConnection) then
    try
      JUseCustomServerSettingsCheckBox.Checked := ReadBool(StrKeyUseCustomServerSettings);
      JUseSSLCheckBox.Checked := ReadBool(StrKeyUseSSL);
      JCustomServerHostEdit.Text := ReadString(StrKeyServerHost);
      JCustomServerPortEdit.Text := ReadString(StrKeyServerPort);
    finally
      CloseKey;
    end;
end;

procedure TJabberOptionsForm.LoadAccountSettings(SettingsXml: TrXML);
begin
  with SettingsXml do
  if OpenKey(StrSettingsJabberAccount) then
    try
      JabberJIDEdit.Text := ReadString(StrKeyLogin);
      if JabberJIDEdit.Text <> EmptyStr then Jabber_JID := JabberJIDEdit.Text;
      SavePassCheckBox.Checked := ReadBool(StrKeySavePassword);
      PassEdit.Text := ReadString(StrKeyPassword);
      if PassEdit.Text <> EmptyStr then
      begin
        PassEdit.Hint := DecryptString(PassEdit.Text, PasswordByMac);
        Jabber_LoginPassword := PassEdit.Hint;
        PassEdit.Text := StrPassMask;
      end;
    finally
      CloseKey;
    end;
end;

procedure TJabberOptionsForm.CancelButtonClick(Sender: TObject);
begin
  //--��������� ����
  Close;
end;

procedure TJabberOptionsForm.FormCreate(Sender: TObject);
begin
  //--��������� ����� �� ������ �����
  TranslateForm;
  //--��������� ���������
  LoadSettings;
  //������������ ��
  UpdateJabberSettings;
  //--������������ ������ "���������"
  ApplyButton.Enabled := false;
  //--���������� ������ ����� � ������
  MainForm.AllImageList.GetIcon(43, Icon);
  MainForm.AllImageList.GetBitmap(3, CancelButton.Glyph);
  MainForm.AllImageList.GetBitmap(6, ApplyButton.Glyph);
  MainForm.AllImageList.GetBitmap(140, OKButton.Glyph);
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TJabberOptionsForm.FormShow(Sender: TObject);
begin
 OptionJvPageList.ActivePage := AccountPage;
 JabberOptionButtonGroup.ItemIndex := 0;
end;

procedure TJabberOptionsForm.JabberSomeEditChange(Sender: TObject);
begin
  //--���������� ������ ���������� ��������
  ApplyButton.Enabled := true;
end;

procedure TJabberOptionsForm.JabberOptionButtonGroupButtonClicked(
  Sender: TObject; Index: Integer);
begin
  //--�������� �������� �������� ������������� ��������� �������
  if Index <= OptionJvPageList.PageCount then OptionJvPageList.ActivePageIndex := Index;
end;

procedure TJabberOptionsForm.JUseCustomServerSettingsCheckBoxClick(Sender: TObject);
begin
  JCustomServerHostEdit.Enabled := JUseCustomServerSettingsCheckBox.Checked;
  JCustomServerPortEdit.Enabled := JUseCustomServerSettingsCheckBox.Checked;
  JabberSomeEditChange(nil);
end;

procedure TJabberOptionsForm.JIDonserverLabelMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlue;
end;

procedure TJabberOptionsForm.JIDonserverLabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clNavy;
end;

procedure TJabberOptionsForm.OKButtonClick(Sender: TObject);
begin
  //--���� ���� ���������, �� ��������� ��������� � ��������� ����
  if ApplyButton.Enabled then ApplySettings;
  Close;
end;

procedure TJabberOptionsForm.PassEditClick(Sender: TObject);
begin
  //--���� ��� ���������� ������, �� ������� ���� ����� ������
  if PassEdit.Text = StrPassMask then PassEdit.Text := EmptyStr;
end;

procedure TJabberOptionsForm.ShowPassCheckBoxClick(Sender: TObject);
begin
  //--�������� ������� ��������� ���� ������
  PassEdit.OnChange := nil;
  //--���������� ������ � ���� ����� ������
  if ShowPassCheckBox.Checked then PassEdit.PasswordChar := #0
  else PassEdit.PasswordChar := '*';
  //--��������������� ������� ��������� ���� ������
  PassEdit.OnChange := JabberSomeEditChange;
end;

end.