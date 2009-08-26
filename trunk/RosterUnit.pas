unit RosterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvListView;

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
    procedure UpdateCL(cId: string);
  end;

var
  RosterForm: TRosterForm;

implementation

{$R *.dfm}

uses
  MainUnit;

procedure TRosterForm.UpdateFullCL;
label
  jl;
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
          if Items[i].SubItems.Strings[3] = 'Jabber' then
          begin
            //--���� ������ �������� � ��
            for c := 0 to Categories.Count - 1 do
            begin
              //--���� ����� ������ �����
              if (Categories[c].GroupCaption = Items[i].SubItems.Strings[1]) and
                (Categories[c].GroupType = 'Jabber') then
              begin
                //--�������� ����� � ��� ����� ��������
                for cc := 0 to Categories[c].Items.Count - 1 do
                begin
                  if Categories[c].Items[cc].UIN = Items[i].Caption then
                  begin
                    //--��������� ���������� ��� ����� �������� � ��
                    //Categories[c].Items[cc]
                    //--���������� ������������ �������
                    goto jl;
                  end;
                  //--������������� ����
                  Application.ProcessMessages;
                end;
                //--��������� ������� � ��� ������ � ��
                with Categories[c].Items.Add do
                begin
                  Caption := Items[i].SubItems.Strings[0];
                  UIN := Items[i].Caption;
                  Status := 30;
                  ImageIndex := 30;
                  ImageIndex1 := -1;
                  ImageIndex2 := -1;
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
              Caption := RosterJvListView.Items[i].SubItems.Strings[1];
              GroupCaption := RosterJvListView.Items[i].SubItems.Strings[1];
              GroupType := 'Jabber';
              //--��������� ������� � ��� ������ � ��
              with Items.Add do
              begin
                Caption := RosterJvListView.Items[i].SubItems.Strings[0];
                UIN := RosterJvListView.Items[i].Caption;
                Status := 30;
                ImageIndex := 30;
                ImageIndex1 := -1;
                ImageIndex2 := -1;
              end;
            end;
            jl: ;
            Continue;
          end
          //--��������� ICQ �������� � ��
          else if Items[i].SubItems.Strings[3] = 'Icq' then
          begin

          end;
        end;
      end;
      //--������������� ����
      Application.ProcessMessages;
    end;
  end;
end;

procedure TRosterForm.UpdateCL(cId: string);
begin
  //--������������ ������ � �������
  if RosterJvListView.FindCaption(0, cId, true, true, false) <> nil then
  begin

  end;
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
      //--������� ��� �������� ��������� ICQ
      if Items[i].SubItems.Strings[3] = cType then
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

