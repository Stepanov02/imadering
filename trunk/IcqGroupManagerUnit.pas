{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit IcqGroupManagerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VarsUnit, ComCtrls;

type
  TIcqGroupManagerForm = class(TForm)
    GNameLabel: TLabel;
    GNameEdit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Name_Group: string;
    GroupType: string;
    Create_Group: boolean;
    Id_Group: string;
    procedure TranslateForm;
  end;

var
  IcqGroupManagerForm: TIcqGroupManagerForm;

implementation

{$R *.dfm}

uses
  MainUnit, IcqProtoUnit, UtilsUnit, RosterUnit;

procedure TIcqGroupManagerForm.TranslateForm;
begin
  //--��������� ����� �� ������ �����

end;

procedure TIcqGroupManagerForm.OKButtonClick(Sender: TObject);
label
  x, y;
var
  iClId: TStringList;
  i: integer;
  newId: string;
begin
  //--��������� ������� �� ��������� ICQ
  if GroupType = 'Icq' then
  begin
    //--���� ���� ������ � ��������� �� ��� �������, �� ��� � ���������
    if ICQ_SSI_Phaze then
    begin
      DAShow(WarningHead, AddContactErr2, EmptyStr, 134, 2, 0);
      Exit;
    end;
    //--���� ��� ���������� ����� �����
    if Create_Group then
    begin
      //--���� �������� ������ ������, �� �������
      if GNameEdit.Text = EmptyStr then goto y;
      //--���� ���� �� ����� ������ ��� � �������
      with RosterForm.RosterJvListView do
      begin
        for i := 0 to Items.Count - 1 do
        begin
          if (Items[i].SubItems[3] = 'Icq') and
            (LowerCase(GNameEdit.Text, loUserLocale) = LowerCase(Items[i].SubItems[1], loUserLocale)) then
          begin
            DAShow(WarningHead, AddNewGroupErr1, EmptyStr, 133, 0, 0);
            Exit;
          end;
        end;
      end;
      //--���������� ������������� ��� ���� ������
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
      end;
      //--��������� ������ � ��������� ������
      ICQ_Add_Nick := GNameEdit.Text;
      ICQ_Add_GroupId := newId;
      ICQ_Add_Group_Phaze := true;
      ICQ_SSI_Phaze := true;
      ICQ_AddGroup(GNameEdit.Text, newId);
    end
    //--���������������� ������
    else
    begin
      //--���� ��� ��������������� ������, �� �������
      if (GNameEdit.Text = EmptyStr) or (GNameEdit.Text = Name_Group) or
        (Id_Group = EmptyStr) or (Id_Group = 'NoCL') or
        (Id_Group = '0000') or (Id_Group = '0001') then goto y;
      //--���������� ���������� ��� ������
      ICQ_Add_Nick := GNameEdit.Text;
      ICQ_Add_GroupId := Id_Group;
      //--������ ������ ��� ��������������� �����
      iClId := TStringList.Create;
      try
        //--������� � ������ �������������� �����
        with RosterForm.RosterJvListView do
        begin
          for i := 0 to Items.Count - 1 do
          begin
            //--��������� �������������� ����� � ������
            if (Items[i].Caption = 'NoCL') or (Items[i].Caption = '0000') then Continue;
            if (Items[i].SubItems[3] = 'Icq') and (Length(Items[i].Caption) = 4) then iClId.Add(Items[i].Caption);
          end;
        end;
        //--��������� ��� ������ �� �������
        ICQ_UpdateGroup_AddContact(GNameEdit.Text, Id_Group, iClId);
        //--��������������� ������ � ��������� ��
        with RosterForm.RosterJvListView do
        begin
          for i := 0 to Items.Count - 1 do
          begin
            //--���� � ������� ��� ������
            if (Items[i].Caption = 'NoCL') or (Items[i].Caption = '0000') or
              (Items[i].Caption = '0001') then Continue;
            if (Items[i].SubItems[3] = 'Icq') and (Items[i].Caption = Id_Group) then
            begin
              Items[i].SubItems[1] := GNameEdit.Text;
              //--������ ��������� ��
              RosterForm.UpdateFullCL;
              Break;
            end;
          end;
        end;
      finally
        iClId.Free;
      end;
    end;
  end
  //--��������� ������� �� ��������� Jabber
  else if GroupType = 'Jabber' then
  begin

  end
  //--��������� ������� �� ��������� MRA
  else if GroupType = 'Mra' then
  begin

  end;
  //--������� � ��������� ��������� ����
  y: ;
  ModalResult := mrOk;
end;

procedure TIcqGroupManagerForm.FormCreate(Sender: TObject);
begin
  //--��������� ����� �� ������ �����
  TranslateForm;
end;

procedure TIcqGroupManagerForm.FormShow(Sender: TObject);
begin
  //--������ ����� � ���� ����� ������
  if GNameEdit.CanFocus then GNameEdit.SetFocus;
end;

end.

