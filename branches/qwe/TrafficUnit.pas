unit TrafficUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TTrafficForm = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

procedure TTrafficForm.BitBtn1Click(Sender: TObject);
begin
  //--��������� ����
  Close;
end;

procedure TTrafficForm.Button1Click(Sender: TObject);
begin
  //--�������� ������� ������
  TrafSend := 0;
  TrafRecev := 0;
  SesDataTraf := now;
  //--���������� ������� ������� �������� �� ��� ������
  Edit1.Text := FloatToStrF(TrafRecev / 1000, ffFixed, 18, 3) + ' �� | ' +
    FloatToStrF(TrafSend / 1000, ffFixed, 18, 3) + ' �� | ' + DateTimeToStr(SesDataTraf);
end;

procedure TTrafficForm.Button2Click(Sender: TObject);
begin
  //--�������� ����� ������
  AllTrafSend := 0;
  AllTrafRecev := 0;
  AllSesDataTraf := DateTimeToStr(now);
  //--���������� ������� ������� �������� �����
  Edit2.Text := FloatToStrF(AllTrafRecev / 1000000, ffFixed, 18, 3) + ' �� | ' +
    FloatToStrF(AllTrafSend / 1000000, ffFixed, 18, 3) + ' �� | ' + AllSesDataTraf;
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
  MainForm.AllImageList.GetBitmap(3, BitBtn1.Glyph);
end;

end.
