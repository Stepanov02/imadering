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
    procedure FormCreate(Sender: TObject);
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
  private
    { Private declarations }
    ver: string;
    bild: string;
    MyPath: string;
    ProxyAddresEdit: string;
    ProxyPortEdit: string;
    ProxyTypeComboBox: integer;
    ProxyVersionComboBox: integer;
    ProxyAuthCheckBox: boolean;
    ProxyLoginEdit: string;
    ProxyPasswordEdit: string;
    NTLMCheckBox: boolean;
    ProxyEnableCheckBox: boolean;
    GetM: boolean;
    UpdateFile: TMemoryStream;
    AbortUpdate: boolean;
    procedure ProxyEnableCheckBoxClick(HttpClient: THttpCli);
    procedure UnZip(FileName: TStream; SDir: string);
  public
    { Public declarations }
  end;

var
  UpdateForm: TUpdateForm;

implementation

{$R *.dfm}

function IsolateTextString(const S: string; Tag1, Tag2: string): string;
var
  pScan, pEnd, pTag1, pTag2: PChar;
  foundText: string;
  searchtext: string;
begin
  Result := '';
  searchtext := Uppercase(S);
  Tag1 := Uppercase(Tag1);
  Tag2 := Uppercase(Tag2);
  pTag1 := PChar(Tag1);
  pTag2 := PChar(Tag2);
  pScan := PChar(searchtext);
  repeat
    pScan := StrPos(pScan, pTag1);
    if pScan <> nil then
    begin
      Inc(pScan, Length(Tag1));
      pEnd := StrPos(pScan, pTag2);
      if pEnd <> nil then
      begin
        SetString(foundText,
          Pchar(S) + (pScan - PChar(searchtext)),
          pEnd - pScan);
        Result := foundText;
        pScan := pEnd + Length(tag2);
      end
      else
        pScan := nil;
    end;
  until pScan = nil;
end;

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
var
  Xml: IXmlDocument;
  XmlElem: IXmlNode;
begin
  //--����� ���� ������ �������� ���������
  MyPath := ExtractFilePath(Application.ExeName);
  //--���� ��������� ������ � ���������� ����� ��������� ��
  if FileExists(MyPath + 'Profile\Proxy.xml') then
  begin
    try
      Xml := CreateXmlDocument;
      Xml.Load(MyPath + 'Profile\Proxy.xml');
      //--��������� ����� ������
      XmlElem := Xml.DocumentElement.SelectSingleNode('proxy');
      if XmlElem <> nil then
      begin
        //--��������� ��������� ������
        if XmlElem.ChildNodes.Count > 0 then
        begin
          ProxyAddresEdit := XmlElem.ChildNodes.Item[0].GetAttr('name');
          ProxyPortEdit := XmlElem.ChildNodes.Item[0].GetAttr('port');
          ProxyTypeComboBox := XmlElem.ChildNodes.Item[1].GetIntAttr('type-index');
          ProxyVersionComboBox := XmlElem.ChildNodes.Item[1].GetIntAttr('version-index');
          ProxyAuthCheckBox := XmlElem.ChildNodes.Item[2].GetBoolAttr('proxy-auth-enable');
          ProxyLoginEdit := XmlElem.ChildNodes.Item[2].GetAttr('proxy-login');
          ProxyPasswordEdit := XmlElem.ChildNodes.Item[2].GetAttr('proxy-password');
          NTLMCheckBox := XmlElem.ChildNodes.Item[2].GetBoolAttr('proxy-ntlm-auth');
        end;
        ProxyEnableCheckBox := XmlElem.GetBoolAttr('proxy-enable');
        //--��������� ��������� ������ ��� ����� http �������
        ProxyEnableCheckBoxClick(DownloadHttpClient);
        ProxyEnableCheckBoxClick(SubHttpClient);
      end;
    except
    end;
  end;
  //--�������� � ������ ����������
  InfoMemo.Lines.Add('������ ���������� ��� ����������...');
  //--������ ���� � ������ ��� ����� ����� ����������
  UpdateFile := TMemoryStream.Create;
  //--������� ������ ���� Update.exe
  if FileExists(MyPath + 'Update.old') then DeleteFile(MyPath + 'Update.old');
  //--��������� ������ ��������� ����� ������
  UpJvTimerList.Events[0].Enabled := true;
end;

procedure TUpdateForm.ProxyEnableCheckBoxClick(HttpClient: THttpCli);
var
  RequestVerProxy: string;
begin
  with HttpClient do
  begin
    //--��������� ��������� ������
    if ProxyEnableCheckBox then
    begin
      //--������ �������
      case ProxyVersionComboBox of
        0: RequestVerProxy := '1.0';
        1: RequestVerProxy := '1.1';
      end;
      RequestVer := RequestVerProxy;
      //--HTTP � HTTPS ��� ������
      if (ProxyTypeComboBox = 0) or (ProxyTypeComboBox = 1) then
      begin
        //--���������� ��� SOCKS ������
        SocksLevel := '';
        //--���������� ����� SOCKS ������ � ����
        SocksServer := '';
        SocksPort := '';
        //--���������� ����������� SOCKS ������
        SocksAuthentication := socksNoAuthentication;
        SocksUsercode := '';
        SocksPassword := '';
        //--��������� ����� HTTP ������ � ����
        Proxy := ProxyAddresEdit;
        ProxyPort := ProxyPortEdit;
        //--��������� ����������� �� HTTP ������
        if ProxyAuthCheckBox then
        begin
          ProxyAuth := httpAuthBasic;
          if NTLMCheckBox then ProxyAuth := httpAuthNtlm;
          ProxyUsername := ProxyLoginEdit;
          ProxyPassword := ProxyPasswordEdit;
        end
        else
        begin
          //--���������� ����������� HTTP ������
          ProxyAuth := httpAuthNone;
          ProxyUsername := '';
          ProxyPassword := '';
        end;
      end
      else
      begin
        //--���������� ����� HTTP ������ � ����
        Proxy := '';
        ProxyPort := '80';
        //--���������� ����������� HTTP ������
        ProxyAuth := httpAuthNone;
        ProxyUsername := '';
        ProxyPassword := '';
        //--SOCKS4, SOCKS4A � SOCKS5 ��� ������
        case ProxyTypeComboBox of
          2: SocksLevel := '4';
          3: SocksLevel := '4A';
          4: SocksLevel := '5';
        end;
        //--��������� ����� SOCKS ������ � ����
        SocksServer := ProxyAddresEdit;
        SocksPort := ProxyPortEdit;
        //--��������� ����������� �� SOCKS ������
        if ProxyAuthCheckBox then
        begin
          SocksAuthentication := socksAuthenticateUsercode;
          SocksUsercode := ProxyLoginEdit;
          SocksPassword := ProxyPasswordEdit;
        end
        else
        begin
          //--���������� ����������� SOCKS ������
          SocksAuthentication := socksNoAuthentication;
          SocksUsercode := '';
          SocksPassword := '';
        end;
      end;
    end
    else
    begin
      //--���������� ������ ��������
      RequestVer := '1.0';
      //--���������� ����� HTTP ������ � ����
      Proxy := '';
      ProxyPort := '80';
      //--���������� ����������� HTTP ������
      ProxyAuth := httpAuthNone;
      ProxyUsername := '';
      ProxyPassword := '';
      //--���������� ��� SOCKS ������
      SocksLevel := '';
      //--���������� ����� SOCKS ������ � ����
      SocksServer := '';
      SocksPort := '';
      //--���������� ����������� SOCKS ������
      SocksAuthentication := socksNoAuthentication;
      SocksUsercode := '';
      SocksPassword := '';
    end;
  end;
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
      //--������ ��������� ����
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
      end;
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
    DownloadHttpClient.URL := 'http://imadering.com/Update_' + ver + '_' + bild + '.z';
    DownloadHttpClient.GetASync;
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

