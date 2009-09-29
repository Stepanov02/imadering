unit TrafficUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TTrafficForm = class(TForm)
    TrafGroupBox: TGroupBox;
    ResetCurTrafButton: TButton;
    ResetAllTrafButton: TButton;
    CurTrafEdit: TEdit;
    AllTrafEdit: TEdit;
    CurTrafLabel: TLabel;
    AllTrafLabel: TLabel;
    CloseBitBtn: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetCurTrafButtonClick(Sender: TObject);
    procedure ResetAllTrafButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrafficForm: TTrafficForm;

implementation

{$R *.dfm}

uses
  MainUnit, VarsUnit;

procedure TTrafficForm.CloseBitBtnClick(Sender: TObject);
begin
  //--��������� ����
  Close;
end;

procedure TTrafficForm.ResetCurTrafButtonClick(Sender: TObject);
begin
  //--�������� ������� ������
  TrafSend := 0;
  TrafRecev := 0;
  SesDataTraf := now;
  //--���������� ������� ������� �������� �� ��� ������
  CurTrafEdit.Text := FloatToStrF(TrafRecev / 1000, ffFixed, 18, 3) + ' KB | ' +
    FloatToStrF(TrafSend / 1000, ffFixed, 18, 3) + ' KB | ' + DateTimeToStr(SesDataTraf);
end;

procedure TTrafficForm.ResetAllTrafButtonClick(Sender: TObject);
begin
  //--�������� ����� ������
  AllTrafSend := 0;
  AllTrafRecev := 0;
  AllSesDataTraf := DateTimeToStr(now);
  //--���������� ������� ������� �������� �����
  AllTrafEdit.Text := FloatToStrF(AllTrafRecev / 1000000, ffFixed, 18, 3) + ' MB | ' +
    FloatToStrF(AllTrafSend / 1000000, ffFixed, 18, 3) + ' MB | ' + AllSesDataTraf;
end;

procedure TTrafficForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--��������� ��� ����� ������ ������������ ����� ��������
  Action := caFree;
  TrafficForm := nil;
end;

procedure TTrafficForm.FormCreate(Sender: TObject);
begin
  //--����������� ������ ���� � ������
  MainForm.AllImageList.GetIcon(226, Icon);
  MainForm.AllImageList.GetBitmap(3, CloseBitBtn.Glyph);
end;

end.
