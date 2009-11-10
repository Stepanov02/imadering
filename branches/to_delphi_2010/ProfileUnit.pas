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
  pngimage,
  StdCtrls;

type
  TProfileForm = class(TForm)
    LogoImage: TImage;
    CenterPanel: TPanel;
    ProfileComboBox: TComboBox;
    ProfileLabel: TLabel;
    ProfilePassEdit: TEdit;
    ProfilePassLabel: TLabel;
    SavePassCheckBox: TCheckBox;
    LoginButton: TButton;
    DeleteButton: TButton;
    VersionLabel: TLabel;
    SiteLabel: TLabel;
    procedure SiteLabelMouseEnter(Sender: TObject);
    procedure SiteLabelMouseLeave(Sender: TObject);
    procedure SiteLabelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
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
  rXML;

procedure TProfileForm.TranslateForm;
begin
  // ������ ������ ��� ��������
  CreateLang(self);
  // ��������� ����
  SetLang(self);
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
  // �������� � ������ ���������
  VersionLabel.Caption := Format(VersionL, [InitBuildInfo]);
  // ��������� �����
  TranslateForm;
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
