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
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, OverbyteIcsWndControl,
  OverbyteIcsHttpProt;

type
  TFileTransferForm = class(TForm)
    TopInfoPanel: TPanel;
    FileNamePanel: TPanel;
    FileSizePanel: TPanel;
    FileNameLabel: TLabel;
    FileSizeLabel: TLabel;
    CancelBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    SendProgressBar: TProgressBar;
    BottomInfoPanel: TPanel;
    ProgressLabel: TLabel;
    SendStatusLabel: TLabel;
    SendFileHttpClient: THttpCli;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure CancelBitBtnClick(Sender: TObject);
    procedure SendFileHttpClientDocBegin(Sender: TObject);
    procedure SendFileHttpClientDocEnd(Sender: TObject);
    procedure SendFileHttpClientSendEnd(Sender: TObject);
    procedure SendFileHttpClientSessionClosed(Sender: TObject);
    procedure SendFileHttpClientSocksConnected(Sender: TObject; ErrCode: Word);
    procedure SendFileHttpClientSocksError(Sender: TObject; Error: Integer;
      Msg: string);
  private
    { Private declarations }
  public
    { Public declarations }
    SendForUIN: string;
    procedure TranslateForm;
    procedure SendUpWap(xFile: string);
  end;

var
  FileTransferForm: TFileTransferForm;

implementation

uses MainUnit, SettingsUnit, UnitLogger, TrafficUnit, VarsUnit, UtilsUnit,
  IcqProtoUnit;

{$R *.dfm}

const
  UpWapRootURL = 'http://upwap.ru';

procedure TFileTransferForm.SendFileHttpClientDocBegin(Sender: TObject);
begin
  //--������ ���� ������ ��� ����� http ������
  SendFileHttpClient.RcvdStream := TMemoryStream.Create;
end;

procedure TFileTransferForm.SendFileHttpClientDocEnd(Sender: TObject);
var
  list: TStringList;
  Doc, skey: string;
begin
  //--������ ���������� http ������ �� ����� ������
  if SendFileHttpClient.RcvdStream <> nil then
  begin
    try
      //--����������� ���������� ��������� �������
      TrafRecev := TrafRecev + SendFileHttpClient.RcvdCount;
      AllTrafRecev := AllTrafRecev + SendFileHttpClient.RcvdCount;
      if Assigned(TrafficForm) then MainForm.OpenTrafficClick(nil);
      //--���������� ���������� ������� ��� ������ �� �����
      //--������ ��������� ����
      list := TStringList.Create;
      try
        //--�������� ������� ������ ������ � ����� ������
        SendFileHttpClient.RcvdStream.Position := 0;
        //--������ ������ � ����
        list.LoadFromStream(SendFileHttpClient.RcvdStream);
        //--��������� ������ � �����
        if list.Text > EmptyStr then
        begin
          Doc := DecodeStr(list.Text);
          case SendFileHttpClient.Tag of
            0:
              begin
                //--����� ���� ������
                skey := IsolateTextString(Doc, 'action="', '"');
                SendFileHttpClient.
              end;
            1:
              begin
                showmessage(Doc);
              end;
          end;
        end;
      finally
        list.Free;
      end;
    finally
      //--������������ ���� ������
      SendFileHttpClient.RcvdStream.Free;
      SendFileHttpClient.RcvdStream := nil;
    end;
  end;
end;

procedure TFileTransferForm.SendFileHttpClientSendEnd(Sender: TObject);
begin
  //--����������� ���������� ���������� �������
  TrafSend := TrafSend + SendFileHttpClient.SentCount;
  AllTrafSend := AllTrafSend + SendFileHttpClient.SentCount;
  if Assigned(TrafficForm) then MainForm.OpenTrafficClick(nil);
end;

procedure TFileTransferForm.SendFileHttpClientSessionClosed(Sender: TObject);
begin
  //--������������ ��������� ������ � ������ http ������
  if (SendFileHttpClient.StatusCode = 0) or (SendFileHttpClient.StatusCode >= 400) then
  begin
    DAShow(ErrorHead, ErrorHttpClient(SendFileHttpClient.StatusCode), EmptyStr, 134, 2, 0);
  end;
end;

procedure TFileTransferForm.SendFileHttpClientSocksConnected(Sender: TObject;
  ErrCode: Word);
begin
  //--���� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(ErrCode), EmptyStr, 134, 2, 0);
  end;
end;

procedure TFileTransferForm.SendFileHttpClientSocksError(Sender: TObject;
  Error: Integer; Msg: string);
begin
  //--���� �������� ������, �� �������� �� ����
  if Error <> 0 then
  begin
    DAShow(ErrorHead, Msg, EmptyStr, 134, 2, 0);
  end;
end;

procedure TFileTransferForm.SendUpWap(xFile: string);
begin
  //--���������� �����
  SendFileHttpClient.Abort;
  //--��������� URL
  try
    SendFileHttpClient.URL := 'http://upwap.ru/upload/';
    SendFileHttpClient.GetASync;
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(E);
  end;
end;

procedure TFileTransferForm.CancelBitBtnClick(Sender: TObject);
begin
  //--��������� ������
  CancelBitBtn.Enabled := false;
  //--������������� �������� �����
  SendFileHttpClient.Tag := 2;
  SendFileHttpClient.Abort;
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
  //--��������� ��������� ������
  SendFileHttpClient.Abort;
  SettingsForm.ApplyProxyHttpClient(SendFileHttpClient);
end;

procedure TFileTransferForm.TranslateForm;
begin
  //--��������� ���� �� ������ �����

end;

end.

