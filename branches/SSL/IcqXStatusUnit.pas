{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit IcqXStatusUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ButtonGroup, StdCtrls, VarsUnit;

type
  TIcqXStatusForm = class(TForm)
    XButtonGroup: TButtonGroup;
    XtextMemo: TMemo;
    BirthDayCheckBox: TCheckBox;
    OKButton: TButton;
    CancelButton: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure XButtonGroupButtonClicked(Sender: TObject; Index: Integer);
  private
    { Private declarations }
    Xindex: integer;
  public
    { Public declarations }
    procedure TranslateForm;
  end;

var
  IcqXStatusForm: TIcqXStatusForm;

implementation

{$R *.dfm}

uses
  MainUnit, IcqProtoUnit, UnitCrypto, UtilsUnit;

procedure TIcqXStatusForm.FormCreate(Sender: TObject);
begin
  //--������� ����� �� �����
  TranslateForm;
  //--������������ ������� �������������� ������ � ��������� ���������
  XButtonGroup.ItemIndex := ICQ_X_CurrentStatus;
  Xindex := ICQ_X_CurrentStatus;
  XtextMemo.Text := ICQ_X_CurrentStatus_Text;
  BirthDayCheckBox.Checked := ICQ_BirthDay_Enabled;
end;

procedure TIcqXStatusForm.FormDeactivate(Sender: TObject);
begin
  //--��������� ����
  Close;
end;

procedure TIcqXStatusForm.TranslateForm;
begin
  //--��������� ��������� ���� �� ������ ����
  
end;

procedure TIcqXStatusForm.OKButtonClick(Sender: TObject);
//var
  //I: integer;
begin
  //--����������� ���������� ��������� ��������� ������
  ICQ_X_CurrentStatus := XButtonGroup.ItemIndex;
  ICQ_X_CurrentStatus_Cap := XButtonGroup.Items[XButtonGroup.ItemIndex].Hint;
  ICQ_X_CurrentStatus_Code := XButtonGroup.Items[XButtonGroup.ItemIndex].Caption;
  if ICQ_X_CurrentStatus = 0 then XTextMemo.Clear;
  ICQ_X_CurrentStatus_Text := XTextMemo.Text;
  //--������ ������ ���. ������� � ���� icq
  MainForm.ICQPopupMenu.Items[2].ImageIndex := XButtonGroup.Items[XButtonGroup.ItemIndex].ImageIndex;
  //--���������� ������ � ����� � ����� �������
  SendFLAP('2', ICQ_CliSetFirstOnlineInfoPkt('IMadering', EmptyStr, ICQ_X_CurrentStatus_Cap, EmptyStr, EmptyStr, EmptyStr));
  ICQ_SetInfoP;
  ICQ_SetStatusXText(ICQ_X_CurrentStatus_Text, ICQ_X_CurrentStatus_Code);
  //--���� ����� ��� �������� �� ���������� ���� �����
  if BirthDayCheckBox.Checked then ICQ_BirthDay_Enabled := true
  else ICQ_BirthDay_Enabled := false;
  SendFLAP('2', ICQ_CreateShortStatusPkt);
  //--��������� ��������� ���. �������
  XButtonGroupButtonClicked(self, ICQ_X_CurrentStatus);
  //--��������� ����
  Close;
end;

procedure TIcqXStatusForm.CancelButtonClick(Sender: TObject);
begin
  //--��������� ��� ����
  Close;
end;

procedure TIcqXStatusForm.XButtonGroupButtonClicked(Sender: TObject;
  Index: Integer);
begin
  {Xini := TIniFile.Create(MyPath + 'Users\' + 'IcqXstatuses.ini');
  //
  if Xindex > 0 then
    Xini.WriteString('XText', IntToStr(Xindex), Encrypt(Memo1.Text, 12345));
  Xindex := Index;
  Memo1.Clear;
  Memo1.Text := Decrypt(Xini.ReadString('XText', IntToStr(Index), EmptyStr), 12345);
  //
  Memo1.SelStart := Memo1.GetTextLen;
  if (Memo1.CanFocus) and (Assigned(IcqXStatusForm)) then Memo1.SetFocus;
  //
  Xini.Free;

  if SaveXStatus then
  begin
    Sini := TIniFile.Create(Mypath + 'Config.ini');
    Sini.WriteInteger('ICQ', 'XStatusImg', ICQ_X_CurrentStatus);
    Sini.WriteString('ICQ', 'XStatusCap', ICQ_X_CurrentStatus_Cap);
    Sini.WriteString('ICQ', 'XStatusCode', ICQ_X_CurrentStatus_Code);
    Sini.WriteString('ICQ', 'XStatusText', Encrypt(ICQ_X_CurrentStatus_Text, 12345));
    Sini.WriteBool('ICQ', 'BirthDayBallon', CheckBox1.Checked);
    Sini.Free;
  end;

  }
end;

procedure TIcqXStatusForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--������� ������� ���� �� �������� ����
  SetForeGroundWindow(Application.MainForm.Handle);
  //--���������� ��� �����
  Action := caFree;
  IcqXStatusForm := nil;
end;

end.
