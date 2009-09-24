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
begin
  //--����������� ���������� ��������� ��������� ������
  ICQ_X_CurrentStatus := XButtonGroup.ItemIndex;
  ICQ_X_CurrentStatus_Cap := XButtonGroup.Items[XButtonGroup.ItemIndex].Hint;
  ICQ_X_CurrentStatus_Code := XButtonGroup.Items[XButtonGroup.ItemIndex].Caption;
  ICQ_X_CurrentStatus_Text := XTextMemo.Text;
  //--������ ������ ���. ������� � ���� icq
  MainForm.ICQXStatus.ImageIndex := XButtonGroup.Items[XButtonGroup.ItemIndex].ImageIndex;
  //--���������� ������ � ����� � ����� �������
  SendFLAP('2', ICQ_CliSetFirstOnlineInfoPkt('IMadering', EmptyStr, ICQ_X_CurrentStatus_Cap, EmptyStr, EmptyStr, EmptyStr));
  ICQ_SetInfoP;
  ICQ_SetStatusXText(ICQ_X_CurrentStatus_Text, ICQ_X_CurrentStatus_Code);
  //--���� ����� ��� �������� �� ���������� ���� �����
  if BirthDayCheckBox.Checked then ICQ_BirthDay_Enabled := true
  else ICQ_BirthDay_Enabled := false;
  SendFLAP('2', ICQ_CreateShortStatusPkt);
  //--��������� ��������� ���. �������
  //
  //--��������� ����
  Close;
end;

procedure TIcqXStatusForm.CancelButtonClick(Sender: TObject);
begin
  //--��������� ��� ����
  Close;
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
