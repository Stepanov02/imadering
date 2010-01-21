{ *******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
  ******************************************************************************* }

unit ProfileUnit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  Pngimage,
  Menus,
  StdCtrls,
  JvSimpleXml;

type
  TProfileForm = class(TForm)
    LogoImage: TImage;
    CenterPanel: TPanel;
    ProfileComboBox: TComboBox;
    ProfileLabel: TLabel;
    LoginButton: TButton;
    DeleteButton: TButton;
    VersionLabel: TLabel;
    SiteLabel: TLabel;
    LangLabel: TLabel;
    LangComboBox: TComboBox;
    AutoSignCheckBox: TCheckBox;
    procedure SiteLabelMouseEnter(Sender: TObject);
    procedure SiteLabelMouseLeave(Sender: TObject);
    procedure SiteLabelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LangComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoginButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ProfileComboBoxChange(Sender: TObject);

  private
    { Private declarations }
    FClose: Boolean;
    procedure SaveSettings;
    procedure LoadSettings;

  public
    { Public declarations }
    procedure TranslateForm;
  end;

var
  ProfileForm: TProfileForm;

implementation

{$R *.dfm}

uses
  MainUnit,
  VarsUnit,
  UtilsUnit,
  SettingsUnit,
  RosterUnit,
  FirstStartUnit,
  LogUnit;

resourcestring
  RS_Lang = 'language';
  RS_Prof = 'profiles';
  RS_Cur = 'current';
  RS_Auto = 'auto_login';

procedure TProfileForm.SaveSettings;
var
  I: Integer;
  JvXML: TJvSimpleXml;
  XML_Node: TJvSimpleXmlElem;
begin
  // ������ ����������� �����
  ForceDirectories(ProfilePath);
  // ��������� ��������� ��������� �������� ���� � xml
  JvXML_Create(JvXML);
  try
    with JvXML do
      begin
        // ��������� ���� �� ���������
        Root.Items.Add(RS_Lang, CurrentLang);
        // ��������� ������� �� ���������
        XML_Node := Root.Items.Add(RS_Prof);
        XML_Node.Properties.Add(RS_Cur, Profile);
        XML_Node.Properties.Add(RS_Auto, AutoSignCheckBox.Checked);
        // ��������� ������ ���� ������ ��������
        for I := 0 to ProfileComboBox.Items.Count - 1 do
          XML_Node.Items.Add('i' + IntToStr(I), ProfileComboBox.Items.Strings[I]);
        // ���������� ��� ����
        SaveToFile(ProfilePath + ProfilesFileName);
      end;
  finally
    JvXML.Free;
  end;
end;

procedure TProfileForm.LoadSettings;
var
  I: Integer;
  JvXML: TJvSimpleXml;
  XML_Node: TJvSimpleXmlElem;
begin
  // �������������� XML
  JvXML_Create(JvXML);
  try
    with JvXML do
      begin
        // ��������� ���������
        if FileExists(ProfilePath + ProfilesFileName) then
          begin
            LoadFromFile(ProfilePath + ProfilesFileName);
            if Root <> nil then
              begin
                // ��������� ���� �� ���������
                CurrentLang := Root.Items.Value(RS_Lang);
                // �������� ��� ���������� �������
                XML_Node := Root.Items.ItemNamed[RS_Prof];
                if XML_Node <> nil then
                  begin
                    ProfileComboBox.Text := XML_Node.Properties.Value(RS_Cur);
                    AutoSignCheckBox.Checked := XML_Node.Properties.BoolValue(RS_Auto);
                    // �������� ������ ������ ��������
                    for I := 0 to XML_Node.Items.Count - 1 do
                      ProfileComboBox.Items.Add(XML_Node.Items.Value('i' + IntToStr(I)));
                  end;
              end;
          end;
      end;
  finally
    JvXML.Free;
  end;
end;

procedure TProfileForm.LoginButtonClick(Sender: TObject);
begin
  // ��������� ��������� �������
  if ProfileComboBox.Text = EmptyStr then
    begin
      // ������� ��������� � ���, ��� ����� ������ ��� ������� �������
      DAShow(S_Errorhead, S_ProfileError, EmptyStr, 134, 2, 0);
      Exit;
    end;
  // ����������� ��� �������
  ProfileComboBox.Text := RafinePath(ProfileComboBox.Text);
  // ���������� ��� �������
  Profile := ProfileComboBox.Text;
  if ProfileComboBox.Items.IndexOf(Profile) = -1 then
    ProfileComboBox.Items.Add(Profile);
  // ��������� ���������
  SaveSettings;
  // �������������� ����� � ��������
  ProfilePath := ProfilePath + Profile + '\';
  XLog(LogProfile + ProfilePath);
  // ������ ����� � ����������� ��� ���������� ��������
  SettingsForm := TSettingsForm.Create(MainForm);
  SettingsForm.ApplySettings;
  // ������������ ���� � ����
  with MainForm do
    begin
      HideProfileInTray.Visible := False;
      HideMainInTray2.Visible := True;
      StatusTray2.Visible := True;
      SettingsTray2.Visible := True;
      CheckUpdateTray2.Visible := True;
      // ������� ���������� ������ ��������� �������� ���������� � ����
      AllImageList.GetIcon(9, ICQTrayIcon.Icon);
      AllImageList.GetIcon(23, MRATrayIcon.Icon);
      AllImageList.GetIcon(30, JabberTrayIcon.Icon);
    end;
  // ���� ������ �������� ����� ������ � ���� (����� ������� ����������� �� ���������)
  MainForm.XTrayIcon.Visible := False;
  // ��������� ��������� �������� ����
  MainForm.LoadMainFormSettings;
  if AllSesDataTraf = EmptyStr then
    AllSesDataTraf := DateTimeToStr(Now);
  // ������ ���� ������� � ��������� �������� � ����
  RosterForm := TRosterForm.Create(MainForm);
  // ���� ��� ������ ����� ���������, �� �� ��������� ��������� ICQ ��������
  if not FirstStart then
    MainForm.ICQEnable(True);
  // ���� ������������� ��������� ����� ������ ��� ������
  if SettingsForm.AutoUpdateCheckBox.Checked then
    MainForm.JvTimerList.Events[2].Enabled := True;
  // ������ ����������� �����
  AccountToNick := TStringList.Create;
  InMessList := TStringList.Create;
  SmilesList := TStringList.Create;
  if FileExists(ProfilePath + Nick_BD_FileName) then
    AccountToNick.LoadFromFile(ProfilePath + Nick_BD_FileName);
  XLog(LogNickCash + IntToStr(AccountToNick.Count));
  if FileExists(MyPath + Format(SmiliesPath, [CurrentSmiles])) then
    SmilesList.LoadFromFile(MyPath + Format(SmiliesPath, [CurrentSmiles]));
  XLog(LogSmiliesCount + IntToStr(SmilesList.Count - 1));
  // ��������� ��������� �������
  RosterForm.UpdateFullCL;
  // ���� �� ������� ����������� �������� � ���� �� ���������� ������� ����
  if not SettingsForm.HideInTrayProgramStartCheckBox.Checked then
    begin
      XShowForm(MainForm);
      // ������� ���� �� ����� �������� ����, ������ ������ � ��� � ����
      SetForeGroundWindow(Application.MainForm.Handle);
    end;
  // � ���� ������ ���� �������
  MainForm.JvTimerList.Events[7].Enabled := True;
  // �������������� ���������� ������� ������ ���������� ������� ������
  SesDataTraf := Now;
  // ���� ��� ������ ����� ��������� �� ��������� ���� ��������� ��������� ����������
  if not FirstStart then
    begin
      // ����� ���������� ���� ��������� ��������� ����������
      FirstStartForm := TFirstStartForm.Create(MainForm);
      XShowForm(FirstStartForm);
    end;
  // ��������� ������ ��������� �������
  MainForm.JvTimerList.Events[1].Enabled := True;
  // ��������� ������ ������ ����������� ������� � ���� ����
  LogForm.WriteLogSpeedButton.Down := False;
  // ������������ ����� ������ ���������� (��������� qip)
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
  // ������������� ���� ������� ���������
  ImPlaySnd(0);
  // ��������� ����
  FClose := True;
  Close;
end;

procedure TProfileForm.ProfileComboBoxChange(Sender: TObject);
begin
  // ����� � ����������� ��������� ���� � �������
  ProfileComboBox.Hint := ProfilePath + ProfileComboBox.Text;
end;

procedure TProfileForm.TranslateForm;
begin
  // ������ ������ ��� ��������
  // CreateLang(Self);
  // ��������� ����
  SetLang(Self);
  // �������� � ������ ���������
  VersionLabel.Caption := Format(S_Version, [InitBuildInfo]);
end;

procedure TProfileForm.DeleteButtonClick(Sender: TObject);
var
  N: Integer;
begin
  // ������� ������� �� ������
  ProfileComboBox.Text := EmptyStr;
  ProfileComboBox.Hint := EmptyStr;
  N := ProfileComboBox.Items.IndexOf(ProfileComboBox.Text);
  if N > -1 then
    begin
      ProfileComboBox.Items.Delete(N);
      ProfileComboBox.Text := EmptyStr;
      SaveSettings;
    end;
end;

procedure TProfileForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // ���������� �����
  Action := CaFree;
  ProfileForm := nil;
end;

procedure TProfileForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // ��������� ���������
  if not FClose then
    MainForm.CloseProgramClick(nil);
end;

procedure TProfileForm.FormCreate(Sender: TObject);
begin
  // ����������� ������ ���� � �������
  MainForm.AllImageList.GetIcon(253, Icon);
  // ��������� ������� ���������
  if FileExists(MyPath + 'Icons\' + CurrentIcons + '\logo.png') then
    LogoImage.Picture.LoadFromFile(MyPath + 'Icons\' + CurrentIcons + '\logo.png');
  // �������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  // ��������� ���������
  LoadSettings;
  ProfileComboBox.Hint := ProfilePath + ProfileComboBox.Text;
  // ��������� ����������� �������� ��� �������
  LangComboBox.Items.NameValueSeparator := BN;
  // ������������� ����
  LangComboBox.ItemIndex := LangComboBox.Items.IndexOfName('[' + CurrentLang + ']');
  // ��������� �����
  LangComboBox.OnChange := LangComboBoxChange;
  LangComboBoxChange(nil);
  // ������������ ����� ������ ���������� (��������� qip)
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
end;

procedure TProfileForm.LangComboBoxChange(Sender: TObject);
begin
  // ������������� ����
  CurrentLang := IsolateTextString(LangComboBox.Items.Names[LangComboBox.ItemIndex], '[', ']');
  // ���������� ���������� �����
  SetLangVars;
  // ��������� �����
  TranslateForm;
  // ��������� ���� � ����� ����
  LogForm.TranslateForm;
  // ��������� ���� � ������� �����
  MainForm.TranslateForm;
end;

procedure TProfileForm.SiteLabelClick(Sender: TObject);
begin
  // ��������� ���� � �������� �� ���������
  OpenURL('http://imadering.com');
end;

procedure TProfileForm.SiteLabelMouseEnter(Sender: TObject);
begin (Sender as TLabel)
  .Font.Color := ClBlue;
end;

procedure TProfileForm.SiteLabelMouseLeave(Sender: TObject);
begin (Sender as TLabel)
  .Font.Color := ClNavy;
end;

end.
