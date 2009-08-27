unit RosterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvListView, CategoryButtons;

type
  TRosterForm = class(TForm)
    RosterJvListView: TJvListView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearContacts(cType: string);
    procedure UpdateFullCL;
    function ReqRosterItem(cId: string): TListItem;
    function ReqCLContact(cId: string): TButtonItem;
    procedure RosterItemSetFull(sItem: TListItem);
  end;

var
  RosterForm: TRosterForm;

implementation

{$R *.dfm}

uses
  MainUnit, IcqProtoUnit;

procedure TRosterForm.RosterItemSetFull(sItem: TListItem);
var
  i: integer;
begin
  for i := 1 to RosterJvListView.Columns.Count - 1 do
  begin
    sItem.SubItems.Add('');
    //--������������� ����
    Application.ProcessMessages;
  end;
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
    for i := 0 to Items.Count - 1 do
    begin
      if Items[i].Caption <> EmptyStr then
      begin
        with MainForm.ContactList do
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
                      end;
                    end;
                    //--���������� ������������ �������
                    goto jl;
                  end;
                  //--������������� ����
                  Application.ProcessMessages;
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
              //--������������� ����
              Application.ProcessMessages;
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
                //--������������� ����
                Application.ProcessMessages;
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
                        end;
                      end;
                      //--���������� ������������ �������
                      goto il;
                    end;
                    //--������������� ����
                    Application.ProcessMessages;
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
                //--������������� ����
                Application.ProcessMessages;
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
      //--������������� ����
      Application.ProcessMessages;
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
        //--������������� ����
        Application.ProcessMessages;
      end;
      //--������������� ����
      Application.ProcessMessages;
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
end;

procedure TRosterForm.ClearContacts(cType: string);
label
  a;
var
  i: integer;
begin
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
      //--������������� ����
      Application.ProcessMessages;
    end;
    Items.EndUpdate;
  end;
end;

end.

