﻿{ *******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
  ******************************************************************************* }

unit Utilsunit;

interface

uses
  Windows,
  Messages,
  Sysutils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  Mmsystem,
  Strutils,
  Jvdesktopalert,
  Shellapi,
  Jvdesktopalertform,
  Stdctrls,
  Varsunit,
  Mainunit,
  Icqprotounit,
  Jvtrayicon,
  Winsock,
  Overbyteicswsocket,
  Categorybuttons,
  Jabberprotounit,
  Registry,
  Mraprotounit,
  Rxml,
  LogUnit,
  JclCompression;

function Parse(Char, S: string; Count: Integer): string;
procedure Listfiledirhist(Path, Ext, Eext: string; Filelist: Tstrings);
procedure Gettreedirs(Root: string; out Outstring: Tstringlist);
function Hex2text(HexText: string): string;
function Text2hex(Msg: RawByteString): string;
function Rightstr(const Str: string; Size: Word): string;
function Leftstr(const Str: string; Size: Word): string;
function Hextoint(Value: string): Longword;
function Nextdata(var Data: string; Count: Integer): string;
function Swap16(Value: Word): Word;
assembler;
function Swap32(Value: Longword): Longword;
assembler;
function Deletespaces(const Value: string): string;
function Deletelinebreaks(const S: string): string;
function Exnormalizescreenname(Sn: string): string;
function Exnormalizeicqnumber(Sn: string): string;
function Normalizecellularnumber(const Value: string): string;
function Datetimechatmess: string;
procedure Sendflap(Channel, Data: string);
procedure Sendflap_avatar(Channel, Data: string);
function Numtoip(Addr: Longword): string;
function Unixtodatetime(const Avalue: Int64): Tdatetime;
function Gettimezone: Integer;
function Taillinetail(Ahistory: string; Alinescount: Integer): string;
function Bmsearch(Startpos: Integer; const S, P: string): Integer;
function Rtf2plain(const Asource: string): string;
procedure Formflash(Hnd: Hwnd);
function Exisvalidcharacterstext(Value: string): Boolean;
function Exisvalidcharactersdigit(Value: string): Boolean;
function Hextoint64(Hex: string): Int64;
function Calculateage(Birthday, Currentdate: Tdate): Integer;
function Setclipboardtext(Wnd: Hwnd; Value: string): Boolean;
function Dump(Data: RawByteString): string;
function Chop(I: Integer; var S: string): string; overload;
function Chop(I, L: Integer; var S: string): string; overload;
function Chop(Ss: string; var S: string): string; overload;
function Readfromfile(Filename: string): string;
function Isolatetextstring(const S: string; Tag1, Tag2: string): string;
function Int64tohex(C: Int64): string;
function Horospope(D, M: Integer): Integer;
function Translitrus2lat(const Str: string): string;
procedure Dashow(Dahead, Datext, Daid: string; Daico, Dacolor, Davisible: Integer);
function Initmixer: Hmixer;
function Icq_bodysize: Integer;
function Icq_bodysize_avatar: Integer;
function Mra_bodysize: Integer;
function Isnotnull(Stringsarr: array of string): Boolean;
procedure Decorateurl(var Text: string);
function Nameandlast(Cid, Cproto: string): string;
procedure Popup(Compon: Tcomponent; Pm: Tpopupmenu);
procedure Popup_down(Compon: Tcomponent; Pm: Tpopupmenu);
function Initbuildinfo: string;
function Getfilesize(Filename: string): Longint;
function Packettohex(Buffer: Pointer; Buflen: Word): string;
function Getrandomhexbytes(Bytescount: Integer): string;
function Errorhttpclient(Errcode: Integer): string;
function Getfulltag(Adata: string): string;
procedure Implaysnd(Snd: Integer);
function Searchnickincash(Ctype, Cid: string): string;
function Copydir(const Fromdir, Todir: string): Boolean;
function Cleardir(const Path: string; Delete: Boolean): Boolean;
procedure SetcustomWidthCombobox(Cb: Tcombobox);
procedure Xshowform(Xform: Tform);
procedure OpenUrl(Url: string);
function Changespaces(const Value: string): string;
function Changeslash(const Value: string): string;
procedure Sendflap_mra(Pkttype, Data: string; Nolen: Boolean = False);
function Getfilefname(Filename: string): string;
procedure Checkmessage_br(var Msg: string);
function NotProtoOnline(Proto: string): Boolean;
function Getfiledatetime(Filename: string): Tdatetime;
procedure Sendflap_jabber(Xmldata: string);
procedure XLog(XLogData: string);
function RafinePath(const Path: string): string;
function NotifyConnectError(SName: string; Errcode: Integer): string;
function CreateHistoryArhive(HFile: string): Boolean;
procedure SaveTextInHistory(LogString: string; LogFileName: string);

implementation

procedure SaveTextInHistory(LogString: string; LogFileName: string);
var
  F: TFileStream;
  PStr: PChar;
  LengthLogString: Integer;
begin
  LengthLogString := (Length(LogString) + 2) * SizeOf(Char);
  LogString := LogString + #13#10;
  PStr := StrAlloc(LengthLogString + 1);
  StrPCopy(PStr, LogString);
  if FileExists(LogFileName) then
    F := TFileStream.Create(LogFileName, fmOpenWrite)
  else
    F := TFileStream.Create(LogFileName, fmCreate);
  F.Position := F.Size;
  F.Write(PStr^, LengthLogString);
  StrDispose(PStr);
  F.Free;
end;

function NotifyConnectError(SName: string; Errcode: Integer): string;
begin
  // Определяем что за ошибка произошла при подключении
  Result := SocketConnErrorInfo_1 + RN + WSocketErrorDesc(Errcode) + RN + Format(HttpSocketErrCodeL, [Errcode])
    + RN + '[ ' + SocketL + ' ' + SName + ' ]';
  XLog(SName + ' | ' + Result);
end;

// На случай, если в имени контакта символы, не поддерживаемые ФС (типа *\/,..)
function RafinePath(const Path: string): string;
begin
  Result := Path;
  Result := ReplaceStr(Result, '*', '_');
  Result := ReplaceStr(Result, '?', '_');
  Result := ReplaceStr(Result, '/', '_');
  Result := ReplaceStr(Result, '|', '_');
end;

procedure XLog(XLogData: string);
begin
  // Если количество строк в логе слишком большое, то очищаем его
  if LogForm.LogMemo.Lines.Count > 10000 then
  begin
    LogForm.LogMemo.Clear;
    LogForm.LogMemo.Lines.Add(DateTimeToStr(Now) + ': ' + Log_Clear);
    LogForm.LogMemo.Lines.Add('-----------------------------------------------------------');
  end;
  // Добавляем в лог новое сообщение
  LogForm.LogMemo.Lines.Add(DateTimeToStr(Now) + ': ' + XLogData);
  LogForm.LogMemo.Lines.Add('-----------------------------------------------------------');
end;

procedure Sendflap_jabber(Xmldata: string);
begin
  // Пишем в лог данные пакета
  if LogForm.JabberDumpSpeedButton.Down then
    XLog('Jabber send | ' + RN + Trim(Dump(Xmldata)));
  // Отправляем данные через сокет
  Mainform.JabberWSocket.SendStr(Utf8Encode(Xmldata));
end;

{$WARNINGS OFF}

function Getfiledatetime(Filename: string): Tdatetime;
var
  Intfileage: Longint;
begin
  Intfileage := Fileage(Filename);
  if Intfileage = -1 then
    Result := 0
  else
    Result := Filedatetodatetime(Intfileage);
end;

{$WARNINGS ON}

function NotProtoOnline(Proto: string): Boolean;
begin
  Result := False;
  // Проверяем онлайн ли клиент для этого протокола
  if (Proto = 'Icq') and (not Icq_work_phaze) then
  begin
    Dashow(Alerthead, Onlinealert, EmptyStr, 133, 3, 0);
    Result := True;
  end
  else if (Proto = 'Jabber') and (not Jabber_work_phaze) then
  begin
    Dashow(Alerthead, Onlinealert, EmptyStr, 133, 3, 0);
    Result := True;
  end
  else if (Proto = 'Mra') and (not Mra_work_phaze) then
  begin
    Dashow(Alerthead, Onlinealert, EmptyStr, 133, 3, 0);
    Result := True;
  end;
end;

procedure Checkmessage_br(var Msg: string);
begin
  // Заменяем все переходы на новую строку в сообщении на соответствующий тэг
  Msg := Ansireplacetext(Msg, #13#10, '<BR>');
end;

procedure Xshowform(Xform: Tform);
begin
  // Автоматизируем показ окон
  if Xform.Visible then
    Showwindow(Xform.Handle, Sw_restore);
  Xform.Show;
  Setforegroundwindow(Xform.Handle);
end;

function Getfilesize(Filename: string): Longint;
var
  Searchrec: Tsearchrec;
begin
  Result := -1;
  if Findfirst(Filename, Faanyfile, Searchrec) = 0 then
    try
      Result := Searchrec.Size;
    finally
      Findclose(Searchrec);
    end;
end;

function Getfilefname(Filename: string): string;
var
  Searchrec: Tsearchrec;
begin
  Result := EmptyStr;
  if Findfirst(Filename, Faanyfile, Searchrec) = 0 then
    try
      Result := Searchrec.name;
    finally
      Findclose(Searchrec);
    end;
end;

function Nameandlast(Cid, Cproto: string): string;
var
  Ln, Lf, La: string;
begin
  Result := EmptyStr;
  Getcitypanel := EmptyStr;
  Getagepanel := EmptyStr;
  // Ищем файл с анкетой этого контакта
  if FileExists(Profilepath + Anketafilename + Cproto + '_' + Cid + '.xml') then
  begin
    // Инициализируем XML
    with Trxml.Create() do
      try
        Loadfromfile(Profilepath + Anketafilename + Cproto + '_' + Cid + '.xml');
        // Загружаем Имя и Фамилию
        if Openkey('profile\name-info') then
          try
            Ln := Readstring('first');
            Lf := Readstring('last');
          finally
            Closekey;
          end;
        // Загружаем Город
        if Openkey('profile\home-info') then
          try
            Getcitypanel := Readstring('city');
          finally
            Closekey;
          end;
        // Загружаем Возраст
        if Openkey('profile\age-info') then
          try
            La := Readstring('age');
            if La <> '0' then
              Getagepanel := Infoagel + ' ' + La;
          finally
            Closekey;
          end;
      finally
        Free();
      end;
    // Формируем строку
    if Ln > EmptyStr then
      Result := Result + Ln;
    if (Ln > EmptyStr) and (Lf > EmptyStr) then
      Result := Result + ' ' + Lf
    else if (Ln = EmptyStr) and (Lf > EmptyStr) then
      Result := Result + Lf;
  end;
end;

procedure Decorateurl(var Text: string);
var
  S, Ltext: string;
begin
  Ltext := Lowercase(Text);
  //
  if Pos('http://', Ltext) > 0 then
  begin
    S := Ltext;
    Delete(S, 1, Pos('http://', S) - 1);
    if Pos(' ', S) > 0 then
    begin
      S := Copy(S, 1, Pos(' ', S) - 1);
      if Pos('<br>', S) > 0 then
        S := Copy(S, 1, Pos('<br>', S) - 1);
    end
    else if Pos('<br>', S) > 0 then
    begin
      S := Copy(S, 1, Pos('<br>', S) - 1);
      if Pos(' ', S) > 0 then
        S := Copy(S, 1, Pos(' ', S) - 1);
    end
    else
      S := Copy(S, 1, Length(S));
    Text := Stringreplace(Ltext, S, '<a href="' + S + '">' + S + '</a>', [Rfreplaceall]);
    Exit;
  end;
  //
  if Pos('https://', Ltext) > 0 then
  begin
    S := Ltext;
    Delete(S, 1, Pos('https://', S) - 1);
    if Pos(' ', S) > 0 then
    begin
      S := Copy(S, 1, Pos(' ', S) - 1);
      if Pos('<br>', S) > 0 then
        S := Copy(S, 1, Pos('<br>', S) - 1);
    end
    else if Pos('<br>', S) > 0 then
    begin
      S := Copy(S, 1, Pos('<br>', S) - 1);
      if Pos(' ', S) > 0 then
        S := Copy(S, 1, Pos(' ', S) - 1);
    end
    else
      S := Copy(S, 1, Length(S));
    Text := Stringreplace(Ltext, S, '<a href="' + S + '">' + S + '</a>', [Rfreplaceall]);
    Exit;
  end;
  //
  if Pos('www.', Ltext) > 0 then
  begin
    S := Ltext;
    Delete(S, 1, Pos('www.', S) - 1);
    if Pos(' ', S) > 0 then
    begin
      S := Copy(S, 1, Pos(' ', S) - 1);
      if Pos('<br>', S) > 0 then
        S := Copy(S, 1, Pos('<br>', S) - 1);
    end
    else if Pos('<br>', S) > 0 then
    begin
      S := Copy(S, 1, Pos('<br>', S) - 1);
      if Pos(' ', S) > 0 then
        S := Copy(S, 1, Pos(' ', S) - 1);
    end
    else
      S := Copy(S, 1, Length(S));
    Text := Stringreplace(Ltext, S, '<a href="' + S + '">' + S + '</a>', [Rfreplaceall]);
    Exit;
  end;
  //
  if Pos('ftp://', Ltext) > 0 then
  begin
    S := Ltext;
    Delete(S, 1, Pos('ftp://', S) - 1);
    if Pos(' ', S) > 0 then
    begin
      S := Copy(S, 1, Pos(' ', S) - 1);
      if Pos('<br>', S) > 0 then
        S := Copy(S, 1, Pos('<br>', S) - 1);
    end
    else if Pos('<br>', S) > 0 then
    begin
      S := Copy(S, 1, Pos('<br>', S) - 1);
      if Pos(' ', S) > 0 then
        S := Copy(S, 1, Pos(' ', S) - 1);
    end
    else
      S := Copy(S, 1, Length(S));
    Text := Stringreplace(Ltext, S, '<a href="' + S + '">' + S + '</a>', [Rfreplaceall]);
    Exit;
  end;
end;

function Isnotnull(Stringsarr: array of string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := low(Stringsarr) to high(Stringsarr) do
  begin
    if Trim(Stringsarr[I]) <> EmptyStr then
      Exit;
  end;
  Result := False;
end;

function Translitrus2lat(const Str: string): string;
const
  Rarrayl = 'абвгдеёжзийклмнопрстуфхцчшщьыъэюя';
  Rarrayu = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ';
  Colchar = 33;
  Arr: array [1 .. 2, 1 .. Colchar] of string =
    (('a', 'b', 'v', 'g', 'd', 'e', 'yo', 'zh', 'z', 'i', 'y', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'kh', 'ts', 'ch',
      'sh', 'shch', '''', 'y', '''', 'e', 'yu', 'ya'), ('A', 'B', 'V', 'G', 'D', 'E', 'Yo', 'Zh', 'Z', 'I', 'Y', 'K', 'L', 'M', 'N', 'O',
      'P', 'R', 'S', 'T', 'U', 'F', 'Kh', 'Ts', 'Ch', 'Sh', 'Shch', '''', 'Y', '''', 'E', 'Yu', 'Ya'));
var
  I: Integer;
  Lens: Integer;
  P: Integer;
  D: Byte;
begin
  Result := EmptyStr;
  Lens := Length(Str);
  for I := 1 to Lens do
  begin
    D := 1;
    P := Pos(Str[I], Rarrayl);
    if P = 0 then
    begin
      P := Pos(Str[I], Rarrayu);
      D := 2
    end;
    if P <> 0 then
      Result := Result + Arr[D, P]
    else
      Result := Result + Str[I];
  end;
end;

function Horospope(D, M: Integer): Integer;
begin
  Result := 0;
  if (M = 12) and (D >= 22) then
    Result := 32 * 9 // Козерог
  else if (M = 1) and (D <= 20) then
    Result := 32 * 9 // Козерог
  else if (M = 1) and (D >= 21) then
    Result := 32 * 10 // Водолей
  else if (M = 2) and (D <= 18) then
    Result := 32 * 10 // Водолей
  else if (M = 2) and (D >= 19) then
    Result := 32 * 11 // Рыбы
  else if (M = 3) and (D <= 20) then
    Result := 32 * 11 // Рыбы
  else if (M = 3) and (D >= 21) then
    Result := 0 // Овен
  else if (M = 4) and (D <= 20) then
    Result := 0 // Овен
  else if (M = 4) and (D >= 21) then
    Result := 32 // Телец
  else if (M = 5) and (D <= 21) then
    Result := 32 // Телец
  else if (M = 5) and (D >= 22) then
    Result := 32 * 2 // Близнецы
  else if (M = 6) and (D <= 21) then
    Result := 32 * 2 // Близнецы
  else if (M = 6) and (D >= 22) then
    Result := 32 * 3 // Рак
  else if (M = 7) and (D <= 22) then
    Result := 32 * 3 // Рак
  else if (M = 7) and (D >= 23) then
    Result := 32 * 4 // Лев
  else if (M = 8) and (D <= 23) then
    Result := 32 * 4 // Лев
  else if (M = 8) and (D >= 24) then
    Result := 32 * 5 // Дева
  else if (M = 9) and (D <= 23) then
    Result := 32 * 5 // Дева
  else if (M = 9) and (D >= 24) then
    Result := 32 * 6 // Весы
  else if (M = 10) and (D <= 23) then
    Result := 32 * 6 // Весы
  else if (M = 10) and (D >= 24) then
    Result := 32 * 7 // Скорпион
  else if (M = 11) and (D <= 22) then
    Result := 32 * 7 // Скорпион
  else if (M = 11) and (D >= 23) then
    Result := 32 * 8 // Стрелец
  else if (M = 12) and (D <= 21) then
    Result := 32 * 8; // Стрелец
end;

type
  Ti64 = record
    Lo, Hi: Integer;
  end;

function Int64tohex;
var
  Temp: string[17];
  B: Byte;
  Ch: Byte;
  I64: Ti64 absolute C;
begin
  SetLength(Temp, 17);
  B := 17;
  repeat
    Ch := (I64.Lo and $0F) + Ord('0');
    if Ch > Ord('9') then
      Inc(Ch, Ord('A') - Ord('9') - 1);
    Temp[B] := Ansichar(Ch);
    Dec(B);
    asm
      MOV     EAX,DWORD PTR [C+4];
      SHRD    DWORD PTR [C],EAX,4
      SHR     EAX,4
      MOV     DWORD PTR[C+4],EAX
    end
    ;
  until (I64.Lo = 0) and (I64.Hi = 0);
  Temp[B] := '$';
  Result := Copy(Temp, B, 255);
end;

procedure Dashow(Dahead, Datext, Daid: string; Daico, Dacolor, Davisible: Integer);
var
  Da: Tjvdesktopalert;
  Ico: Ticon;
begin
  // Применяем параметры для всплывающего окна
  if Davisible = 0 then
    Davisible := Datimeshow;
  Da := Tjvdesktopalert.Create(Mainform);
  Da.Options := Fdaoptions;
  Da.Autofree := True;
  Da.Autofocus := False;
  Da.Location.Position := Tjvdesktopalertposition(Dapos);
  Da.Alertstyle := Tjvalertstyle(Dastyle);
  Da.Stylehandler.Displayduration := Davisible;
  Da.Stylehandler.Startinterval := 10;
  Da.Stylehandler.Startsteps := 10;
  Da.Stylehandler.Endinterval := 10;
  Da.Stylehandler.Endsteps := 10;
  // Применяем цвет всплывающего окна
  case Dacolor of
    0: // Голубой
      begin
        Da.Colors.Windowfrom := Tcolor($00FFC688);
        Da.Colors.Windowto := Tcolor($00FFE3C7);
      end;
    1: // Жёлтый
      begin
        Da.Colors.Windowfrom := Tcolor($0092FFFF);
        Da.Colors.Windowto := Tcolor($00B6FFFF);
      end;
    2: // Красный
      begin
        Da.Colors.Windowfrom := Tcolor($009DCDFF);
        Da.Colors.Windowto := Tcolor($00DAF4FF);
      end;
    3: // Зелёный
      begin
        Da.Colors.Windowfrom := Tcolor($0092FF92);
        Da.Colors.Windowto := Tcolor($00B6FFB6);
      end;
  end;
  // Применяем иконку и текст сообщения
  Ico := Ticon.Create;
  Mainform.Allimagelist.Geticon(Daico, Ico);
  Da.Image.Assign(Ico);
  Da.Headertext := Dahead;
  Da.Messagetext := Datext;
  Da.Hint := Daid;
  // Вызываем непосредственно сам показ всплывающего окна
  Da.Execute;
end;

function Isolatetextstring(const S: string; Tag1, Tag2: string): string;
var
  Pscan, Pend, Ptag1, Ptag2: PChar;
  Foundtext: string;
  Searchtext: string;
begin
  Result := EmptyStr;
  Searchtext := Uppercase(S);
  Tag1 := Uppercase(Tag1);
  Tag2 := Uppercase(Tag2);
  Ptag1 := PChar(Tag1);
  Ptag2 := PChar(Tag2);
  Pscan := PChar(Searchtext);
  repeat
    Pscan := Strpos(Pscan, Ptag1);
    if Pscan <> nil then
    begin
      Inc(Pscan, Length(Tag1));
      Pend := Strpos(Pscan, Ptag2);
      if Pend <> nil then
      begin
        Setstring(Foundtext, PChar(S) + (Pscan - PChar(Searchtext)), Pend - Pscan);
        Result := Foundtext;
        Pscan := Pend + Length(Tag2);
      end
      else
        Pscan := nil;
    end;
  until Pscan = nil;
end;

function Readfromfile(Filename: string): string;
begin
  with Tstringlist.Create do
    try
      Loadfromfile(Filename, TEncoding.Unicode);
      Result := Text;
    finally
      Free;
    end;
end;

function Chop(Ss: string; var S: string): string;
begin
  Result := Chop(Pos(Ss, S), Length(Ss), S);
end;

function Chop(I: Integer; var S: string): string;
begin
  Result := Chop(I, 1, S);
end;

function Chop(I, L: Integer; var S: string): string;
begin
  if I = 0 then
  begin
    Result := S;
    S := EmptyStr;
    Exit;
  end;
  Result := Copy(S, 1, I - 1);
  Delete(S, 1, I - 1 + L);
end;

function Setclipboardtext(Wnd: Hwnd; Value: string): Boolean;
var
  Hdata: Hglobal;
  Pdata: Pointer;
  Len: Integer;
begin
  Result := True;
  if Openclipboard(Wnd) then
  begin
    try
      Len := Length(Value) + 1;
      Hdata := Globalalloc(Gmem_moveable or Gmem_ddeshare, Len);
      try
        Pdata := Globallock(Hdata);
        try
          Move(PChar(Value)^, Pdata^, Len);
          Emptyclipboard;
          Setclipboarddata(Cf_text, Hdata);
        finally
          Globalunlock(Hdata);
        end;
      except
        Globalfree(Hdata);
        raise
      end;
    finally
      Closeclipboard;
    end;
  end
  else
    Result := False;
end;

function Calculateage(Birthday, Currentdate: Tdate): Integer;
var
  Month, Day, Year, Currentyear, Currentmonth, Currentday: Word;
begin
  Decodedate(Birthday, Year, Month, Day);
  Decodedate(Currentdate, Currentyear, Currentmonth, Currentday);
  if (Year = Currentyear) and (Month = Currentmonth) and (Day = Currentday) then
  begin
    Result := 0;
  end
  else
  begin
    Result := Currentyear - Year;
    if (Month > Currentmonth) then
      Dec(Result)
    else
    begin
      if Month = Currentmonth then
        if (Day > Currentday) then
          Dec(Result);
    end;
  end;
end;

function Hextoint64(Hex: string): Int64;
const
  Hexvalues = '0123456789ABCDEF';
var
  I: Integer;
begin
  Result := 0;
  case Length(Hex) of
    0:
      Result := 0;
    1 .. 16:
      for I := 1 to Length(Hex) do
        Result := 16 * Result + Pos(Upcase(Hex[I]), Hexvalues) - 1;
  else
    for I := 1 to 16 do
      Result := 16 * Result + Pos(Upcase(Hex[I]), Hexvalues) - 1;
  end;
end;

function Exisvalidcharacterstext(Value: string): Boolean;
const
  Validasciichars = ['a' .. 'z', 'A' .. 'Z'];
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(Value) do
    if not(Value[I] in Validasciichars) then
    begin
      Result := False;
      Exit;
    end;
end;

function Exisvalidcharactersdigit(Value: string): Boolean;
const
  Validasciichars = ['0' .. '9'];
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(Value) do
    if not(Value[I] in Validasciichars) then
    begin
      Result := False;
      Exit;
    end;
end;

procedure Formflash(Hnd: Hwnd);
var
  Rec: Flashwinfo;
begin
  Rec.Cbsize := SizeOf(Rec);
  Rec.Hwnd := Hnd;
  Rec.Dwflags := Flashw_tray or Flashw_timernofg;
  Rec.Dwtimeout := 0;
  Rec.Ucount := DWORD(-1);
  Flashwindowex(Rec);
end;

function Rtf2plain(const Asource: string): string;
var
  Source: string;
  Nchar: Integer;

function Processgrouprecursevly: string;

procedure Skipstar;
var
  Bracesopened: Integer;
  Escaped: Boolean;
begin
  Bracesopened := 1;
  Escaped := False;
  while Bracesopened > 0 do
  begin
    Inc(Nchar);
    case Source[Nchar] of
      '{':
        if Escaped then
          Escaped := False
        else
          Inc(Bracesopened);
      '}':
        if Escaped then
          Escaped := False
        else
          Dec(Bracesopened);
      '\':
        Escaped := not Escaped;
    else
      Escaped := False;
    end;
  end;
end;

var
  Control, Numericvalue, Textvalue: string;
begin
  Result := EmptyStr;
  Inc(Nchar);
  while Nchar <= Length(Source) do
    case Source[Nchar] of
      '{':
        Result := Result + Processgrouprecursevly;
      '}':
        begin
          Inc(Nchar);
          Break;
        end;
      '\':
        begin
          Inc(Nchar);
          case Source[Nchar] of
            '''':
              begin
                Result := Result + Chr(Hextoint(Copy(Source, Nchar + 1, 2)));
                Inc(Nchar, 3);
              end;
            '~':
              Result := Result + #$20;
            '*':
              Skipstar;
            'a' .. 'z':
              begin
                Control := EmptyStr;
                while Source[Nchar] in ['a' .. 'z'] do
                begin
                  Control := Control + Source[Nchar];
                  Inc(Nchar);
                end;
                if Source[Nchar] = '-' then
                begin
                  Numericvalue := Source[Nchar];
                  Inc(Nchar);
                end
                else
                  Numericvalue := EmptyStr;
                while Source[Nchar] in ['0' .. '9'] do
                begin
                  Numericvalue := Numericvalue + Source[Nchar];
                  Inc(Nchar);
                end;
                if Source[Nchar] = '{' then
                  Processgrouprecursevly;
                Textvalue := EmptyStr;
                if not(Source[Nchar] in ['a' .. 'z', '{', '}', '\']) then
                begin
                  Inc(Nchar);
                  while not(Source[Nchar] in ['{', '}', '\']) do
                  begin
                    Textvalue := Textvalue + Source[Nchar];
                    Inc(Nchar);
                  end;
                end;
                if (Control = 'line') or (Control = 'par') then
                  Result := Result + #$0D#$0A
                else if Control = 'tab' then
                  Result := Result + #$09
                  { else if Control = 'u' then
                    Result := Result + Unicodecharcode2ansistring(Strtoint(Numericvalue)) }
                else if Control = 'colortbl' then
                  Textvalue := EmptyStr;
                if Length(Textvalue) > 0 then
                  if (not((Textvalue[Length(Textvalue)] = ';') and (Source[Nchar] = '}'))) then
                  begin
                    Result := Result + Textvalue;
                    Textvalue := EmptyStr;
                  end;
              end;
          else
            begin
              Result := Result + Source[Nchar];
              Inc(Nchar);
            end;
          end;
        end;
    else
      begin
        Result := Result + Source[Nchar];
        Inc(Nchar);
      end;
    end;
end;

function Initsource: Boolean;
var
  Bracescount: Integer;
  Escaped: Boolean;
begin
  if Copy(Asource, 1, 5) <> '{\rtf' then
    Initsource := False
  else
  begin
    Source := EmptyStr;
    Bracescount := 0;
    Escaped := False;
    Nchar := 1;
    while (Nchar <= Length(Asource)) and (Bracescount >= 0) do
    begin
      if not(Asource[Nchar] in [#$0D, #$0A]) then
      begin
        Source := Source + Asource[Nchar];
        case Asource[Nchar] of
          '{':
            if not Escaped then
              Inc(Bracescount)
            else
              Escaped := False;
          '}':
            if not Escaped then
              Dec(Bracescount)
            else
              Escaped := False;
          '\':
            Escaped := True;
        else
          Escaped := False;
        end;
      end;
      Inc(Nchar);
    end;
    Initsource := Bracescount = 0;
  end;
end;

begin
  if Initsource then
  begin
    Nchar := 1;
    Result := Processgrouprecursevly;
  end
  else
    Result := Asource;
end;

function Bmsearch(Startpos: Integer; const S, P: string): Integer;
type
  Tbmtable = array [0 .. 255] of Integer;
var
  Pos, Lp, I: Integer;
  Bmt: Tbmtable;
begin
  Result := -1;
  if (S = EmptyStr) or (P = EmptyStr) then
    Exit;
  for I := 0 to 255 do
    Bmt[I] := Length(P);
  for I := Length(P) downto 1 do
    if Bmt[Byte(P[I])] = Length(P) then
      Bmt[Byte(P[I])] := Length(P) - I;
  Lp := Length(P);
  Pos := Startpos + Lp - 1;
  while Pos <= Length(S) do
    if P[Lp] <> S[Pos] then
      Pos := Pos + Bmt[Byte(S[Pos])]
    else if Lp = 1 then
    begin
      Result := Pos;
      Exit;
    end
    else
      for I := Lp - 1 downto 1 do
        if P[I] <> S[Pos - Lp + I] then
        begin
          Inc(Pos);
          Break;
        end
        else if I = 1 then
        begin
          Result := Pos - Lp + 1;
          Exit;
        end;
  Result := -1;
end;

function Taillinetail(Ahistory: string; Alinescount: Integer): string;
var
  List: Tstringlist;
  I, F: Integer;
begin
  // Создаём стринглист для разбивки строк в истории
  List := Tstringlist.Create;
  try
    // Заносим историю в лист
    List.Text := Ahistory;
    // Определяем макс количество строк в истории
    if Alinescount > List.Count then
      F := List.Count
    else
      F := Alinescount;
    // Вычисляем обратный отсчёт
    F := List.Count - F;
    // Запускаем цикл граббинда посдежних сообщений из истории
    for I := List.Count - 1 downto F do
      Result := Result + List.Strings[I] + #13#10;
    // Заносим результат снова в список
    List.Text := Result;
    // Обнуляем результат
    Result := EmptyStr;
    // Переворачиваем строки в списке
    for I := List.Count - 1 downto 0 do
      Result := Result + List.Strings[I] + #13#10;
  finally
    List.Free;
  end;
end;

function Gettimezone: Integer;
var
  Timezone: Ttimezoneinformation;
begin
  Gettimezoneinformation(Timezone);
  Result := Timezone.Bias div -60;
end;

function Unixtodatetime(const Avalue: Int64): Tdatetime;
const
  Unixdatedelta = 25569;
begin
  // Вычисляем время из юникс представления времени
  Result := ((Avalue / Secsperday) + Unixdatedelta) + Gettimezone * Hour;
  // Почему то + 1 час нужно добавить для точности
  Result := Result + Hour;
end;

function Numtoip(Addr: Longword): string;
var
  Inaddr: In_addr;
begin
  Inaddr.S_addr := Addr;
  Result := Inet_ntoa(Inaddr);
end;

function Dump(Data: RawByteString): string;
const
  Cols = 16;
var
  Ofs, I: Integer;
  S1, S2: string;
begin
  Result := EmptyStr;
  Ofs := 0;
  while Ofs < Length(Data) do
  begin
    S1 := EmptyStr;
    S2 := EmptyStr;
    for I := 1 to Cols do
      if Ofs + I <= Length(Data) then
      begin
        S1 := S1 + IntToHex(Ord(Data[Ofs + I]), 2);
        if I = 8 then
          S1 := S1 + '  '
        else
          S1 := S1 + ' ';
        if Data[Ofs + I] < #32 then
          S2 := S2 + '.'
        else
          S2 := S2 + Data[Ofs + I];
      end;
    S1 := S1 + StringOfChar(' ', Cols * 3 + 4 - Length(S1));
    Result := Result + S1 + S2 + RN;
    Inc(Ofs, Cols);
  end;
end;

function Icq_bodysize: Integer;
var
  Header: string;
begin
  Header := Text2hex(ICQ_BuffPkt[5] + ICQ_BuffPkt[6]);
  Result := Hextoint(Header);
end;

function Icq_bodysize_avatar: Integer;
var
  Header: string;
begin
  Header := Text2hex(Icq_avatar_hexpkt[5] + Icq_avatar_hexpkt[6]);
  Result := Hextoint(Header);
end;

function Mra_bodysize: Integer;
var
  Header: string;
begin
  Header := Text2hex(Mra_hexpkt[35] + Mra_hexpkt[36] + Mra_hexpkt[33] + Mra_hexpkt[34]);
  Result := Hextoint(Header);
end;

procedure Sendflap(Channel, Data: string);
var
  Str: RawByteString;
  Len: Integer;
begin
  // Вычисляем длинну данных
  Len := Length(Hex2text(Data));
  // Преобразуем данные в бинарный формат
  Str := Hex2text('2A0' + Channel + IntToHex(Icq_seq, 4) + IntToHex(Len, 4) + Data);
  // Пишем в лог данные пакета
  if LogForm.ICQDumpSpeedButton.Down then
    XLog('ICQ send | ' + RN + Trim(Dump(Str)));
  // Отсылаем данные по сокету
  Mainform.Icqwsocket.SendStr(Str);
  // Увеличиваем счётчик пакетов
  Inc(Icq_seq);
end;

procedure Sendflap_avatar(Channel, Data: string);
var
  Str: RawByteString;
  Len: Integer;
begin
  // Вычисляем длинну данных
  Len := Length(Hex2text(Data));
  // Преобразуем данные в бинарный формат
  Str := Hex2text('2A0' + Channel + IntToHex(ICQ_Avatar_Seq, 4) + IntToHex(Len, 4) + Data);
  // Пишем в лог данные пакета
  if LogForm.ICQDumpSpeedButton.Down then
    XLog('ICQ avatar send | ' + RN + Trim(Dump(Str)));
  // Отсылаем данные по сокету
  Mainform.Icqavatarwsocket.SendStr(Str);
  // Увеличиваем счётчик пакетов
  Inc(ICQ_Avatar_Seq);
end;

procedure Sendflap_mra(Pkttype, Data: string; Nolen: Boolean = False);
var
  Str: RawByteString;
  Len: Integer;
begin
  // Вычисляем длинну данных
  if not Nolen then
    Len := Length(Hex2text(Data))
  else
    Len := 0;
  // Преобразуем данные в бинарный формат
  Str := Hex2text(Mra_magkey + Mra_protover + IntToHex(Swap32(Mra_seq), 8) + Pkttype + IntToHex(Swap32(Len), 8) + Data);
  // Пишем в лог данные пакета
  if LogForm.MRADumpSpeedButton.Down then
    XLog('MRA send | ' + RN + Trim(Dump(Str)));
  // Отсылаем данные по сокету
  Mainform.Mrawsocket.SendStr(Str);
  // Увеличиваем счётчик пакетов
  Inc(Mra_seq);
end;

function Datetimechatmess: string;
begin
  // YYYYMMDDHHNNSS
  Result := Formatdatetime('HH:NN:SS', Time) + ' ' + Formatdatetime('DD.MM.YYYY', Date);
end;

function Exnormalizeicqnumber(Sn: string): string;

function Deletedashes(const Value: string): string;
var
  Counter, I: Integer;
begin
  Counter := 0;
  SetLength(Result, Length(Value));
  for I := 1 to Length(Value) do
    if Value[I] <> '-' then
    begin
      Inc(Counter);
      Result[Counter] := Value[I];
    end;
  SetLength(Result, Counter);
end;

begin
  Result := Deletedashes(Sn);
end;

function Changespaces(const Value: string): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to Length(Value) do
  begin
    if Value[I] = ' ' then
      Result := Result + '%20'
    else
      Result := Result + Value[I];
  end;
end;

function Changeslash(const Value: string): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to Length(Value) do
  begin
    if Value[I] = '\' then
      Result := Result + '/'
    else
      Result := Result + Value[I];
  end;
end;

function Deletespaces(const Value: string): string;
var
  Counter, I: Integer;
begin
  Counter := 0;
  SetLength(Result, Length(Value));
  for I := 1 to Length(Value) do
    if Value[I] <> ' ' then
    begin
      Inc(Counter);
      Result[Counter] := Value[I];
    end;
  SetLength(Result, Counter);
end;

function Exnormalizescreenname(Sn: string): string;
begin
  Result := Lowercase(Deletespaces(Sn));
end;

function Normalizecellularnumber(const Value: string): string;
var
  Counter, I: Integer;
begin
  Counter := 0;
  SetLength(Result, Length(Value));
  for I := 1 to Length(Value) do
    if (Value[I] <> ' ') and (Value[I] <> '-') and (Value[I] <> '(') and (Value[I] <> ')') and (Value[I] <> 'S') and (Value[I] <> 'M') then
    begin
      Inc(Counter);
      Result[Counter] := Value[I];
    end;
  SetLength(Result, Counter);
end;

function Deletelinebreaks(const S: string): string;
var
  Source, Sourceend: PChar;
begin
  Source := Pointer(S);
  Sourceend := Source + Length(S);
  while Source < Sourceend do
  begin
    case Source^ of
      #10:
        Source^ := #32;
      #13:
        Source^ := #32;
    end;
    Inc(Source);
  end;
  Result := S;
end;

function Hextoint(Value: string): Longword;
const
  Hexstr: string = '0123456789ABCDEF';
var
  I: Word;
begin
  Result := 0;
  if Value = EmptyStr then
    Exit;
  for I := 1 to Length(Value) do
    Inc(Result, (Pos(Upcase(Value[I]), Hexstr) - 1) shl ((Length(Value) - I) shl 2));
end;

function Hex2text(HexText: string): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to Length(HexText) div 2 do
    Result := Result + Ansichar(StrToInt('$' + Copy(HexText, (I - 1) * 2 + 1, 2)));
end;

function Text2hex(Msg: RawByteString): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to Length(Msg) do
  begin
    Result := Result + IntToHex(Ord(Msg[I]), 2);
  end;
end;

function Rightstr(const Str: string; Size: Word): string;
var
  Len: Integer;
begin
  Len := Length(Str);
  if Size > Len then
    Size := Len;
  Result := Copy(Str, Len - Size + 1, Size);
end;

function Leftstr(const Str: string; Size: Word): string;
begin
  Result := Copy(Str, 1, Size);
end;

function Nextdata(var Data: string; Count: Integer): string;
var
  Blok: string;
begin
  if Count <= 0 then
  begin
    Result := EmptyStr;
    Exit;
  end;
  if Count > Length(Data) then
  begin
    Result := Data;
    SetLength(Data, 0);
    Exit;
  end;
  Blok := Leftstr(Data, Count);
  Data := Rightstr(Data, Length(Data) - Count);
  Result := Blok;
end;

function Swap16(Value: Word): Word;
assembler;
asm
  rol   ax,8
end
;

function Swap32(Value: Longword): Longword;
assembler;
asm
  bswap eax
end
;

{$WARNINGS OFF}

procedure Gettreedirs(Root: string; out Outstring: Tstringlist);
var
  Sresult: Tsearchrec;
begin
  Outstring := Tstringlist.Create();
  if not Directoryexists(Root) then
    Exit;
  Root := Includetrailingbackslash(Root);
  Setcurrentdir(Root);
  if Findfirst('*', Faanyfile, Sresult) = 0 then
  begin
    repeat
      if (Sresult.name <> '.') and (Sresult.name <> '..') and ((Sresult.Attr and Fadirectory) = Fadirectory) then
        Outstring.Add(Sresult.name);
    until Findnext(Sresult) <> 0;
    Findclose(Sresult);
  end;
end;

{$WARNINGS ON}

function Initmixer: Hmixer;
var
  Err: Mmresult;
begin
  Err := Mixeropen(@Result, 0, 0, 0, 0);
  if Err <> Mmsyserr_noerror then
    Result := 0;
end;

function Parse(Char, S: string; Count: Integer): string;
var
  I: Integer;
  T: string;
begin
  if S = EmptyStr then
    Exit;
  if S[Length(S)] <> Char then
    S := S + Char;
  for I := 1 to Count do
  begin
    T := Copy(S, 0, Pos(Char, S) - 1);
    S := Copy(S, Pos(Char, S) + 1, Length(S));
  end;
  Result := T;
end;

procedure Listfiledirhist(Path, Ext, Eext: string; Filelist: Tstrings);
var
  Sr: Tsearchrec;
begin
  if Findfirst(Path + '\' + Ext, Faanyfile, Sr) = 0 then
  begin
    repeat
      if (Sr.Attr <> Fadirectory) then
      begin
        Filelist.Add(Parse(Eext, Sr.name, 1));
      end;
    until Findnext(Sr) <> 0;
    Findclose(Sr);
  end;
end;

procedure Popup(Compon: Tcomponent; Pm: Tpopupmenu);
var
  Xpoint: Tpoint;
begin
  Getparentform(Twincontrol(Compon)).Sendcancelmode(nil);
  Pm.Popupcomponent := Twincontrol(Compon);
  Xpoint := Point(Twincontrol(Compon).Width, Twincontrol(Compon).Top);
  with Twincontrol(Compon).Clienttoscreen(Xpoint) do
    Pm.Popup(X, Y);
end;

procedure Popup_down(Compon: Tcomponent; Pm: Tpopupmenu);
var
  Xpoint: Tpoint;
begin
  Getparentform(Twincontrol(Compon)).Sendcancelmode(nil);
  Pm.Popupcomponent := Twincontrol(Compon);
  Xpoint := Point(Twincontrol(Compon).Width, Twincontrol(Compon).Top);
  with Twincontrol(Compon).Clienttoscreen(Xpoint) do
    Pm.Popup(X - 14, Y + 22);
end;

function Initbuildinfo: string;
var
  S, Ts: string;
  H, Sz, Len: DWORD;
  Buf: PChar;
  Value: Pointer;
begin
  Result := EmptyStr;
  //
  S := Application.Exename;
  Sz := Getfileversioninfosize(PChar(S), H);
  if Sz > 0 then
  begin
    try
      Buf := Allocmem(Sz);
      Getfileversioninfo(PChar(S), H, Sz, Buf);
      Verqueryvalue(Buf, '\VarFileInfo\Translation', Value, Len);
      Ts := IntToHex(Makelong(Hiword(Longint(Value^)), Loword(Longint(Value^))), 8);
      // Получаем номер билда
      Verqueryvalue(Buf, PChar('StringFileInfo\' + Ts + '\FileVersion'), Pointer(Value), Len);
      if Len > 1 then
        Result := Strpas(PChar(Value));
    except
    end;
  end;
end;

{$WARNINGS OFF}

function Packettohex(Buffer: Pointer; Buflen: Word): string;
var
  S: string;
  I: Integer;
begin
  for I := 1 to Buflen do
  begin
    S := S + IntToHex(Pbyte(Longword(Buffer) + I - 1)^, 2);
  end;
  Result := S;
end;

{$WARNINGS ON}

function Getrandomhexbytes(Bytescount: Integer): string;
const
  Bit16 = '0123456789abcdef';
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 0 to Bytescount do
  begin
    Result := Result + Bit16[Random(15) + 1];
  end;
end;

function Errorhttpclient(Errcode: Integer): string;
begin
  case Errcode of
    0:
      Result := SocketConnErrorInfo_1;
    400:
      Result := Err400;
    401:
      Result := Err401;
    402:
      Result := Err402;
    403:
      Result := Err403;
    404:
      Result := Err404;
    405:
      Result := Err405;
    406:
      Result := Err406;
    407:
      Result := Err407;
    408:
      Result := Err408;
    409:
      Result := Err409;
    410:
      Result := Err410;
    411:
      Result := Err411;
    412:
      Result := Err412;
    413:
      Result := Err413;
    414:
      Result := Err414;
    415:
      Result := Err415;
    416:
      Result := Err416;
    417:
      Result := Err417;
    500:
      Result := Err500;
    501:
      Result := Err501;
    502:
      Result := Err502;
    503:
      Result := Err503;
    504:
      Result := Err504;
    505:
      Result := Err505
    else
      Result := SocketConnErrorInfo_1;
  end;
  Result := Result + #13#10 + Format(HttpSocketErrCodeL, [Errcode]);
end;

function Min(const A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

// Thanks Exodus Project
function Getfulltag(Adata: string): string;

function Rpos(Find_data, In_data: string): Cardinal;
var
  Lastpos, Newpos: Cardinal;
  Mybuff: string;
  Origlen: Cardinal;
begin
  Lastpos := 0;
  Newpos := 0;
  Origlen := Length(Adata);
  repeat
    Mybuff := Copy(In_data, Lastpos + 1, Origlen - Newpos);
    Newpos := Pos(Find_data, Mybuff);
    if (Newpos > 0) then
    begin
      Lastpos := Lastpos + Newpos;
    end;
  until (Newpos <= 0);
  Result := Lastpos;
end;

var
  Froot, Sbuff, R, Stag, Etag, Tmps: string;
  P, Ls, Le, E, L, Ps, Pe, Ws, Sp, Tb, Cr, Nl, I: Longint;
  _counter: Integer;
begin
  Froot := EmptyStr;
  Result := EmptyStr;
  _counter := 0;
  Sbuff := Adata;
  L := Length(Sbuff);
  if (Trim(Sbuff)) = EmptyStr then
    Exit;
  P := Pos('<', Sbuff);
  if P <= 0 then
  begin
    Dashow(Errorhead, Parsingpkterror, EmptyStr, 134, 2, 0);
    Exit;
  end;
  Tmps := Copy(Sbuff, P, L - P + 1);
  E := Pos('>', Tmps);
  I := Pos('/>', Tmps);
  if ((E = 0) and (I = 0)) then
    Exit;
  if Froot = EmptyStr then
  begin
    Sp := Pos(' ', Tmps);
    Tb := Pos(#09, Tmps);
    Cr := Pos(#10, Tmps);
    Nl := Pos(#13, Tmps);
    Ws := Sp;
    if (Tb > 0) then
      Ws := Min(Ws, Tb);
    if (Cr > 0) then
      Ws := Min(Ws, Cr);
    if (Nl > 0) then
      Ws := Min(Ws, Nl);
    if ((I > 0) and (I < Ws)) then
      Froot := Trim(Copy(Sbuff, P + 1, I - 2))
    else if (E < Ws) then
      Froot := Trim(Copy(Sbuff, P + 1, E - 2))
    else
      Froot := Trim(Copy(Sbuff, P + 1, Ws - 2));
    if (Froot = '?xml') or (Froot = '!ENTITY') or (Froot = '!--') or (Froot = '!ATTLIST') or (Froot = Froottag) then
    begin
      R := Copy(Sbuff, P, E);
      Froot := EmptyStr;
      Jabber_buffpkt := Copy(Sbuff, P + E, L - E - P + 1);
      Result := R;
      Exit;
    end;
  end;
  if (E = (I + 1)) then
  begin
    R := Copy(Sbuff, P, E);
    Froot := EmptyStr;
    Jabber_buffpkt := Copy(Sbuff, P + E, L - E - P + 1);
  end
  else
  begin
    I := P;
    Stag := '<' + Froot;
    Etag := '</' + Froot + '>';
    Ls := Length(Stag);
    Le := Length(Etag);
    R := EmptyStr;
    repeat
      Tmps := Copy(Sbuff, I, L - I + 1);
      Ps := Pos(Stag, Tmps);
      if (Ps > 0) then
      begin
        _counter := _counter + 1;
        I := I + Ps + Ls - 1;
      end;
      Tmps := Copy(Sbuff, I, L - I + 1);
      Pe := Rpos(Etag, Tmps);
      if ((Pe > 0) and ((Ps > 0) and (Pe > Ps))) then
      begin
        _counter := _counter - 1;
        I := I + Pe + Le - 1;
        if (_counter <= 0) then
        begin
          R := Copy(Sbuff, P, I - P);
          Froot := EmptyStr;
          Jabber_buffpkt := Copy(Sbuff, I, L - I + 1);
          Break;
        end;
      end;
    until ((Pe <= 0) or (Ps <= 0) or (Tmps = EmptyStr));
  end;
  Result := R;
end;

procedure Implaysnd(Snd: Integer);
begin
  // Играем звуки imadering
  {
    0 - Старт программы
    1 - Входящее сообщение
    }
  try
    if Soundon then
    begin
      case Snd of
        0:
          if (Soundstartprog) and (FileExists(Soundstartprogpath)) then
            Sndplaysound(PChar(Soundstartprogpath), Snd_async);
        1:
          if (Soundincmsg) and (FileExists(Soundincmsgpath)) then
            Sndplaysound(PChar(Soundincmsgpath), Snd_async);
      end;
    end;
  except
  end;
end;

function Searchnickincash(Ctype, Cid: string): string;
var
  I: Integer;
begin
  Result := Cid;
  try
    // Проверяем создан ли список ников
    if Assigned(Accounttonick) then
    begin
      // Находим ники в списке ников по учётной записи
      for I := 0 to Accounttonick.Count - 1 do
      begin
        if (Ctype + '_' + Cid) = Accounttonick.Strings[I] then
        begin
          Result := Accounttonick.Strings[I + 1];
          // Выходим из цикла
          Break;
        end;
      end;
    end;
  except
  end;
end;

function Copydir(const Fromdir, Todir: string): Boolean;
var
  Fos: Tshfileopstruct;
begin
  Zeromemory(@Fos, SizeOf(Fos));
  with Fos do
  begin
    Wfunc := Fo_copy;
    Fflags := Fof_filesonly;
    Pfrom := PChar(Fromdir + #0);
    Pto := PChar(Todir)
  end;
  Result := (0 = Shfileoperation(Fos));
end;

{$WARNINGS OFF}

function Cleardir(const Path: string; Delete: Boolean): Boolean;
const
  Filenotfound = 18;
var
  Fileinfo: Tsearchrec;
  Doscode: Integer;
begin
  Result := Directoryexists(Path);
  if not Result then
    Exit;
  Doscode := Findfirst(Path + '*.*', Faanyfile, Fileinfo);
  try
    while Doscode = 0 do
    begin
      if (Fileinfo.name[1] <> '.') then
      begin
        if (Fileinfo.Attr and Fadirectory = Fadirectory) then
          Result := Cleardir(Path + Fileinfo.name, Delete) and Result
        else
        begin
          if (Fileinfo.Attr and Fareadonly = Fareadonly) then
            Filesetattr(Path + Fileinfo.name, Faarchive);
          Result := Deletefile(Path + Fileinfo.name) and Result;
        end;
      end;
      Doscode := Findnext(Fileinfo);
    end;
  finally
    Findclose(Fileinfo);
  end;
  if Delete and Result and (Doscode = Filenotfound) and not((Length(Path) = 2) and (Path[2] = ':')) then
  begin
    Rmdir(Path);
    Result := (Ioresult = 0) and Result;
  end;
end;

{$WARNINGS ON}

procedure SetcustomWidthCombobox(Cb: Tcombobox);
var
  I, Itemwidth, Cwidth: Integer;
begin
  // Выравниваем ширину списка по самой длинной строке
  Itemwidth := 0;
  with Cb do
  begin
    for I := 0 to Items.Count - 1 do
    begin
      Cwidth := Application.Mainform.Canvas.Textwidth(Items.Strings[I]);
      if Cwidth > Itemwidth then
        Itemwidth := Cwidth;
    end;
    if Items.Count > Dropdowncount then
      Perform(Cb_setdroppedwidth, Itemwidth + 25, 0)
    else
      Perform(Cb_setdroppedwidth, Itemwidth + 8, 0);
  end;
end;

procedure OpenUrl(Url: string);
var
  Ts: string;
begin
  // Ищем в реестре браузер по умолчанию
  with Tregistry.Create do
    try
      Rootkey := Hkey_classes_root;
      Openkey('\http\shell\open\command', False);
      try
        Ts := Readstring(EmptyStr);
      except
        Ts := EmptyStr;
      end;
      Closekey;
    finally
      Free;
    end;
  if Ts = EmptyStr then
  begin
    Setclipboardtext(Application.Handle, Url);
    Dashow(Errorhead, Urlopenerrl, EmptyStr, 134, 2, 0);
    Exit;
  end;
  if Bmsearch(0, Ts, '"') > -1 then
    Ts := Parse('"', Ts, 2);
  // Проверяем под wine запущена программа или нет
  if Bmsearch(0, Ts, 'winebrowser.exe') = -1 then
    Url := Changespaces(Url) // Преобразуем пробелы в %20
  else
  begin
    if Bmsearch(0, Url, ':\') > -1 then
      Url := '"' + Changeslash(Url) + '"'; // Для открытия в winebrowser
  end;
  Shellexecute(0, 'open', PChar(Ts), PChar(Url), nil, Sw_show);
end;

function CreateHistoryArhive(HFile: string): Boolean;
var
  AFormat: TJclCompressArchiveClass;
  FArchive: TJclCompressionArchive;
  FCompressionLevel: IJclArchiveCompressionLevel;
  FCompressHeader: IJclArchiveCompressHeader;
  FSaveCreationDateTime: IJclArchiveSaveCreationDateTime;
  FSaveLastAccessDateTime: IJclArchiveSaveLastAccessDateTime;
  HArhFile: string;
  N: integer;
begin
  Result := False;
  // Проверяем размер файла истории
  if Getfilesize(HFile) > 1000000 then
  begin
    FreeAndNil(FArchive);
    // Проверяем какой номер архива свободен
    N := 1;
    HArhFile := Copy(HFile, 1, Length(HFile) - 4);
    while FileExists(HArhFile + ' [' + IntToStr(N) + '].7z') do
      Inc(N);
    HArhFile := HArhFile + ' [' + IntToStr(N) + '].7z';
    // Инициализируем архиватор по расширению 7z
    AFormat := GetArchiveFormats.FindCompressFormat(HArhFile);
    if AFormat <> nil then
    begin
      // Устанавливаем параметры архивирования
      FArchive := AFormat.Create(HArhFile);
      FArchive.Password := ''; (FArchive as TJclCompressArchive)
      .AddFile(ExtractFileName(HFile), HFile);
      Supports(IUnknown(FArchive), IJclArchiveCompressionLevel, FCompressionLevel);
      Supports(IUnknown(FArchive), IJclArchiveCompressHeader, FCompressHeader);
      Supports(IUnknown(FArchive), IJclArchiveSaveCreationDateTime, FSaveCreationDateTime);
      Supports(IUnknown(FArchive), IJclArchiveSaveLastAccessDateTime, FSaveLastAccessDateTime);
      FCompressionLevel.CompressionLevel := 9;
      FCompressHeader.CompressHeader := True;
      FCompressHeader.CompressHeaderFull := True;
      FSaveLastAccessDateTime.SaveLastAccessDateTime := False;
      FSaveCreationDateTime.SaveCreationDateTime := False;
      // Упаковываем файл архиватором 7zip
      CompresHistoryProcess := True; (FArchive as TJclCompressArchive)
      .Compress;
      // Завершаем процесс архивирования
      FreeAndNil(FArchive);
      CompresHistoryProcess := False;
    end;
    Result := True;
  end;
end;

end.