{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, Buttons, ExtCtrls, GIFImage, JvExStdCtrls,
  JvBehaviorLabel, UtilsUnit;

type
  TAboutForm = class(TForm)
    VersionLabel: TLabel;
    BuildLabel: TLabel;
    URLLabel: TLabel;
    SiteLabel: TLabel;
    DataLabel: TLabel;
    HeadLabel: TLabel;
    InfoAboutMemo: TMemo;
    CheckUpdateBitBtn: TBitBtn;
    Bevel1: TBevel;
    DonateBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    LogoImage: TImage;
    HeadJvBehaviorLabel: TJvBehaviorLabel;
    SubJvBehaviorLabel: TJvBehaviorLabel;
    AboutListTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure URLLabelMouseEnter(Sender: TObject);
    procedure URLLabelMouseLeave(Sender: TObject);
    procedure URLLabelClick(Sender: TObject);
    procedure CheckUpdateBitBtnClick(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure DonateBitBtnClick(Sender: TObject);
    procedure HeadJvBehaviorLabelStart(Sender: TObject);
    procedure HeadJvBehaviorLabelStop(Sender: TObject);
    procedure SubJvBehaviorLabelStart(Sender: TObject);
    procedure SubJvBehaviorLabelStop(Sender: TObject);
    procedure AboutListTimerTimer(Sender: TObject);
  private
    { Private declarations }
    AboutLen: integer;
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

uses
  MainUnit, VarsUnit;

{$WARNINGS OFF}

function GetFileDateTime(FileName: string): TDateTime;
var
  intFileAge: LongInt;
begin
  intFileAge := FileAge(FileName);
  if intFileAge = -1 then Result := 0
  else Result := FileDateToDateTime(intFileAge);
end;

{$WARNINGS ON}

procedure TAboutForm.OKBitBtnClick(Sender: TObject);
begin
  //--��������� ����
  Close;
end;

procedure TAboutForm.SubJvBehaviorLabelStart(Sender: TObject);
begin
  //--���� ��������� ������ �� ������ About
  SubJvBehaviorLabel.Caption := Parse(';', AboutList[AboutLen], 2);
end;

procedure TAboutForm.SubJvBehaviorLabelStop(Sender: TObject);
begin
  //--����������� �������� ������ ������ ������
  Inc(AboutLen);
  //--���� ������ ������ �� ����������, �� ���������� �����
  if AboutLen > Length(AboutList) then AboutLen := 1;
  AboutListTimer.Enabled := true;
end;

procedure TAboutForm.URLLabelClick(Sender: TObject);
begin
  //--��������� ���� � �������� �� ���������
  ShellExecute(Application.Handle, 'open', PChar('http://imadering.com'), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.URLLabelMouseEnter(Sender: TObject);
begin
  URLLabel.Font.Color := clBlue;
end;

procedure TAboutForm.URLLabelMouseLeave(Sender: TObject);
begin
  URLLabel.Font.Color := clNavy;
end;

procedure TAboutForm.AboutListTimerTimer(Sender: TObject);
begin
  AboutListTimer.Enabled := false;
  //--������� ���� ������
  SubJvBehaviorLabel.Caption := EmptyStr;
  //--�������� ����� ������
  if HeadJvBehaviorLabel.Hint <> Parse(';', AboutList[AboutLen], 1) then
  begin
    HeadJvBehaviorLabel.Caption := EmptyStr;
    HeadJvBehaviorLabel.BehaviorOptions.Active := true;
  end
  else SubJvBehaviorLabel.BehaviorOptions.Active := true;
end;

procedure TAboutForm.CheckUpdateBitBtnClick(Sender: TObject);
begin
  //--��������� �������� ���������� ��������� �� �����
  MainForm.JvTimerListEvents2Timer(nil);
end;

procedure TAboutForm.DonateBitBtnClick(Sender: TObject);
begin
  //--��������� ������ ���������� ������������ �����
  URLLabelClick(self);
end;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--��������� ������������ ���� ��� ��������
  Action := caFree;
  AboutForm := nil;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  //--����������� ������ ���� � ������
  MainForm.AllImageList.GetIcon(0, Icon);
  MainForm.AllImageList.GetBitmap(6, CheckUpdateBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(185, DonateBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(140, OKBitBtn.Glyph);
  //--��������� ������� ���������
  if FileExists(MyPath + 'Icons\' + CurrentIcons + '\noavatar.gif') then
    LogoImage.Picture.LoadFromFile(MyPath + 'Icons\' + CurrentIcons + '\noavatar.gif');
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  //--�������� � ������ ���������
  VersionLabel.Caption := VersionLabel.Caption + ' ' + Bild_Version;
  //--�������� �������� � ����� ����������
  BuildLabel.Caption := BuildLabel.Caption + ' ' + Parse('.', InitBuildInfo, 4);
  //--�������� ���� ��������� �����
  DataLabel.Caption := DataLabel.Caption + ' ' + DateToStr(GetFileDateTime(MyPath + 'Imadering.exe'));
  //--����������� ��������� �������� ������ ������ ������
  AboutLen := 1;
  //--�������� ����� ������
  HeadJvBehaviorLabel.BehaviorOptions.Active := true;
end;

procedure TAboutForm.HeadJvBehaviorLabelStart(Sender: TObject);
begin
  //--���� ��������� ������ �� ������ About
  HeadJvBehaviorLabel.Hint := Parse(';', AboutList[AboutLen], 1);
  HeadJvBehaviorLabel.Caption := HeadJvBehaviorLabel.Hint;
end;

procedure TAboutForm.HeadJvBehaviorLabelStop(Sender: TObject);
begin
  //--�������� ������ ������ ������
  SubJvBehaviorLabel.BehaviorOptions.Active := true;
end;

end.
