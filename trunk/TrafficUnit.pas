﻿{ *******************************************************************************
  Copyright (c) 2004-2010 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
  ******************************************************************************* }

unit TrafficUnit;

interface

{$REGION 'Uses'}

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons;

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
    procedure FormDblClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure TranslateForm;
  end;

{$ENDREGION}

var
  TrafficForm: TTrafficForm;

implementation

{$R *.dfm}
{$REGION 'MyUses'}

uses
  MainUnit,
  VarsUnit,
  UtilsUnit;

{$ENDREGION}
{$REGION 'TranslateForm'}

procedure TTrafficForm.TranslateForm;
begin
  // Создаём шаблон для перевода
  // CreateLang(Self);
  // Применяем язык
  SetLang(Self);
  // Другое
  CloseBitBtn.Caption := S_Close;
  ResetAllTrafButton.Caption := ResetCurTrafButton.Caption;
end;

{$ENDREGION}
{$REGION 'Reset'}

procedure TTrafficForm.ResetCurTrafButtonClick(Sender: TObject);
begin
  // Обнуляем текущий трафик
  TrafSend := 0;
  TrafRecev := 0;
  SesDataTraf := Now;
  // Показываем сколько трафика передано за эту сессию
  CurTrafEdit.Text := FloatToStrF(TrafRecev / 1000, FfFixed, 18, 3) + ' KB | ' + FloatToStrF(TrafSend / 1000, FfFixed, 18, 3) + ' KB | ' + DateTimeToStr(SesDataTraf);
end;

procedure TTrafficForm.ResetAllTrafButtonClick(Sender: TObject);
begin
  // Обнуляем общий трафик
  AllTrafSend := 0;
  AllTrafRecev := 0;
  AllSesDataTraf := DateTimeToStr(Now);
  // Показываем сколько трафика передано всего
  AllTrafEdit.Text := FloatToStrF(AllTrafRecev / 1000000, FfFixed, 18, 3) + ' MB | ' + FloatToStrF(AllTrafSend / 1000000, FfFixed, 18, 3) + ' MB | ' + AllSesDataTraf;
end;

{$ENDREGION}
{$REGION 'Other'}

procedure TTrafficForm.CloseBitBtnClick(Sender: TObject);
begin
  // Закрываем окно
  Close;
end;

procedure TTrafficForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Указываем что форма должна уничтожиться после закрытия
  Action := CaFree;
  TrafficForm := nil;
end;

procedure TTrafficForm.FormDblClick(Sender: TObject);
begin
  // Устанавливаем перевод
  TranslateForm;
end;

{$ENDREGION}
{$REGION 'FormCreate'}

procedure TTrafficForm.FormCreate(Sender: TObject);
begin
  // Переводим форму на язык
  TranslateForm;
  // Присваиваем иконку окну и кнопке
  MainForm.AllImageList.GetIcon(226, Icon);
  MainForm.AllImageList.GetBitmap(3, CloseBitBtn.Glyph);
end;

{$ENDREGION}

end.
