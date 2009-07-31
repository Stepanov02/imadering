{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit HistoryUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Htmlview, ExtCtrls, Buttons, Menus, VarsUnit,
  ExtDlgs, SimpleXML;

type
  THistoryForm = class(TForm)
    TopPanel: TPanel;
    BottomPanel: TPanel;
    HTMLHistoryViewer: THTMLViewer;
    ContactsComboBox: TComboBox;
    ArhiveComboBox: TComboBox;
    Bevel1: TBevel;
    ContactsLabel: TLabel;
    ArhiveLabel: TLabel;
    SearchTextLabel: TLabel;
    SearchTextEdit: TEdit;
    SearchTextBitBtn: TBitBtn;
    RegistrCheckBox: TCheckBox;
    FullSearchTextCheckBox: TCheckBox;
    ReloadHistoryBitBtn: TBitBtn;
    SaveHistoryAsBitBtn: TBitBtn;
    DeleteHistoryBitBtn: TBitBtn;
    HistoryPopupMenu: TPopupMenu;
    CopyHistorySelText: TMenuItem;
    CopyAllHistoryText: TMenuItem;
    SaveTextAsFileDialog: TSaveTextFileDialog;
    UpSearchCheckBox: TRadioButton;
    DownSearchCheckBox: TRadioButton;
    CloseBitBtn: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HistoryPopupMenuPopup(Sender: TObject);
    procedure HTMLHistoryViewerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchTextBitBtnClick(Sender: TObject);
    procedure ReloadHistoryBitBtnClick(Sender: TObject);
    procedure SaveHistoryAsBitBtnClick(Sender: TObject);
    procedure DeleteHistoryBitBtnClick(Sender: TObject);
    procedure ContactsComboBoxChange(Sender: TObject);
    procedure CopyHistorySelTextClick(Sender: TObject);
    procedure CopyAllHistoryTextClick(Sender: TObject);
    procedure CloseBitBtnClick(Sender: TObject);
  private
    { Private declarations }
    ReqHUIN: string;
    ReqCType: string;
  public
    { Public declarations }
    procedure TranslateForm;
    procedure LoadHistoryFromFile(hUIN: string; fullpath: boolean = false);
  end;

var
  HistoryForm: THistoryForm;

implementation

{$R *.dfm}

uses
  MainUnit, ChatUnit, UtilsUnit;

procedure THistoryForm.LoadHistoryFromFile(hUIN: string; fullpath: boolean = false);
label
  x;
var
  HistoryFile, Doc: string;
  I, II: integer;
begin
  if fullpath then
  begin
    //--�������� ��� � ������������� ��������
    ReqHUIN := Parse('_', hUIN, 2);
    ReqCType := Parse('_', hUIN, 1);
    //--�������� ��������� �������
    HTMLHistoryViewer.Clear;
    //--��������� ���� ������� ���������
    HistoryFile := MyPath + 'Profile\History\' + hUIN + '.z';
    if FileExists(HistoryFile) then
    begin
      try
        //--������������� ���� � ��������
        UnZip_File(HistoryFile, MyPath + 'Profile\History\');
        //--��������� �����
        Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
        //--���������� �������
        Doc := Doc + ReadFromFile(MyPath + 'Profile\History\Icq_History.htm');
        //--������� ��� �� ������ ������������� ���� � ��������
        if FileExists(MyPath + 'Profile\History\Icq_History.htm') then DeleteFile(MyPath + 'Profile\History\Icq_History.htm');
        if not TextSmilies then ChatForm.CheckMessage_Smilies(Doc);
        SetLength(Doc, Length(Doc) - 6);
        Doc := Doc + '<HR>';
        HTMLHistoryViewer.LoadFromBuffer(PChar(Doc), Length(Doc), '');
        HTMLHistoryViewer.Position := HTMLHistoryViewer.VScrollBar.Max;
        //--������ ������� � ����� ��� ������
        HTMLHistoryViewer.CaretPos := Length(Doc);
      except
      end;
    end;
  end
  else
  begin
    //--���������� ������������� ��������
    ReqHUIN := hUIN;
    //--��������� ��������� ������� ��� ����� ��������
    with MainForm.ContactList do
    begin
      for I := 0 to Categories.Count - 1 do
      begin
        for II := 0 to Categories[I].Items.Count - 1 do
        begin
          if Categories[I].Items[II].UIN = hUIN then
          begin
            //--���������� ��� ��������
            ReqCType := Categories[I].Items[II].ContactType;
            //--������������ ������ �� ��� ������� ������
            ContactsComboBox.ItemIndex := ContactsComboBox.Items.IndexOf(ReqCType + '_' + hUIN);
            //--��������� ��������� �� ������� ���
            if Categories[I].Items[II].History = '' then
            begin
              //--��������� ���� ������� ���������
              HistoryFile := MyPath + 'Profile\History\' + ReqCType + '_' + hUIN + '.z';
              if FileExists(HistoryFile) then
              begin
                try
                  //--������������� ���� � ��������
                  UnZip_File(HistoryFile, MyPath + 'Profile\History\');
                  //--���������� ������� � ��������� � ����� ��������
                  Categories[I].Items[II].History := ReadFromFile(MyPath + 'Profile\History\Icq_History.htm');
                  //--������� ��� �� ������ ������������� ���� � ��������
                  if FileExists(MyPath + 'Profile\History\Icq_History.htm') then DeleteFile(MyPath + 'Profile\History\Icq_History.htm');
                except
                end;
              end;
            end;
            //--���������� ������� � ����
            if Categories[I].Items[II].History <> '' then
            begin
              //--�������� ��������� �������
              HTMLHistoryViewer.Clear;
              //--��������� �����
              Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
              //--��������� �� ����� ������� ��������� ��������� ���������
              Doc := Doc + Categories[I].Items[II].History;
              if not TextSmilies then ChatForm.CheckMessage_Smilies(Doc);
              SetLength(Doc, Length(Doc) - 6);
              Doc := Doc + '<HR>';
              HTMLHistoryViewer.LoadFromBuffer(PChar(Doc), Length(Doc), '');
              HTMLHistoryViewer.Position := HTMLHistoryViewer.VScrollBar.Max;
              //--������ ������� � ����� ��� ������
              HTMLHistoryViewer.CaretPos := Length(Doc);
            end
            else
            begin
              //--�������� ��������� �������
              HTMLHistoryViewer.Clear;
              //--��������� �����
              Doc := '<html><head>' + ChatCSS + '<title>Chat</title></head><body>';
              Doc := Doc + '<span class=d>' + HistoryNotFile + '</span>';
              HTMLHistoryViewer.LoadFromBuffer(PChar(Doc), Length(Doc), '');
            end;
            //--������� �� ����� ���� ����� �������
            goto x;
          end;
          //--�� ������������ ���������
          Application.ProcessMessages;
        end;
      end;
    end;
  end;
  x: ;
end;

procedure THistoryForm.CopyHistorySelTextClick(Sender: TObject);
begin
  //--�������� ���������� ����� � ����� ������
  HTMLHistoryViewer.CopyToClipboard;
end;

procedure THistoryForm.CopyAllHistoryTextClick(Sender: TObject);
begin
  //--�������� ���� ����� � ����� ������
  HTMLHistoryViewer.SelectAll;
  HTMLHistoryViewer.CopyToClipboard;
end;

procedure THistoryForm.HistoryPopupMenuPopup(Sender: TObject);
begin
  //--���������� ���� �� ���������� �����
  if HTMLHistoryViewer.SelLength = 0 then
  begin
    HistoryPopupMenu.Items.Items[0].Enabled := false;
  end
  else
  begin
    HistoryPopupMenu.Items.Items[0].Enabled := true;
  end;
end;

procedure THistoryForm.TranslateForm;
begin
  //--��������� ����� �� ������ �����

end;

procedure THistoryForm.SearchTextBitBtnClick(Sender: TObject);
begin
  //--������ ����� ������ � �������
  HTMLHistoryViewer.FindEx(SearchTextEdit.Text, RegistrCheckBox.Checked, UpSearchCheckBox.Checked);
end;

procedure THistoryForm.ReloadHistoryBitBtnClick(Sender: TObject);
begin
  //--������������� ���� �������
  LoadHistoryFromFile(ReqHUIN);
end;

procedure THistoryForm.SaveHistoryAsBitBtnClick(Sender: TObject);
var
  list: TStringList;
begin
  //--���� ���� � ����� ������, �� �������
  if (ReqHUIN = '') or (ReqCType = '') then Exit;
  //--��������� ��������� ��� �����
  SaveTextAsFileDialog.FileName := 'History_' + ReqCType + '_' + ReqHUIN;
  //--��������� ������ ���������� �����
  if SaveTextAsFileDialog.Execute then
  begin
    //--������ ���� �����
    list := TStringList.Create;
    try
      //--�������� ���� ����� � �������
      HTMLHistoryViewer.SelectAll;
      //--�������� ���������� ����� � ����
      list.Text := HTMLHistoryViewer.SelText;
      //--���������� ��������� ������
      HTMLHistoryViewer.SelLength := 0;
      //--��������� ����� �� ����� � ���� �� �������
      list.SaveToFile(SaveTextAsFileDialog.FileName);
    finally
      list.Free;
    end;
  end;
end;

procedure THistoryForm.DeleteHistoryBitBtnClick(Sender: TObject);
var
  Doc: string;
  i: integer;
begin
  //--���� ���� � ����� ������, �� �������
  if (ReqHUIN = '') or (ReqCType = '') then Exit;
  //--������� ������ �� �������� ����� �������
  i := MessageBox(Handle, PChar(HistoryDelL), PChar(WarningHead), MB_TOPMOST or MB_YESNO or MB_ICONQUESTION);
  //--���� ����� �������������
  if i = 6 then
  begin
    //--������� ����
    if FileExists(MyPath + 'Profile\History\' + ReqCType + '_' + ReqHUIN + '.z') then
      DeleteFile(MyPath + 'Profile\History\' + ReqCType + '_' + ReqHUIN + '.z');
    //--������� ��������� �������
    HTMLHistoryViewer.Clear;
    Doc := '';
    HTMLHistoryViewer.LoadFromBuffer(PChar(Doc), Length(Doc), '');
  end;
end;

procedure THistoryForm.CloseBitBtnClick(Sender: TObject);
begin
  //--��������� ���� � ��������
  Close;
end;

procedure THistoryForm.ContactsComboBoxChange(Sender: TObject);
begin
  //--��������� ���� � �������� ���������� ��������
  LoadHistoryFromFile(ContactsComboBox.Text, true);
  if SearchTextEdit.CanFocus then SearchTextEdit.SetFocus;
end;

procedure THistoryForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--���������, ��� ���� ����� �������� �����������
  Action := caFree;
  HistoryForm := nil;
end;

procedure THistoryForm.FormCreate(Sender: TObject);
var
  Xml: IXmlDocument;
  XmlElem: IXmlNode;
begin
  //--�������������� XML
  try
    Xml := CreateXmlDocument;
    //--��������� ���������
    if FileExists(MyPath + 'Profile\HistoryForm.xml') then
    begin
      Xml.Load(MyPath + 'Profile\HistoryForm.xml');
      //--��������� ������� ����
      XmlElem := Xml.DocumentElement.SelectSingleNode('historyform-position');
      if XmlElem <> nil then
      begin
        Top := XmlElem.GetIntAttr('top');
        Left := XmlElem.GetIntAttr('left');
        Height := XmlElem.GetIntAttr('height');
        Width := XmlElem.GetIntAttr('width');
        //--���������� �� ��������� �� ���� �� ��������� ������
        while Top + Height > Screen.Height do Top := Top - 50;
        while Left + Width > Screen.Width do Left := Left - 50;
      end;
    end;
  except
  end;
  //--��������� ���� �� ������ �����
  TranslateForm;
  //--��������� ������ ���� � �������
  MainForm.AllImageList.GetIcon(147, Icon);
  MainForm.AllImageList.GetBitmap(221, SearchTextBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(6, ReloadHistoryBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(150, SaveHistoryAsBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(148, DeleteHistoryBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(3, CloseBitBtn.Glyph);
  //--������ ������ ��������� ������ ������� ��� ������
  ListFileDirHist(MyPath + 'Profile\History', '*.z', '.z', ContactsComboBox.Items);
  //--������ ���� ����������� � ������ ��� ������ � ������ �����
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure THistoryForm.FormDestroy(Sender: TObject);
var
  Xml: IXmlDocument;
  XmlElem: IXmlNode;
begin
  //--������ ����������� �����
  ForceDirectories(MyPath + 'Profile');
  //--��������� ��������� ��������� ���� ������� � xml
  try
    Xml := CreateXmlDocument('xml');
    //--��������� ������� ����
    XmlElem := Xml.DocumentElement.AppendElement('historyform-position');
    XmlElem.SetIntAttr('top', Top);
    XmlElem.SetIntAttr('left', Left);
    XmlElem.SetIntAttr('height', Height);
    XmlElem.SetIntAttr('width', Width);
    //--���������� ��� ����
    Xml.Save(MyPath + 'Profile\HistoryForm.xml');
  except
  end;
end;

procedure THistoryForm.HTMLHistoryViewerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //--��� ������� ������ ������ + � �������� ���������� ����� � ����� ������
  if (GetKeyState(VK_CONTROL) < 0) and (Key = 67) then
  begin
    HTMLHistoryViewer.CopyToClipboard;
  end;
end;

end.

