{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit UpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, OverbyteIcsWndControl,
  OverbyteIcsHttpProt, SimpleXML, OverbyteIcsWSocket, JvTimerList, UnitCrypto,
  JvZLibMultiple;

type
  TUpdateForm = class(TForm)
    StartBitBtn: TBitBtn;
    AbortBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    DownloadProgressBar: TProgressBar;
    LoadSizeLabel: TLabel;
    InfoMemo: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure AbortBitBtnClick(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateForm: TUpdateForm;

implementation

{$R *.dfm}

uses
  MainUnit, UtilsUnit, VarsUnit, UnitLogger;

procedure TUpdateForm.AbortBitBtnClick(Sender: TObject);
begin
  //--���������� ������ ����������� �������
  StartBitBtn.Enabled := true;
  //--������������ ������ ��������
  AbortBitBtn.Enabled := false;
  //--������ ���� ����� ��������� �������
  MainForm.UpdateHttpClient.Tag := 2;
  //--������� ���������� � ����������� ������� ���������
  InfoMemo.Lines.Add(UpDateAbortL);
end;

procedure TUpdateForm.CloseBitBtnClick(Sender: TObject);
begin
  //--��������� ���������
  Close;
end;

procedure TUpdateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--���������� ���� ����� ��������
  Action := caFree;
  UpdateForm := nil;
end;

procedure TUpdateForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //--��������� ������� ����� ����������
  AbortBitBtnClick(nil);
end;

procedure TUpdateForm.FormCreate(Sender: TObject);
begin
  //--�������� ������� ����������� ������� ����
  DoubleBuffered := true;
  //--����������� ������ ���� � ������
  MainForm.AllImageList.GetIcon(225, Icon);
  MainForm.AllImageList.GetBitmap(3, CloseBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(139, AbortBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(140, StartBitBtn.Glyph);
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TUpdateForm.StartBitBtnClick(Sender: TObject);
begin
  //--������������ ������ ����������� �������
  StartBitBtn.Enabled := false;
  //--���������� ������ ��������
  AbortBitBtn.Enabled := true;
  //--������ ���� ��������� ������� ����� ����������
  MainForm.UpdateHttpClient.Tag := 1;
  //--��������� � ���� ������
  if InfoMemo.Text <> EmptyStr then InfoMemo.Lines.Add('');
  //--�������� ���������� ���������
  LoadSizeLabel.Caption := '�������: 0 ��';
  DownloadProgressBar.Position := 0;
  //--������� ���������� � ������ ������� ���������
  InfoMemo.Lines.Add(UpDateStartL + ' (' + UpdateVersionPath + ')');
  //--��������� ������� ����� ���������� � �����
  MainForm.UpdateHttpClient.Abort;
  try
    MainForm.UpdateHttpClient.URL := 'http://imadering.googlecode.com/files/' + UpdateVersionPath;
    MainForm.UpdateHttpClient.GetASync;
  except
    on E: Exception do
      //--���� ��� ����������� ��������� ������, �� �������� �� ����
      InfoMemo.Lines.Add(E.Message);
  end;
end;

end.

