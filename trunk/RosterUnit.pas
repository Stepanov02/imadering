﻿unit RosterUnit;

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
  ComCtrls,
  JvExComCtrls,
  JvListView,
  CategoryButtons,
  Menus,
  ExtCtrls,
  StdCtrls,
  Buttons,
  JvSimpleXml,
  ChatUnit;
{$ENDREGION}

{$REGION 'Procedures and Functions'}
procedure UpdateFullCL;
procedure ClearContacts(CType: string);
procedure RosterDeleteContact(KProto, KItem, KValue: string);
procedure RosterUpdateContact(KProto, KItem, KValue, UItem, UValue: string);
procedure RosterDeleteGroup(GProto, GItem, GValue: string);
procedure RosterUpdateGroup(GProto, GItem, GValue, UItem, UValue: string);
procedure OpenChatPage(CButton: TButtonItem; UIN: string = '');
{$ENDREGION}

implementation

{$REGION 'MyUses'}
uses
  MainUnit,
  VarsUnit,
  UtilsUnit,
  OverbyteIcsUrl;
{$ENDREGION}

{$REGION 'OpenChatPage'}

procedure OpenChatPage(CButton: TButtonItem; UIN: string = '');
label
  A;
var
  ChatTab: TToolButton;
  I: Integer;
begin
  // Если окно чата не создано, то создаём его
  if not Assigned(ChatForm) then
    Application.CreateForm(TChatForm, ChatForm);
  with ChatForm do
  begin
    // Сохраняем набранный текст для этой вкладки
    Save_Input_Text;

    {with ChatPageToolBar do
      begin
        // Удаляем кнопку с меткой удаления (против глюка в Wine)
        if (ButtonCount = 1) and (Buttons[0].AutoSize = False) then
          RemoveChatPageButton(Buttons[0]);
        // Если это кнопка
        if (CButton <> nil) and (UIN = EmptyStr) then
          begin
            // Ищем вкладку в табе
            for I := 0 to ButtonCount - 1 do
              begin
                if Buttons[I].HelpKeyword = CButton.UIN then
                  begin
                    Buttons[I].Down := True;
                    CreateNewChat(Buttons[I]);
                    // Выходим из цикла
                    goto A;
                  end;
              end;
            // Если вкладку не нашли, то создаём её
            ChatTab := TToolButton.Create(nil);
            ChatTab.Parent := ChatPageToolBar;
            ChatTab.Caption := CButton.Caption;
            ChatTab.HelpKeyword := CButton.UIN;
            ChatTab.ShowHint := True;
            ChatTab.Hint := CButton.Hint;
            ChatTab.Style := TbsCheck;
            ChatTab.AutoSize := True;
            ChatTab.Grouped := True;
            ChatTab.ImageIndex := CButton.Status;
            ChatTab.OnMouseDown := ToolButtonMouseDown;
            ChatTab.OnMouseUp := ToolButtonMouseUp;
            ChatTab.OnContextPopup := ToolButtonContextPopup;
            ChatTab.Down := True;
            ChatTab.PopupMenu := TabPopupMenu;
            CreateNewChat(ChatTab);
          end
        else if (CButton = nil) and (UIN <> EmptyStr) then
          begin
            // Ищем вкладку в табе
            for I := 0 to ButtonCount - 1 do
              begin
                if Buttons[I].HelpKeyword = UIN then
                  begin
                    Buttons[I].Down := True;
                    CreateNewChat(Buttons[I]);
                    // Выходим из цикла
                    goto A;
                  end;
              end;
            // Ищем этот UIN в Ростере
            RosterItem := RosterForm.ReqRosterItem(UIN);
            // Если вкладку не нашли, то создаём её
            ChatTab := TToolButton.Create(nil);
            ChatTab.Parent := ChatPageToolBar;
            ChatTab.Caption := URLDecode(RosterItem.SubItems[0]);
            ChatTab.HelpKeyword := RosterItem.Caption;
            ChatTab.ShowHint := True;
            ChatTab.Hint := URLDecode(RosterItem.SubItems[34]);
            ChatTab.Style := TbsCheck;
            ChatTab.AutoSize := True;
            ChatTab.Grouped := True;
            ChatTab.ImageIndex := StrToInt(RosterItem.SubItems[6]);
            ChatTab.OnMouseDown := ToolButtonMouseDown;
            ChatTab.OnMouseUp := ToolButtonMouseUp;
            ChatTab.OnContextPopup := ToolButtonContextPopup;
            ChatTab.Down := True;
            ChatTab.PopupMenu := TabPopupMenu;
            CreateNewChat(ChatTab);
          end;
      end;
  A :;
    // Испраляем глюк тулбара закладок чата (те кто писал ComCtrls.pas - пиздюки)
    ChatPageToolBar.Realign;
    // Отображаем окно сообщений
    XShowForm(ChatForm);
    // Ставим фокус в поле ввода текста
    if (InputRichEdit.CanFocus) and (Visible) then
      InputRichEdit.SetFocus;}
  end;
end;
{$ENDREGION}
{$REGION 'UpdateFullCL'}

procedure UpdateFullCL;
label
  A;
var
  I, G, K, S: Integer;
  XML_Node, Sub_Node, Tri_Node: TJvSimpleXmlElem;
  Group_Yes, Contact_Yes: Boolean;
  JvXML: TJvSimpleXml;
begin
  with MainForm.ContactList do
  begin
    try
      // Начинаем обновление КЛ
      Categories.BeginUpdate;
      // Сканируем Ростер
      if V_Roster <> nil then
      begin
        with V_Roster do
        begin
          if Root <> nil then
          begin
            // --------------------------------------------------------------------------------------------------------------------------
            // Добавляем MRA контакты в КЛ
            XML_Node := Root.Items.ItemNamed[C_Mra];
            if XML_Node <> nil then
            begin
              // Открываем раздел с группами
              Sub_Node := XML_Node.Items.ItemNamed[C_Group + C_SS];
              if Sub_Node <> nil then
              begin
                // Запускаем цикл сканирования групп
                for I := 0 to Sub_Node.Items.Count - 1 do
                begin
                  Tri_Node := Sub_Node.Items.Item[I];
                  if Tri_Node <> nil then
                  begin
                    // Сканируем группы КЛ
                    Group_Yes := False;
                    for G := 0 to Categories.Count - 1 do
                    begin
                      if (Categories[G].GroupId = Tri_Node.Properties.Value(C_Id)) and (Categories[G].GroupType = C_Mra) then
                      begin
                        // Если такую группу нашли
                        Group_Yes := True;
                        // Обновляем название этой группы
                        Categories[G].Caption := URLDecode(Tri_Node.Properties.Value(C_Name));
                        Categories[G].GroupCaption := URLDecode(Tri_Node.Properties.Value(C_Name));
                        Break;
                      end;
                    end;
                    // Если такую группу не нашли, то добавляем её
                    if not Group_Yes then
                    begin
                      with Categories.Add do
                      begin
                        Caption := URLDecode(Tri_Node.Properties.Value(C_Name));
                        GroupCaption := URLDecode(Tri_Node.Properties.Value(C_Name));
                        GroupId := Tri_Node.Properties.Value(C_Id);
                        GroupType := C_Mra;
                        GroupImage := 311;
                      end;
                    end;
                  end;
                end;
              end;
              // Открываем раздел с контактами
              Sub_Node := XML_Node.Items.ItemNamed[C_Contact + C_SS];
              if Sub_Node <> nil then
              begin
                // Запускаем цикл сканирования контактов
                for I := 0 to Sub_Node.Items.Count - 1 do
                begin
                  Tri_Node := Sub_Node.Items.Item[I];
                  if Tri_Node <> nil then
                  begin
                    A: ;
                    // Запоминаем статус этого контакта
                    S := Tri_Node.Properties.IntValue(C_Status);
                    // Сканируем группу контакта в КЛ
                    Group_Yes := False;
                    Contact_Yes := False;
                    for G := 0 to Categories.Count - 1 do
                    begin
                      // Если такую группу нашли
                      if (RightStr(Categories[G].GroupId, 4) = Tri_Node.Properties.Value(C_Group + C_Id)) and (Categories[G].GroupType = C_Mra) then
                      begin
                        Group_Yes := True;
                        // Начинаем поиск в ней этого контакта
                        for K := 0 to Categories[G].Items.Count - 1 do
                        begin
                          if Categories[G].Items[K].UIN = Tri_Node.Properties.Value(C_Login) then
                          begin
                            // Если такой контакт нашли
                            Contact_Yes := True;
                            // Обновляем параметры этого контакта
                            with Categories[G].Items[K] do
                            begin
                              Status := S;
                              ImageIndex := S;
                              XImageIndex := Tri_Node.Properties.IntValue(C_XStatus);
                              CImageIndex := Tri_Node.Properties.IntValue(C_Client);
                              // Hint := URLDecode(Items[I].SubItems[34]);
                              // Если статус в сети
                              if (S <> 23) and (S <> 25) and (S <> 275) then
                              begin
                                // Поднимаем этот контакт вверх группы
                                index := 0;
                                // Назначаем ему синий цвет
                                NickColor := 2;
                              end
                              else // Если статус не в сети и скрывать оффлайн контакты
                              begin
                                if (MainForm.OnlyOnlineContactsToolButton.Down) and (Categories[G].GroupId <> C_NoCL) and (Categories[G].GroupId <> C_Phone_m2) then
                                  Free
                                else
                                begin
                                  // Опускаем контакт в конец группы
                                  index := Categories[G].Items.Count - 1;
                                  // Назначаем ему темнокрасный цвет
                                  if Categories[G].GroupId <> C_NoCL then
                                    NickColor := 1
                                  else
                                    NickColor := 0;
                                end;
                              end;
                            end;
                            Break;
                          end;
                        end;
                        // Добавляем контакт в эту группу в КЛ
                        if not Contact_Yes then
                        begin
                          // Если статус не в сети и скрывать оффлайн контакты
                          if ((S = 23) or (S = 25) or (S = 275)) and (MainForm.OnlyOnlineContactsToolButton.Down) and //
                            ((Categories[G].GroupId <> C_NoCL) and (Categories[G].GroupId <> C_Phone_m2)) then
                            Continue;
                          // Добавляем контакт
                          with Categories[G].Items.Add do
                          begin
                            Caption := Trim(URLDecode(Tri_Node.Properties.Value(C_Nick)));
                            if Caption = EmptyStr then
                              Caption := Tri_Node.Properties.Value(C_Login);
                            UIN := Tri_Node.Properties.Value(C_Login);
                            Status := S;
                            ImageIndex := S;
                            XImageIndex := -1;
                            CImageIndex := Tri_Node.Properties.IntValue(C_Client);
                            ContactType := C_Mra;
                            // Hint := URLDecode(Items[I].SubItems[34]);
                            if Categories[G].GroupId <> C_NoCL then
                              NickColor := 1
                            else
                              NickColor := 0;
                          end;
                        end;
                        Break;
                      end;
                    end;
                    // Если такая группа не была найдена
                    if not Group_Yes then
                    begin
                      // Добавляем такие контакты в специальную группу
                      Tri_Node.Properties.ItemNamed[C_Group + C_Id].Value := C_AuthNone;
                      goto A;
                    end;
                  end;
                end;
              end;
              // Если группы "телефонных контактов" и "вне групп" пустые то удаляем их
              I := 0;
              for G := 0 to Categories.Count - 1 do
              begin
                if (Categories[i].GroupId = C_Phone_m2) or (Categories[i].GroupId = C_AuthNone) then
                begin
                  if Categories[i].Items.Count = 0 then
                    begin
                      Categories[i].Free;
                      Dec(I);
                    end;
                end;
                Inc(I);
              end;
            end;
            // --------------------------------------------------------------------------------------------------------------------------
            // Добавляем ICQ контакты в КЛ

            // --------------------------------------------------------------------------------------------------------------------------
            // Добавляем Jabber контакты в КЛ

            // Если активен режим "Скрывать пустые группы"
            if MainForm.HideEmptyGroups.Checked then
            begin
              // Сканируем КЛ и удаляем пустые группы
              I := 0;
              for G := 0 to Categories.Count - 1 do
              begin
                if Categories[I].Items.Count = 0 then
                begin
                  Categories[I].Free;
                  Dec(I);
                end;
                Inc(I);
              end;
            end;
            // Вычисляем количесво контактов и количество онлайн-контактов в группах КЛ
            for G := 0 to Categories.Count - 1 do
            begin
              if ((Categories[G].GroupId = '0000') and (Categories[G].GroupType = C_Icq)) //
              or (Categories[G].GroupId = C_NoCL) or (Categories[G].Items.Count = 0) //
              or (MainForm.OnlyOnlineContactsToolButton.Down) //
              or ((Categories[G].GroupId = C_Phone_m2) and (Categories[G].GroupType = C_Mra)) then
                Categories[G].Caption := Categories[G].GroupCaption + C_BN + '-' + C_BN + IntToStr(Categories[G].Items.Count)
              else
              begin
                I := Categories[G].Items.Count;
                for K := 0 to Categories[G].Items.Count - 1 do
                  case Categories[G].Items[K].Status of
                    9, 23, 25, 30, 41, 42, 80, 83, 84, 214, 298, 299, 300, 312: Dec(I);
                  end;
                Categories[G].Caption := Categories[G].GroupCaption + C_BN + '-' + C_BN + Format('%d/%d', [I, Categories[G].Items.Count]);
              end;
            end;
            // Восстанавливаем состояние свёрнутых групп
            if V_CollapseGroupsRestore then
            begin
              // Ищем раздел состояния групп
              XML_Node := Root.Items.ItemNamed[C_Group + C_SS];
              if XML_Node <> nil then
              begin
                for G := 0 to Categories.Count - 1 do
                begin
                  Sub_Node := XML_Node.Items.ItemNamed[ChangeCP(URLEncode(Categories[G].GroupCaption + Categories[G].GroupType + Categories[G].GroupId))];
                  if Sub_Node <> nil then
                    Categories[G].Collapsed := Sub_Node.Properties.BoolValue(C_CS);
                end;
              end;
              V_CollapseGroupsRestore := False;
            end;
          end;
        end;
      end;
    finally
      // Заканчиваем обновление КЛ
      Categories.EndUpdate;
    end;
  end;
end;
{$ENDREGION}
{$REGION 'ClearContacts'}

procedure ClearContacts(CType: string);
label
  A;
var
  I: Integer;
  XML_Node: TJvSimpleXmlElem;
begin
  // Удаляем контакты из Ростера
  if V_Roster <> nil then
  begin
    with V_Roster do
    begin
      if Root <> nil then
      begin
        // Очищаем раздел MRA если он есть
        XML_Node := Root.Items.ItemNamed[CType];
        if XML_Node <> nil then
          Root.Items.Delete(CType);
      end;
    end;
  end;
  // Удаляем контакты в КЛ
  with MainForm.ContactList do
  begin
    A: ;
    for I := 0 to Categories.Count - 1 do
    begin
      // Удаляем все группы протокола
      if Categories[I].GroupType = CType then
      begin
        Categories[I].Free;
        goto A;
      end;
    end;
  end;
end;
{$ENDREGION}
{$REGION 'RosterDeleteContact'}

procedure RosterDeleteContact(KProto, KItem, KValue: string);
begin
  //

end;
{$ENDREGION}
{$REGION 'RosterUpdateContact'}

procedure RosterUpdateContact(KProto, KItem, KValue, UItem, UValue: string);
var
  I, P: Integer;
  XML_Node, Sub_Node, Tri_Node: TJvSimpleXmlElem;
  XML_Prop: TJvSimpleXMLProp;
begin
  // Обновляем данные контакта в Ростере
  if KProto <> EmptyStr then
  begin
    if V_Roster <> nil then
    begin
      with V_Roster do
      begin
        if Root <> nil then
        begin
          // Ищем раздел нужного нам протокола
          XML_Node := Root.Items.ItemNamed[KProto];
          if XML_Node <> nil then
          begin
            // Ищем раздел контактов в этом протоколе
            Sub_Node := XML_Node.Items.ItemNamed[C_Contact + C_SS];
            if Sub_Node <> nil then
            begin
              if (KItem <> EmptyStr) and (KValue <> EmptyStr) and (UItem <> EmptyStr) then
              begin
                // Ищем параметр этого контакта
                for I := 0 to Sub_Node.Items.Count - 1 do
                begin
                  Tri_Node := Sub_Node.Items.Item[I];
                  if Tri_Node <> nil then
                  begin
                    if Tri_Node.Properties.Value(KItem) = KValue then
                    begin
                      // Обновляем параметр этой записи
                      P := 1;
                      while Parse(C_LN, UItem, P) <> EmptyStr do
                      begin
                        XML_Prop := Tri_Node.Properties.ItemNamed[Parse(C_LN, UItem, P)];
                        if XML_Prop <> nil then
                          XML_Prop.Value := Parse(C_LN, UValue, P)
                        else
                          Tri_Node.Properties.Add(Parse(C_LN, UItem, P), Parse(C_LN, UValue, P));
                        Inc(P);
                      end;
                      Break;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;
{$ENDREGION}
{$REGION 'RosterDeleteGroup'}

procedure RosterDeleteGroup(GProto, GItem, GValue: string);
begin
  //

end;
{$ENDREGION}
{$REGION 'RosterUpdateGroup'}

procedure RosterUpdateGroup(GProto, GItem, GValue, UItem, UValue: string);
begin
  //

end;
{$ENDREGION}

end.

