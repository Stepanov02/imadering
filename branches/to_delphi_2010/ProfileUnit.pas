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
  StdCtrls;

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

  private
    { Private declarations }
    FClose: boolean;
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
  RXML,
  SettingsUnit;

procedure TProfileForm.SaveSettings;
var
  I: Integer;
begin
  // ������ ����������� �����
  ForceDirectories(ProfilePath);
  // ��������� ��������� ��������� �������� ���� � xml
  with TrXML.Create() do
    try
      // ��������� ���� �� ���������
      if OpenKey('defaults\language', True) then
        try
          WriteString('locale', CurrentLang);
        finally
          CloseKey();
        end;
      // ��������� ������� �� ���������
      if OpenKey('defaults\profile', True) then
        try
          WriteString('name', Profile);
          WriteBool('auto', AutoSignCheckBox.Checked);
        finally
          CloseKey();
        end;
      // ��������� ������ ���� ������ ��������
      for I := 0 to ProfileComboBox.Items.Count - 1 do
        begin
          if OpenKey('defaults\profile\items' + IntToStr(I), True) then
            try
              WriteString('name', ProfileComboBox.Items.Strings[I]);
            finally
              CloseKey();
            end;
        end;
      // ���������� ��� ����
      SaveToFile(ProfilePath + ProfilesFileName);
    finally
      Free();
    end;
end;

procedure TProfileForm.LoadSettings;
var
  I, Cnt: Integer;
begin
  // �������������� XML
  with TrXML.Create() do
    try
      // ��������� ���������
      if FileExists(ProfilePath + ProfilesFileName) then
        begin
          LoadFromFile(ProfilePath + ProfilesFileName);
          // ��������� ���� �� ���������
          if OpenKey('defaults\language') then
            try
              CurrentLang := ReadString('locale');
            finally
              CloseKey();
            end;
          // �������� ��� ���������� �������
          if OpenKey('defaults\profile') then
            try
              ProfileComboBox.Text := ReadString('name');
              AutoSignCheckBox.Checked := ReadBool('auto');
            finally
              CloseKey();
            end;
          // �������� ������ ������ ��������
          if OpenKey('defaults\profile') then
            try
              Cnt := GetKeyCount();
            finally
              CloseKey();
            end;
          for I := 0 to Cnt - 1 do
            begin
              if OpenKey('defaults\profile\items' + IntToStr(I)) then
                try
                  ProfileComboBox.Items.Add(ReadString('name'));
                finally
                  CloseKey();
                end;
            end;
        end;
    finally
      Free();
    end;
end;

procedure TProfileForm.LoginButtonClick(Sender: TObject);
begin
  // ��������� ��������� �������
  if ProfileComboBox.Text = EmptyStr then
    begin
      // ������� ��������� � ���, ��� ����� ������ ��� ������� �������
      DAShow(ErrorHead, ProfileErrorL, EmptyStr, 134, 2, 0);
      Exit;
    end;
  Profile := ProfileComboBox.Text;
  if ProfileComboBox.Items.IndexOf(Profile) = -1 then
    ProfileComboBox.Items.Add(Profile);

  // �������� ������ ����� � ����������� ��� ���������� ��������
  //SettingsForm := TSettingsForm.Create(Self);
  //SettingsForm.ApplySettings;

  // ��������� ���������
  SaveSettings;
  // ��������� ����
  FClose := true;
  Close;
end;

procedure TProfileForm.TranslateForm;
begin
  // ������ ������ ��� ��������
  //CreateLang(Self);
  // ��������� ����
  SetLang(Self);
  // �������� � ������ ���������
  VersionLabel.Caption := Format(VersionL, [InitBuildInfo]);
end;

procedure TProfileForm.DeleteButtonClick(Sender: TObject);
var
  N: integer;
begin
  // ������� ������� �� ������
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
  if not FClose then MainForm.CloseProgramClick(nil);
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
  // ������������� ����
  if CurrentLang = 'ru' then
    LangComboBox.ItemIndex := 0
  else
    LangComboBox.ItemIndex := 1;
  // ��������� �����
  LangComboBox.OnChange := LangComboBoxChange;
  LangComboBoxChange(nil);
end;

procedure TProfileForm.LangComboBoxChange(Sender: TObject);
begin
  // ������������� ����
  case LangComboBox.ItemIndex of
    0: CurrentLang := 'ru';
    1: CurrentLang := 'en';
  end;
  // ��������� �����
  SetLangVars;
  TranslateForm;
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
