unit UpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, OverbyteIcsWndControl,
  OverbyteIcsHttpProt, SimpleXML, OverbyteIcsWSocket, JvTimerList, Code,
  JvZLibMultiple;

type
  TUpdateForm = class(TForm)
    StartBitBtn: TBitBtn;
    AbortBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    DownloadProgressBar: TProgressBar;
    SubHttpClient: THttpCli;
    DownloadHttpClient: THttpCli;
    UpJvTimerList: TJvTimerList;
    LoadSizeLabel: TLabel;
    InfoMemo: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure UpJvTimerListEvents0Timer(Sender: TObject);
    procedure SubHttpClientDocBegin(Sender: TObject);
    procedure SubHttpClientDocEnd(Sender: TObject);
    procedure UpJvTimerListEvents1Timer(Sender: TObject);
    procedure DownloadHttpClientDocBegin(Sender: TObject);
    procedure DownloadHttpClientDocEnd(Sender: TObject);
    procedure AbortBitBtnClick(Sender: TObject);
    procedure StartBitBtnClick(Sender: TObject);
    procedure DownloadHttpClientDocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure SubHttpClientDocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure SubHttpClientSessionClosed(Sender: TObject);
    procedure UpJvTimerListEvents2Timer(Sender: TObject);
    procedure DownloadHttpClientSessionClosed(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    GetM: boolean;
    UpdateFile: TMemoryStream;
    AbortUpdate: boolean;
    procedure UnZip(FileName: TStream; SDir: string);
  public
    { Public declarations }
  end;

var
  UpdateForm: TUpdateForm;

implementation

{$R *.dfm}

uses
  MainUnit, UtilsUnit, VarsUnit;

procedure TUpdateForm.AbortBitBtnClick(Sender: TObject);
begin
  //--���������� ����� �� ��������� ������ � ������
  AbortUpdate := true;
  //--��������� HTTP �����
  if DownloadHttpClient.State <> httpNotConnected then DownloadHttpClient.Abort;
  //--��������� HTTP �����
  if SubHttpClient.State <> httpNotConnected then SubHttpClient.Abort;
  //--���������� ������ ����������� �������
  StartBitBtn.Enabled := true;
  //--������������ ������ ��������
  AbortBitBtn.Enabled := false;
end;

procedure TUpdateForm.CloseBitBtnClick(Sender: TObject);
begin
  //--��������� ���������
  Close;
end;

procedure TUpdateForm.DownloadHttpClientDocBegin(Sender: TObject);
begin
  //--������ ���� ������ ��� ����� http ������
  DownloadHttpClient.RcvdStream := TMemoryStream.Create;
end;

procedure TUpdateForm.DownloadHttpClientDocData(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
  //--���� ��� ����������� ����� ������, �� ������� � ��������� �����
  if AbortUpdate then if DownloadHttpClient.State <> httpNotConnected then DownloadHttpClient.Abort;
  //--���������� ������� ��������� ������
  if DownloadHttpClient.ContentLength > -1 then
  begin
    LoadSizeLabel.Caption := '�������: ' + FloatToStrF(DownloadHttpClient.RcvdCount / 1000, ffFixed, 7, 1) + ' ��';
    DownloadProgressBar.Max := DownloadHttpClient.ContentLength;
    DownloadProgressBar.Position := DownloadHttpClient.RcvdCount;
  end;
  //--��������� ����� � �������� ����� ������ ���������
  Update;
end;

procedure TUpdateForm.DownloadHttpClientDocEnd(Sender: TObject);
label
  x;
begin
  //--������ ���������� http ������ �� ����� ������
  if DownloadHttpClient.RcvdStream <> nil then
  begin
    //--���� ��� ����������� ����� ������, �� ������� � ������������ ������
    if AbortUpdate then goto x;
    try
      //--�������� ������� ������ ������ � ����� ������
      DownloadHttpClient.RcvdStream.Position := 0;
      //--������ ������ � ����
      UpdateFile.LoadFromStream(DownloadHttpClient.RcvdStream);
      //--����������� � �������� ������� ����� ����������
      InfoMemo.Lines.Add('���� ���������� ������� �������.');
      InfoMemo.Lines.Add('��������� ����������...');
      //--��������������� ���� Imadering.exe
      if FileExists(MyPath + 'Imadering.exe') then
        RenameFile(MyPath + 'Imadering.exe', MyPath + 'Imadering.old');
      //--��������������� ���� Update.exe
      if FileExists(MyPath + 'Update.exe') then
        RenameFile(MyPath + 'Update.exe', MyPath + 'Update.old');
      //--��������� ������ ���������� ������ � �����������
      UpJvTimerList.Events[2].Enabled := true;
    except
    end;
    x: ;
    //--������������ ���� ������
    DownloadHttpClient.RcvdStream.Free;
    DownloadHttpClient.RcvdStream := nil;
  end;
end;

procedure TUpdateForm.DownloadHttpClientSessionClosed(Sender: TObject);
begin
  //--�������� � ���������� ����������
  //InfoMemo.Lines.Add('����������� ���������.');
end;

procedure TUpdateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--��������� HTTP �����
  if DownloadHttpClient.State <> httpNotConnected then DownloadHttpClient.Abort;
  //--��������� HTTP �����
  if SubHttpClient.State <> httpNotConnected then SubHttpClient.Abort;
  //--������������ ���� ������
  FreeAndNil(UpdateFile);
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
  //--��������� ������ ��������� ����� ������
  UpJvTimerList.Events[0].Enabled := true;
  //--������������ ������ ����������� �������
  StartBitBtn.Enabled := false;
  //--���������� ������ ��������
  AbortBitBtn.Enabled := true;
  //--����������� ����� �� ��������� ������ � ������
  AbortUpdate := false;
  //--��������� � ���� ������
  InfoMemo.Lines.Add('');
end;

procedure TUpdateForm.SubHttpClientDocBegin(Sender: TObject);
begin
  //--������ ���� ������ ��� ����� http ������
  SubHttpClient.RcvdStream := TMemoryStream.Create;
end;

procedure TUpdateForm.SubHttpClientDocData(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
  //--���������� ������� ��������� ������
  if SubHttpClient.ContentLength > -1 then
  begin
    LoadSizeLabel.Caption := '�������: ' + FloatToStrF(SubHttpClient.RcvdCount / 1000, ffFixed, 7, 1) + ' ��';
    DownloadProgressBar.Max := SubHttpClient.ContentLength;
    DownloadProgressBar.Position := SubHttpClient.RcvdCount;
  end;
  //--��������� ����� � �������� ����� ������ ���������
  Update;
end;

procedure TUpdateForm.SubHttpClientDocEnd(Sender: TObject);
label
  x;
var
  list: TStringList;
begin
  //--������ ���������� http ������ �� ����� ������
  if SubHttpClient.RcvdStream <> nil then
  begin
    //--���� ��� ����������� ����� ������, �� ������� � ������������ ������
    if AbortUpdate then goto x;
    //--���� ������ ��� �������� ������� ������
    if not GetM then
    begin
      {//--������ ��������� ����
      list := TStringList.Create;
      try
        try
          //--�������� ������� ������ ������ � ����� ������
          SubHttpClient.RcvdStream.Position := 0;
          //--������ ������ � ����
          list.LoadFromStream(SubHttpClient.RcvdStream);
          //--��������� ������ � �����
          if list.Text > '' then
          begin
            ver := IsolateTextString(list.Text, '<v>', '</v>');
            bild := IsolateTextString(list.Text, '<b>', '</b>');
            //--��������� ���� �������� �� ����������
            if (ver = '') or (bild = '') then InfoMemo.Lines.Add('������: ���������� �� ��������.')
            else
            begin
              //--������� ���������� � ������ ����������
              InfoMemo.Lines.Add('������: ' + ver);
              InfoMemo.Lines.Add('������: ' + bild);
              //--��������� ������� ����� ����������
              UpJvTimerList.Events[1].Enabled := true;
            end;
          end;
        except
        end;
      finally
        list.Free;
      end;}
    end;
    x: ;
    //--������������ ���� ������
    SubHttpClient.RcvdStream.Free;
    SubHttpClient.RcvdStream := nil;
  end;
end;

procedure TUpdateForm.UpJvTimerListEvents0Timer(Sender: TObject);
begin
  //--��������� �������� ���������� ��������� �� �����
  try
    SubHttpClient.URL := 'http://imadering.com/version.txt';
    SubHttpClient.GetASync;
  except
    on E: Exception do
      //--���� ��� ����������� ��������� ������, �� �������� �� ����
      InfoMemo.Lines.Add(E.Message);
  end;
end;

procedure TUpdateForm.UpJvTimerListEvents1Timer(Sender: TObject);
begin
  //--�������� ���������� ���������
  LoadSizeLabel.Caption := '�������: 0 ��';
  DownloadProgressBar.Position := 0;
  //--������� ���������� � ������ ������� ���������
  InfoMemo.Lines.Add('�������� ����������...');
  //--��������� ������� ����� ���������� � �����
  try
    //DownloadHttpClient.URL := 'http://imadering.com/Update_' + ver + '_' + bild + '.z';
    //DownloadHttpClient.GetASync;
  except
    on E: Exception do
      //--���� ��� ����������� ��������� ������, �� �������� �� ����
      InfoMemo.Lines.Add(E.Message);
  end;
end;

procedure TUpdateForm.UnZip(FileName: TStream; SDir: string);
var
  z: TJvZlibMultiple;
begin
  //--������������� ���� � ��������� ����������
  z := TJvZlibMultiple.Create(nil);
  try
    z.DecompressStream(FileName, SDir, true);
  finally
    z.Free;
    //--�������� � ���������� ����������
    InfoMemo.Lines.Add('��������� ���������� ���������.');
    InfoMemo.Lines.Add(' ');
    InfoMemo.Lines.Add('��� ���������� ���������� ���������� ������������� ��������� IMadering!');
  end;
end;

procedure TUpdateForm.UpJvTimerListEvents2Timer(Sender: TObject);
begin
  //--������������� ���� � ����������� � ����� Imadering (�������)
  UnZip(UpdateFile, MyPath);
end;

procedure TUpdateForm.SubHttpClientSessionClosed(Sender: TObject);
begin
  //--�������� � ���������� ����������
  //InfoMemo.Lines.Add('����������� ���������.');
end;

end.

