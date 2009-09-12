{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit MraOptionsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ButtonGroup, ExtCtrls, ComCtrls, JvPageList,
  JvExControls, rXML;

type
  TMraOptionsForm = class(TForm)
    CancelButton: TBitBtn;
    ApplyButton: TBitBtn;
    OKButton: TBitBtn;
    MRAOptionButtonGroup: TButtonGroup;
    OptionPanel: TPanel;
    OptionJvPageList: TJvPageList;
    AccountPage: TJvStandardPage;
    AccountGroupBox: TGroupBox;
    ReqPassLabel: TLabel;
    ICQUINLabel: TLabel;
    PassLabel: TLabel;
    MRAEmailEdit: TEdit;
    PassEdit: TEdit;
    ShowPassCheckBox: TCheckBox;
    SavePassCheckBox: TCheckBox;
    RegNewEmailLabel: TLabel;
    OptionGroupBox: TGroupBox;
    ConnectPage: TJvStandardPage;
    GroupBox1: TGroupBox;
    MraLoginServerLabel: TLabel;
    MraLoginServerComboBox: TComboBox;
    MraLoginServerPortLabel: TLabel;
    MraLoginServerPortEdit: TEdit;
    OptionsPage: TJvStandardPage;
    IDClientPage: TJvStandardPage;
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure MRAonserverLabelMouseEnter(Sender: TObject);
    procedure MRAonserverLabelMouseLeave(Sender: TObject);
    procedure RegNewEmailLabelClick(Sender: TObject);
    procedure ReqPassLabelClick(Sender: TObject);
    procedure MRAEmailEditChange(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure PassEditClick(Sender: TObject);
    procedure ShowPassCheckBoxClick(Sender: TObject);
    procedure MRAOptionButtonGroupButtonClicked(Sender: TObject;
      Index: Integer);
  private
    { Private declarations }
    procedure LoadSettings;
  public
    { Public declarations }
    procedure ApplySettings;
    procedure TranslateForm;
  end;

var
  MraOptionsForm: TMraOptionsForm;

implementation

{$R *.dfm}

uses
  MainUnit, UtilsUnit, VarsUnit, MraProtoUnit, Code;

procedure TMraOptionsForm.ApplyButtonClick(Sender: TObject);
begin
  //--��������� ���������
  ApplySettings;
end;

//--APPLY SETTINGS--------------------------------------------------------------

procedure TMraOptionsForm.ApplySettings;
begin
  //--��������� ��������� Jabber ���������
  //--����������� Jabber �����
  MRAEmailEdit.Text := Trim(MRAEmailEdit.Text);
  MRAEmailEdit.Text := exNormalizeScreenName(MRAEmailEdit.Text);
  //--��������� ������ ������ � ���������
  if MRAEmailEdit.Enabled then
  begin
    MRA_LoginUIN := MRAEmailEdit.Text;
    if PassEdit.Text <> '----------------------' then
    begin
      PassEdit.Hint := PassEdit.Text;
      MRA_LoginPassword := PassEdit.Hint;
    end;
  end;
  //----------------------------------------------------------------------------
  //--���������� ��������� Jabber ��������� � ����
  with TrXML.Create() do
  try
    if FileExists(ProfilePath + SettingsFileName) then LoadFromFile(ProfilePath + SettingsFileName);
    if OpenKey('settings\mra\account', True) then
    try
      WriteString('login', MRAEmailEdit.Text);
      WriteBool('save-password', SavePassCheckBox.Checked);
      if (SavePassCheckBox.Checked) and (PassEdit.Text <> '----------------------') then
        WriteString('password', Encrypt(PassEdit.Hint, PassKey))
      else WriteString('password', EmptyStr);
      //--��������� ������
      if PassEdit.Text <> EmptyStr then PassEdit.Text := '----------------------';
    finally
      CloseKey();
    end;
    SaveToFile(ProfilePath + SettingsFileName);
  finally
    Free();
  end;
  //--������������ ������ ���������� ��������
  ApplyButton.Enabled := false;
end;

//--LOAD SETTINGS---------------------------------------------------------------

procedure TMraOptionsForm.LoadSettings;
begin
  //--�������������� XML
  with TrXML.Create() do
  try
    if FileExists(ProfilePath + SettingsFileName) then
    begin
      LoadFromFile(ProfilePath + SettingsFileName);
      //--��������� ������ ������
      if OpenKey('settings\mra\account') then
      try
        MRAEmailEdit.Text := ReadString('login');
        if MRAEmailEdit.Text <> EmptyStr then MRA_LoginUIN := MRAEmailEdit.Text;
        SavePassCheckBox.Checked := ReadBool('save-password');
        PassEdit.Text := ReadString('password');
        if PassEdit.Text <> EmptyStr then
        begin
          PassEdit.Hint := Decrypt(PassEdit.Text, PassKey);
          MRA_LoginPassword := PassEdit.Hint;
          PassEdit.Text := '----------------------';
        end;
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
  end;
end;

procedure TMraOptionsForm.TranslateForm;
begin
  //--��������� ����� �� ������ �����

end;

procedure TMraOptionsForm.CancelButtonClick(Sender: TObject);
begin
  //--��������� �����
  Close;
end;

procedure TMraOptionsForm.FormCreate(Sender: TObject);
begin
  //--��������� ����� �� ������ �����
  TranslateForm;
  //--��������� ���������
  LoadSettings;
  //--������������ ������ "���������"
  ApplyButton.Enabled := false;
  //--���������� ������ ����� � ������
  MainForm.AllImageList.GetIcon(66, Icon);
  MainForm.AllImageList.GetBitmap(3, CancelButton.Glyph);
  MainForm.AllImageList.GetBitmap(6, ApplyButton.Glyph);
  MainForm.AllImageList.GetBitmap(140, OKButton.Glyph);
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TMraOptionsForm.MRAEmailEditChange(Sender: TObject);
begin
  //--���������� ������ ���������� ��������
  ApplyButton.Enabled := true;
end;

procedure TMraOptionsForm.MRAonserverLabelMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlue;
end;

procedure TMraOptionsForm.MRAonserverLabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clNavy;
end;

procedure TMraOptionsForm.MRAOptionButtonGroupButtonClicked(Sender: TObject;
  Index: Integer);
begin
  //--�������� �������� �������� ������������� ��������� �������
  if Index <= OptionJvPageList.PageCount then OptionJvPageList.ActivePageIndex := Index;
end;

procedure TMraOptionsForm.OKButtonClick(Sender: TObject);
begin
  //--���� ���� ���������, �� ��������� ��������� � ��������� ����
  if ApplyButton.Enabled then ApplySettings;
  Close;
end;

procedure TMraOptionsForm.PassEditClick(Sender: TObject);
begin
  //--���� ��� ���������� ������, �� ������� ���� ����� ������
  if PassEdit.Text = '----------------------' then PassEdit.Text := EmptyStr;
end;

procedure TMraOptionsForm.RegNewEmailLabelClick(Sender: TObject);
begin
  //--��������� ����������� �� ��� ����� mail.ru
  OpenURL('http://win.mail.ru/cgi-bin/signup');
end;

procedure TMraOptionsForm.ReqPassLabelClick(Sender: TObject);
begin
  //--��������� ������ �������������� ������
  OpenURL('http://win.mail.ru/cgi-bin/passremind');
end;

procedure TMraOptionsForm.ShowPassCheckBoxClick(Sender: TObject);
begin
  //--�������� ������� ��������� ���� ������
  PassEdit.OnChange := nil;
  //--���������� ������ � ���� ����� ������
  if ShowPassCheckBox.Checked then PassEdit.PasswordChar := #0
  else PassEdit.PasswordChar := '*';
  //--��������������� ������� ��������� ���� ������
  PassEdit.OnChange := MRAEmailEditChange;
end;

end.
