unit ShowCertUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OverbyteIcsWSocket, Buttons;

const
  AcceptedCertsFile = 'Profile\AcceptedCerts.txt';

type
  /// <summary>������������� ����������. ������������ ����� ���  ������� ��� ����������</summary>
  TShowCertForm = class(TForm)
    AcceptCertButton: TBitBtn;
    RefuseCertButton: TBitBtn;
    CertGroupBox: TGroupBox;
    BottomPanel: TPanel;
    LblIssuer: TLabel;
    LblSubject: TLabel;
    LblSerial: TLabel;
    lblValidAfter: TLabel;
    LblValidBefore: TLabel;
    LblShaHash: TLabel;
    LblCertExpired: TLabel;
    LblIssuerMemo: TMemo;
    procedure AcceptCertButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCertAccepted: Boolean;
    FAcceptedCertsList: TStringList;
    FCertHash: string;
    procedure SaveAcceptedCertsList;
    procedure LoadAcceptedCertsList;
  public
    ///  <summary>������ �� ������������ ����������</summary>
    property CertAccepted: boolean read FCertAccepted default false;
    ///  <summary>���������, ����� ���� ���������� ��� ���������</summary>
    function CheckAccepted(Hash: string): boolean;

{$WARNINGS OFF}

    /// <param name="Cert">����������, ���������� � ������� ����� ����������</param>
    constructor Create(const Cert: TX509Base);
    destructor Destory(); override;
  end;

{$WARNINGS ON}

implementation

uses MainUnit, EncdDecd, UnitLogger, VarsUnit, UnitCrypto;

{$R *.dfm}

procedure TShowCertForm.AcceptCertButtonClick(Sender: TObject);
begin
  //--��������� � ��������� � ���� ����������
  try
    FAcceptedCertsList.Add(FCertHash);
    SaveAcceptedCertsList;
    FCertAccepted := true;
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(e);
  end;
  //--��������� ��������� ����
  ModalResult := mrOk;
end;

function TShowCertForm.CheckAccepted(Hash: string): boolean;
begin
  Result := false;
  if FAcceptedCertsList <> nil then 
  begin
    if FAcceptedCertsList.IndexOf(hash) >= 0 then 
      Result := true;
  end;
end;
    
destructor TShowCertForm.Destory(); override;
    
begin
  if FAcceptedCertsList <> nil then begin
    SaveAcceptedCertsList;
    FreeAndNil(FAcceptedCertsList);
  end;
    
  inherited Destory();
end;

constructor TShowCertForm.Create(const Cert: TX509Base);
begin
  inherited Create(nil);
  FAcceptedCertsList := TStringList.Create;
  LoadAcceptedCertsList;
  //--��������� ���� �����
  with Cert do
  begin
    FCertHash := EncodeString(Sha1Hash);
    LblIssuerMemo.Text := IssuerOneLine;
    LblSubject.Caption := LblSubject.Caption + SubjectCName;
    LblSerial.Caption := LblSerial.Caption + IntToStr(SerialNum);
    lblValidAfter.Caption := lblValidAfter.Caption + DateToStr(ValidNotAfter);
    LblValidBefore.Caption := LblValidBefore.Caption + DateToStr(ValidNotBefore);
    LblShaHash.Caption := LblShaHash.Caption + FCerthash;
    LblCertExpired.Visible := HasExpired;
  end;
end;

procedure TShowCertForm.FormCreate(Sender: TObject);
begin
  //--����������� ������ ���� � ������
  MainForm.AllImageList.GetIcon(173, Icon);
  MainForm.AllImageList.GetBitmap(139, RefuseCertButton.Glyph);
  MainForm.AllImageList.GetBitmap(140, AcceptCertButton.Glyph);
end;

procedure TShowCertForm.LoadAcceptedCertsList;
var
  EncryptedDataStream: TFileStream;
  DecryptedDataStream: TStream;
begin
  
  if not FileExists(ProfilePath + AcceptedCertsFile) then 
    Exit;
  
  try
    EncryptedDataStream := TFileStream.Create(ProfilePath + AcceptedCertsFile, fmOpenRead);
    try
      //--��������������
      DecryptedDataStream := DecryptStream(EncryptedDataStream, UnitCrypto.PasswordByMac);
      try
        FAcceptedCertsList.LoadFromStream(DecryptedDataStream);
      finally
        FreeAndNil(DecryptedDataStream);
      end;
    finally
      FreeAndNil(EncryptedDataStream);
    end;
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(e);
  end;

end;
  
procedure TShowCertForm.SaveAcceptedCertsList;
var
  EncryptedFileStream: TFileStream;
  DecryptedDataStream: TMemoryStream;
  EncryptedDataStream: TStream;
begin
  //--��������� ������ �������� ������������ � ����
  try
    DecryptedDataStream := TMemoryStream.Create;
    try
      EncryptedDataStream := TMemoryStream.Create;
      try
        FAcceptedCertsList.SaveToStream(DecryptedDataStream);
        //--�������
        EncryptedDataStream := EncryptStream(DecryptedDataStream, UnitCrypto.PasswordByMac);
        //--���� ��� ���� �����-�� ���� ������, �� ������� ���
        if FileExists(ProfilePath + AcceptedCertsFile) then
          DeleteFile(ProfilePath + AcceptedCertsFile);
        //--������ ����� �������
        if not DirectoryExists(ExtractFilePath(ProfilePath + AcceptedCertsFile)) then
          ForceDirectories(ProfilePath + AcceptedCertsFile);
        //--���������� � ���� �� ������
        EncryptedFileStream := TFileStream.Create(ProfilePath + AcceptedCertsFile, fmCreate);
        try
          EncryptedFileStream.CopyFrom(EncryptedDataStream, EncryptedDataStream.Size);
        finally
          FreeAndNil(EncryptedFileStream);
        end;
      finally
        FreeAndNil(EncryptedDataStream);
      end;
    finally
      FreeAndNil(DecryptedDataStream);
    end;
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(e);
  end;
end;

end.

