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
    Panel1: TPanel;
    JvPageList1: TJvPageList;
    JvStandardPage1: TJvStandardPage;
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
    GroupBox1: TGroupBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JIDonserverLabelMouseEnter(Sender: TObject);
    procedure JIDonserverLabelMouseLeave(Sender: TObject);
    procedure JabberJIDEditChange(Sender: TObject);
    procedure PassEditClick(Sender: TObject);
    procedure ShowPassCheckBoxClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSettings;
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
  MainUnit, JabberProtoUnit, Code, SettingsUnit, UtilsUnit, VarsUnit;

procedure TJabberOptionsForm.ApplyButtonClick(Sender: TObject);
begin
  //--��������� ���������
  ApplySettings;
end;

//--APPLY SETTINGS--------------------------------------------------------------

procedure TJabberOptionsForm.ApplySettings;
begin
  //--��������� ��������� Jabber ���������
  //--����������� Jabber �����
  JabberJIDEdit.Text := Trim(JabberJIDEdit.Text);
  JabberJIDEdit.Text := exNormalizeScreenName(JabberJIDEdit.Text);
  //--��������� ������ ������ � ���������
  if JabberJIDEdit.Enabled then
  begin
    Jabber_JID := JabberJIDEdit.Text;
    if PassEdit.Text <> '----------------------' then
    begin
      PassEdit.Hint := PassEdit.Text;
      Jabber_LoginPassword := PassEdit.Hint;
    end;
  end;
  //----------------------------------------------------------------------------
  //--���������� ��������� Jabber ��������� � ����
  with TrXML.Create() do
  try
    if FileExists(ProfilePath + SettingsFileName) then LoadFromFile(ProfilePath + SettingsFileName);
    if OpenKey('settings\jabber\account', True) then
    try
      WriteString('login', JabberJIDEdit.Text);
      WriteBool('save-password', SavePassCheckBox.Checked);
      if SavePassCheckBox.Checked then
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

procedure TJabberOptionsForm.LoadSettings;
begin
  //--�������������� XML
  with TrXML.Create() do
  try
    if FileExists(ProfilePath + SettingsFileName) then
    begin
      LoadFromFile(ProfilePath + SettingsFileName);
      //--��������� ������ ������
      if OpenKey('settings\jabber\account') then
      try
        JabberJIDEdit.Text := ReadString('login');
        if JabberJIDEdit.Text <> EmptyStr then Jabber_JID := JabberJIDEdit.Text;
        SavePassCheckBox.Checked := ReadBool('save-password');
        PassEdit.Text := ReadString('password');
        if PassEdit.Text <> EmptyStr then
        begin
          PassEdit.Hint := Decrypt(PassEdit.Text, PassKey);
          Jabber_LoginPassword := PassEdit.Hint;
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

procedure TJabberOptionsForm.TranslateForm;
begin
  //--��������� ����� �� ������ �����

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

procedure TJabberOptionsForm.JabberJIDEditChange(Sender: TObject);
begin
  //--���������� ������ ���������� ��������
  ApplyButton.Enabled := true;
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
  if PassEdit.Text = '----------------------' then PassEdit.Text := EmptyStr;
end;

procedure TJabberOptionsForm.ShowPassCheckBoxClick(Sender: TObject);
begin
  //--�������� ������� ��������� ���� ������
  PassEdit.OnChange := nil;
  //--���������� ������ � ���� ����� ������
  if ShowPassCheckBox.Checked then PassEdit.PasswordChar := #0
  else PassEdit.PasswordChar := '*';
  //--��������������� ������� ��������� ���� ������
  PassEdit.OnChange := JabberJIDEditChange;
end;

end.
