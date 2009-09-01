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
  Dialogs, ComCtrls, JvExComCtrls, JvListView, CategoryButtons;

type
  TRosterForm = class(TForm)
    RosterJvListView: TJvListView;
    procedure FormCreate(Sender: TObject);
    procedure RosterJvListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearContacts(cType: string);
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
  MainUnit, IcqProtoUnit, UtilsUnit, VarsUnit, ChatUnit;

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
    if Visible then ShowWindow(ChatForm.Handle, SW_RESTORE);
    Show;
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
        end;
      end;
    end;
    //--��������� ������� � ���� �������
    SubItems[13] := SubItems[13] + '<span class=b>' + cMsgD +
      '</span><br><span class=c>' + cMess + '</span><br><br>' + #13#10;
    //--������ ���� ����� ��������, ��� ������� ����������
    Checked := true;
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

procedure TRosterForm.RosterJvListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
 // showmessage('s');
end;

procedure TRosterForm.UpdateFullCL;
label
  jl, il;
var
  i, c, cc: integer;
begin
  //--������������ ���� ������
  with RosterJvListView do
  begin
    with MainForm.ContactList do
    begin
      for i := 0 to Items.Count - 1 do
      begin
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
                  //--��������� ���������� ��� ����� �������� � ��
                  Categories[c].Items[cc].Status := StrToInt(Items[i].SubItems[6]);
                  Categories[c].Items[cc].ImageIndex := Categories[c].Items[cc].Status;
                  with Categories[c].Items[cc] do
                  begin
                    //--���� ������ � ����
                    if (Status <> 30) and (Status <> 41) and (Status <> 42) then
                    begin
                      //--��������� ���� ������� � ���� ������
                      Categories[c].Items[cc].Index := 0;
                    end
                    else //--���� ������ �� � ���� � �������� ������� ��������
                    begin
                      if (MainForm.OnlyOnlineContactsToolButton.Down) and
                        (Categories[c].GroupId <> 'NoCL') then Categories[c].Items[cc].Free;
                    end;
                  end;
                  //--���������� ������������ �������
                  goto jl;
                end;
              end;
              //--��������� ������� � ��� ������ � ��
              with Categories[c].Items.Add do
              begin
                Caption := Items[i].SubItems[0];
                UIN := Items[i].Caption;
                Status := 30;
                ImageIndex := 30;
                ImageIndex1 := -1;
                ImageIndex2 := -1;
                ContactType := 'Jabber';
              end;
              //--���������� ������������ �������
              goto jl;
            end;
          end;
          //--���� ����� ������ �� �����
          //--��������� ������ � ���� ������� � ��
          with Categories.Add do
          begin
            Caption := RosterJvListView.Items[i].SubItems[1];
            GroupCaption := RosterJvListView.Items[i].SubItems[1];
            GroupType := 'Jabber';
            //--��������� ������� � ��� ������ � ��
            with Items.Add do
            begin
              Caption := RosterJvListView.Items[i].SubItems[0];
              UIN := RosterJvListView.Items[i].Caption;
              Status := 30;
              ImageIndex := 30;
              ImageIndex1 := -1;
              ImageIndex2 := -1;
              ContactType := 'Jabber';
            end;
          end;
          jl: ;
          Continue;
        end
        //--��������� ICQ �������� � ��
        else if Items[i].SubItems[3] = 'Icq' then
        begin
          if (Length(Items[i].Caption) = 4) and (Items[i].SubItems[0] = '') then
          begin //--������ ICQ
            if (not ICQ_Show_HideContacts) and (Items[i].Caption = '0000') then goto il;
            for c := 0 to Categories.Count - 1 do
            begin
              //--���� ����� ������ �����
              if (Categories[c].GroupId = Items[i].Caption) and (Categories[c].GroupType = 'Icq') then goto il;
            end;
            //--���� ����� ������ �� �����, �� ��������� �
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
            if (not ICQ_Show_HideContacts) and (Items[i].SubItems[1] = '0000') then goto il;
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
                      Status := StrToInt(Items[i].SubItems[6]);
                      ImageIndex := Status;
                      ImageIndex1 := StrToInt(Items[i].SubItems[7]);
                      ImageIndex2 := StrToInt(Items[i].SubItems[8]);
                      //--���� ������ � ����
                      if (Status <> 9) and (Status <> 80) and (Status <> 214) then
                      begin
                        //--��������� ���� ������� � ���� ������
                        Categories[c].Items[cc].Index := 0;
                      end
                      else //--���� ������ �� � ���� � �������� ������� ��������
                      begin
                        if (MainForm.OnlyOnlineContactsToolButton.Down) and (Categories[c].GroupId <> 'NoCL') and
                          (Categories[c].GroupId <> '0000') then Categories[c].Items[cc].Free;
                      end;
                    end;
                    //--���������� ������������ �������
                    goto il;
                  end;
                end;
                //--��������� ������� � ��� ������ � ��
                with Categories[c].Items.Add do
                begin
                  Caption := Items[i].SubItems[0];
                  UIN := Items[i].Caption;
                  Status := 9;
                  ImageIndex := 9;
                  ImageIndex1 := -1;
                  ImageIndex2 := -1;
                  ContactType := 'Icq';
                end;
                //--���������� ������������ �������
                goto il;
              end;
            end;
          end;
          il: ;
          Continue;
        end
        //--��������� MRA �������� � ��
        else if Items[i].SubItems[3] = 'Mra' then
        begin

        end;
      end;
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
  UpdateFullCL;
end;

procedure TRosterForm.ClearContacts(cType: string);
label
  a, b;
var
  i: integer;
begin
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
        Items[i].Delete;
        goto a;
      end;
    end;
    Items.EndUpdate;
  end;
  //--������� �������� � ��
  with MainForm.ContactList do
  begin
    b: ;
    for i := 0 to Categories.Count - 1 do
    begin
      //--������� ������ � ���������� ���������
      if Categories[i].GroupType = cType then
      begin
        Categories[i].Free;
        goto b;
      end;
    end;
  end;
end;

end.

