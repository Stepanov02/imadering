{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit FileTransferUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  TFileTransferForm = class(TForm)
    TopInfoPanel: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    CancelBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    ProgressBar1: TProgressBar;
    BottomInfoPanel: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure CancelBitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure TranslateForm;
    procedure SendUpWap(xFile: string);
  end;

var
  FileTransferForm: TFileTransferForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TFileTransferForm.SendUpWap(xFile: string);
begin
  //--��������� ���� �� UpWap.ru
  
end;

procedure TFileTransferForm.CancelBitBtnClick(Sender: TObject);
begin
  //--��������� ������
  CancelBitBtn.Enabled := false;
  //--������������� �������� �����

end;

procedure TFileTransferForm.CloseBitBtnClick(Sender: TObject);
begin
  //--��������� ����
  Close;
end;

procedure TFileTransferForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //--���� �������� ���������, �� ���������� ����
  if not CancelBitBtn.Enabled then
  begin
    Action := caFree;
    FileTransferForm := nil;
  end;
end;

procedure TFileTransferForm.FormCreate(Sender: TObject);
begin
  //--��������� ���� �� ������ �����
  TranslateForm;
  //--��������� ������ � ���� � �������
  MainForm.AllImageList.GetIcon(149, Icon);
  //--������ ���� ����������� � �������� ��� ������ �� ������ �����
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFileTransferForm.TranslateForm;
begin
  //--��������� ���� �� ������ �����

end;

end.
