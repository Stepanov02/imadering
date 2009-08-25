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
  end;

var
  RosterForm: TRosterForm;

implementation

{$R *.dfm}

uses
  MainUnit;

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

