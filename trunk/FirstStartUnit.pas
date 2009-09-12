{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit FirstStartUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvPageList, JvExControls, Buttons, ShellApi;

type
  TFirstStartForm = class(TForm)
    BottomPanel: TPanel;
    CancelButton: TBitBtn;
    ProtoJvPageList: TJvPageList;
    Jabber_Page: TJvStandardPage;
    MRA_Page: TJvStandardPage;
    ICQ_Page: TJvStandardPage;
    JabberEnableCheckBox: TCheckBox;
    JabberGroupBox: TGroupBox;
    JabberIconImage: TImage;
    JabberIDLabel: TLabel;
    JabberIDEdit: TEdit;
    JabberPassEdit: TEdit;
    JabberPassLabel: TLabel;
    JabberShowPassCheckBox: TCheckBox;
    JabberSavePassCheckBox: TCheckBox;
    NextButton: TBitBtn;
    ICQIconImage: TImage;
    ICQEnableCheckBox: TCheckBox;
    ICQGroupBox: TGroupBox;
    ICQUINLabel: TLabel;
    ICQPassLabel: TLabel;
    ICQUINEdit: TEdit;
    ICQPassEdit: TEdit;
    ICQShowPassCheckBox: TCheckBox;
    ICQSavePassCheckBox: TCheckBox;
    MRAIconImage: TImage;
    MRAEnableCheckBox: TCheckBox;
    MRAGroupBox: TGroupBox;
    MRAEmailLabel: TLabel;
    MRAPassLabel: TLabel;
    MRARegNewEmailLabel: TLabel;
    MRAEmailEdit: TEdit;
    MRAPassEdit: TEdit;
    MRAShowPassCheckBox: TCheckBox;
    MRASavePassCheckBox: TCheckBox;
    PrevButton: TBitBtn;
    RegNewJIDLabel: TLabel;
    RegNewUINLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure JabberEnableCheckBoxClick(Sender: TObject);
    procedure ICQEnableCheckBoxClick(Sender: TObject);
    procedure MRAEnableCheckBoxClick(Sender: TObject);
    procedure PrevButtonClick(Sender: TObject);
    procedure MRARegNewEmailLabelMouseEnter(Sender: TObject);
    procedure MRARegNewEmailLabelMouseLeave(Sender: TObject);
    procedure ICQShowPassCheckBoxClick(Sender: TObject);
    procedure MRAShowPassCheckBoxClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RegNewUINLabelClick(Sender: TObject);
    procedure MRARegNewEmailLabelClick(Sender: TObject);
  private
    { Private declarations }
    procedure CheckSelectProtocols;
  public
    { Public declarations }
    procedure TranslateForm;
  end;

var
  FirstStartForm: TFirstStartForm;

implementation

{$R *.dfm}

uses
  MainUnit, VarsUnit, UtilsUnit, IcqProtoUnit, Code, IcqOptionsUnit,
  JabberOptionsUnit;

procedure TFirstStartForm.CheckSelectProtocols;
begin
  //--��������� ������ �� ���� ���� ��������
  if (not ICQEnableCheckBox.Checked) and (not MRAEnableCheckBox.Checked) and
    (not JabberEnableCheckBox.Checked) then
  begin
    ShowMessage(FirstStartProtoSelectAlert);
    ICQEnableCheckBox.Checked := true;
  end;
end;

procedure TFirstStartForm.TranslateForm;
begin
  //--������� ���������� ���� �� ������ ����

end;

procedure TFirstStartForm.CancelButtonClick(Sender: TObject);
begin
  //--��������� ����
  Close;
end;

procedure TFirstStartForm.NextButtonClick(Sender: TObject);
begin
  //--����������� ��������
  case ProtoJvPageList.ActivePageIndex of
    0:
      begin
        //--��������� � ��������� ����� � ������ ICQ
        if Assigned(IcqOptionsForm) then
        begin
          //--����������� �����
          IcqOptionsForm.ICQUINEdit.Text := ICQUINEdit.Text;
          IcqOptionsForm.PassEdit.Text := ICQPassEdit.Text;
          IcqOptionsForm.SavePassCheckBox.Checked := ICQSavePassCheckBox.Checked;
          //--��������� � ��������� ��������� ������ ICQ
          IcqOptionsForm.ApplySettings;
        end;
        //--����������� �� Jabber ��������
        ProtoJvPageList.ActivePageIndex := 1;
        //--���������� ������� ��������
        PrevButton.Enabled := true;
      end;
    1:
      begin
        //--��������� � ��������� ����� � ������ Jabber
        if Assigned(JabberOptionsForm) then
        begin
          //--����������� �����
          JabberOptionsForm.JabberJIDEdit.Text := JabberIDEdit.Text;
          JabberOptionsForm.PassEdit.Text := JabberPassEdit.Text;
          JabberOptionsForm.SavePassCheckBox.Checked := JabberSavePassCheckBox.Checked;
          //--��������� � ��������� ��������� ������ ICQ
          JabberOptionsForm.ApplySettings;
        end;
        //--����������� �� MRA ��������
        ProtoJvPageList.ActivePageIndex := 2;
        //--������������� ����� �� ������ ����������
        NextButton.Caption := 'OK';
        //--���������� ������� ��������
        PrevButton.Enabled := true;
      end;
    2:
      begin
        //--��������� �� ��� �� ��������� ���� ���������
        CheckSelectProtocols;
        //--��������� ���������� ��������� ��������� ����������
        MainForm.SaveMainFormSettings;
        //--��������� ����
        Close;
      end;
  end;
end;

procedure TFirstStartForm.PrevButtonClick(Sender: TObject);
begin
  //--������� �� ���������� ��������
  with ProtoJvPageList do
  begin
    if ActivePageIndex = 0 then Exit
    else
    begin
      //--������� �������� �����
      ActivePageIndex := ActivePageIndex - 1;
      //--������������ ������� �������� ���� ������ ��������
      if ActivePageIndex = 0 then PrevButton.Enabled := false;
    end;
  end;
  //--������������� ����� �� ������ ����������
  NextButton.Caption := FirstStartNextButton;
end;

procedure TFirstStartForm.JabberEnableCheckBoxClick(Sender: TObject);
begin
  //--��������� ���������� ��� Jabber
  if JabberEnableCheckBox.Checked then
  begin
    JabberGroupBox.Enabled := true;
    JabberIDEdit.Color := clWindow;
    JabberPassEdit.Color := clWindow;
    JabberShowPassCheckBox.Enabled := true;
    JabberSavePassCheckBox.Enabled := true;
    RegNewJIDLabel.Enabled := true;
    //--�������� �������� ������
    MainForm.JabberEnable(true);
  end
  else
  begin
    JabberGroupBox.Enabled := false;
    JabberIDEdit.Color := clBtnFace;
    JabberPassEdit.Color := clBtnFace;
    JabberShowPassCheckBox.Enabled := false;
    JabberSavePassCheckBox.Enabled := false;
    RegNewJIDLabel.Enabled := false;
    //--��������� �������� ������
    MainForm.JabberEnable(false);
  end;
end;

procedure TFirstStartForm.RegNewUINLabelClick(Sender: TObject);
begin
  //--��������� ����������� �� ��� ����� ICQ
  OpenURL('http://www.icq.com/register');
end;

procedure TFirstStartForm.ICQEnableCheckBoxClick(Sender: TObject);
begin
  //--��������� ���������� ��� ICQ
  if ICQEnableCheckBox.Checked then
  begin
    ICQGroupBox.Enabled := true;
    ICQUINEdit.Color := clWindow;
    ICQPassEdit.Color := clWindow;
    ICQShowPassCheckBox.Enabled := true;
    ICQSavePassCheckBox.Enabled := true;
    RegNewUINLabel.Enabled := true;
    //--�������� �������� ICQ
    MainForm.ICQEnable(true);
  end
  else
  begin
    ICQGroupBox.Enabled := false;
    ICQUINEdit.Color := clBtnFace;
    ICQPassEdit.Color := clBtnFace;
    ICQShowPassCheckBox.Enabled := false;
    ICQSavePassCheckBox.Enabled := false;
    RegNewUINLabel.Enabled := false;
    //--��������� �������� ICQ
    MainForm.ICQEnable(false);
  end;
end;

procedure TFirstStartForm.ICQShowPassCheckBoxClick(Sender: TObject);
begin
  if ICQShowPassCheckBox.Checked then ICQPassEdit.PasswordChar := #0
  else ICQPassEdit.PasswordChar := '*';
end;

procedure TFirstStartForm.MRARegNewEmailLabelClick(Sender: TObject);
begin
  //--��������� ����������� �� ��� ����� mail.ru
  OpenURL('http://win.mail.ru/cgi-bin/signup');
end;

procedure TFirstStartForm.MRARegNewEmailLabelMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlue;
end;

procedure TFirstStartForm.MRARegNewEmailLabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clNavy;
end;

procedure TFirstStartForm.MRAShowPassCheckBoxClick(Sender: TObject);
begin
  if MRAShowPassCheckBox.Checked then MRAPassEdit.PasswordChar := #0
  else MRAPassEdit.PasswordChar := '*';
end;

procedure TFirstStartForm.MRAEnableCheckBoxClick(Sender: TObject);
begin
  //--��������� ���������� ��� MRA
  if MRAEnableCheckBox.Checked then
  begin
    MRAGroupBox.Enabled := true;
    MRAEmailEdit.Color := clWindow;
    MRAPassEdit.Color := clWindow;
    MRAShowPassCheckBox.Enabled := true;
    MRASavePassCheckBox.Enabled := true;
    MRARegNewEmailLabel.Enabled := true;
    //--�������� �������� MRA
    MainForm.MRAEnable(true);
  end
  else
  begin
    MRAGroupBox.Enabled := false;
    MRAEmailEdit.Color := clBtnFace;
    MRAPassEdit.Color := clBtnFace;
    MRAShowPassCheckBox.Enabled := false;
    MRASavePassCheckBox.Enabled := false;
    MRARegNewEmailLabel.Enabled := false;
    //--��������� �������� MRA
    MainForm.MRAEnable(false);
  end;
end;

procedure TFirstStartForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //--������� ������� ���� �� ����� �������� ����
  SetForeGroundWindow(Application.MainForm.Handle);
  //--��� ����� ����������
  Action := caFree;
  FirstStartForm := nil;
end;

procedure TFirstStartForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //--��������� �� ��� �� ��������� ���� ���������
  CheckSelectProtocols;
end;

procedure TFirstStartForm.FormCreate(Sender: TObject);
begin
  //--��������� ������ ����
  MainForm.AllImageList.GetIcon(0, Icon);
  MainForm.AllImageList.GetIcon(81, ICQIconImage.Picture.Icon);
  MainForm.AllImageList.GetIcon(24, MRAIconImage.Picture.Icon);
  MainForm.AllImageList.GetIcon(28, JabberIconImage.Picture.Icon);
  MainForm.AllImageList.GetBitmap(3, CancelButton.Glyph);
  MainForm.AllImageList.GetBitmap(167, PrevButton.Glyph);
  MainForm.AllImageList.GetBitmap(166, NextButton.Glyph);
  //--��������� ����� �� ������ �����
  TranslateForm;
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  //--�� ��������� ������������ �������� ���������� MRA � Jabber
  MRAEnableCheckBoxClick(self);
  JabberEnableCheckBoxClick(self);
end;

end.

