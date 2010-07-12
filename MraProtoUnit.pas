﻿{ *******************************************************************************
  Copyright (c) 2004-2010 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
  ******************************************************************************* }

unit MraProtoUnit;

interface

{$REGION 'Uses'}

uses
  Windows,
  MainUnit,
  MraOptionsUnit,
  SysUtils,
  JvTrayIcon,
  Dialogs,
  OverbyteIcsWSocket,
  ChatUnit,
  MmSystem,
  Forms,
  ComCtrls,
  Messages,
  Classes,
  IcqContactInfoUnit,
  VarsUnit,
  Graphics,
  CategoryButtons;

{$ENDREGION}
{$REGION 'Const Users Statuses'}

const
  // Коды статусов
  M_OFFLINE = '00000000';
  M_ONLINE = '010000000D0000005354415455535F4F4E4C494E4506000000CEEDEBE0E9ED';
  M_AWAY = '020000000B0000005354415455535F4157415906000000CEF2EEF8E5EB';
  M_UNDETERMINATED = '03000000';
  M_FFC = '040000000B0000007374617475735F636861740F000000C3EEF2EEE220EFEEE1EEEBF2E0F2FC';
  M_DND = '040000000A0000007374617475735F646E640D000000CDE520E1E5F1EFEEEAEEE8F2FC';
  M_INVISIBLE = '01000080100000005354415455535F494E56495349424C4507000000CDE5E2E8E4E8EC';

{$ENDREGION}
{$REGION 'Const XStatuses'}

  // Доп. статусы
  M_1 = '04000000080000007374617475735F35';
  M_2 = '04000000090000007374617475735F3138';
  M_3 = '04000000090000007374617475735F3139';
  M_4 = '04000000080000007374617475735F37';
  M_5 = '04000000090000007374617475735F3130';
  M_6 = '04000000090000007374617475735F3437';
  M_7 = '04000000090000007374617475735F3232';
  M_8 = '04000000090000007374617475735F3236';
  M_9 = '04000000090000007374617475735F3234';
  M_10 = '04000000090000007374617475735F3237';
  M_11 = '04000000090000007374617475735F3233';
  M_12 = '04000000080000007374617475735F34';
  M_13 = '04000000080000007374617475735F39';
  M_14 = '04000000080000007374617475735F36';
  M_15 = '04000000090000007374617475735F3231';
  M_16 = '04000000090000007374617475735F3230';
  M_17 = '04000000090000007374617475735F3137';
  M_18 = '04000000080000007374617475735F38';
  M_19 = '04000000090000007374617475735F3135';
  M_20 = '04000000090000007374617475735F3136';
  M_21 = '04000000090000007374617475735F3238';
  M_22 = '04000000090000007374617475735F3531';
  M_23 = '04000000090000007374617475735F3532';
  M_24 = '04000000090000007374617475735F3436';
  M_25 = '04000000090000007374617475735F3132';
  M_26 = '04000000090000007374617475735F3133';
  M_27 = '04000000090000007374617475735F3131';
  M_28 = '04000000090000007374617475735F3134';
  M_29 = '04000000090000007374617475735F3438';
  M_30 = '04000000090000007374617475735F3533';
  M_31 = '04000000090000007374617475735F3239';
  M_32 = '04000000090000007374617475735F3330';
  M_33 = '04000000090000007374617475735F3332';
  M_34 = '04000000090000007374617475735F3333';
  M_35 = '04000000090000007374617475735F3430';
  M_36 = '04000000090000007374617475735F3431';
  M_37 = '04000000090000007374617475735F3334';
  M_38 = '04000000090000007374617475735F3335';
  M_39 = '04000000090000007374617475735F3336';
  M_40 = '04000000090000007374617475735F3337';
  M_41 = '04000000090000007374617475735F3338';
  M_42 = '04000000090000007374617475735F3339';
  M_43 = '04000000090000007374617475735F3432';
  M_44 = '04000000090000007374617475735F3433';
  M_45 = '04000000090000007374617475735F3439';
  M_46 = '04000000090000007374617475735F3434';
  M_47 = '04000000090000007374617475735F3435';
  M_48 = '04000000090000007374617475735F3530';

{$ENDREGION}
{$REGION 'Const'}

  // Длинна заголовка в MRA пакетах
  MRA_FLAP_HEAD_SIZE = 44;
  // Пустой набор from и fromport и 16 ресерв
  MRA_Empty = '000000000000000000000000000000000000000000000000';

{$ENDREGION}
{$REGION 'Array Pkt Codes'}

  // Расшифровка пакетов для лога
  MRA_Pkt_Names:
    packed array[0..30] of record
    Pkt_Code: Integer;
    Pkt_Name: string;
  end = ((Pkt_Code: $1001; Pkt_Name: 'HELLO'), // 0
    (Pkt_Code: $1002; Pkt_Name: 'HELLO_ACK'), // 1
    (Pkt_Code: $1004; Pkt_Name: 'LOGIN_ACK'), // 2
    (Pkt_Code: $1005; Pkt_Name: 'LOGIN_REJ'), // 3
    (Pkt_Code: $1006; Pkt_Name: 'PING'), // 4
    (Pkt_Code: $1008; Pkt_Name: 'SEND_MESSAGE'), // 5
    (Pkt_Code: $1009; Pkt_Name: 'MESSAGE_ACK'), // 6
    (Pkt_Code: $1011; Pkt_Name: 'MESSAGE_RECV'), // 7
    (Pkt_Code: $1012; Pkt_Name: 'MESSAGE_STATUS'), // 8
    (Pkt_Code: $100F; Pkt_Name: 'USER_STATUS'), // 9
    (Pkt_Code: $1013; Pkt_Name: 'LOGOUT'), // 10
    (Pkt_Code: $1014; Pkt_Name: 'CONNECTION_PARAMS'), // 11
    (Pkt_Code: $1015; Pkt_Name: 'USER_INFO'), // 12
    (Pkt_Code: $1019; Pkt_Name: 'ADD_CONTACT'), // 13
    (Pkt_Code: $101A; Pkt_Name: 'ADD_CONTACT_ACK'), // 14
    (Pkt_Code: $101B; Pkt_Name: 'MODIFY_CONTACT'), // 15
    (Pkt_Code: $101C; Pkt_Name: 'MODIFY_CONTACT_ACK'), // 16
    (Pkt_Code: $101D; Pkt_Name: 'OFFLINE_MESSAGE_ACK'), // 17
    (Pkt_Code: $101E; Pkt_Name: 'DELETE_OFFLINE_MESSAGE'), // 18
    (Pkt_Code: $1020; Pkt_Name: 'AUTHORIZE'), // 19
    (Pkt_Code: $1021; Pkt_Name: 'AUTHORIZE_ACK'), // 20
    (Pkt_Code: $1022; Pkt_Name: 'CHANGE_STATUS'), // 21
    (Pkt_Code: $1024; Pkt_Name: 'GET_MPOP_SESSION'), // 22
    (Pkt_Code: $1025; Pkt_Name: 'MPOP_SESSION'), // 23
    (Pkt_Code: $1026; Pkt_Name: 'FILE_TRANSFER'), // 24
    (Pkt_Code: $1027; Pkt_Name: 'FILE_TRANSFER_ACK'), // 25
    (Pkt_Code: $1029; Pkt_Name: 'WP_REQUEST'), // 26
    (Pkt_Code: $1028; Pkt_Name: 'ANKETA_INFO'), // 27
    (Pkt_Code: $1033; Pkt_Name: 'MAILBOX_STATUS'), // 28
    (Pkt_Code: $1037; Pkt_Name: 'CONTACT_LIST2'), // 29
    (Pkt_Code: $1038; Pkt_Name: 'LOGIN2')); // 30

{$ENDREGION}
{$REGION 'Vars'}

var
  MRA_Bos_IP: string;
  MRA_Bos_Port: string;
  MRA_myBeautifulSocketBuffer: string;
  MRA_LoginServerAddr: string;
  MRA_LoginServerPort: string;
  MRA_BuffPkt: string;
  MRA_LoginUIN: string;
  MRA_LoginPassword: string;
  MRA_MagKey: string = 'EFBEADDE';
  MRA_ProtoVer: string = '13000100';
  MRA_Ident_Client: string = 'client="IMadering" version="5.0" build="0224"';
  MRA_Ident: string = 'IMR 5.0 (build 0224);';
  MRA_Seq: LongWord = 1;
  // Фазы работы начало
  MRA_Connect_Phaze: Boolean = False;
  MRA_HTTP_Connect_Phaze: Boolean = False;
  MRA_BosConnect_Phaze: Boolean = False;
  MRA_Work_Phaze: Boolean = False;
  MRA_Offline_Phaze: Boolean = True;
  // Фазы работы конец
  MRA_CurrentStatus: Integer = 23;
  MRA_CurrentStatus_bac: Integer = 23;
  MRA_Reconnect: Boolean = False;
  // Другие переменные протокола
  MRA_Bos_Addr: string;
  MRA_Server_Proto_Ver: string;
  MRA_Email_Total: string;
  MRA_Email_Unread: string;
  MRA_MyNick: string;

{$ENDREGION}
{$REGION 'Procedures and Functions'}

procedure MRA_Login_1;
procedure MRA_Login_2;
procedure MRA_AlivePkt;
procedure MRA_ParseUserInfo(PktData: string);
procedure MRA_ParseCL(PktData: string);
procedure MRA_SendMessage(ToEmail, Msg: string);
procedure MRA_MessageRecv(PktData: string);
procedure MRA_SendMessageACK(ToEmail, M_Id: string);
procedure MRA_ParseStatus(PktData: string);
procedure MRA_ParseOfflineMess(PktData: string);
procedure MRA_SendSMS(ToPhone, Mess: string);
procedure MRA_GoOffline;

{$ENDREGION}

implementation

{$REGION 'MyUses'}

uses
  UtilsUnit,
  LogUnit,
  OverbyteIcsUrl;

{$ENDREGION}
{$REGION 'MRA_Login_1'}

procedure MRA_Login_1;
var
  Pkt: string;
begin
  // Формируем пакет первичного логина
  Pkt := MRA_Empty;
  // Отправляем пакет
  Mra_SendPkt('01100000', Pkt, True);
end;

{$ENDREGION}
{$REGION 'MRA_Login_2'}

procedure MRA_Login_2;
var
  Pkt: string;
begin
  // Формируем пакет авторизации на сервере
  Pkt := MRA_Empty + IntToHex(Swap32(Length(MRA_LoginUIN)), 8) + Text2Hex(MRA_LoginUIN) // Логин
  + IntToHex(Swap32(Length(MRA_LoginPassword)), 8) + Text2Hex(MRA_LoginPassword) // Пароль
  + '010000000d0000005354415455535f4f4e4c494e450c0000004f006e006c0069006e00650000000000ff030000' // Пока фиксированная строка статуса при подключении
  + IntToHex(Swap32(Length(MRA_Ident_Client)), 8) + Text2Hex(MRA_Ident_Client) // Идентификатор клиента
  + '02000000' + Text2Hex(V_CurrentLang) // Язык
  + IntToHex(Swap32(Length(MRA_Ident)), 8) + Text2Hex(MRA_Ident); // Официальный идентификатор
  // Отправляем пакет
  Mra_SendPkt('38100000', Pkt, False);
end;

{$ENDREGION}
{$REGION 'MRA_SendMessage'}

procedure MRA_SendMessage(ToEmail, Msg: string);
var
  Pkt: string;
begin
  Pkt := MRA_Empty + '00001000' + IntToHex(Swap32(Length(ToEmail)), 8) + Text2Hex(ToEmail) // Флаг мультисообщения и кому
  + IntToHex(Swap32(Length(Msg) * SizeOf(Char)), 8) + Text2UnicodeLEHex(Msg) + '00000000'; // тест сообщения в UnicodeLE и пустой rtf
  // Отправляем пакет
  Mra_SendPkt('08100000', Pkt, False);
end;

{$ENDREGION}
{$REGION 'MRA_MessageRecv'}

procedure MRA_MessageRecv(PktData: string);
const
  M_Log = 'Message ';
var
  S_Log, M_Id, M_Flag, M_From, Nick, Mess, MsgD, PopMsg, HistoryFile: string;
  Len: Integer;
  RosterItem: TListItem;
begin
  // Если окно сообщений не было создано, то создаём его
  if not Assigned(ChatForm) then
    ChatForm := TChatForm.Create(MainForm);
  // Получаем Id сообщения
  M_Id := Text2Hex(NextData(PktData, 4));
  // Получаем флаг сообщения
  { #define MESSAGE_FLAG_OFFLINE		0001
    #define MESSAGE_FLAG_NORECV		  0004
    #define MESSAGE_FLAG_AUTHORIZE	0008
    #define MESSAGE_FLAG_SYSTEM		  0040
    #define MESSAGE_FLAG_RTF		    0080
    #define MESSAGE_FLAG_CONTACT		0200
    #define MESSAGE_FLAG_NOTIFY		  0400
    #define MESSAGE_FLAG_MULTICAST	1000
    #define MESSAGE_FLAG_NOTIFY		  3000 }
  M_Flag := RightStr(Text2Hex(NextData(PktData, 4)), 4);
  // Получаем отправителя сообщения
  Len := HexToInt(Text2Hex(NextData(PktData, 4)));
  Len := Swap32(Len);
  M_From := NextData(PktData, Len);
  // Получаем текст сообщения
  if (M_Flag = '0001') or (M_Flag = '0004') or (M_Flag = '0040') or (M_Flag = '0080') or (M_Flag = '1000') then
  begin
    Len := HexToInt(Text2Hex(NextData(PktData, 4)));
    Len := Swap32(Len);
    Mess := Text2XML(UnicodeLEHex2Text(Text2Hex(NextData(PktData, Len))));
  end;
  // Обрабатываем сообщение и отображаем
  if (M_From <> EmptyStr) and (Mess <> EmptyStr) then
  begin
    // Отсылаем подтверждение о доставке
    if (M_Flag <> '0004') and (M_Flag <> '0400') and (M_Flag <> '3000') then
      MRA_SendMessageACK(M_From, M_Id);
    // Форматируем сообщение
    CheckMessage_BR(Mess);
    ChatForm.CheckMessage_ClearTag(Mess);
    PopMsg := Mess;
    // Ищем эту запись в Ростере
    {RosterItem := RosterForm.ReqRosterItem(M_From);
    if RosterItem <> nil then
    begin
      // Выставляем параметры сообщения в этой записи
      with RosterItem do
      begin
        // Ник контакта из Ростера
        Nick := URLDecode(SubItems[0]);
        // Дата сообщения
        MsgD := Nick + ' [' + DateTimeChatMess + ']';
        // Записываем историю в этот контакт если он уже найден в списке контактов
        SubItems[15] := URLEncode(PopMsg);
        SubItems[35] := '0';
      end;
    end
    else // Если такой контакт не найден в Ростере, то добавляем его
    begin
      // Если ник не нашли в Ростере, то ищем его в файле-кэше ников
      Nick := SearchNickInCash(C_Mra, M_From);
      // Дата сообщения
      MsgD := Nick + ' [' + DateTimeChatMess + ']';
      // Ищем группу "Не в списке" в Ростере
      RosterItem := RosterForm.ReqRosterItem(C_NoCL);
      if RosterItem = nil then // Если группу не нашли
      begin
        // Добавляем такую группу в Ростер
        RosterItem := RosterForm.RosterJvListView.Items.Add;
        RosterItem.Caption := C_NoCL;
        // Подготавиливаем все значения
        RosterForm.RosterItemSetFull(RosterItem);
        RosterItem.SubItems[1] := URLEncode(Lang_Vars[33].L_S);
      end;
      // Добавляем этот контакт в Ростер
      RosterItem := RosterForm.RosterJvListView.Items.Add;
      with RosterItem do
      begin
        Caption := M_From;
        // Подготавиливаем все значения
        RosterForm.RosterItemSetFull(RosterItem);
        // Обновляем субстроки
        SubItems[0] := URLEncode(Nick);
        SubItems[1] := C_NoCL;
        SubItems[2] := 'none';
        SubItems[3] := C_Mra;
        SubItems[6] := '25';
        SubItems[15] := URLEncode(PopMsg);
        SubItems[35] := '0';
      end;
      // Запускаем таймер задержку событий Ростера
      MainForm.JvTimerList.Events[11].Enabled := False;
      MainForm.JvTimerList.Events[11].Enabled := True;
    end;}
    // Записываем история в файл истории с этим контактов
    HistoryFile := V_ProfilePath + C_HistoryFolder + C_Mra + C_BN + MRA_LoginUIN + C_BN + M_From + '.htm';
    Mess := Text2XML(Mess);
    CheckMessage_BR(Mess);
    DecorateURL(Mess);
    SaveTextInHistory('<span class=b>' + MsgD + '</span><br><span class=c>' + Mess + '</span><br><br>', HistoryFile);
    // Добавляем сообщение в текущий чат
    RosterItem.SubItems[36] := 'X';
    if ChatForm.AddMessInActiveChat(Nick, PopMsg, M_From, MsgD, Mess) then
      RosterItem.SubItems[36] := EmptyStr;
  end;
  // Пишем в лог
  S_Log := S_Log + M_Log + C_PN + 'Id: ' + M_Id + C_LN + 'Flag: ' + M_Flag + C_LN //
  + 'From: ' + M_From + C_LN + 'Text: ' + Mess;
  XLog(C_Mra + Log_Parsing + MRA_Pkt_Names[6].Pkt_Name + C_RN + Trim(S_Log), C_Mra);
end;

{$ENDREGION}
{$REGION 'MRA_SendMessageACK'}

procedure MRA_SendMessageACK(ToEmail, M_Id: string);
var
  Pkt: string;
begin
  // Формируем пакет подтверждения о получении сообщения
  Pkt := MRA_Empty + IntToHex(Swap32(Length(ToEmail)), 8) + Text2Hex(ToEmail) // Кому отсылаем подтверждение
  + M_Id;
  // Отправляем пакет
  Mra_SendPkt('11100000', Pkt, False);
end;

{$ENDREGION}
{$REGION 'MRA_SendSMS'}

procedure MRA_SendSMS(ToPhone, Mess: string);
var
  Pkt: string;
begin
  // Формируем пакет подтверждения о получении сообщения
  Pkt := MRA_Empty + '00000000' + IntToHex(Swap32(Length(ToPhone)), 8) + Text2Hex(ToPhone) // Кому отсылаем Телефон +7...
  + IntToHex(Swap32(Length(Mess) * SizeOf(Char)), 8) + Text2UnicodeLEHex(Mess); // Текст SMS сообщения 41 символ
  // Отправляем пакет
  Mra_SendPkt('39100000', Pkt, False);
end;

{$ENDREGION}
{$REGION 'MRA_AlivePkt'}

procedure MRA_AlivePkt;
var
  Pkt: string;
begin
  // Формируем пакет Ping
  Pkt := MRA_Empty;
  // Отправляем пакет
  Mra_SendPkt('06100000', Pkt, True);
end;

{$ENDREGION}
{$REGION 'MRA_ParseUserInfo'}

procedure MRA_ParseUserInfo(PktData: string);
var
  S_Log, S: string;
  Len: Integer;

  function GetLast: string;
  begin
    Result := EmptyStr;
    Len := HexToInt(Text2Hex(NextData(PktData, 4)));
    Len := Swap32(Len);
    Result := UnicodeLEHex2Text(Text2Hex(NextData(PktData, Len)));
  end;

begin
  // Разбираем все данные пакета
  while Length(PktData) > 0 do
  begin
    // Получаем длинну TLV
    Len := HexToInt(Text2Hex(NextData(PktData, 4)));
    Len := Swap32(Len);
    // Получаем данные TLV
    S := NextData(PktData, Len);
    if IsValidUnicode(S, True) then
      S := UnicodeLEHex2Text(Text2Hex(S));
    // Для лога
    S_Log := S_Log + S + C_RN;
    // Получаем информацию
    if S = 'MESSAGES.TOTAL' then
    begin
      MRA_Email_Total := GetLast;
      S_Log := S_Log + MRA_Email_Total + C_RN;
    end
    else if S = 'MESSAGES.UNREAD' then
    begin
      MRA_Email_Unread := GetLast;
      S_Log := S_Log + MRA_Email_Unread + C_RN;
      // Сообщаем всплывашкой сколько Email сообщений
      if MRA_Email_Unread <> '0' then
        DAShow(Lang_Vars[16].L_S, Format(Lang_Vars[59].L_S, [MRA_Email_Unread, MRA_Email_Total]), EmptyStr, 133, 3, 60000);
    end
    else if S = 'MRIM.NICKNAME' then
    begin
      MRA_MyNick := GetLast;
      S_Log := S_Log + MRA_MyNick + C_RN;
    end;
  end;
  // Пишем в лог данные пакета
  XLog(C_Mra + Log_Parsing + MRA_Pkt_Names[12].Pkt_Name + C_RN + Trim(S_Log), C_Mra);
end;

{$ENDREGION}
{$REGION 'MRA_ParseCL'}

procedure MRA_ParseCL(PktData: string);
const
  G_Log = 'Group';
  C_Log = 'Contact';
var
  UL, S_Log, G_Mask, C_Mask, G_Id, G_Name, C_Email, C_Phone: string;
  C_Status, C_StatusId, C_XText, C_Client, Unk: string;
  I, M, Len, G_Count: Integer;
  C_Auth: Boolean;
  ListItemD: TListItem;
begin
  {// Получаем ошибки списка контактов
  UL := Text2Hex(NextData(PktData, 4));
  S_Log := S_Log + 'UL: ' + UL + C_RN;
  // Если ошибок в списке контактов нет
  if UL = '00000000' then
  begin
    // Начинаем добаление записей контактов в Ростер
    RosterForm.RosterJvListView.Items.BeginUpdate;
    try
      // Получаем количество групп
      G_Count := HexToInt(Text2Hex(NextData(PktData, 4)));
      G_Count := Swap32(G_Count);
      S_Log := S_Log + G_Log + 'count: ' + IntToStr(G_Count) + C_RN;
      // Получаем маску группы
      Len := HexToInt(Text2Hex(NextData(PktData, 4)));
      Len := Swap32(Len);
      G_Mask := NextData(PktData, Len);
      S_Log := S_Log + G_Log + 'mask: ' + G_Mask + C_RN;
      // Получаем маску контакта
      Len := HexToInt(Text2Hex(NextData(PktData, 4)));
      Len := Swap32(Len);
      C_Mask := NextData(PktData, Len);
      S_Log := S_Log + C_Log + 'mask: ' + C_Mask + C_RN;
      // В цикле получаем группы
      for I := 0 to G_Count - 1 do
      begin
        G_Id := EmptyStr;
        G_Name := EmptyStr;
        Unk := EmptyStr;
        for M := 1 to Length(G_Mask) do
        begin
          case G_Mask[M] of
            'u':
              begin
                if M = 1 then
                  G_Id := Text2Hex(NextData(PktData, 4))
                else
                  Unk := Unk + '[u' + IntToStr(M) + '] ' + Text2Hex(NextData(PktData, 4)) + ', ';
              end;
            's':
              begin
                Len := HexToInt(Text2Hex(NextData(PktData, 4)));
                Len := Swap32(Len);
                if M = 2 then
                  G_Name := UnicodeLEHex2Text(Text2Hex(NextData(PktData, Len)))
                else
                  Unk := Unk + '[s' + IntToStr(M) + '] ' + Text2Hex(NextData(PktData, Len)) + ', ';
              end;
          end;
        end;
        // Записываем в Ростер
        ListItemD := RosterForm.RosterJvListView.Items.Add;
        ListItemD.Caption := IntToStr(I);
        // Подготавиливаем все значения
        RosterForm.RosterItemSetFull(ListItemD);
        // Обновляем субстроки
        ListItemD.SubItems[1] := URLEncode(G_Name);
        ListItemD.SubItems[3] := C_Mra;
        ListItemD.SubItems[4] := G_Id;
        // Заполняем лог
        S_Log := S_Log + G_Log + C_PN + 'Id: ' + G_Id + C_LN + 'Name: ' + G_Name + C_LN + 'Unk: ' + Unk + C_RN;
      end;
      // Добавляем группу для телефонных контактов
      ListItemD := RosterForm.RosterJvListView.Items.Add;
      ListItemD.Caption := '999';
      RosterForm.RosterItemSetFull(ListItemD);
      ListItemD.SubItems[1] := URLEncode(Lang_Vars[34].L_S);
      ListItemD.SubItems[3] := C_Mra;
      ListItemD.SubItems[4] := 'phone';
      // Получаем контакты
      while Length(PktData) > 0 do
      begin
        G_Id := EmptyStr;
        C_Email := EmptyStr;
        G_Name := EmptyStr;
        C_Auth := True;
        C_Status := EmptyStr;
        C_StatusId := EmptyStr;
        C_XText := EmptyStr;
        C_Client := EmptyStr;
        Unk := EmptyStr;
        for M := 1 to Length(C_Mask) do
        begin
          case C_Mask[M] of
            'u':
              begin
                if M = 2 then
                  G_Id := Text2Hex(NextData(PktData, 4))
                else if M = 5 then
                begin
                  if Text2Hex(NextData(PktData, 4)) = '01000000' then
                    C_Auth := False;
                end
                else if M = 6 then
                  C_Status := Text2Hex(NextData(PktData, 4))
                else
                  Unk := Unk + '[u' + IntToStr(M) + '] ' + Text2Hex(NextData(PktData, 4)) + ', ';
              end;
            's':
              begin
                Len := HexToInt(Text2Hex(NextData(PktData, 4)));
                Len := Swap32(Len);
                if M = 3 then
                  C_Email := NextData(PktData, Len)
                else if M = 4 then
                  G_Name := UnicodeLEHex2Text(Text2Hex(NextData(PktData, Len)))
                else if M = 7 then
                  C_Phone := NextData(PktData, Len)
                else
                  Unk := Unk + '[s' + IntToStr(M) + '] ' + Text2Hex(NextData(PktData, Len)) + ', ';
              end;
          end;
        end;
        // Записываем в Ростер
        ListItemD := RosterForm.RosterJvListView.Items.Add;
        if C_Email = 'phone' then
          ListItemD.Caption := C_Phone
        else
          ListItemD.Caption := C_Email;
        // Подготавиливаем все значения
        RosterForm.RosterItemSetFull(ListItemD);
        // Обновляем субстроки
        ListItemD.SubItems[0] := URLEncode(G_Name);
        if ListItemD.SubItems[0] = EmptyStr then
          ListItemD.SubItems[0] := ListItemD.Caption;
        if C_Email = 'phone' then
          ListItemD.SubItems[1] := '999'
        else
          ListItemD.SubItems[1] := IntToStr(Swap32(HexToInt(G_Id)));
        if C_Auth then
        begin
          ListItemD.SubItems[2] := 'both';
          ListItemD.SubItems[6] := '23';
        end
        else
        begin
          ListItemD.SubItems[2] := 'none';
          ListItemD.SubItems[6] := '25';
          ListItemD.SubItems[8] := '220';
        end;
        ListItemD.SubItems[3] := C_Mra;
        if C_Email = 'phone' then
        begin
          ListItemD.SubItems[4] := 'phone';
          ListItemD.SubItems[6] := '275';
        end;
        ListItemD.SubItems[9] := C_Phone;
        // Заполняем лог
        S_Log := S_Log + C_Log + C_PN + 'G_Id: ' + G_Id + C_LN + 'Email: ' + C_Email + C_LN //
        + 'Nick: ' + G_Name + C_LN + 'Auth: ' + BoolToStr(C_Auth) + C_LN + 'Status: ' + C_Status + C_LN //
        + 'Phone: ' + C_Phone + C_LN + 'Unk: ' + Copy(Unk, 1, Length(Unk) - 2) + C_RN;
      end;
    finally
      // Заканчиваем добаление записей контактов в Ростер
      RosterForm.RosterJvListView.Items.EndUpdate;
    end;
    // Запускаем обработку Ростера
    V_CollapseGroupsRestore := True;
    RosterForm.UpdateFullCL;
  end;
  // Пишем в лог данные пакета
  XLog(C_Mra + Log_Parsing + MRA_Pkt_Names[29].Pkt_Name + C_RN + Trim(S_Log), C_Mra);}
end;

{$ENDREGION}
{$REGION 'MRA_GoOffline'}

procedure MRA_GoOffline;
var
  I: Integer;
begin
  // Отключаем таймер факстатуса, пингов
  MainForm.UnstableMRAStatus.Checked := False;
  with MainForm.JvTimerList do
  begin
    Events[10].Enabled := False;
  end;
  // Если существует форма настроек протокола MRA, то блокируем там контролы
  if Assigned(MraOptionsForm) then
  begin
    with MraOptionsForm do
    begin
      MRAEmailEdit.Enabled := True;
      MRAEmailEdit.Color := ClWindow;
      PassEdit.Enabled := True;
      PassEdit.Color := ClWindow;
      MRAEmailComboBox.Enabled := True;
    end;
  end;
  // Активируем фазу оффлайн и обнуляем буферы пакетов
  MRA_Connect_Phaze := False;
  MRA_HTTP_Connect_Phaze := False;
  MRA_BosConnect_Phaze := False;
  MRA_Work_Phaze := False;
  MRA_Offline_Phaze := True;
  MRA_myBeautifulSocketBuffer := EmptyStr;
  MRA_BuffPkt := EmptyStr;
  // Отключаем сокет
  with MainForm do
  begin
    MRAWSocket.Abort;
    // Ставим иконку и значение статуса оффлайн
    MRA_CurrentStatus := 23;
    MRAToolButton.ImageIndex := MRA_CurrentStatus;
    //MRATrayIcon.IconIndex := MRA_CurrentStatus;
    // Подсвечиваем в меню статуса MRA статус оффлайн
    MRAStatusOffline.default := True;
  end;
  // Обнуляем счётчики пакетов
  MRA_Seq := 1;
  // Обнуляем события и переменные в Ростере
  {with RosterForm.RosterJvListView do
  begin
    for I := 0 to Items.Count - 1 do
    begin
      if Items[I].SubItems[3] = C_Mra then
      begin
        if Items[I].SubItems[6] <> '275' then
          Items[I].SubItems[6] := '23';
        Items[I].SubItems[7] := '-1';
        Items[I].SubItems[8] := '-1';
        Items[I].SubItems[15] := '';
        Items[I].SubItems[16] := '';
        Items[I].SubItems[18] := '0';
        Items[I].SubItems[19] := '0';
        Items[I].SubItems[35] := '0';
      end;
    end;
  end;
  // Запускаем обработку Ростера
  RosterForm.UpdateFullCL;}
end;

{$ENDREGION}
{$REGION 'MRA_ParseStatus'}

procedure MRA_ParseStatus(PktData: string);
begin

end;

{$ENDREGION}
{$REGION 'MRA_ParseOfflineMess'}

procedure MRA_ParseOfflineMess(PktData: string);
begin

end;

{$ENDREGION}

end.

