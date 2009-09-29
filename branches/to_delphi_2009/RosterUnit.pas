{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit RosterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvListView, CategoryButtons, Menus;

type
  TRosterForm = class(TForm)
    RosterJvListView: TJvListView;
    RosterPopupMenu: TPopupMenu;
    ClearICQ: TMenuItem;
    ClearJabber: TMenuItem;
    ClearMRA: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ClearICQClick(Sender: TObject);
    procedure ClearJabberClick(Sender: TObject);
    procedure RosterJvListViewGetImageIndex(Sender: TObject; Item: TListItem);
    procedure ClearMRAClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ClearContacts(cType: string): boolean;
    procedure UpdateFullCL;
    function ReqRosterItem(cId: string): TListItem;
    function ReqCLContact(cId: string): TButtonItem;
    function ReqChatPage(cId: string): TTabSheet;
    procedure RosterItemSetFull(sItem: TListItem);
    procedure AddHistory(cItem: TListItem; cMsgD, cMess: string);
    procedure OpenChatPage(cId: string);
    procedure ResetGroupSelected;
    procedure DellcIdInMessList(cId: string);
  end;

var
  RosterForm: TRosterForm;

implementation

{$R *.dfm}

uses
  MainUnit, IcqProtoUnit, UtilsUnit, VarsUnit, ChatUnit, UnitLogger, rXML;

function TRosterForm.ReqChatPage(cId: string): TTabSheet;
var
  i: integer;
begin
  Result := nil;
  //--���� ������� � ���� ����
  if Assigned(ChatForm) then
  begin
    with ChatForm.ChatPageControl do
    begin
      for i := 0 to PageCount - 1 do
      begin
        if Pages[i].HelpKeyword = cId then
        begin
          Result := Pages[i];
          //--������� �� �����
          Break;
        end;
      end;
    end;
  end;
end;

procedure TRosterForm.DellcIdInMessList(cId: string);
var
  i: integer;
begin
  //--������� ������� � ��������� �� ������ ������� �������� ���������
  if Assigned(InMessList) then
  begin
    try
      with InMessList do
      begin
        for i := 0 to Count - 1 do
        begin
          if Strings[i] = cId then
          begin
            Delete(i);
            Break;
          end;
        end;
      end;
    except
      on E: Exception do
        TLogger.Instance.WriteMessage(E);
    end;
  end;
end;

procedure TRosterForm.ResetGroupSelected;
var
  i: integer;
begin
  //--���������� ��������� ��������� ������ ��� ����� �� ������ ��������
  with MainForm.ContactList do
  begin
    for i := 0 to Categories.Count - 1 do
    begin
      if Categories[i].GroupSelected = true then
      begin
        Categories[i].GroupSelected := false;
        //--�������������� ��������� ������
        ShareUpdateCategory(Categories[i]);
        //--������� �� �����
        Break;
      end;
    end;
  end;
end;

procedure TRosterForm.OpenChatPage(cId: string);
label
  a;
var
  Sheet: TTabSheet;
  i: integer;
begin
  //--���� ���� ���� �� �������, �� ������ ���
  if not Assigned(ChatForm) then ChatForm := TChatForm.Create(self);
  //--���� ������� � ����
  with ChatForm do
  begin
    with ChatPageControl do
    begin
      for i := 0 to PageCount - 1 do
      begin
        if Pages[i].HelpKeyword = cId then
        begin
          ActivePageIndex := Pages[i].PageIndex;
          //--������� �� �����
          goto a;
        end;
      end;
    end;
    //--���� ������� �� �����, �� ������ �
    Sheet := TTabSheet.Create(self);
    Sheet.Caption := cId;
    Sheet.HelpKeyword := cId;
    Sheet.ShowHint := true;
    Sheet.PageControl := ChatPageControl;
    ChatPageControl.ActivePageIndex := Sheet.PageIndex;
    a: ;
    //--���������� ��������� �����
    ChatPageControl.Visible := true;
    //--���������� ��� � ��������� ��������� � ���� ����
    ChatPageControlChange(self);
    //--���������� ���� ���������
    xShowForm(ChatForm);
    //--������ ����� � ���� ����� ������
    if (InputMemo.CanFocus) and (Visible) then InputMemo.SetFocus;
  end;
end;

procedure TRosterForm.AddHistory(cItem: TListItem; cMsgD, cMess: string);
var
  HistoryFile, hFile: string;
begin
  with cItem do
  begin
    //--��������� ��������� �� ������� ���
    if SubItems[13] = EmptyStr then
    begin
      //--��������� ���� ������� ���������
      HistoryFile := ProfilePath + 'Profile\History\' + SubItems[3] + '_' + Caption + '.z';
      if FileExists(HistoryFile) then
      begin
        try
          //--������������� ���� � ��������
          UnZip_File(HistoryFile, ProfilePath + 'Profile\History\');
          //--���������� ������� � ��������� � ����� ��������
          hFile := ProfilePath + 'Profile\History\' + SubItems[3] + '_History.htm';
          SubItems[13] := ReadFromFile(hFile);
          //--������� ��� �� ������ ������������� ���� � ��������
          if FileExists(hFile) then DeleteFile(hFile);
        except
          on E: Exception do
            TLogger.Instance.WriteMessage(E);
        end;
      end;
    end;
    //--��������� ������� � ���� �������
    SubItems[13] := SubItems[13] + '<span class=b>' + cMsgD +
      '</span><br><span class=c>' + cMess + '</span><br><br>' + #13#10;
    //--������ ���� ����� ��������, ��� ���� ������������� ���������
    SubItems[17] := 'X';
    SubItems[36] := 'X';
  end;
end;

procedure TRosterForm.RosterItemSetFull(sItem: TListItem);
var
  i: integer;
begin
  for i := 1 to RosterJvListView.Columns.Count - 1 do
  begin
    case i of
      7, 8, 9: sItem.SubItems.Add('-1');
      19, 20, 36: sItem.SubItems.Add('0');
    else sItem.SubItems.Add('');
    end;
  end;
end;

procedure TRosterForm.RosterJvListViewGetImageIndex(Sender: TObject;
  Item: TListItem);
begin
  //--���������� ������ � �������
  if (Item.SubItems[3] = 'Icq') and (Length(Item.Caption) = 4) then Item.ImageIndex := 227
  else if Item.SubItems[3] = 'Icq' then Item.ImageIndex := 81
  else if Item.SubItems[3] = 'Jabber' then Item.ImageIndex := 43
  else if Item.Caption = 'NoCL' then Item.ImageIndex := 227;
end;

procedure TRosterForm.UpdateFullCL;
label
  x, a;
var
  i, c, cc, s: integer;
begin
  //--������������ ���� ������
  with RosterJvListView do
  begin
    with MainForm.ContactList do
    begin
      //--�������� ���������� ��
      Categories.BeginUpdate;
      //--��������� ������
      for i := 0 to Items.Count - 1 do
      begin
        //--�������� ������ �������� �������
        s := StrToInt(Items[i].SubItems[6]);
        //--��������� Jabber �������� � ��
        if Items[i].SubItems[3] = 'Jabber' then
        begin
          //--���� ������ �������� � ��
          for c := 0 to Categories.Count - 1 do
          begin
            //--���� ����� ������ �����
            if (Categories[c].GroupCaption = Items[i].SubItems[1]) and (Categories[c].GroupType = 'Jabber') then
            begin
              //--�������� ����� � ��� ����� ��������
              for cc := 0 to Categories[c].Items.Count - 1 do
              begin
                if Categories[c].Items[cc].UIN = Items[i].Caption then
                begin
                  with Categories[c].Items[cc] do
                  begin
                    //--��������� ���������� ��� ����� �������� � ��
                    Status := s;
                    ImageIndex := s;
                    //--���� ������ � ����
                    if (Status <> 30) and (Status <> 41) and (Status <> 42) then
                    begin
                      //--��������� ���� ������� ����� ������
                      Index := 0;
                    end
                    else //--���� ������ �� � ���� � �������� ������� ��������
                    begin
                      if (MainForm.OnlyOnlineContactsToolButton.Down) and
                        (Categories[c].GroupId <> 'NoCL') then Free
                      else Index := Categories[c].Items.Count - 1;
                    end;
                  end;
                  //--���������� ������������ �������
                  goto x;
                end;
              end;
              //--���������� ����� ��
              if (MainForm.OnlyOnlineContactsToolButton.Down) and (Categories[c].GroupId <> 'NoCL') and
                ((s = 30) or (s = 41) or (s = 42)) then goto x;
              //--��������� ������� � ��� ������ � ��
              with Categories[c].Items.Add do
              begin
                Caption := Items[i].SubItems[0];
                UIN := Items[i].Caption;
                Status := 30;
                ImageIndex := 30;
                XImageIndex := -1;
                CImageIndex := -1;
                ContactType := 'Jabber';
              end;
              //--���������� ������������ �������
              goto x;
            end;
          end;
          //--���� ����� ������ �� �����
          //--��������� ������ � ���� ������� � ��
          with Categories.Add do
          begin
            Caption := RosterJvListView.Items[i].SubItems[1];
            GroupCaption := RosterJvListView.Items[i].SubItems[1];
            GroupType := 'Jabber';
            //--���������� ����� ��
            if (MainForm.OnlyOnlineContactsToolButton.Down) and
              (RosterJvListView.Items[i].Caption <> 'NoCL') and
              ((s = 30) or (s = 41) or (s = 42)) then goto x;
            //--��������� ������� � ��� ������ � ��
            with Items.Add do
            begin
              Caption := RosterJvListView.Items[i].SubItems[0];
              UIN := RosterJvListView.Items[i].Caption;
              Status := 30;
              ImageIndex := 30;
              XImageIndex := -1;
              CImageIndex := -1;
              ContactType := 'Jabber';
            end;
          end;
        end
        //--��������� ICQ �������� � ��
        else if Items[i].SubItems[3] = 'Icq' then
        begin
          if (Length(Items[i].Caption) = 4) and (Items[i].SubItems[0] = EmptyStr) then
          begin //--������ ICQ
            for c := 0 to Categories.Count - 1 do
            begin
              //--���� ����� ������ �����
              if (not ICQ_Show_HideContacts) and (Categories[c].GroupId = '0000') then
              begin
                Categories[c].Free;
                goto x;
              end;
              if (Categories[c].GroupId = Items[i].Caption) and (Categories[c].GroupType = 'Icq') then
              begin
                Categories[c].GroupCaption := Items[i].SubItems[1];
                goto x;
              end;
            end;
            //--���� ����� ������ �� �����, �� ��������� �
            if (not ICQ_Show_HideContacts) and (Items[i].Caption = '0000') then goto x;
            with Categories.Add do
            begin
              Caption := RosterJvListView.Items[i].SubItems[1];
              GroupCaption := RosterJvListView.Items[i].SubItems[1];
              GroupId := RosterJvListView.Items[i].Caption;
              GroupType := 'Icq';
              if GroupId = '0000' then Collapsed := true; //--����������� ������ ��������� ���������
            end;
          end
          else //--�������
          begin
            //--������ ��������� ��� ����� ��������
            Items[i].SubItems[34] := ICQ_CreateHint(Items[i]);
            if (not ICQ_Show_HideContacts) and (Items[i].SubItems[1] = '0000') then goto x;
            //--���� ������ �������� � ��
            for c := 0 to Categories.Count - 1 do
            begin
              //--���� ����� ������ �����
              if (Categories[c].GroupId = Items[i].SubItems[1]) and (Categories[c].GroupType = 'Icq') then
              begin
                //--�������� ����� � ��� ����� ��������
                for cc := 0 to Categories[c].Items.Count - 1 do
                begin
                  if Categories[c].Items[cc].UIN = Items[i].Caption then
                  begin
                    with Categories[c].Items[cc] do
                    begin
                      //--��������� ���������� ��� ����� �������� � ��
                      Status := s;
                      ImageIndex := s;
                      XImageIndex := StrToInt(Items[i].SubItems[7]);
                      CImageIndex := StrToInt(Items[i].SubItems[8]);
                      Hint := Items[i].SubItems[34];
                      //--���� ������ � ����
                      if (Status <> 9) and (Status <> 80) and (Status <> 214) then
                      begin
                        //--��������� ���� ������� ����� ������
                        Index := 0;
                      end
                      else //--���� ������ �� � ���� � �������� ������� ��������
                      begin
                        if (MainForm.OnlyOnlineContactsToolButton.Down) and (Categories[c].GroupId <> 'NoCL') and
                          (Categories[c].GroupId <> '0000') then Free
                        else Index := Categories[c].Items.Count - 1;
                      end;
                    end;
                    //--���������� ������������ �������
                    goto x;
                  end;
                end;
                //--���������� ����� ��
                if (MainForm.OnlyOnlineContactsToolButton.Down) and
                  (Categories[c].GroupId <> 'NoCL') and
                  (Categories[c].GroupId <> '0000') and
                  ((s = 9) or (s = 80) or (s = 214)) then goto x;
                //--��������� ������� � ��� ������ � ��
                with Categories[c].Items.Add do
                begin
                  Caption := Items[i].SubItems[0];
                  UIN := Items[i].Caption;
                  Status := 9;
                  ImageIndex := 9;
                  XImageIndex := -1;
                  CImageIndex := -1;
                  ContactType := 'Icq';
                  Hint := Items[i].SubItems[34];
                end;
                //--���������� ������������ �������
                goto x;
              end;
            end;
          end;
        end
        //--��������� MRA �������� � ��
        else if Items[i].SubItems[3] = 'Mra' then
        begin

        end;
        x: ;
      end;
      //--���� ������� ����� "�������� ������ ������"
      if MainForm.HideEmptyGroups.Checked then
      begin
        //--��������� �� � ������� ������ ������
        a: ;
        for i := 0 to Categories.Count - 1 do
          if Categories[i].Items.Count = 0 then
          begin
            Categories[i].Free;
            goto a;
          end;
      end;
      //--��������� ��������� ��������� � ���������� ������-��������� � ������� ���������� ��
      for c := 0 to Categories.Count - 1 do
      begin
        if (Categories[c].GroupId = '0000') or (Categories[c].GroupId = 'NoCL') or
          (Categories[c].Items.Count = 0) or (MainForm.OnlyOnlineContactsToolButton.Down) then
          Categories[c].Caption := Categories[c].GroupCaption + ' - ' + IntToStr(Categories[c].Items.Count)
        else
        begin
          i := Categories[c].Items.Count;
          for cc := 0 to Categories[c].Items.Count - 1 do
            case Categories[c].Items[cc].Status of
              9, 30, 41, 42, 80, 214: dec(i);
            end;
          Categories[c].Caption := Categories[c].GroupCaption + ' - ' + IntToStr(i) + GroupInv + IntToStr(Categories[c].Items.Count);
        end;
      end;
      //--��������������� ��������� �������� �����
      if CollapseGroupsRestore then
      begin
        with TrXML.Create() do
        try
          if FileExists(ProfilePath + GroupsFileName) then
            LoadFromFile(ProfilePath + GroupsFileName);
          for c := 0 to Categories.Count - 1 do
          begin
            if OpenKey('groups\' + Categories[c].GroupCaption + '-' +
              Categories[c].GroupType + '-' + Categories[c].GroupId) then
            try
              Categories[c].Collapsed := ReadBool('collapsed');
            finally
              CloseKey();
            end;
          end;
        finally
          Free();
        end;
        CollapseGroupsRestore := false;
      end;
      //--����������� ���������� ��
      Categories.EndUpdate;
    end;
  end;
end;

function TRosterForm.ReqRosterItem(cId: string): TListItem;
begin
  //--������������ ������ � �������
  Result := RosterJvListView.FindCaption(0, cId, true, true, false);
end;

function TRosterForm.ReqCLContact(cId: string): TButtonItem;
label
  x;
var
  i, ii: integer;
begin
  Result := nil;
  //--���� ������� � ��
  with MainForm.ContactList do
  begin
    for i := 0 to Categories.Count - 1 do
    begin
      for ii := 0 to Categories[i].Items.Count - 1 do
      begin
        if Categories[i].Items[ii].UIN = cId then
        begin
          Result := Categories[i].Items[ii];
          //--������� �� ������
          goto x;
        end;
      end;
    end;
  end;
  x: ;
end;

procedure TRosterForm.FormCreate(Sender: TObject);
begin
  //--������������� ������ ����
  MainForm.AllImageList.GetIcon(1, Icon);
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  //--��������� ����� ��������� ������ ���������
  if FileExists(ProfilePath + 'Profile\ContactList.dat') then
    RosterJvListView.LoadFromFile(ProfilePath + 'Profile\ContactList.dat');
end;

function TRosterForm.ClearContacts(cType: string): boolean;
label
  a, b;
var
  i: integer;
begin
  Result := false;
  //--������� �������� � �������
  with RosterJvListView do
  begin
    Items.BeginUpdate;
    a: ;
    for i := 0 to Items.Count - 1 do
    begin
      //--������� ��� �������� ���������
      if Items[i].SubItems[3] = cType then
      begin
        Result := true;
        Items[i].Delete;
        goto a;
      end;
    end;
    Items.EndUpdate;
  end;
  //--������� �������� � ��
  if Result then
  begin
    with MainForm.ContactList do
    begin
      b: ;
      for i := 0 to Categories.Count - 1 do
      begin
        //--������� ��� ������ ���������
        if Categories[i].GroupType = cType then
        begin
          Categories[i].Free;
          goto b;
        end;
      end;
    end;
  end;
end;

procedure TRosterForm.ClearICQClick(Sender: TObject);
begin
  //--������� � ������� ��� ICQ ��������
  if ClearContacts('Icq') then if RoasterReady then RosterForm.UpdateFullCL;
end;

procedure TRosterForm.ClearJabberClick(Sender: TObject);
begin
  //--������� � ������� ��� Jabber ��������
  if ClearContacts('Jabber') then if RoasterReady then RosterForm.UpdateFullCL;
end;

procedure TRosterForm.ClearMRAClick(Sender: TObject);
begin
  //--������� � ������� ��� MRA ��������
  if ClearContacts('Mra') then if RoasterReady then RosterForm.UpdateFullCL;
end;

end.

