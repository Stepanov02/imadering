{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit CLSearchUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, VarsUnit, rXML, JvExComCtrls, JvListView,
  CategoryButtons, ComCtrls, ExtCtrls;

type
  TCLSearchForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CLSearchEdit: TEdit;
    CLSearchJvListView: TJvListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CLSearchEditChange(Sender: TObject);
    procedure CLSearchJvListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CLSearchJvListViewDblClick(Sender: TObject);
    procedure CLSearchJvListViewColumnClick(Sender: TObject;
      Column: TListColumn);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure TranslateForm;
  end;

var
  CLSearchForm: TCLSearchForm;

implementation

{$R *.dfm}

uses
  MainUnit, UtilsUnit, RosterUnit;

procedure TCLSearchForm.CLSearchEditChange(Sender: TObject);
var
  i: integer;
begin
  //--������ ����� ���������� ��������� �������� � ������� ������� � �����
  //��������� � ������
  //--������� ������ ��������� �� ����������� ������
  CLSearchJvListView.Clear;
  if CLSearchEdit.Text <> '' then
  begin
    with RosterForm.RosterJvListView do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        //--���� ����� ����� � ������� ������ ��� ����
        if (BMSearch(0, UpperCase(Items[i].Caption, loUserLocale), UpperCase(CLSearchEdit.Text, loUserLocale)) > -1) or
          (BMSearch(0, UpperCase(Items[i].SubItems[0], loUserLocale), UpperCase(CLSearchEdit.Text, loUserLocale)) > -1) then
        begin
          CLSearchJvListView.Items.Add.Caption := Items[i].Caption;
          CLSearchJvListView.Items[CLSearchJvListView.Items.Count - 1].SubItems.Append(Items[i].SubItems[0]);
          CLSearchJvListView.Items[CLSearchJvListView.Items.Count - 1].ImageIndex := StrToInt(Items[i].SubItems[6]);
        end;
      end;
    end;
  end;
end;

procedure TCLSearchForm.CLSearchJvListViewColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  //--���������� ��������� ����������
  if Column.ImageIndex <> 5 then Column.ImageIndex := 5
  else Column.ImageIndex := 4;
  //--���������� ��������� ���������� � ������ ��������
  for i := 0 to CLSearchJvListView.Columns.Count - 1 do
    if CLSearchJvListView.Columns[i] <> Column then CLSearchJvListView.Columns[i].ImageIndex := -1;
end;

procedure TCLSearchForm.CLSearchJvListViewDblClick(Sender: TObject);
begin
  //--���� �������� �������, �� �������� ��� � � ��
  if CLSearchJvListView.Selected <> nil then
  begin
    //--��������� ��� � ���� ���������
    RosterForm.OpenChatPage(CLSearchJvListView.Selected.Caption);
  end;
end;

procedure TCLSearchForm.CLSearchJvListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  CLItem: TButtonItem;
begin
  //--���� �������� �������, �� �������� ��� � � ��
  if Selected then
  begin
    CLItem := RosterForm.ReqCLContact(Item.Caption);
    if CLItem <> nil then
    begin
      //--�������� ���� ������� � ��
      MainForm.ContactList.SelectedItem := CLItem;
      if CLItem.Category.Collapsed then CLItem.Category.Collapsed := false;
      MainForm.ContactList.ScrollIntoView(CLItem);
    end;
  end;
end;

procedure TCLSearchForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--������� ���� ������ ��������� �� �������� ����
  BringWindowToTop(MainForm.Handle);
  //--��������� �������� ���� ������������ ����� ��������
  Action := caFree;
  CLSearchForm := nil;
end;

procedure TCLSearchForm.FormCreate(Sender: TObject);
begin
  //--�������������� XML
  with TrXML.Create() do
  try
    //--��������� ���������
    if FileExists(ProfilePath + SettingsFileName) then
    begin
      LoadFromFile(ProfilePath + SettingsFileName);
      //--��������� ������� ����
      if OpenKey('settings\forms\clsearchform\position') then
      try
        Top := ReadInteger('top');
        Left := ReadInteger('left');
        Height := ReadInteger('height');
        Width := ReadInteger('width');
        //--���������� �� ��������� �� ���� �� ��������� ������
        MainForm.FormSetInWorkArea(self);
      finally
        CloseKey();
      end;
    end;
  finally
    Free();
  end;
  //--��������� ���� �� ������ �����
  TranslateForm;
  //--��������� ������ � ���� � �������
  MainForm.AllImageList.GetIcon(215, Icon);
  //--������ ���� ����������� � �������� ��� ������ �� ������ �����
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TCLSearchForm.FormDestroy(Sender: TObject);
begin
  //--������ ����������� �����
  ForceDirectories(ProfilePath + 'Profile');
  //--��������� ��������� ��������� ���� � xml
  with TrXML.Create() do
  try
    if FileExists(ProfilePath + SettingsFileName) then LoadFromFile(ProfilePath + SettingsFileName);
    //--��������� ������� ����
    if OpenKey('settings\forms\clsearchform\position', True) then
    try
      WriteInteger('top', Top);
      WriteInteger('left', Left);
      WriteInteger('height', Height);
      WriteInteger('width', Width);
    finally
      CloseKey();
    end;
    //--���������� ��� ����
    SaveToFile(ProfilePath + SettingsFileName);
  finally
    Free();
  end;
end;

procedure TCLSearchForm.TranslateForm;
begin
  //--��������� ���� �� ������ �����

end;

end.

