﻿{ *******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
  ******************************************************************************* }

unit IcqContactInfoUnit;

interface

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
  Buttons,
  ExtCtrls,
  Htmlview,
  ShellApi,
  StrUtils,
  VarsUnit,
  RXML;

type
  TIcqContactInfoForm = class(TForm)
    ReqInfoBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    BottomHTMLViewer: THTMLViewer;
    InfoLabel: TLabel;
    AvatarImage: TImage;
    TopHTMLViewer: THTMLViewer;
    HoroImage: TImage;
    Bevel1: TBevel;
    procedure OKBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReqInfoBitBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
    procedure AddHTML(const ToWhere: THTMLViewer; Text: string; TextClass: string = 'cdef'; InsertBR: Boolean = False;
      StupidInsert: Boolean = False; ClearIt: Boolean = False);
    procedure CreateSummery;

  public
    { Public declarations }
    ReqUIN: string;
    ReqProto: string;
    procedure TranslateForm;
    procedure LoadUserUnfo;
  end;

var
  IcqContactInfoForm: TIcqContactInfoForm;

const
  DetailsCSS: string = '<style type="text/css">' + 'body, span { color: #000000; font: 12px tahoma, verdana; }' +
    'hr { margin: 5px; border: none; color: gray; background-color: gray; height: 1px; }' + '.cbold { font: bold 12px tahoma, verdana; }' +
    '.cdef { font: 12px tahoma, verdana; }' + '.cmargin { font: 11px tahoma, verdana; margin: 10px; }' + '</style>';

implementation

{$R *.dfm}

uses
  MainUnit,
  IcqProtoUnit,
  UtilsUnit,
  IcqOptionsUnit,
  OverbyteIcsMimeUtils;

procedure TIcqContactInfoForm.TranslateForm;
begin
  // Переводим форму на другие языки

end;

procedure TIcqContactInfoForm.AddHTML(const ToWhere: THTMLViewer; Text: string; TextClass: string = 'cdef'; InsertBR: Boolean = False;
  StupidInsert: Boolean = False; ClearIt: Boolean = False);
var
  Doc: string;
begin
  Doc := ToWhere.DocumentSource;
  if StupidInsert then
    Doc := Doc + Text
  else
    Doc := Doc + '<span class="' + TextClass + '">' + Text + '</span>';
  if InsertBR then
    Doc := Doc + '<br>';
  if ClearIt then
    Doc := Text;
  ToWhere.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
end;

procedure TIcqContactInfoForm.LoadUserUnfo;
var
  Doc: string;
begin
  // Устанавливаем заголовок окна
  Caption := InfoCaptionL + ': ' + ReqUIN;
  // Стираем отображение предыдущей инфы
  TopHTMLViewer.Clear;
  BottomHTMLViewer.Clear;
  Doc := EmptyStr;
  TopHTMLViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
  BottomHTMLViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
  // Ищем локально файл с информацией
  if FileExists(ProfilePath + AnketaFileName + ReqProto + '_' + ReqUIN + '.xml') then
    begin
      InfoLabel.Caption := InfoOKL;
      // Запускаем создание суммарного инфо из распакованного файла
      CreateSummery;
    end
    // Если файл с инфой не нашли, то запрашиваем её и ожидаем получения
  else
    begin
      if ICQ_Work_Phaze then
        begin
          InfoLabel.Caption := InfoReqL;
          ICQ_ReqInfo_New_Pkt(ReqUIN);
        end;
      // Добавляем стили
      AddHTML(TopHTMLViewer, '<html><head>' + DetailsCSS + '<title>Details</title></head><body>', EmptyStr, False, False, True);
      // Учётная запись контакта
      if ReqProto = 'Icq' then
        AddHTML(TopHTMLViewer, ICQAccountInfo + ' ' + ReqUIN, 'cbold')
      else if ReqProto = 'Jabber' then
        AddHTML(TopHTMLViewer, JabberAccountInfo + ' ' + ReqUIN, 'cbold');
      AddHTML(TopHTMLViewer, '<hr>', EmptyStr, False, True);
      // Очищаем картинку гороскопа
      HoroImage.Picture.Assign(nil);
      // Загружаем аватар
      AvatarImage.Picture.LoadFromFile(MyPath + 'Icons\' + CurrentIcons + '\noavatar.gif');
    end;
end;

procedure TIcqContactInfoForm.CreateSummery;
var
  Nick, First, Last, Age, IDay, IMonth, IYear: string;
  Email1, Email2, Email3, OCity, OState, Gender: string;
  Address, City, State, Zip, Country, OCountry: string;
  // WebAware, Auth: boolean;
  WCity, WState, WZip, WAddress, Company, Department, Position, WSite, WCountry, Occupation: string;
  Phone, Fax, Cellular, WPhone, WFax, HomePage, LastUpdateInfo: string;
  Int1, Int2, Int3, Int4, I1, I2, I3, I4, About: string;
  Lang1, Lang2, Lang3, Marital, Sexual, Height, Relig, Smok, Hair, Children: string;

function StrArrayToStr(StrArr: array of string): string;
var
  I: Integer;
  S, Ss: string;
begin
  Result := EmptyStr;
  for I := low(StrArr) to high(StrArr) do
    begin
      S := StrArr[I];
      if (S > EmptyStr) and (Ss > EmptyStr) then
        Ss := Ss + ', ' + S
      else if (S > EmptyStr) and (Ss = EmptyStr) then
        Ss := S;
    end;
  Result := Ss;
end;

function CheckTextBR(Msg: string): string;
begin
  Result := AnsiReplaceText(Msg, #13#10, '<BR>');
end;

begin
  // Добавляем стили
  AddHTML(TopHTMLViewer, '<html><head>' + DetailsCSS + '<title>Details</title></head><body>', EmptyStr, False, False, True);
  AddHTML(BottomHTMLViewer, '<html><head>' + DetailsCSS + '<title>Details</title></head><body>', EmptyStr, False, False, True);
  // Учётная запись контакта
  AddHTML(TopHTMLViewer, ICQAccountInfo + ' ' + ReqUIN, 'cbold');
  AddHTML(TopHTMLViewer, '<hr>', EmptyStr, False, True);
  // Загружаем информацию из распакованного xml файла с инфой
  // Инициализируем XML
  with TrXML.Create() do
    try
      // Загружаем настройки
      LoadFromFile(ProfilePath + AnketaFileName + ReqProto + '_' + ReqUIN + '.xml');
      // Ник, Имя и фамилию
      if OpenKey('profile\name-info') then
        try
          Nick := ReadString('nick');
          if Nick <> EmptyStr then
            begin
              AddHTML(TopHTMLViewer, InfoNickL + ' ', 'cbold');
              AddHTML(TopHTMLViewer, Nick, 'cdef', True);
            end;
          First := ReadString('first');
          Last := ReadString('last');
          if IsNotNull([First, Last]) then
            begin
              AddHTML(TopHTMLViewer, InfoNameL + ' ', 'cbold');
              if Trim(First) <> EmptyStr then
                AddHTML(TopHTMLViewer, First + ' ');
              AddHTML(TopHTMLViewer, Last, 'cdef', True);
            end;
        finally
          CloseKey();
        end;
      // Email адреса
      if OpenKey('profile\emails-info') then
        try
          Email1 := ReadString('email1');
          Email2 := ReadString('email2');
          Email3 := ReadString('email3');
          if IsNotNull([Email1, Email2, Email3]) then
            begin
              if Trim(Email1) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, EmailL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, '<a href="mailto:' + Email1 + '">' + Email1 + '</a>', 'cmargin', True);
                end;
              if Trim(Email2) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, EmailL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, '<a href="mailto:' + Email2 + '">' + Email2 + '</a>', 'cmargin', True);
                end;
              if Trim(Email3) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, EmailL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, '<a href="mailto:' + Email3 + '">' + Email3 + '</a>', 'cmargin', True);
                end;
              // Вставляем разделитель
              AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
            end;
        finally
          CloseKey();
        end;
      // Место жительства
      if OpenKey('profile\home-info') then
        try
          Address := ReadString('address');
          City := ReadString('city');
          State := ReadString('state');
          Zip := ReadString('zip');
          Country := ReadString('country');
          // Получаем текст страны из кода
          if Assigned(IcqOptionsForm) then
            Country := IcqOptionsForm.CountryInfoComboBox.Items.Strings[IcqOptionsForm.CountryCodesComboBox.Items.IndexOf(Country)];
          if IsNotNull([Country, City]) then
            begin
              AddHTML(BottomHTMLViewer, InfoHomeL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, StrArrayToStr([Country, City]), 'cdef', True);
            end;
          if IsNotNull([Address, State, Zip]) then
            begin
              if Trim(Address) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoAdressL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Address, 'cdef', True);
                end;
              if Trim(State) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoStateL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, State, 'cdef', True);
                end;
              if Trim(Zip) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoZipL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Zip, 'cdef', True);
                end;
            end;
          // Вставляем разделитель
          if (IsNotNull([Country, City])) or (IsNotNull([Address, State, Zip])) then
            AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
        finally
          CloseKey();
        end;
      // Пол, последнее обновление, домашняя страничка, авторизация и вебаваре
      if OpenKey('profile\personal-info') then
        try
          // WebAware := XmlElem.GetBoolAttr('webaware');
          // Auth := XmlElem.GetBoolAttr('auth');
          HomePage := ReadString('homepage');
          LastUpdateInfo := ReadString('lastchange');
          Gender := ReadString('gender');
          if Gender = '1' then
            begin
              AddHTML(BottomHTMLViewer, InfoGenderL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, InfoGender1L, 'cdef', True);
            end
          else if Gender = '2' then
            begin
              AddHTML(BottomHTMLViewer, InfoGenderL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, InfoGender2L, 'cdef', True);
            end;
        finally
          CloseKey();
        end;
      // Дата рождения
      if OpenKey('profile\age-info') then
        try
          Age := ReadString('age');
          IDay := ReadString('day');
          IMonth := ReadString('month');
          IYear := ReadString('year');
          if Age <> '0' then
            begin
              AddHTML(BottomHTMLViewer, InfoAgeL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, Age, 'cdef', True);
            end;
          if (IDay <> '0') and (IMonth <> '0') and (IYear <> '0') then
            begin
              AddHTML(BottomHTMLViewer, InfoBirDate + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, IDay + '.' + IMonth + '.' + IYear, 'cdef', True);
            end;
          // Вставляем разделитель
          if (Gender <> '0') or ((IDay <> '0') and (IMonth <> '0') and (IYear <> '0')) then
            AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
        finally
          CloseKey();
        end;
      // Место рождения
      if OpenKey('profile\orig-home-info') then
        try
          OCountry := ReadString('country');
          // Получаем текст страны из кода
          if Assigned(IcqOptionsForm) then
            OCountry := IcqOptionsForm.CountryInfoComboBox.Items.Strings[IcqOptionsForm.CountryCodesComboBox.Items.IndexOf(OCountry)];
          OCity := ReadString('city');
          OState := ReadString('state');
          if IsNotNull([OCountry, OCity]) then
            begin
              AddHTML(BottomHTMLViewer, InfoOHomeL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, StrArrayToStr([OCountry, OCity]), 'cdef', True);
            end;
          if Trim(OState) <> EmptyStr then
            begin
              AddHTML(BottomHTMLViewer, InfoStateL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, OState, 'cdef', True);
            end;
          // Вставляем разделитель
          if (IsNotNull([OCountry, OCity])) or (Trim(OState) <> EmptyStr) then
            AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
        finally
          CloseKey();
        end;
      // Работа
      if OpenKey('profile\work-info') then
        try
          WCity := ReadString('city');
          WState := ReadString('state');
          WZip := ReadString('zip');
          WAddress := ReadString('address');
          Company := ReadString('corp');
          Department := ReadString('dep');
          Position := ReadString('prof');
          WSite := ReadString('site');
          WCountry := ReadString('country');
          Occupation := ReadString('occup');
          // Получаем текст страны из кода
          if Assigned(IcqOptionsForm) then
            WCountry := IcqOptionsForm.CountryInfoComboBox.Items.Strings[IcqOptionsForm.CountryCodesComboBox.Items.IndexOf(WCountry)];
          // Получаем текст занятия из кода
          if Assigned(IcqOptionsForm) then
            Occupation := IcqOptionsForm.CompanyProfInfoComboBox.Items.Strings[IcqOptionsForm.OccupationCodeComboBox.Items.IndexOf
              (Occupation)];
          if IsNotNull([WCountry, WCity]) then
            begin
              AddHTML(BottomHTMLViewer, InfoWorkL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, StrArrayToStr([WCountry, WCity]), 'cdef', True);
            end;
          if IsNotNull([WAddress, WState, WZip]) then
            begin
              if Trim(WAddress) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoAdressL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, WAddress, 'cdef', True);
                end;
              if Trim(WState) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoStateL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, WState, 'cdef', True);
                end;
              if Trim(WZip) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoZipL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, WZip, 'cdef', True);
                end;
            end;
          if IsNotNull([Company, Department, Position, Occupation, WSite]) then
            begin
              if Trim(Company) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoCompanyL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Company, 'cdef', True);
                end;
              if Trim(Department) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoDeportL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Department, 'cdef', True);
                end;
              if Trim(Position) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoPositionL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Position, 'cdef', True);
                end;
              if Trim(Occupation) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoOccupationL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Occupation, 'cdef', True);
                end;
              if Trim(WSite) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoWebSiteL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, WSite, 'cdef', True);
                end;
            end;
          // Вставляем разделитель
          if (IsNotNull([WCountry, WCity])) or (IsNotNull([WAddress, WState, WZip])) or
            (IsNotNull([Company, Department, Position, Occupation, WSite])) then
            AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
        finally
          CloseKey();
        end;
      // Телефоны
      if OpenKey('profile\phone-info') then
        try
          Phone := ReadString('phone1');
          Fax := ReadString('phone2');
          Cellular := ReadString('phone3');
          WPhone := ReadString('phone4');
          WFax := ReadString('phone5');
          if IsNotNull([Phone, Fax, Cellular, WPhone, WFax]) then
            begin
              if Trim(Phone) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoPhoneL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Phone, 'cdef', True);
                end;
              if Trim(Fax) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoFaxL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Fax, 'cdef', True);
                end;
              if Trim(Cellular) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoCellularL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Cellular, 'cdef', True);
                end;
              if Trim(WPhone) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfowPhoneL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, WPhone, 'cdef', True);
                end;
              if Trim(WFax) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfowFaxL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, WFax, 'cdef', True);
                end;
              // Вставляем разделитель
              AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
            end;
        finally
          CloseKey();
        end;
      // Интересы
      if OpenKey('profile\interests-info') then
        try
          Int1 := ReadString('int1');
          Int2 := ReadString('int2');
          Int3 := ReadString('int3');
          Int4 := ReadString('int4');
        finally
          CloseKey();
        end;
      if OpenKey('profile\interests-id-info') then
        try
          I1 := ReadString('int_id1');
          I2 := ReadString('int_id2');
          I3 := ReadString('int_id3');
          I4 := ReadString('int_id4');
          // Получаем название интереса из кода интереса
          if Assigned(IcqOptionsForm) then
            begin
              with IcqOptionsForm do
                begin
                  I1 := Interest1InfoComboBox.Items.Strings[InterestsCodesComboBox.Items.IndexOf(I1)];
                  I2 := Interest1InfoComboBox.Items.Strings[InterestsCodesComboBox.Items.IndexOf(I2)];
                  I3 := Interest1InfoComboBox.Items.Strings[InterestsCodesComboBox.Items.IndexOf(I3)];
                  I4 := Interest1InfoComboBox.Items.Strings[InterestsCodesComboBox.Items.IndexOf(I4)];
                end;
            end;
          // Формируем отображение интересов
          if IsNotNull([I1, I2, I3, I4, Int1, Int2, Int3, Int4]) then
            begin
              AddHTML(BottomHTMLViewer, InfoInterestsL + ' ', 'cbold', True);
              if (Trim(I1) <> EmptyStr) or (Trim(Int1) <> EmptyStr) then
                begin
                  AddHTML(BottomHTMLViewer, I1 + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Int1, 'cdef', True);
                end;
              if (Trim(I2) <> EmptyStr) or (Trim(Int2) <> EmptyStr) then
                begin
                  AddHTML(BottomHTMLViewer, I2 + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Int2, 'cdef', True);
                end;
              if (Trim(I3) <> EmptyStr) or (Trim(Int3) <> EmptyStr) then
                begin
                  AddHTML(BottomHTMLViewer, I3 + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Int3, 'cdef', True);
                end;
              if (Trim(I4) <> EmptyStr) or (Trim(Int4) <> EmptyStr) then
                begin
                  AddHTML(BottomHTMLViewer, I4 + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Int4, 'cdef', True);
                end;
              // Вставляем разделитель
              AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
            end;
        finally
          CloseKey();
        end;
      // Личное
      if OpenKey('profile\personal-x-info') then
        try
          Marital := ReadString('marital');
          Sexual := ReadString('sexual');
          Height := ReadString('height');
          Relig := ReadString('relig');
          Smok := ReadString('smok');
          Hair := ReadString('hair');
          Children := ReadString('children');
          // Получаем название из кода
          if Assigned(IcqOptionsForm) then
            begin
              with IcqOptionsForm do
                begin
                  Marital := PersonalMaritalInfoComboBox.Items.Strings[MaritalCodesComboBox.Items.IndexOf(Marital)];
                  Sexual := PersonalSexInfoComboBox.Items.Strings[SexCodesComboBox.Items.IndexOf(Sexual)];
                  Relig := PersonalReligionInfoComboBox.Items.Strings[ReligionCodesComboBox.Items.IndexOf(Relig)];
                  Smok := PersonalSmokInfoComboBox.Items.Strings[SmokCodesComboBox.Items.IndexOf(Smok)];
                  Hair := PersonalHairColourInfoComboBox.Items.Strings[HairColourCodesComboBox.Items.IndexOf(Hair)];
                end;
            end;
          // Формируем отображение
          if IsNotNull([Marital, Sexual, Height, Relig, Smok, Hair, Children]) then
            begin
              if Trim(Marital) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoMaritalL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Marital, 'cdef', True);
                end;
              if Trim(Sexual) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoSexualL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Sexual, 'cdef', True);
                end;
              if Height <> '0' then
                begin
                  case StrToInt(Height) of
                    140: Height := '140cm';
                    145: Height := '141-145cm';
                    150: Height := '146-150cm';
                    155: Height := '151-155cm';
                    160: Height := '156-160cm';
                    165: Height := '161-165cm';
                    170: Height := '166-170cm';
                    175: Height := '171-175cm';
                    180: Height := '176-180cm';
                    185: Height := '181-185cm';
                    190: Height := '186-190cm';
                    195: Height := '191-195cm';
                    200: Height := '196-200cm';
                    205: Height := '201-205cm';
                    210: Height := '206-210cm';
                    220: Height := '220cm';
                  end;
                  AddHTML(BottomHTMLViewer, InfoHeightL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Height, 'cdef', True);
                end;
              if Trim(Relig) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoReligL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Relig, 'cdef', True);
                end;
              if Trim(Smok) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoSmokL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Smok, 'cdef', True);
                end;
              if Trim(Hair) <> EmptyStr then
                begin
                  AddHTML(BottomHTMLViewer, InfoHairL + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Hair, 'cdef', True);
                end;
              if Children <> '0' then
                begin
                  case StrToInt(Children) of
                    1: Children := '1';
                    2: Children := '2';
                    3: Children := '3';
                    4: Children := '4';
                    5: Children := '5';
                    6: Children := '6';
                    7: Children := '7';
                    8: Children := '8';
                    9: Children := InfoChildrenL2;
                    255: Children := InfoChildrenL3;
                  end;
                  AddHTML(BottomHTMLViewer, InfoChildrenL1 + ' ', 'cbold');
                  AddHTML(BottomHTMLViewer, Children, 'cdef', True);
                end;
              // Вставляем разделитель
              if (IsNotNull([Marital, Sexual, Relig, Smok, Hair])) or (Height <> '0') or (Children <> '0') then
                AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
            end;
        finally
          CloseKey();
        end;
      // Языки
      if OpenKey('profile\lang-info') then
        try
          Lang1 := ReadString('lang1');
          Lang2 := ReadString('lang2');
          Lang3 := ReadString('lang3');
          // Получаем название языка из кода языка
          if Assigned(IcqOptionsForm) then
            begin
              with IcqOptionsForm do
                begin
                  Lang1 := Lang1InfoComboBox.Items.Strings[LangsCodeComboBox.Items.IndexOf(Lang1)];
                  Lang2 := Lang1InfoComboBox.Items.Strings[LangsCodeComboBox.Items.IndexOf(Lang2)];
                  Lang3 := Lang1InfoComboBox.Items.Strings[LangsCodeComboBox.Items.IndexOf(Lang3)];
                end;
            end;
          // Формируем отображение языков
          if IsNotNull([Lang1, Lang2, Lang3]) then
            begin
              AddHTML(BottomHTMLViewer, InfoLangL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, StrArrayToStr([Lang1, Lang2, Lang3]), 'cdef', True);
              // Вставляем разделитель
              AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
            end;
        finally
          CloseKey();
        end;
      // О себе
      if OpenKey('profile\about-info') then
        try
          About := Base64Decode(ReadString('info'));
          if Trim(About) <> EmptyStr then
            begin
              AddHTML(BottomHTMLViewer, InfoAboutL + ' ', 'cbold');
              AddHTML(BottomHTMLViewer, About, 'cdef', True);
              // Вставляем разделитель
              AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
            end;
        finally
          CloseKey();
        end;
      // Домашняя страница
      if Trim(HomePage) <> EmptyStr then
        begin
          AddHTML(BottomHTMLViewer, InfoHomePageL + ' ', 'cbold');
          AddHTML(BottomHTMLViewer, HomePage, 'cdef', True);
          // Вставляем разделитель
          AddHTML(BottomHTMLViewer, '<hr>', EmptyStr, False, True);
        end;
      // Дата последнего обновления, дополнительно
      if Trim(LastUpdateInfo) <> EmptyStr then
        begin
          AddHTML(BottomHTMLViewer, InfoLastUpDateL + ' ', 'cbold');
          AddHTML(BottomHTMLViewer, LastUpdateInfo, 'cdef', True);
        end;
    finally
      Free();
    end;
  // Вычисляем знак гороскопа
  if (IDay <> '0') and (IMonth <> '0') then
    begin
      // Загружаем картинку гороскопа
      HoroImage.Picture.LoadFromFile(MyPath + 'Icons\' + CurrentIcons + '\horoscope.bmp');
      // Прокручиваем на картинку этого знака
      HoroImage.Canvas.CopyRect(Rect(0, 0, 32, 32), HoroImage.Canvas, Bounds(Horospope(StrToInt(IDay), StrToInt(IMonth)), 0, 32, 32));
    end
  else
    HoroImage.Picture.Assign(nil);
  // Загружаем аватар
  AvatarImage.Picture.LoadFromFile(MyPath + 'Icons\' + CurrentIcons + '\noavatar.gif');
  { if (Length(UserAvatarHash) = 32) and ((FileExists(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.jpg')) or
    (FileExists(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.gif')) or
    (FileExists(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.bmp'))) then
    begin
    if FileExists(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.jpg') then
    ContactImage.Picture.LoadFromFile(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.jpg')
    else if FileExists(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.gif') then
    ContactImage.Picture.LoadFromFile(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.gif')
    else if FileExists(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.bmp') then
    ContactImage.Picture.LoadFromFile(ProfilePath + 'Profile\Avatars\' + UserAvatarHash + '.bmp');
    end
    else
    begin
    if (Length(UserAvatarHash) = 32) and (ICQ_Avatar_Work_Phaze) then
    begin
    ICQ_GetAvatarImage(UIN, UserAvatarHash);
    end;
    if (Length(UserAvatarHash) = 32) and (not AvatarServiceDisable) and (not ICQ_Avatar_Connect_Phaze) and
    (not ICQ_Avatar_Work_Phaze) and (ICQ_Work_Phaze) then
    begin
    ICQ_Avatar_Connect_Phaze := true;
    ICQ_Avatar_Work_Phaze := false;
    ICQ_GetAvatar_UIN := UIN;
    ICQ_GetAvatar_Hash := UserAvatarHash;
    ICQ_GetAvatarBosServer;
    end;
    //SearchAvatarTimer.Enabled := true;
    ContactImage.Picture.Assign(nil);
    ContactImage.Picture.Assign(NoAvatar.Picture);
    end; }
  // Удаляем распакованный файл с информацией
  // if FileExists(ProfilePath + 'Profile\Contacts\Icq_Info.xml') then DeleteFile(ProfilePath + 'Profile\Contacts\Icq_Info.xml');
end;

procedure TIcqContactInfoForm.ReqInfoBitBtnClick(Sender: TObject);
begin
  // Запрашиваем информацию о контакте
  if (ReqUIN > EmptyStr) and (ICQ_Work_Phaze) then
    begin
      InfoLabel.Caption := InfoReqL;
      ICQ_ReqInfo_New_Pkt(ReqUIN);
    end;
end;

procedure TIcqContactInfoForm.OKBitBtnClick(Sender: TObject);
begin
  // Закрываем окно
  Close;
end;

procedure TIcqContactInfoForm.FormCreate(Sender: TObject);
begin
  // Инициализируем XML
  with TrXML.Create() do
    try
      // Загружаем настройки
      if FileExists(ProfilePath + SettingsFileName) then
        begin
          LoadFromFile(ProfilePath + SettingsFileName);
          // Загружаем позицию окна
          if OpenKey('settings\forms\contactinfoform\position') then
            try
              Top := ReadInteger('top');
              Left := ReadInteger('left');
            finally
              CloseKey();
            end;
        end;
    finally
      Free();
    end;
  // Переводим форму на другие языки
  TranslateForm;
  // Ставим иконки окна и кнопок
  MainForm.AllImageList.GetIcon(178, Icon);
  MainForm.AllImageList.GetBitmap(140, OKBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(6, ReqInfoBitBtn.Glyph);
  // Помещаем кнопку формы в таскбар и делаем независимой
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TIcqContactInfoForm.FormDestroy(Sender: TObject);
begin
  // Сохраняем настройки положения окна в xml
  with TrXML.Create() do
    try
      if FileExists(ProfilePath + SettingsFileName) then
        LoadFromFile(ProfilePath + SettingsFileName);
      if OpenKey('settings\forms\contactinfoform\position', True) then
        try
          WriteInteger('top', Top);
          WriteInteger('left', Left);
        finally
          CloseKey();
        end;
      // Записываем сам файл
      SaveToFile(ProfilePath + SettingsFileName);
    finally
      Free();
    end;
end;

end.