{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit IcqAddContactUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VarsUnit, ComCtrls;

type
  TIcqAddContactForm = class(TForm)
    AccountEdit: TEdit;
    NameEdit: TEdit;
    GroupComboBox: TComboBox;
    CancelButton: TButton;
    AddContactButton: TButton;
    AccountLabel: TLabel;
    NameLabel: TLabel;
    GroupLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure AddContactButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ContactType: string;
    procedure TranslateForm;
    procedure BuildGroupList(gProto: string);
  end;

var
  IcqAddContactForm: TIcqAddContactForm;

implementation

uses MainUnit, IcqProtoUnit, UtilsUnit, RosterUnit;

{$R *.dfm}

procedure TIcqAddContactForm.BuildGroupList(gProto: string);
var
  i: integer;
begin
  //--���������� ������ ����� �� �������
  with RosterForm.RosterJvListView do
  begin
    //--������ ��� ICQ
    if gProto = 'Icq' then
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if (Items[i].SubItems[3] = 'Icq') and (Length(Items[i].Caption) = 4) then
        begin
          if Items[i].Caption = '0000' then Continue; //--������ ��������� ���������
          if (Items[i].Caption = 'NoCL') or (Items[i].Caption = '0001') then Continue; //--������ "�� � ������"
          GroupComboBox.Items.Add(Items[i].SubItems[1]);
        end;
      end;
    end
    //--������ ��� Jabber
    else if gProto = 'Jabber' then
    begin

    end
    //--������ ��� Mra
    else if gProto = 'Mra' then
    begin

    end;
  end;
  //--���������� �� ��������� ������ ������ � ������ ������ �����
  if GroupComboBox.Items.Count > 0 then GroupComboBox.ItemIndex := 0;
end;

procedure TIcqAddContactForm.TranslateForm;
begin
  //--��������� ����� �� ������ �����

end;

procedure TIcqAddContactForm.AddContactButtonClick(Sender: TObject);
label
  x, y;
var
  RosterItem: TListItem;
  newId, iGpId: string;
  i: integer;
begin
  //--��������� �������� �� ��������� ICQ
  if ContactType = 'Icq' then
  begin
    if ICQ_Work_Phaze then
    begin
      if (AccountEdit.Text <> EmptyStr) and (Length(AccountEdit.Text) > 4) then
      begin
        //--����������� ICQ �����
        AccountEdit.Text := exNormalizeScreenName(AccountEdit.Text);
        AccountEdit.Text := exNormalizeIcqNumber(AccountEdit.Text);
        if Trim(NameEdit.Text) = EmptyStr then NameEdit.Text := AccountEdit.Text;
        //--���� ����� ������� � �������
        RosterItem := RosterForm.ReqRosterItem(AccountEdit.Text);
        if RosterItem <> nil then //--���� ����� ������� ��� �������� � ������, �� �������� �� ����
        begin
          DAShow(WarningHead, AddContactErr1, EmptyStr, 133, 0, 0);
          Exit;
        end;
        //--���� ���� ���������� �������� ��� �������, �� ��� � ���������
        if ICQ_SSI_Phaze then
        begin
          DAShow(WarningHead, AddContactErr2, EmptyStr, 134, 2, 0);
          Exit;
        end;
        //--���� ������ �� �������
        if GroupComboBox.ItemIndex = -1 then
        begin
          DAShow(AlertHead, AddContactErr3, EmptyStr, 134, 2, 0);
          goto y;
        end;
        //--���������� ������������� ��� ����� ��������
        x: ;
        Randomize;
        newId := IntToHex(Random($7FFF), 4);
        //--���� ��� �� ��� ������ �������������� � ������ ���������
        with RosterForm.RosterJvListView do
        begin
          for i := 0 to Items.Count - 1 do
          begin
            if newId = Items[i].SubItems[4] then goto x;
          end;
          //--���� ������������� ��������� ������
          for i := 0 to Items.Count - 1 do
          begin
            if (Items[i].SubItems[1] = GroupComboBox.Text) and (Items[i].SubItems[3] = 'Icq') then
            begin
              iGpId := Items[i].SubItems[4];
              Break;
            end;
          end;
        end;
        //--��������� ������ � ��������� �������
        ICQ_Add_Contact_Phaze := true;
        ICQ_SSI_Phaze := true;
        ICQ_AddContact(AccountEdit.Text, iGpId, newId, NameEdit.Text, false);
      end;
    end;
  end
  //--��������� �������� �� ��������� Jabber
  else if ContactType = 'Jabber' then
  begin

  end
  //--��������� �������� �� ��������� Mra
  else if ContactType = 'Mra' then
  begin

  end;
  //--������� � ��������� ��������� ����
  y: ;
  ModalResult := mrOk;
end;

procedure TIcqAddContactForm.FormCreate(Sender: TObject);
begin
  //--��������� ����� �� ������ �����
  TranslateForm;
  //--����������� ������ ����
  MainForm.AllImageList.GetIcon(143, Icon);
end;

procedure TIcqAddContactForm.FormShow(Sender: TObject);
begin
  //--������ ����� � ���� ����� ������� ������ ���� ��� ������
  if (AccountEdit.CanFocus) and (AccountEdit.Text = EmptyStr) then AccountEdit.SetFocus;
end;

end.

