﻿{ *******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
  ******************************************************************************* }

unit ChatUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Htmlview, StrUtils, Menus, ExtCtrls, StdCtrls, Buttons,
  CategoryButtons, VarsUnit, ShellApi, MMsystem, GIFImg, ComCtrls, CommCtrl,
  ToolWin;

type
  TChatForm = class(TForm)
    CloseTabPopupMenu: TPopupMenu;
    CloseTabAllOffline: TMenuItem;
    CloseTabAllNoCurrent: TMenuItem;
    CloseTabAll: TMenuItem;
    CenterChatFormPanel: TPanel;
    ChatCategoryButtons: TCategoryButtons;
    GroupSplitter: TSplitter;
    BottomChatFormPanel: TPanel;
    BottomToolsPanel: TPanel;
    MemoPanel: TPanel;
    MyAvatarPanelSpeedButton: TSpeedButton;
    InputMemo: TMemo;
    MyAvatarPanel: TPanel;
    MyAvatarImage: TImage;
    HTMLMsg: THTMLViewer;
    ChatSplitter: TSplitter;
    HtmlPanel: TPanel;
    HTMLChatViewer: THTMLViewer;
    TopChatFormPanel: TPanel;
    InfoPanel1: TPanel;
    InfoPanel2: TPanel;
    InfoContactSpeedButton: TSpeedButton;
    EditContactSpeedButton: TSpeedButton;
    HistoryShowPopupMenu: TPopupMenu;
    ShowAllHistory: TMenuItem;
    Show100History: TMenuItem;
    Show50History: TMenuItem;
    Show20History: TMenuItem;
    MemoPopupMenu: TPopupMenu;
    QRepMess: TMenuItem;
    CutMemo: TMenuItem;
    N1: TMenuItem;
    CopyMemo: TMenuItem;
    CopyAllMemo: TMenuItem;
    PasteMemo: TMenuItem;
    HtmlPopupMenu: TPopupMenu;
    ChatHTMLTextCopy: TMenuItem;
    ChatHTMLAllTextCopy: TMenuItem;
    ChatHTMLQText: TMenuItem;
    QmessPopupMenu: TPopupMenu;
    ChatPageControl: TPageControl;
    InfoPanel3: TPanel;
    InfoPanel4: TPanel;
    ContactAvatarPanel: TPanel;
    ContactAvatarImage: TImage;
    ChatToolBar: TToolBar;
    EnterKeyToolButton: TToolButton;
    ChatSettingsToolButton: TToolButton;
    TypingTextToolButton: TToolButton;
    ChatFontToolButton: TToolButton;
    KeySoundToolButton: TToolButton;
    TopToolsPanel: TPanel;
    TextLenPanel: TPanel;
    SmiliesSpeedButton: TSpeedButton;
    Bevel1: TBevel;
    QSpeedButton: TSpeedButton;
    QRepSpeedButton: TSpeedButton;
    Bevel2: TBevel;
    HistorySpeedButton: TSpeedButton;
    Bevel3: TBevel;
    NotifyPanel: TPanel;
    ClearChatSpeedButton: TSpeedButton;
    ContactMenuToolButton: TToolButton;
    ContactAvatarPanelSpeedButton: TSpeedButton;
    SendFileSpeedButton: TSpeedButton;
    SendMessageSpeedButtonDrop: TSpeedButton;
    SendMessageBitBtn: TBitBtn;
    CloseTabBitBtn: TBitBtn;
    CloseTabSpeedButtonDrop: TSpeedButton;
    SendPopupMenu: TPopupMenu;
    SendAllOnline: TMenuItem;
    SendAll: TMenuItem;
    TabPopupMenu: TPopupMenu;
    CloseChatTabMenu: TMenuItem;
    ConfPopupMenu: TPopupMenu;
    ChatUserPopupMenu: TPopupMenu;
    CloseLastChatMenu: TMenuItem;
    FileTransferPopupMenu: TPopupMenu;
    UpWapru1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MyAvatarPanelSpeedButtonClick(Sender: TObject);
    procedure ChatSplitterMoved(Sender: TObject);
    procedure InputMemoChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChatCategoryButtonsContextPopup
      (Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ChatCategoryButtonsHotButton(Sender: TObject;
      const Button: TButtonItem);
    procedure ChatCategoryButtonsButtonClicked(Sender: TObject;
      const Button: TButtonItem);
    procedure CloseTabAllClick(Sender: TObject);
    procedure CloseTabAllNoCurrentClick(Sender: TObject);
    procedure CloseTabAllOfflineClick(Sender: TObject);
    procedure InputMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChatSettingsToolButtonClick(Sender: TObject);
    procedure InputMemoKeyPress(Sender: TObject; var Key: Char);
    procedure EditContactSpeedButtonClick(Sender: TObject);
    procedure ShowAllHistoryClick(Sender: TObject);
    procedure InfoContactSpeedButtonClick(Sender: TObject);
    procedure ChatHTMLTextCopyClick(Sender: TObject);
    procedure HTMLChatViewerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoPopupMenuPopup(Sender: TObject);
    procedure PasteMemoClick(Sender: TObject);
    procedure ChatHTMLQTextClick(Sender: TObject);
    procedure CutMemoClick(Sender: TObject);
    procedure CopyMemoClick(Sender: TObject);
    procedure CopyAllMemoClick(Sender: TObject);
    procedure ChatHTMLAllTextCopyClick(Sender: TObject);
    procedure HtmlPopupMenuPopup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure ChatFontToolButtonClick(Sender: TObject);
    procedure HTMLChatViewerHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ChatPageControlChange(Sender: TObject);
    procedure ChatPageControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChatPageControlMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SmiliesSpeedButtonClick(Sender: TObject);
    procedure QSpeedButtonClick(Sender: TObject);
    procedure HistorySpeedButtonClick(Sender: TObject);
    procedure HistorySpeedButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ClearChatSpeedButtonClick(Sender: TObject);
    procedure ContactAvatarPanelSpeedButtonClick(Sender: TObject);
    procedure SendMessageBitBtnClick(Sender: TObject);
    procedure SendMessageSpeedButtonDropClick(Sender: TObject);
    procedure CloseTabBitBtnClick(Sender: TObject);
    procedure CloseTabSpeedButtonDropClick(Sender: TObject);
    procedure SendAllOnlineClick(Sender: TObject);
    procedure SendAllClick(Sender: TObject);
    procedure SendFileSpeedButtonClick(Sender: TObject);
    procedure TypingTextToolButtonClick(Sender: TObject);
    procedure CloseChatTabMenuClick(Sender: TObject);
    procedure ContactMenuToolButtonClick(Sender: TObject);
    procedure ContactMenuToolButtonContextPopup
      (Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure HTMLChatViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SendFileSpeedButtonMouseDown
      (Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure QRepSpeedButtonClick(Sender: TObject);
    procedure QRepSpeedButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpWapru1Click(Sender: TObject);
    procedure HTMLChatViewerParseEnd(Sender: TObject);
  private
    { Private declarations }
    lastClick: Tdatetime;
    ButtonInd: Integer;
    // Zundo: string;
    HintInd: Integer;
    iTab: Integer;
    procedure QuickMessClick(Sender: TObject);
  public
    { Public declarations }
    OutMessIndex: Integer;
    ChatButton: TButtonItem;
    UserType: string;
    UserUtf8Support: Boolean;
    UserAvatarHash: string;
    procedure TranslateForm;
    procedure CheckMessage_Smilies(var msg: string);
    procedure CheckMessage_ClearTag(var msg: string);
    procedure AddChatText(Nick_Time, Mess_Text: string;
      MessIn: Boolean = false);
    procedure CreateFastReplyMenu;
    function pageIdxAt(X, Y: Integer): Integer;
    function AddMessInActiveChat(cNick, cPopMsg, cId, cMsgD, cMess: string)
      : Boolean;
  end;

var
  ChatForm: TChatForm;
  ChatCSS: string = '<style type="text/css">' +
    'body, span { color: #000000; font: 12px tahoma, verdana; }' +
    'hr { margin: 5px; border: none; color: gray; background-color: gray; height: 1px; }'
    + '.a { font: bold 11px tahoma, verdana; color: blue; }' +
    '.b { font: bold 11px tahoma, verdana; color: red; }' +
    '.c { font: 12px tahoma, verdana; color: black; }' +
    '.d { font: bold 11px tahoma, verdana; color: green; }' + '</style>';

implementation

{$R *.dfm}

uses
  MainUnit, SmilesUnit, SettingsUnit, IcqProtoUnit, HistoryUnit,
  IcqContactInfoUnit, UtilsUnit, RosterUnit, JabberProtoUnit, UnitCrypto,
  FileTransferUnit, UnitLogger, rXML;

function TChatForm.AddMessInActiveChat
  (cNick, cPopMsg, cId, cMsgD, cMess: string): Boolean;
begin
  Result := false;
  if Visible then
  begin
    // Если открыт текущий чат с этим контактом
    if InfoPanel2.Caption = cId then
    begin
      // Если не включены текстовые смайлы, то форматируем сообщение под смайлы
      if not TextSmilies then
        CheckMessage_Smilies(cMess);
      // Добавляем сообщение в текущий чат
      AddChatText(cMsgD, cMess, true);
      // Прокручиваем чат в самый конец
      HTMLChatViewer.VScrollBarPosition := HTMLChatViewer.VScrollBar.Max;
      // Если окно сообщений активно, то выходим
      if ChatForm.Active then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
  // Если в списке очереди входящих сообщений нет этого контакта, то добавляем его туда
  if InMessList.IndexOf(cId) = -1 then
    InMessList.Add(cId);
  // Играем звук входящего сообщения
  ImPlaySnd(1);
  // Показываем всплывашку с сообщением
  DAShow(cNick, cPopMsg, cId, 165, 1, 0);
end;

function TChatForm.pageIdxAt(X, Y: Integer): Integer;
var
  R: Trect;
begin
  Result := 0;
  while Result < ChatPageControl.PageCount do
  begin
    SendMessage(ChatPageControl.Handle, TCM_GETITEMRECT, Result, Longint(@R));
    if ptInRect(R, point(X, Y)) then
      Exit;
    inc(Result);
  end;
  Result := -1;
end;

procedure TChatForm.QRepSpeedButtonClick(Sender: TObject);
begin
  // Открываем меню над этим элементом
  Popup(QRepSpeedButton, QmessPopupMenu);
end;

procedure TChatForm.QRepSpeedButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Открываем меню над этим элементом
  if Button = mbRight then
    Popup(QRepSpeedButton, QmessPopupMenu);
end;

procedure TChatForm.QSpeedButtonClick(Sender: TObject);
var
  RosterItem: TListItem;
begin
  // Достаём из Ростера последнее сообщение от этого контакта
  RosterItem := RosterForm.ReqRosterItem(InfoPanel2.Caption);
  if RosterItem <> nil then
  begin
    if RosterItem.SubItems[15] <> EmptyStr then
      InputMemo.Lines.Add('> ' + RosterItem.SubItems[15]);
  end;
end;

procedure TChatForm.QuickMessClick(Sender: TObject);
begin
  // Вставляем в поле ввода текст из меню быстрых ответов
  InputMemo.SelText := TMenuItem(Sender).Hint;
end;

procedure TChatForm.CreateFastReplyMenu;
var
  i: Integer;
  list: TStringList;
begin
  // Создаём временный лист строк
  list := TStringList.Create;
  // Если файл с быстрыми ответами найден, то загружаем его
  if FileExists(ProfilePath + 'Profile\QReply.txt') then
    list.LoadFromFile(ProfilePath + 'Profile\QReply.txt')
  else
  begin
    // Иначе добавляем быстрые ответы по умолчанию
    list.Add(QReply1L);
    list.Add(QReply2L);
    list.Add(QReply3L);
  end;
  try
    // Добаляем быстрые ответы в раздел меню поля ввода текста
    with MemoPopupMenu.Items.Items[0] do
    begin
      for i := 0 to list.Count - 1 do
      begin
        if list.Strings[i] <> EmptyStr then
        begin
          Add(NewItem(list.Strings[i], 0, false, true, QuickMessClick, 0,
              'MenuItem' + IntToStr(i)));
          // Добавляем и в хинты, против глюка акселя
          Items[i].Hint := list.Strings[i];
          // Назначаем иконку для пункта меню
          Items[i].ImageIndex := 157;
        end;
      end;
    end;
    // Добавляем быстрые ответы в меню быстрых ответов
    with QmessPopupMenu.Items do
    begin
      for i := 0 to list.Count - 1 do
      begin
        if list.Strings[i] <> EmptyStr then
        begin
          Add(NewItem(list.Strings[i], 0, false, true, QuickMessClick, 0,
              'MenuItem' + IntToStr(i)));
          // Добавляем и в хинты, против глюка акселя
          Items[i].Hint := list.Strings[i];
          // Назначаем иконку для пункта меню
          Items[i].ImageIndex := 157;
        end;
      end;
    end;
  finally
    list.Free;
  end;
end;

procedure TChatForm.ChatCategoryButtonsButtonClicked
  (Sender: TObject; const Button: TButtonItem);
var
  diff: Tdatetime;
begin
  // Проверяем двойной клик
  diff := now - lastClick;
  lastClick := now;
  if (diff < dblClickTime) and (ButtonInd = Button.Index) then
  begin
    // В будущем вставка ника в поле ввода для jabber конференций

    Exit;
  end;
  ButtonInd := Button.Index;
end;

procedure TChatForm.ChatCategoryButtonsContextPopup
  (Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := true;
  // Выделяем выбранный контакт
  ChatCategoryButtons.FocusedItem := nil;
  ChatCategoryButtons.SelectedItem := ChatButton;
  if ChatButton <> nil then
  begin
    // Параметры меню контактов в конференции

  end;
end;

procedure TChatForm.ChatCategoryButtonsHotButton
  (Sender: TObject; const Button: TButtonItem);
begin
  // Запоминаем над какой кнопкой происходит действие
  if Button <> nil then
    ChatButton := Button
  else
    ChatButton := nil;
end;

procedure TChatForm.CheckMessage_Smilies(var msg: string);
var
  ImgTag1, ImgTag2, Cod: string;
  i, II: Integer;

  function GenTag(Path: string): string;
  begin
    Result := ImgTag1 + Path + ImgTag2;
  end;

begin
  // Определяем html тэги для вставки смайлов заместо их текстовых обозначений
  ImgTag1 := '<img src="' + MyPath + 'Smilies\' + CurrentSmiles + '\';
  ImgTag2 := '" ALIGN=ABSMIDDLE BORDER="0">';
  // Сканируем список кодов смайлов на совпадения
  for i := 1 to SmilesList.Count - 1 do
  begin
    for II := 1 to 20 do
    begin
      Cod := Parse(',', SmilesList.Strings[i], II);
      if Cod > EmptyStr then
        msg := AnsiReplaceText(msg, Cod, GenTag(IntToStr(i) + '.gif'))
      else
        Break;
    end;
  end;
end;

procedure TChatForm.CheckMessage_ClearTag(var msg: string);
var
  Doc: string;
begin
  // Вырезаем таким образом все левые тэги из сообщения оставляя чистый текст
  HTMLMsg.Clear;
  Doc := msg;
  HTMLMsg.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
  HTMLMsg.SelectAll;
  msg := HTMLMsg.SelText;
end;

procedure TChatForm.AddChatText(Nick_Time, Mess_Text: string;
  MessIn: Boolean = false);
var
  Doc: string;
begin
  try
    Doc := HTMLChatViewer.DocumentSource;
    if MessIn then
      Doc := Doc + '<IMG NAME=i SRC="' + MyPath + 'Icons\' + CurrentIcons +
        '\inmess.gif" ALIGN=ABSMIDDLE BORDER=0><span class=b> ' + Nick_Time +
        '</span><br>'
    else
      Doc := Doc + '<IMG NAME=o' + IntToStr(OutMessIndex)
        + ' SRC="' + MyPath + 'Icons\' + CurrentIcons +
        '\outmess1.gif" ALIGN=ABSMIDDLE BORDER=0><span class=a> ' + Nick_Time +
        '</span><br>';
    Doc := Doc + '<span class=c>' + Mess_Text + '</span><br><br>';
    HTMLChatViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(E);
  end;
end;

procedure TChatForm.InputMemoChange(Sender: TObject);
begin
  // Убираем из поля ввода текста сишний символ перехода на новую строку
  if InputMemo.Text = #13#10 then
    InputMemo.Clear;
  // Отображаем длинну введённого текста
  TextLenPanel.Caption := IntToStr(InputMemo.GetTextLen);
end;

procedure TChatForm.InputMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ var
  list: TStringList;
  Selected, YesConvert: boolean;
  buf, Outbuf, temp: string;
  HMemo: HWND;
  i, ii: integer;

  procedure ReplaceText(Str: string);
  begin
  SendMessage(HMemo, EM_REPLACESEL, 0, Longint(PChar(Str)));
  end;

  function GetSelText(var Str: string): boolean;
  begin
  result := false;
  if self.InputMemo.SelText <> EmptyStr then
  begin
  result := true;
  Str := self.InputMemo.SelText;
  end
  else
  Str := self.InputMemo.Text;
  end; }

begin
  // Если зажата клавиша контрл и нажата клавиша интер и не нажата кнопка отправки по интер, то отправляем сообщение
  if (GetKeyState(VK_CONTROL) < 0) and (Key = 13) and
    (not EnterKeyToolButton.Down) then
    SendMessageBitBtnClick(self);
  // Если зажата клавиша контрл и нажата клавиша "s", то открываем окно смайлов
  if (GetKeyState(VK_CONTROL) < 0) and (Key = 83) then
    SmiliesSpeedButtonClick(self);
  //
  { if (GetKeyState(VK_CONTROL) < 0) and (Key = 82) then
    begin
    if not FileExists(MyPath + 'Langs\chars_r.txt') then Exit;
    HMemo := self.InputMemo.Handle;
    if HMemo = 0 then Exit;
    Selected := GetSelText(buf);
    if Length(buf) = 0 then Exit;
    Zundo := self.InputMemo.Text;
    list := TStringList.Create;
    list.LoadFromFile(MyPath + 'Langs\chars_r.txt');
    //
    for i := 1 to Length(buf) do
    begin
    YesConvert := false;
    for ii := 0 to list.Count - 1 do
    begin
    temp := Parse('=', list.Strings[ii], 1);
    if buf[i] = temp then
    begin
    Outbuf := Outbuf + Parse('=', list.Strings[ii], 2);
    YesConvert := true;
    Break;
    end;
    end;
    if not YesConvert then Outbuf := Outbuf + buf[i];
    end;
    //
    list.Free;
    if Selected then ReplaceText(Outbuf)
    else SetWindowText(HMemo, PChar(Outbuf));
    SendMessage(HMemo, EM_SETSEL, Length(self.InputMemo.Text), Length(self.InputMemo.Text));
    end;
    //
    if (GetKeyState(VK_CONTROL) < 0) and (Key = 84) then
    begin
    if not FileExists(MyPath + 'Langs\chars_t.txt') then Exit;
    HMemo := self.InputMemo.Handle;
    if HMemo = 0 then Exit;
    Selected := GetSelText(buf);
    if Length(buf) = 0 then Exit;
    Zundo := self.InputMemo.Text;
    list := TStringList.Create;
    list.LoadFromFile(MyPath + 'Langs\chars_t.txt');
    //
    for i := 1 to Length(buf) do
    begin
    YesConvert := false;
    for ii := 0 to list.Count - 1 do
    begin
    temp := Parse('=', list.Strings[ii], 1);
    if buf[i] = temp then
    begin
    Outbuf := Outbuf + Parse('=', list.Strings[ii], 2);
    YesConvert := true;
    Break;
    end;
    end;
    if not YesConvert then Outbuf := Outbuf + buf[i];
    end;
    //
    list.Free;
    if Selected then ReplaceText(Outbuf)
    else SetWindowText(HMemo, PChar(Outbuf));
    SendMessage(HMemo, EM_SETSEL, Length(self.InputMemo.Text), Length(self.InputMemo.Text));
    end;
    //
    if (GetKeyState(VK_CONTROL) < 0) and (Key = 90) then
    begin
    if Zundo > EmptyStr then self.InputMemo.Text := Zundo;
    self.InputMemo.SelStart := self.InputMemo.GetTextLen;
    Zundo := EmptyStr;
    end; }
end;

procedure TChatForm.InputMemoKeyPress(Sender: TObject; var Key: Char);
label X;
var
  msgD, msg, UIN: string;
  RosterItem: TListItem;
begin
  // Если поле идентификатора пользователя пустое, то выходим от сюда (в будущем сделать чтобы закрывалось окно)
  if InfoPanel2.Caption = EmptyStr then
    Exit;
  // Если нажата клавиша не интер, то если включен режим звуковой клавиатуры, то воспроизводим звуки
  if Key <> #13 then
  begin
    // Если нажата кнопка звука нажатия клавиш, то играем звуки
    if KeySoundToolButton.Down then
    begin
      try
        if (Key = #8) and (InputMemo.Text <> EmptyStr) then
        begin
          if FileExists(MyPath + 'Sounds\' + CurrentSounds + '\Back.wav') then
            sndPlaySound(PChar(MyPath + 'Sounds\' + CurrentSounds + '\Back.wav')
                , SND_ASYNC);
        end
        else
        begin
          if (Key <> #8) then
          begin
            if FileExists(MyPath + 'Sounds\' + CurrentSounds + '\Type.wav') then
              sndPlaySound
                (PChar(MyPath + 'Sounds\' + CurrentSounds + '\Type.wav'),
                SND_ASYNC);
          end;
        end;
      except
        on E: Exception do
          TLogger.Instance.WriteMessage(E);
      end;
    end;
    // Если нажата кнопка отправки оповещения о печати текста
    if TypingTextToolButton.Down then
    begin
      { if not MainForm.ICQTypeTextTimer.Enabled then
        begin
        UIN := InfoPanel2.Caption;
        //if ICQ_Work_Phaze then ICQ_SendTextTyping(TextTypeForUIN, '02');
        MainForm.ICQTypeTextTimer.Enabled := true;
        end
        else MainForm.ICQTypeTextTimer.Enabled := true; }
    end;
    // Выходим
    Exit;
  end;
  // Если нажата клавиша интер и кнопка отправки по интер
  if (Key = #13) and (EnterKeyToolButton.Down) then
    // Если зажата клавиша Шифт
    if GetKeyState(VK_SHIFT) < 0 then
      Exit
    else
    begin
    X :;
      // Обнуляем символ клавиши
      Key := #0;
      // Если поле ввода пустое, то выходим
      if InputMemo.GetTextLen = 0 then
        Exit;
      // Если нажата кнопка звука нажатия клавиш, то играем звуки
      if KeySoundToolButton.Down then
      begin
        try
          if FileExists(MyPath + 'Sounds\' + CurrentSounds + '\Send.wav') then
            sndPlaySound(PChar(MyPath + 'Sounds\' + CurrentSounds + '\Send.wav')
                , SND_ASYNC);
        except
          on E: Exception do
            TLogger.Instance.WriteMessage(E);
        end;
      end;
      // Узнаём Идентификатор пользователя
      UIN := InfoPanel2.Caption;
      // Копируем текст сообщения
      msg := InputMemo.Text;
      // Если тип контакта ICQ, то отправляем сообщение по ICQ протоколу
      if UserType = 'Icq' then
      begin
        // Если нет подключения к серверу ICQ, то выходим
        if not ICQ_Work_Phaze then
          Exit;
        // Заканчиваем оповещение о наборе текста
        // if MainForm.ICQTypeTextTimer.Enabled then MainForm.ICQTypeTextTimerTimer(self);
        // Если статус пользователя не оффлайн и есть поддержка UTF-8 сообщений, то отправляем сообщение в юникоде.
        // Иначе отправляем сообщение в старом анси формате
        if (ChatPageControl.ActivePage.Tag <> 9) and (UserUtf8Support) then
          ICQ_SendMessage_0406(UIN, msg, false)
        else
          ICQ_SendMessage_0406(UIN, msg, true);
      end
      else if UserType = 'Jabber' then
      begin
        // Если нет подключения к серверу Jabber, то выходим
        if not Jabber_Work_Phaze then
          Exit;
        // Отправляем сообщение
        Jabber_SendMessage(UIN, msg);
      end
      else if UserType = 'Mra' then
      begin

      end
      else
        Exit;
      // Добавляем сообщение в файл истории и в чат
      msgD := YouAt + ' [' + DateTimeChatMess + ']';
      // Форматируем сообщение под html формат
      CheckMessage_BR(msg);
      CheckMessage_ClearTag(msg);
      CheckMessage_BR(msg);
      DecorateURL(msg);
      // Записываем историю в этот контакт
      RosterItem := RosterForm.ReqRosterItem(UIN);
      if RosterItem <> nil then
      begin
        RosterItem.SubItems[13] := RosterItem.SubItems[13]
          + '<span class=a>' + msgD + '</span><br><span class=c>' + msg +
          '</span><br><br>' + RN;
        // Ставим флаг этому контакту, что история изменилась
        RosterItem.SubItems[17] := 'X';
      end;
      // Если включены графические смайлики, то форматируем сообщение под смайлы
      if not TextSmilies then
        CheckMessage_Smilies(msg);
      // Увеличиваем счётчик исходящих сообщений
      inc(OutMessIndex);
      // Добавляем в чат сообщение
      AddChatText(msgD, msg);
      // Прокручиваем чат до конца
      HTMLChatViewer.VScrollBarPosition := HTMLChatViewer.VScrollBar.Max;
      // Очищаем поле ввода теста
      InputMemo.Clear;
      InputMemoChange(self);
      // Выходим
      Exit;
    end;
  // Если нажата клавиша интер и не нажата кнопка отправки по интер и зажата клавиша сонтрл, то переходим к отправке сообщения
  if (Key = #13) and (not EnterKeyToolButton.Down) and
    (GetKeyState(VK_CONTROL) < 0) then
    goto X;
  // Если нажата кнопка "отправить" сообщение
  if (Key = #13) and (not EnterKeyToolButton.Down) and
    (Sender.ClassName = 'TBitBtn') then
    goto X;
end;

procedure TChatForm.CloseTabAllOfflineClick(Sender: TObject);
label X;
var
  i: Integer;
begin
  // Если вкладки есть, то закрываем те что со статусом оффлайн
  with ChatPageControl do
  begin
    if Visible then
    begin
    X :;
      // Сканируем вкладки
      for i := 0 to PageCount - 1 do
      begin
        case Pages[i].ImageIndex of
          9, 23, 25, 30, 41, 42, 214:
            begin
              Pages[i].Free;
              // Прыгаем на повторение скана
              goto X;
            end;
        end;
        // Прорисовываем интерфейс
        Update;
      end;
      // Если вкладки все закрыты, то закрываем окно чата
      if PageCount = 0 then
        Close
      else
        ChatPageControlChange(self);
    end;
  end;
end;

procedure TChatForm.CloseTabAllNoCurrentClick(Sender: TObject);
var
  i: Integer;
begin
  // Если вкладки присутствуют, то закрываем все кроме текущей
  with ChatPageControl do
  begin
    if Visible then
    begin
      // Переводим активную вкладку в самое начало вкладок
      ActivePage.PageIndex := 0;
      // Закрываем все остальные вкладки в цикле
      if PageCount > 1 then
        ActivePageIndex := 1;
      for i := 1 to PageCount - 1 do
      begin
        if PageCount > 1 then
          ActivePage.Free;
        // Прорисовываем интерфэйс
        Update;
      end;
      // Регулируем высоту табов
      Height := ActivePage.Top - 3;
    end;
  end;
end;

procedure TChatForm.CloseChatTabMenuClick(Sender: TObject);
begin
  // Закрываем вкладку над которой было вызвано меню
  try
    if (ChatPageControl.Visible) and (ChatPageControl.PageCount > 0) then
    begin
      ChatPageControl.Pages[iTab].Free;
      // Если вкладок больше нет, то закрываем окно
      if ChatPageControl.PageCount = 0 then
        Close
      else
        ChatPageControlChange(self);
    end;
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(E);
  end;
end;

procedure TChatForm.CloseTabAllClick(Sender: TObject);
begin
  // Закрываем все вкладки чата
  with ChatPageControl do
  begin
    // Если вкладки активны
    if Visible then
    begin
      // Прячем компонент вкладок чтобы не мерцал
      Visible := false;
      // Поочередно закрываем все вкладки
      while PageCount > 0 do
      begin
        ActivePage.Free;
        // Прорисовываем интерфэйс
        Update;
      end;
    end;
  end;
  // Закрываем окно чата
  Close;
end;

procedure TChatForm.CopyMemoClick(Sender: TObject);
begin
  // Копируем выделенный текст из поля ввода в буфер обмена
  InputMemo.CopyToClipboard;
end;

procedure TChatForm.ChatHTMLQTextClick(Sender: TObject);
var
  Str: string;
begin
  // Цитируем выделенный текст в поле ввода и подставляем в начало каждой строки символ >
  HTMLChatViewer.CopyToClipboard;
  InputMemo.SelText := '> ';
  InputMemo.PasteFromClipboard;
  InputMemo.Text := Trim(InputMemo.Text);
  Str := AnsiReplaceText(InputMemo.Text, #13#10, #13#10 + '> ');
  InputMemo.Text := Str + #13#10;
  InputMemo.SelStart := InputMemo.GetTextLen;
  if InputMemo.CanFocus then
    InputMemo.SetFocus;
end;

procedure TChatForm.CopyAllMemoClick(Sender: TObject);
begin
  // Копируем весь текст из поля ввода в буфер обмена
  InputMemo.SelectAll;
  InputMemo.CopyToClipboard;
end;

procedure TChatForm.PasteMemoClick(Sender: TObject);
begin
  // Вставляем в поле ввода текст из буфера обмена
  InputMemo.PasteFromClipboard;
end;

procedure TChatForm.ChatPageControlChange(Sender: TObject);
var
  UIN, HistoryFile, Doc, HFile: string;
  RosterItem: TListItem;
begin
  try
    // Если пустая вкладка, то выходим
    if ChatPageControl.ActivePage = nil then
      Exit;
    // Изменяем размер компонента вкладок
    ChatPageControl.Height := ChatPageControl.ActivePage.Top - 3;
    // Получаем учётную запись контакта
    UIN := ChatPageControl.ActivePage.HelpKeyword;
    // Ищем эту запись в Ростере и помечаем что сообщения прочитаны и получаем параметры
    RosterItem := RosterForm.ReqRosterItem(UIN);
    if RosterItem <> nil then
    begin
      with RosterItem do
      begin
        // Выставляем параметры этого контакта
        SubItems[36] := EmptyStr;
        ChatPageControl.ActivePage.Caption := SubItems[0];
        ChatPageControl.ActivePage.Tag := StrToInt(SubItems[6]);
        ChatPageControl.ActivePage.ImageIndex := ChatPageControl.ActivePage.Tag;
        ChatPageControl.ActivePage.Hint := SubItems[34];
        if SubItems[33] = 'X' then
          UserUtf8Support := true
        else
          UserUtf8Support := false;
        UserAvatarHash := Hex2Text(SubItems[29]);
        UserType := SubItems[3];
        InputMemo.Text := SubItems[14];
        // Проверяем загружена ли история уже
        {if SubItems[13] = EmptyStr then
        begin
          // Загружаем файл истории сообщений
          HistoryFile := ProfilePath + 'Profile\History\' + UserType + '_' +
            UIN + '.z';
          if FileExists(HistoryFile) then
          begin
            try
              // Распаковываем файл с историей
              UnZip_File(HistoryFile, ProfilePath + 'Profile\History\');
              HFile := ProfilePath + 'Profile\History\' + UserType +
                '_History.htm';
              // Записываем историю в хранилище у этого контакта
              SubItems[13] := ReadFromFile(HFile);
              // Удаляем уже не нужный распакованный файл с историей
              if FileExists(HFile) then
                DeleteFile(HFile);
            except
              on E: Exception do
                TLogger.Instance.WriteMessage(E);
            end;
          end;
        end;}
        // Отображаем историю в чате
        if SubItems[13] <> EmptyStr then
        begin
          // Очищаем чат от другой истории
          HTMLChatViewer.Clear;
          // Добавляем стили
          Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
          // Загружаем из файла истории указанное количесво сообщений
          Doc := Doc + TailLineTail(SubItems[13], 5);
          if not TextSmilies then
            CheckMessage_Smilies(Doc);
          SetLength(Doc, Length(Doc) - 6);
          Doc := Doc + '<HR>';
          HTMLChatViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
        end
        else
        begin
          // Очищаем чат от другой истории
          HTMLChatViewer.Clear;
          // Добавляем стили
          Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
          HTMLChatViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
        end;
        // Ставим имя и фамилию в информационное поле
        InfoPanel1.Caption := NameAndLast(UIN, UserType);
        // Ставим город и возраст в информационное поле
        InfoPanel3.Caption := GetCityPanel;
        InfoPanel4.Caption := GetAgePanel;
        // Ставим клиент в информационное поле
        if SubItems[32] <> EmptyStr then
        begin
          NotifyPanel.Caption := SubItems[32];
          NotifyPanel.Hint := SubItems[32];
        end
        else
          NotifyPanel.Caption := '...';
        // Выводим текст доп. статуса и иконку доп статуса
        if SubItems[31] <> EmptyStr then
        begin
          Doc := HTMLChatViewer.DocumentSource;
          // Если есть и иконка доп. статуса
          if SubItems[7] > '-1' then
            Doc := Doc + '<IMG NAME=x SRC="" ALIGN=ABSMIDDLE BORDER=0> ';
          Doc := Doc + '<span class=d>' + SubItems[31] + '</span><br><br>';
          HTMLChatViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
          // Преобразуем и подгружаем иконку доп. статуса
          if SubItems[7] > '-1' then
          begin
            xStatusImg.Assign(nil);
            MainForm.AllImageList.GetBitmap(StrToInt(SubItems[7]), xStatusImg);
            xStatusGif.Assign(nil);
            xStatusGif.Add(xStatusImg);
            xStatusMem.Clear;
            xStatusGif.SaveToStream(xStatusMem);
            HTMLChatViewer.ReplaceImage('x', xStatusMem);
          end;
          // Ставим каретку в самый низ текста
          HTMLChatViewer.VScrollBarPosition := HTMLChatViewer.VScrollBar.Max;
          HTMLChatViewer.CaretPos := Length(Doc);
        end;
      end;
    end;
    if InfoPanel1.Caption = EmptyStr then
      InfoPanel1.Caption := ChatPageControl.ActivePage.Caption;
    // Ставим учётную запись контакта в информационное поле
    InfoPanel2.Caption := UIN;
    // Ставим курсор в мемо после последнего символа
    InputMemo.SelStart := InputMemo.GetTextLen;
    // Ставим фокус в поле ввода текста
    if (InputMemo.CanFocus) and (ChatForm.Visible) then
      InputMemo.SetFocus;
    // Удаляем отметку о сообщении из списка очереди входящих сообщений
    RosterForm.DellcIdInMessList(UIN);

    // Загружаем аватар
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

  except
    on E: Exception do
      TLogger.Instance.WriteMessage(E);
  end;
end;

procedure TChatForm.ChatPageControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  diff: Tdatetime;
  FCursor: TPoint;
begin
  // Обрабатываем нажатия кнопок мыши по вкладке
  case Button of
    mbRight: // Если нажали правой клавишей мыши
      begin
        iTab := pageIdxAt(X, Y);
        if iTab < 0 then
          Exit;
        // Вычисляем позицию окна от позиции курсора
        GetCursorPos(FCursor);
        // Отображаем меню этой вкладки
        TabPopupMenu.Popup(FCursor.X, FCursor.Y);
      end;
    mbLeft: // Если нажали левой клавишей мыши
      begin
        // Проверяем двойной клик
        diff := now - lastClick;
        lastClick := now;
        // Если двойной клик, то закрываем вкладку и выходим
        if (diff < dblClickTime) and
          (ButtonInd = ChatPageControl.ActivePageIndex) then
        begin
          ButtonInd := -1;
          CloseTabBitBtnClick(self);
          Exit;
        end;
        // Запоминаем индекс нажатой вкладки
        ButtonInd := ChatPageControl.ActivePageIndex;
      end;
    mbMiddle: // Если нажали средней клавишей мыши
      begin
        iTab := pageIdxAt(X, Y);
        if iTab < 0 then
          Exit;
        // Закрываем эту вкладку
        CloseChatTabMenuClick(self);
      end;
  end;
end;

procedure TChatForm.ChatPageControlMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  // Вычисляем над какой вкладкой у нас курсор, чтобы показать подсказку
  if pageIdxAt(X, Y) <> HintInd then
    Application.CancelHint;
  // Присваиваем подсказку для контакта компоненту вкладок
  ChatPageControl.Hint := ChatPageControl.Pages[pageIdxAt(X, Y)].Hint;
  // Запоминаем индекс вкладки с подсказкой
  HintInd := pageIdxAt(X, Y);
end;

procedure TChatForm.SendAllClick(Sender: TObject);
begin
  //
  ShowMessage(DevelMess);
end;

procedure TChatForm.SendAllOnlineClick(Sender: TObject);
begin
  //
  ShowMessage(DevelMess);
end;

procedure TChatForm.SendFileSpeedButtonClick(Sender: TObject);
begin
  // Открываем меню над этим элементом
  Popup(SendFileSpeedButton, FileTransferPopupMenu);
end;

procedure TChatForm.SendFileSpeedButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Открываем меню над этим элементом
  if Button = mbRight then
    Popup(SendFileSpeedButton, FileTransferPopupMenu);
end;

procedure TChatForm.SendMessageBitBtnClick(Sender: TObject);
var
  k: Char;
begin
  // Вызываем событие нажатия клавиши интер для поля ввода текста
  k := #13;
  InputMemoKeyPress(Sender, k);
  // Ставим фокус курсора в поле ввода
  if (ChatForm.InputMemo.CanFocus) and (ChatForm.Visible) then
    ChatForm.InputMemo.SetFocus;
end;

procedure TChatForm.MyAvatarPanelSpeedButtonClick(Sender: TObject);
var
  FCursor: TPoint;
begin
  // Прячем панель с аватаркой
  GetCursorPos(FCursor);
  if MyAvatarPanelSpeedButton.NumGlyphs = 1 then
  begin
    MyAvatarPanel.Width := 0;
    MyAvatarPanelSpeedButton.NumGlyphs := 4;
    SetCursorPos(FCursor.X + 68, FCursor.Y);
  end
  else
  begin
    MyAvatarPanel.Width := 68;
    MyAvatarPanelSpeedButton.NumGlyphs := 1;
    SetCursorPos(FCursor.X - 68, FCursor.Y);
  end;
end;

procedure TChatForm.InfoContactSpeedButtonClick(Sender: TObject);
begin
  // Открываем окно информации о контакте
  if not Assigned(IcqContactInfoForm) then
    IcqContactInfoForm := TIcqContactInfoForm.Create(MainForm);
  // Присваиваем UIN инфу которого хотим смотреть
  IcqContactInfoForm.ReqUIN := InfoPanel2.Caption;
  IcqContactInfoForm.ReqProto := UserType;
  // Загружаем информацию о нем
  IcqContactInfoForm.LoadUserUnfo;
  // Отображаем окно на передний план
  xShowForm(IcqContactInfoForm);
end;

procedure TChatForm.EditContactSpeedButtonClick(Sender: TObject);
begin
  //
  ShowMessage(DevelMess);
end;

procedure TChatForm.ChatSplitterMoved(Sender: TObject);
begin
  // Перерисовываем компоненты аватара
  MyAvatarPanelSpeedButton.Refresh;
  MyAvatarPanel.Refresh;
end;

procedure TChatForm.ChatFontToolButtonClick(Sender: TObject);
begin
  //
  ShowMessage(DevelMess);
end;

procedure TChatForm.ChatSettingsToolButtonClick(Sender: TObject);
begin
  // Отображаем окно настроек в разделе окно сообщений
  if Assigned(SettingsForm) then
  begin
    with SettingsForm do
    begin
      // Отображаем окно
      if Visible then
        ShowWindow(Handle, SW_RESTORE);
      Show;
      // Активируем раздел
      JvPageList1.ActivePageIndex := 2;
      SettingButtonGroup.ItemIndex := 2;
    end;
  end;
end;

procedure TChatForm.TranslateForm;
begin
  // Переводим форму на другие языки

end;

procedure TChatForm.TypingTextToolButtonClick(Sender: TObject);
begin
  ShowMessage(DevelMess);
end;

procedure TChatForm.UpWapru1Click(Sender: TObject);
var
  fsize: Longint;
begin
  if NotProtoOnline(UserType) then
    Exit;
  // Открываем форму отправки файлов
  if not Assigned(FileTransferForm) then
    FileTransferForm := TFileTransferForm.Create(self);
  // Присваиваем переменную способа передачи
  with FileTransferForm do
  begin
    Tag := (Sender as TMenuItem).Tag;
    TopInfoPanel.Caption := FileTransfer1L + ' ' +
      ChatPageControl.ActivePage.Caption;
    TopInfoPanel.Hint := InfoPanel2.Caption;
    BottomInfoPanel.Hint := UserType;
    // Открываем диалог выбора файла для передачи
    if MainForm.SendFileOpenDialog.Execute then
    begin
      FileNamePanel.Hint := MainForm.SendFileOpenDialog.FileName;
      FileSizePanel.Hint := GetFileFName(MainForm.SendFileOpenDialog.FileName);
      FileNamePanel.Caption := ' ' + FileSizePanel.Hint;
      // Вычисляем размер файла
      fsize := GetFileSize(MainForm.SendFileOpenDialog.FileName);
      if fsize > 1000000 then
        FileSizePanel.Caption := FloatToStrF(fsize / 1000000, ffFixed, 18, 3)
          + ' MB'
      else
        FileSizePanel.Caption := FloatToStrF(fsize / 1000, ffFixed, 18, 3)
          + ' KB';
      // Отображаем окно
      xShowForm(FileTransferForm);
    end;
  end;
end;

procedure TChatForm.FormActivate(Sender: TObject);
var
  RosterItem: TListItem;
begin
  // Сбрасываем иконку в активной вкладке в окне чата
  if ChatPageControl.ActivePage = nil then
    Exit;
  ChatPageControl.ActivePage.ImageIndex := ChatPageControl.ActivePage.Tag;
  // Сбрасываем иконку сообщения в Ростере
  RosterItem := RosterForm.ReqRosterItem(InfoPanel2.Caption);
  if RosterItem <> nil then
    RosterItem.SubItems[36] := EmptyStr;
  // Удаляем отметку о сообщении из списка очереди входящих сообщений
  RosterForm.DellcIdInMessList(InfoPanel2.Caption);
end;

procedure TChatForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Выводим на передний план окно со списком контактов
  BringWindowToTop(MainForm.Handle);
end;

procedure TChatForm.FormCreate(Sender: TObject);
begin
  // Инициализируем XML
  with TrXML.Create() do
    try
      // Загружаем настройки
      if FileExists(ProfilePath + SettingsFileName) then
      begin
        LoadFromFile(ProfilePath + SettingsFileName);
        // Загружаем позицию окна
        if OpenKey('settings\forms\chatform\position') then
          try
            Top := ReadInteger('top');
            Left := ReadInteger('left');
            Height := ReadInteger('height');
            Width := ReadInteger('width');
            // Загружаем позицию сплитеров
            BottomChatFormPanel.Height := ReadInteger('chat-splitter', 130);
            ChatCategoryButtons.Width := ReadInteger('group-splitter', 130);
            // Определяем не находится ли окно за пределами экрана
            MainForm.FormSetInWorkArea(self);
          finally
            CloseKey();
          end;
        // Загружаем "отправлять по интер"
        if OpenKey('settings\forms\chatform\send-enter') then
          try
            EnterKeyToolButton.Down := ReadBool('value');
          finally
            CloseKey();
          end;
        // Загружаем отправлять отчёт о печати текста
        if OpenKey('settings\forms\chatform\send-typing-notify') then
          try
            TypingTextToolButton.Down := ReadBool('value');
          finally
            CloseKey();
          end;
        // Загружаем "звук нажатия клавиш"
        if OpenKey('settings\forms\chatform\key-sound') then
          try
            KeySoundToolButton.Down := ReadBool('value');
          finally
            CloseKey();
          end;
        // Загружаем состояние панелей аватар
        if OpenKey('settings\forms\chatform\avatar-panels') then
          try
            ContactAvatarPanel.Width := ReadInteger('contact-avatar', 68);
            if ContactAvatarPanel.Width = 0 then
            begin
              ContactAvatarPanelSpeedButton.NumGlyphs := 1;
              InfoPanel1.Left := 9;
              InfoPanel3.Left := 9;
              InfoPanel1.Width := Width - 238;
              InfoPanel3.Width := InfoPanel1.Width;
            end;
            MyAvatarPanel.Width := ReadInteger('my-avatar', 68);
            if MyAvatarPanel.Width = 0 then
              MyAvatarPanelSpeedButton.NumGlyphs := 4;
          finally
            CloseKey();
          end;
      end;
    finally
      Free();
    end;
  // Включаем двойной буферинг для вкладок
  ChatPageControl.DoubleBuffered := true;
  // Устанавливаем начальный индекс подсказки
  HintInd := -1;
  // Присваиваем окну и кнопкам иконки
  MainForm.AllImageList.GetIcon(163, Icon);
  MainForm.AllImageList.GetBitmap(156, SmiliesSpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(216, QSpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(157, QRepSpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(147, HistorySpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(149, SendFileSpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(159, ClearChatSpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(178, InfoContactSpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(141, EditContactSpeedButton.Glyph);
  MainForm.AllImageList.GetBitmap(166, SendMessageBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(158, CloseTabBitBtn.Glyph);
  // Создаём хранитель картинки пустой аватары для быстрого её отображения
  NoAvatar := TImage.Create(MainForm);
  if FileExists(MyPath + 'Icons\' + CurrentIcons + '\noavatar.gif') then
    NoAvatar.Picture.LoadFromFile
      (MyPath + 'Icons\' + CurrentIcons + '\noavatar.gif');
  // Создаём иконки подтвержения сообщений
  OutMessage2 := TMemoryStream.Create;
  if FileExists(MyPath + 'Icons\' + CurrentIcons + '\outmess2.gif') then
    OutMessage2.LoadFromFile
      (MyPath + 'Icons\' + CurrentIcons + '\outmess2.gif');
  OutMessage3 := TMemoryStream.Create;
  if FileExists(MyPath + 'Icons\' + CurrentIcons + '\outmess3.gif') then
    OutMessage3.LoadFromFile
      (MyPath + 'Icons\' + CurrentIcons + '\outmess3.gif');
  // Присваиваем картинку пустой аватары в места для аватар
  ContactAvatarImage.Picture.Assign(NoAvatar.Picture);
  MyAvatarImage.Picture.Assign(NoAvatar.Picture);
  xStatusImg := TBitmap.Create;
  xStatusGif := TGifImage.Create;
  xStatusMem := TMemoryStream.Create;
  // Переводим форму на другие языки
  TranslateForm;
  // Создаём меню быстрых ответов
  CreateFastReplyMenu;
  // Помещаем кнопку формы в таскбар и делаем независимой
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE)
      or WS_EX_APPWINDOW);
  // Делаем окно прилипающим к краям экрана
  ScreenSnap := true;
  // Пока скрываем всегда отображение участников конференции
  ChatCategoryButtons.Visible := false;
  GroupSplitter.Visible := false;
end;

procedure TChatForm.FormDestroy(Sender: TObject);
begin
  // Создаём необходимые папки
  ForceDirectories(ProfilePath + 'Profile');
  // Сохраняем настройки положения окна чата в xml
  with TrXML.Create() do
    try
      if FileExists(ProfilePath + SettingsFileName) then
        LoadFromFile(ProfilePath + SettingsFileName);
      // Сохраняем позицию окна
      if OpenKey('settings\forms\chatform\position', true) then
        try
          WriteInteger('top', Top);
          WriteInteger('left', Left);
          WriteInteger('height', Height);
          WriteInteger('width', Width);
          // Сохраняем позицию сплитеров
          WriteInteger('chat-splitter', BottomChatFormPanel.Height);
          WriteInteger('group-splitter', ChatCategoryButtons.Width);
        finally
          CloseKey();
        end;
      // Сохраняем "отправлять по интер"
      if OpenKey('settings\forms\chatform\send-enter', true) then
        try
          WriteBool('value', EnterKeyToolButton.Down);
        finally
          CloseKey();
        end;
      // Сохраняем отправлять отчёт о печати текста
      if OpenKey('settings\forms\chatform\send-typing-notify', true) then
        try
          WriteBool('value', TypingTextToolButton.Down);
        finally
          CloseKey();
        end;
      // Сохраняем "звук нажатия клавиш"
      if OpenKey('settings\forms\chatform\key-sound', true) then
        try
          WriteBool('value', KeySoundToolButton.Down);
        finally
          CloseKey();
        end;
      // Сохраняем состояние панелей аватар
      if OpenKey('settings\forms\chatform\avatar-panels', true) then
        try
          WriteInteger('contact-avatar', ContactAvatarPanel.Width);
          WriteInteger('my-avatar', MyAvatarPanel.Width);
        finally
          CloseKey();
        end;
      // Записываем сам файл
      SaveToFile(ProfilePath + SettingsFileName);
    finally
      Free();
    end;
end;

procedure TChatForm.FormResize(Sender: TObject);
begin
  // Если пустая вкладка, то выходим
  if ChatPageControl.ActivePage = nil then
    Exit;
  // Регулируем высоту вкладок для мультилайн режима
  ChatPageControl.Height := ChatPageControl.ActivePage.Top - 3;
end;

procedure TChatForm.HtmlPopupMenuPopup(Sender: TObject);
begin
  // Проверяем есть ли выделенный текст в истории чата
  if HTMLChatViewer.SelLength = 0 then
  begin
    ChatHTMLTextCopy.Enabled := false;
    ChatHTMLQText.Enabled := false;
  end
  else
  begin
    ChatHTMLTextCopy.Enabled := true;
    ChatHTMLQText.Enabled := true;
  end;
end;

procedure TChatForm.HistorySpeedButtonClick(Sender: TObject);
begin
  // Открываем окно истории
  if not Assigned(HistoryForm) then
    HistoryForm := THistoryForm.Create(self);
  // Загружаем файл истории для текущего чата
  HistoryForm.LoadHistoryFromFile(InfoPanel2.Caption);
  // Отображаем окно
  if HistoryForm.Visible then
    ShowWindow(HistoryForm.Handle, SW_RESTORE);
  HistoryForm.Show;
end;

procedure TChatForm.HistorySpeedButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Открываем меню над этим элементом
  if Button = mbRight then
    Popup(HistorySpeedButton, HistoryShowPopupMenu);
end;

procedure TChatForm.HTMLChatViewerHotSpotClick
  (Sender: TObject; const SRC: string; var Handled: Boolean);
begin
  Handled := true;
  // Открываем ссылку из чата во внешнем браузере
  OpenURL(SRC);
end;

procedure TChatForm.HTMLChatViewerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // При нажатии комбинации клавиш контрл + с в истории чата
  // копируем выделенный текст в буфер обмена
  if (GetKeyState(VK_CONTROL) < 0) and (Key = 67) then
    HTMLChatViewer.CopyToClipboard;
end;

procedure TChatForm.HTMLChatViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Сбрасываем выделение текста в чате по клику левой клавишей мыши
  if Button = mbLeft then
    HTMLChatViewer.SelLength := 0;
end;

procedure TChatForm.HTMLChatViewerParseEnd(Sender: TObject);
begin
  // Заменяем всегда картинку доп. статуса при изменениях текста чата
  try
    HTMLChatViewer.ReplaceImage('x', xStatusMem);
  except
    on E: Exception do
      TLogger.Instance.WriteMessage(E);
  end;
end;

procedure TChatForm.SmiliesSpeedButtonClick(Sender: TObject);
var
  xPoint: TPoint;
begin
  // Если окно не создано ещё, то создаём его
  if not Assigned(SmilesForm) then
    SmilesForm := TSmilesForm.Create(nil);
  // Присваиваем окну чата
  SmilesForm.PopupParent := ChatForm;
  // Вычисляем позицию над вызывающим контролом
  xPoint := point(SmiliesSpeedButton.Width, SmiliesSpeedButton.Top);
  with SmiliesSpeedButton.ClientToScreen(xPoint) do
  begin
    SmilesForm.Left := X - SmiliesSpeedButton.Width;
    SmilesForm.Top := (Y - SmilesForm.Height) - 2;
  end;
  // Ставим флаги окну отображаться поверх всех (против глюка в вайн)
  SetWindowPos(SmilesForm.Handle, HWND_TOPMOST, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOOWNERZORDER or
      SWP_NOREDRAW or SWP_NOSENDCHANGING);
  // Отображаем окно смайлов
  SmilesForm.Show;
end;

procedure TChatForm.SendMessageSpeedButtonDropClick(Sender: TObject);
begin
  // Открываем меню над этим элементом
  Popup_down(SendMessageSpeedButtonDrop, SendPopupMenu);
end;

procedure TChatForm.ContactAvatarPanelSpeedButtonClick(Sender: TObject);
var
  FCursor: TPoint;
begin
  // Прячем панель с аватаркой
  GetCursorPos(FCursor);
  if ContactAvatarPanelSpeedButton.NumGlyphs = 4 then
  begin
    ContactAvatarPanel.Width := 0;
    ContactAvatarPanelSpeedButton.NumGlyphs := 1;
    SetCursorPos(FCursor.X - 68, FCursor.Y);
    InfoPanel1.Left := ContactAvatarPanelSpeedButton.Left + 8;
    InfoPanel3.Left := InfoPanel1.Left;
    InfoPanel1.Width := InfoPanel2.Left - 15;
    InfoPanel3.Width := InfoPanel1.Width;
  end
  else
  begin
    ContactAvatarPanel.Width := 68;
    ContactAvatarPanelSpeedButton.NumGlyphs := 4;
    SetCursorPos(FCursor.X + 68, FCursor.Y);
    InfoPanel1.Left := ContactAvatarPanelSpeedButton.Left + 8;
    InfoPanel3.Left := InfoPanel1.Left;
    InfoPanel1.Width := InfoPanel2.Left - 83;
    InfoPanel3.Width := InfoPanel1.Width;
  end;
end;

procedure TChatForm.ContactMenuToolButtonClick(Sender: TObject);
begin
  // Открываем меню над этим элементом
  Popup(ContactMenuToolButton, ChatUserPopupMenu);
end;

procedure TChatForm.ContactMenuToolButtonContextPopup
  (Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  // Открываем меню над этим элементом
  Popup(ContactMenuToolButton, ChatUserPopupMenu);
end;

procedure TChatForm.ClearChatSpeedButtonClick(Sender: TObject);
var
  Doc: string;
begin
  // Очищаем окно чата от истории сообщений
  HTMLChatViewer.Clear;
  // Добавляем стили
  Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
  HTMLChatViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
end;

procedure TChatForm.CloseTabBitBtnClick(Sender: TObject);
begin
  // Закрываем вкладку чата
  if (ChatPageControl.Visible) and (ChatPageControl.PageCount > 0) then
  begin
    ChatPageControl.ActivePage.Free;
    // Если вкладок больше нет, то закрываем окно
    if ChatPageControl.PageCount = 0 then
      Close
    else
      ChatPageControlChange(self);
  end;
end;

procedure TChatForm.CloseTabSpeedButtonDropClick(Sender: TObject);
begin
  // Открываем меню над этим элементом
  Popup_down(CloseTabSpeedButtonDrop, CloseTabPopupMenu);
end;

procedure TChatForm.ShowAllHistoryClick(Sender: TObject);
var
  Doc: string;
  RosterItem: TListItem;
begin
  // Ищем эту запись в Ростере и помечаем что сообщения прочитаны и получаем параметры
  RosterItem := RosterForm.ReqRosterItem(InfoPanel2.Caption);
  if RosterItem <> nil then
  begin
    with RosterItem do
    begin
      // Проверяем загружена ли история
      if SubItems[13] = EmptyStr then
        Exit
        // Отображаем историю в чате
      else
      begin
        // Очистили компонент истории и выводим надпись, что история загружается
        Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
        Doc := Doc + '<span class=b>' + HistoryLoadFileL + '</span>';
        HTMLChatViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
        HTMLChatViewer.Refresh;
        // Добавляем стили
        Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
        // Загружаем из истории указанное количесво сообщений
        if (Sender as TMenuItem).Tag = 1 then
          Doc := Doc + SubItems[13]
        else if (Sender as TMenuItem).Tag = 2 then
          Doc := Doc + TailLineTail(SubItems[13], 100)
        else if (Sender as TMenuItem).Tag = 3 then
          Doc := Doc + TailLineTail(SubItems[13], 50)
        else if (Sender as TMenuItem).Tag = 4 then
          Doc := Doc + TailLineTail(SubItems[13], 20);
        if not TextSmilies then
          ChatForm.CheckMessage_Smilies(Doc);
        SetLength(Doc, Length(Doc) - 6);
        Doc := Doc + '<HR>';
        HTMLChatViewer.LoadFromBuffer(PChar(Doc), Length(Doc), EmptyStr);
        // Ставим каретку в самый низ текста
        HTMLChatViewer.VScrollBarPosition := HTMLChatViewer.VScrollBar.Max;
        HTMLChatViewer.CaretPos := Length(Doc);
      end;
    end;
  end;
end;

procedure TChatForm.ChatHTMLTextCopyClick(Sender: TObject);
begin
  // Копируем выделенный текст в буфер обмена
  HTMLChatViewer.CopyToClipboard;
end;

procedure TChatForm.MemoPopupMenuPopup(Sender: TObject);
begin
  // Управляем пунктами меню
  if InputMemo.SelLength = 0 then
  begin
    CutMemo.Enabled := false;
    CopyMemo.Enabled := false;
  end
  else
  begin
    CutMemo.Enabled := true;
    CopyMemo.Enabled := true;
  end;
end;

procedure TChatForm.CutMemoClick(Sender: TObject);
begin
  // Вырезаем в буфер обмена
  InputMemo.CutToClipboard;
end;

procedure TChatForm.ChatHTMLAllTextCopyClick(Sender: TObject);
begin
  // Выделяем всё и копируем в буфер обмена
  HTMLChatViewer.SelectAll;
  HTMLChatViewer.CopyToClipboard;
end;

end.
