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
    SendFileHttpClient: THttpCli;
    DescEdit: TEdit;
    PassEdit: TEdit;
    DescLabel: TLabel;
    SendFileButton: TBitBtn;
    PassLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure CancelBitBtnClick(Sender: TObject);
    procedure SendFileHttpClientDocBegin(Sender: TObject);
    procedure SendFileHttpClientDocEnd(Sender: TObject);
    procedure SendFileHttpClientSendEnd(Sender: TObject);
    procedure SendFileHttpClientSessionClosed(Sender: TObject);
    procedure SendFileButtonClick(Sender: TObject);
    procedure SendFileHttpClientSendData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure TranslateForm;
  end;

var
  FileTransferForm: TFileTransferForm;

implementation

uses MainUnit, SettingsUnit, UnitLogger, TrafficUnit, VarsUnit, UtilsUnit,
  IcqProtoUnit, RosterUnit, JabberProtoUnit, MraProtoUnit;

{$R *.dfm}

const
  UpWapRootURL = 'http://upwap.ru';

procedure TFileTransferForm.SendFileButtonClick(Sender: TObject);
begin
  //--��������� �������� �������� � ������
  CancelBitBtn.Enabled := true;
  DescEdit.Enabled := false;
  DescEdit.Color := clBtnFace;
  PassEdit.Enabled := false;
  PassEdit.Color := clBtnFace;
  SendFileButton.Enabled := false;
  //--��������� ��������� ������
  SendFileHttpClient.Abort;
  SettingsForm.ApplyProxyHttpClient(SendFileHttpClient);
  case Tag of
    1:
      begin
        //--����������� �������� � ����� ������
        try
          SendProgressBar.Position := 0;
          SendFileHttpClient.Tag := 0;
          SendFileHttpClient.URL := 'http://upwap.ru/upload/';
          BottomInfoPanel.Caption := FileTransfer2L;
          SendFileHttpClient.GetASync;
        except
          on E: Exception do
            TLogger.Instance.WriteMessage(E);
        end;
      end;
  end;
end;

procedure TFileTransferForm.SendFileHttpClientDocBegin(Sender: TObject);
begin
  //--������ ���� ������ ��� ����� http ������
  SendFileHttpClient.RcvdStream := TMemoryStream.Create;
end;

procedure TFileTransferForm.SendFileHttpClientDocEnd(Sender: TObject);
var
  list: TStringList;
  Doc, skey, Buf, Boundry, OKURL: string;
  FileToSend: TMemoryStream;
  RosterItem: TListItem;
  SendYES: boolean;
begin
  SendYES := false;
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
                //--������ ���� ������ ��� �������� ����� ������� POST
                SendFileHttpClient.SendStream := TMemoryStream.Create;
                //--��������� ������ ��� ��������
                with SendFileHttpClient do
                begin
                  //--������ ��� ����� ������
                  URL := UpWapRootURL + skey;
                  //--��������� ���������� ��� POST
                  Boundry := '----------sZLbqiVRVfOO8NjlMuYJE3'; { Specified in Multipart/form-data RFC }
                  ContentTypePost := UTF8Encode('multipart/form-data; boundary=' + Copy(Boundry, 3, length(boundry)));
                  Buf := UTF8Encode(Boundry + RN + 'Content-Disposition: form-data; name="file"; filename="' +
                    FileSizePanel.Hint + '"' + RN + 'Content-Type: image/jpeg' + RN + RN);
                  //--���������� ���������� � ������
                  SendStream.Write(Buf[1], Length(Buf));
                  //--������ ���� ������ ��� �����
                  try
                    FileToSend := TMemoryStream.Create;
                    FileToSend.LoadFromFile(FileNamePanel.Hint);
                    FileToSend.SaveToStream(SendStream);
                  finally
                    FileToSend.Free;
                  end;
                  //--���������� ���������� �������� �����
                  Buf := UTF8Encode(RN + Boundry + RN + 'Content-Disposition: form-data; name="desc"' +
                    RN + RN + DescEdit.Text + RN + Boundry + RN +
                    'Content-Disposition: form-data; name="password"' + RN + RN +
                    PassEdit.Text + RN + Boundry + RN + 'Content-Disposition: form-data; name="send"' +
                    RN + RN + '���������!' + RN + Boundry + '--' + RN);
                  SendStream.Write(Buf[1], Length(Buf));
                  SendStream.Seek(0, soFromBeginning);
                  //--���������� ������ �� ������
                  OnSessionClosed := nil;
                  Abort;
                  OnSessionClosed := SendFileHttpClientSessionClosed;
                  SendFileHttpClient.Tag := 1;
                  PostAsync;
                end;
              end;
            1:
              begin
                //--��������� ������ ������ ��������
                CancelBitBtnClick(nil);
                //--���� ���������� �� �������� ������� ����� �� ������
                if BMSearch(0, Doc, '���� ��������') > -1 then
                begin
                  BottomInfoPanel.Caption := FileTransfer3L;
                  OKURL := UpWapRootURL + IsolateTextString(Doc, 'action="', '"');
                  //--��������� ����� �� �������
                  case Tag of
                    1: OKURL := Format(FileTransfer5L, [FileSizePanel.Hint, OKURL, 'upwap.ru', 'http://upwap.ru']);
                  end;
                  //--���� ����� ������� � �������
                  RosterItem := RosterForm.ReqRosterItem(TopInfoPanel.Hint);
                  if RosterItem <> nil then
                  begin
                    //--�������� �������� ������ � ���������� ��� � ������� ���������
                    if RosterItem.SubItems[3] = 'Icq' then
                    begin
                      if ICQ_Work_Phaze then
                      begin
                        if (RosterItem.SubItems[6] <> '9') and (RosterItem.SubItems[33] = 'X') then ICQ_SendMessage_0406(RosterItem.Caption, OKURL, false)
                        else ICQ_SendMessage_0406(RosterItem.Caption, OKURL, true);
                        SendYES := true;
                      end;
                    end
                    else if RosterItem.SubItems[3] = 'Jabber' then
                    begin

                    end
                    else if RosterItem.SubItems[3] = 'Mra' then
                    begin

                    end;
                    //--��������� � �������
                    if SendYES then
                    begin
                      CheckMessage_BR(OKURL);
                      DecorateURL(OKURL);
                      RosterItem.SubItems[13] := RosterItem.SubItems[13] +
                        '<span class=a>' + YouAt + ' [' + DateTimeChatMess + ']' +
                        '</span><br><span class=c>' + OKURL + '</span><br><br>' + RN;
                    end;
                  end;
                end;
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

procedure TFileTransferForm.SendFileHttpClientSendData(Sender: TObject;
  Buffer: Pointer; Len: Integer);
begin
  //--���� ���������� ��������, �� ������������� �����
  if SendFileHttpClient.Tag = 2 then
  begin
    SendFileHttpClient.CloseAsync;
    SendFileHttpClient.Abort;
  end;
  //--���������� ������� �������� �����
  SendProgressBar.Max := SendFileHttpClient.SendStream.Size;
  SendProgressBar.Position := SendFileHttpClient.SentCount;
  //--��������� ����� � �������� ����� ������ ���������
  Update;
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
    BottomInfoPanel.Caption := ErrorHttpClient(SendFileHttpClient.StatusCode);
  end;
end;

procedure TFileTransferForm.CancelBitBtnClick(Sender: TObject);
begin
  //--��������� ������
  CancelBitBtn.Enabled := false;
  //--������������� �������� �����
  SendFileHttpClient.Tag := 2;
  SendFileHttpClient.Abort;
  //--������������ �������� �������� � ������
  DescEdit.Enabled := true;
  DescEdit.Color := clWindow;
  PassEdit.Enabled := true;
  PassEdit.Color := clWindow;
  if Sender <> nil then
  begin
    BottomInfoPanel.Caption := FileTransfer4L;
    SendFileButton.Enabled := true;
  end;
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
    //--������������ ������
    if SendFileHttpClient.SendStream <> nil then
    begin
      SendFileHttpClient.SendStream.Free;
      SendFileHttpClient.SendStream := nil;
    end;
    //--���������� �����
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
  MainForm.AllImageList.GetBitmap(139, CancelBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(3, CloseBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(166, SendFileButton.Glyph);
  //--������ ���� ����������� � �������� ��� ������ �� ������ �����
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFileTransferForm.TranslateForm;
begin
  //--��������� ���� �� ������ �����

end;

end.

