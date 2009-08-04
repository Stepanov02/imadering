{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit SettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvPageList, JvExControls, ExtCtrls, ButtonGroup, StdCtrls, Buttons,
  SimpleXML, OverbyteIcsWndControl, OverbyteIcsWSocket, OverbyteIcsHttpProt,
  Registry, ComCtrls;

type
  TSettingsForm = class(TForm)
    SettingButtonGroup: TButtonGroup;
    PagesPanel: TPanel;
    JvPageList1: TJvPageList;
    JvStandardPage1: TJvStandardPage;
    JvStandardPage2: TJvStandardPage;
    JvStandardPage3: TJvStandardPage;
    JvStandardPage4: TJvStandardPage;
    JvStandardPage5: TJvStandardPage;
    CancelBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    ApplyBitBtn: TBitBtn;
    GeneralOptionGroupBox: TGroupBox;
    CLWindowGroupBox: TGroupBox;
    ChatFormGroupBox: TGroupBox;
    EventsGroupBox: TGroupBox;
    GroupBox5: TGroupBox;
    ProxyAddresEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ProxyPortEdit: TEdit;
    ProxyTypeComboBox: TComboBox;
    Label3: TLabel;
    ProxyVersionComboBox: TComboBox;
    Label4: TLabel;
    ProxyAuthCheckBox: TCheckBox;
    ProxyLoginEdit: TEdit;
    ProxyPasswordEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    ProxyShowPassCheckBox: TCheckBox;
    ProxyEnableCheckBox: TCheckBox;
    NTLMCheckBox: TCheckBox;
    GroupBox6: TGroupBox;
    ReconnectCheckBox: TCheckBox;
    HideInTrayProgramStartCheckBox: TCheckBox;
    StartOnWinStartCheckBox: TCheckBox;
    AutoUpdateCheckBox: TCheckBox;
    TransparentGroupBox: TGroupBox;
    HeadTextGroupBox: TGroupBox;
    CLOptionsGroupBox: TGroupBox;
    AlwaylTopCheckBox: TCheckBox;
    TransparentTrackBar: TTrackBar;
    TransparentNotActiveCheckBox: TCheckBox;
    AutoHideCLCheckBox: TCheckBox;
    AutoHideClEdit: TEdit;
    HeaderTextEdit: TEdit;
    JvStandardPage6: TJvStandardPage;
    JvStandardPage7: TJvStandardPage;
    JvStandardPage8: TJvStandardPage;
    JvStandardPage9: TJvStandardPage;
    JvStandardPage10: TJvStandardPage;
    JvStandardPage11: TJvStandardPage;
    JvStandardPage12: TJvStandardPage;
    JvStandardPage13: TJvStandardPage;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    ProtocolsGroupBox: TGroupBox;
    ProtocolsListView: TListView;
    AddProtoBitBtn: TBitBtn;
    SettingsProtoBitBtn: TBitBtn;
    DeleteProtoBitBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure SettingButtonGroupButtonClicked(Sender: TObject; Index: Integer);
    procedure CancelBitBtnClick(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure ApplyBitBtnClick(Sender: TObject);
    procedure ProxyAuthCheckBoxClick(Sender: TObject);
    procedure ProxyShowPassCheckBoxClick(Sender: TObject);
    procedure ProxyEnableCheckBoxClick(Sender: TObject);
    procedure ProxyAddresEditChange(Sender: TObject);
    procedure ProxyTypeComboBoxSelect(Sender: TObject);
    procedure TransparentTrackBarChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure AutoHideClEditKeyPress(Sender: TObject; var Key: Char);
    procedure AutoHideClEditExit(Sender: TObject);
    procedure AddProtoBitBtnClick(Sender: TObject);
    procedure DeleteProtoBitBtnClick(Sender: TObject);
    procedure ProtocolsListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SettingButtonGroupKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ProtocolsListViewClick(Sender: TObject);
    procedure ProtocolsListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SettingsProtoBitBtnClick(Sender: TObject);
    procedure ProtocolsListViewDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSettings;
    procedure TranslateForms;
  public
    { Public declarations }
    procedure ApplySettings;
  end;

var
  SettingsForm: TSettingsForm;
  NoReSave: boolean = false;

implementation

{$R *.dfm}

uses
  MainUnit, VarsUnit, TypInfo, IcqOptionsUnit;

procedure DoAppToRun(RunName, AppName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    WriteString(RunName, AppName);
    CloseKey;
    Free;
  end;
end;

function IsAppInRun(RunName: string): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
    Result := ValueExists(RunName);
    CloseKey;
    Free;
  end;
end;

procedure DelAppFromRun(RunName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    if ValueExists(RunName) then DeleteValue(RunName);
    CloseKey;
    Free;
  end;
end;

procedure TSettingsForm.LoadSettings;
var
  Xml: IXmlDocument;
  XmlElem: IXmlNode;
  ListItemD: TListItem;
begin
  //--��������� � ���������� ��������� ������
  if FileExists(MyPath + 'Profile\Proxy.xml') then
  begin
    try
      Xml := CreateXmlDocument;
      Xml.Load(MyPath + 'Profile\Proxy.xml');
      //--��������� ����� ������
      XmlElem := Xml.DocumentElement.SelectSingleNode('proxy');
      if XmlElem <> nil then
      begin
        if XmlElem.ChildNodes.Count > 0 then
        begin
          ProxyAddresEdit.Text := XmlElem.ChildNodes.Item[0].GetAttr('name');
          ProxyPortEdit.Text := XmlElem.ChildNodes.Item[0].GetAttr('port');
          ProxyTypeComboBox.ItemIndex := XmlElem.ChildNodes.Item[1].GetIntAttr('type-index');
          ProxyVersionComboBox.ItemIndex := XmlElem.ChildNodes.Item[1].GetIntAttr('version-index');
          ProxyAuthCheckBox.Checked := XmlElem.ChildNodes.Item[2].GetBoolAttr('proxy-auth-enable');
          ProxyLoginEdit.Text := XmlElem.ChildNodes.Item[2].GetAttr('proxy-login');
          ProxyPasswordEdit.Text := XmlElem.ChildNodes.Item[2].GetAttr('proxy-password');
          NTLMCheckBox.Checked := XmlElem.ChildNodes.Item[2].GetBoolAttr('proxy-ntlm-auth');
        end;
        ProxyEnableCheckBox.Checked := XmlElem.GetBoolAttr('proxy-enable');
        ProxyEnableCheckBoxClick(nil);
      end;
    except
    end;
  end;
  //----------------------------------------------------------------------------
  //--��������� � ���������� ������ ���������
  if FileExists(MyPath + 'Profile\Settings.xml') then
  begin
    try
      Xml := CreateXmlDocument;
      Xml.Load(MyPath + 'Profile\Settings.xml');
      //--��������� ������ �������� � ����
      XmlElem := Xml.DocumentElement.SelectSingleNode('hide-in-tray-program-start');
      if XmlElem <> nil then HideInTrayProgramStartCheckBox.Checked := XmlElem.GetBoolAttr('boolean');
      //--��������� ���������� ��� ������ Windows
      StartOnWinStartCheckBox.Checked := IsAppInRun('IMadering');
      //--��������� ��������� ������� ����� ������ ��� �������
      XmlElem := Xml.DocumentElement.SelectSingleNode('auto-update-check');
      if XmlElem <> nil then AutoUpdateCheckBox.Checked := XmlElem.GetBoolAttr('boolean');
      //--��������� ������ ���� ����
      XmlElem := Xml.DocumentElement.SelectSingleNode('always-top');
      if XmlElem <> nil then AlwaylTopCheckBox.Checked := XmlElem.GetBoolAttr('boolean');
      //--��������� ��������� ������������ ������ ���������
      XmlElem := Xml.DocumentElement.SelectSingleNode('transparent-value');
      if XmlElem <> nil then TransparentTrackBar.Position := XmlElem.GetIntAttr('value');
      //--��������� ������������ ����������� ���� ������ ���������
      XmlElem := Xml.DocumentElement.SelectSingleNode('transparent-active');
      if XmlElem <> nil then TransparentNotActiveCheckBox.Checked := XmlElem.GetBoolAttr('boolean');
      //--��������� ����������� ������ ���������
      XmlElem := Xml.DocumentElement.SelectSingleNode('auto-hide-cl');
      if XmlElem <> nil then AutoHideCLCheckBox.Checked := XmlElem.GetBoolAttr('boolean');
      XmlElem := Xml.DocumentElement.SelectSingleNode('auto-hide-cl-value');
      if XmlElem <> nil then AutoHideCLEdit.Text := XmlElem.GetAttr('value');
      //--��������� ��������� ���� ������ ���������
      XmlElem := Xml.DocumentElement.SelectSingleNode('header-cl-form');
      if XmlElem <> nil then HeaderTextEdit.Text := XmlElem.GetAttr('text');
      //--��������� �������������� ��� ������� ����������
      XmlElem := Xml.DocumentElement.SelectSingleNode('reconnect');
      if XmlElem <> nil then ReconnectCheckBox.Checked := XmlElem.GetBoolAttr('boolean');
    except
    end;
  end;
  //----------------------------------------------------------------------------
  //--������������� ������� ���������� ����������
  ProtocolsListView.Clear;
  ProtocolsListView.Items.BeginUpdate;
  //--��������� ICQ ��������
  ListItemD := ProtocolsListView.Items.Add;
  ListItemD.Checked := MainForm.ICQToolButton.Visible;
  if Assigned(IcqOptionsForm) then ListItemD.Caption := 'ICQ: ' + IcqOptionsForm.ICQUINEdit.Text
  else ListItemD.Caption := 'ICQ:';
  ListItemD.ImageIndex := 81;
  //--��������� MRA ��������
  ListItemD := ProtocolsListView.Items.Add;
  ListItemD.Checked := MainForm.MRAToolButton.Visible;
  ListItemD.Caption := 'MRA:';
  ListItemD.ImageIndex := 66;
  //--��������� Jabber ��������
  ListItemD := ProtocolsListView.Items.Add;
  ListItemD.Checked := MainForm.JabberToolButton.Visible;
  ListItemD.Caption := 'Jabber:';
  ListItemD.ImageIndex := 43;
  ProtocolsListView.Items.EndUpdate;
end;

procedure TSettingsForm.ApplySettings;
var
  Xml: IXmlDocument;
  XmlElem, XmlElem1: IXmlNode;
begin
  //--������ ����������� �����
  ForceDirectories(MyPath + 'Profile');
  ForceDirectories(MyPath + 'Profile\History');
  ForceDirectories(MyPath + 'Profile\Avatars');
  ForceDirectories(MyPath + 'Profile\Contacts');
  //--��������� ��������� ������
  if ProxyEnableCheckBox.Checked then
  begin
    //--������ �������
    MainForm.HttpClient.RequestVer := ProxyVersionComboBox.Text;
    //--HTTP � HTTPS ��� ������
    if (ProxyTypeComboBox.ItemIndex = 0) or (ProxyTypeComboBox.ItemIndex = 1) then
    begin
      //--���������� ��� SOCKS ������
      MainForm.HttpClient.SocksLevel := '';
      //--���������� ����� SOCKS ������ � ����
      MainForm.HttpClient.SocksServer := '';
      MainForm.HttpClient.SocksPort := '';
      //--���������� ����������� SOCKS ������
      MainForm.HttpClient.SocksAuthentication := socksNoAuthentication;
      MainForm.HttpClient.SocksUsercode := '';
      MainForm.HttpClient.SocksPassword := '';
      //--��������� ����� HTTP ������ � ����
      MainForm.HttpClient.Proxy := ProxyAddresEdit.Text;
      MainForm.HttpClient.ProxyPort := ProxyPortEdit.Text;
      //--��������� ����������� �� HTTP ������
      if ProxyAuthCheckBox.Checked then
      begin
        MainForm.HttpClient.ProxyAuth := httpAuthBasic;
        if NTLMCheckBox.Checked then MainForm.HttpClient.ProxyAuth := httpAuthNtlm;
        MainForm.HttpClient.ProxyUsername := ProxyLoginEdit.Text;
        MainForm.HttpClient.ProxyPassword := ProxyPasswordEdit.Text;
      end
      else
      begin
        //--���������� ����������� HTTP ������
        MainForm.HttpClient.ProxyAuth := httpAuthNone;
        MainForm.HttpClient.ProxyUsername := '';
        MainForm.HttpClient.ProxyPassword := '';
      end;
    end
    else
    begin
      //--���������� ����� HTTP ������ � ����
      MainForm.HttpClient.Proxy := '';
      MainForm.HttpClient.ProxyPort := '80';
      //--���������� ����������� HTTP ������
      MainForm.HttpClient.ProxyAuth := httpAuthNone;
      MainForm.HttpClient.ProxyUsername := '';
      MainForm.HttpClient.ProxyPassword := '';
      //--SOCKS4, SOCKS4A � SOCKS5 ��� ������
      case ProxyTypeComboBox.ItemIndex of
        2: MainForm.HttpClient.SocksLevel := '4';
        3: MainForm.HttpClient.SocksLevel := '4A';
        4: MainForm.HttpClient.SocksLevel := '5';
      end;
      //--��������� ����� SOCKS ������ � ����
      MainForm.HttpClient.SocksServer := ProxyAddresEdit.Text;
      MainForm.HttpClient.SocksPort := ProxyPortEdit.Text;
      //--��������� ����������� �� SOCKS ������
      if ProxyAuthCheckBox.Checked then
      begin
        MainForm.HttpClient.SocksAuthentication := socksAuthenticateUsercode;
        MainForm.HttpClient.SocksUsercode := ProxyLoginEdit.Text;
        MainForm.HttpClient.SocksPassword := ProxyPasswordEdit.Text;
      end
      else
      begin
        //--���������� ����������� SOCKS ������
        MainForm.HttpClient.SocksAuthentication := socksNoAuthentication;
        MainForm.HttpClient.SocksUsercode := '';
        MainForm.HttpClient.SocksPassword := '';
      end;
    end;
  end
  else
  begin
    //--���������� ������ ��������
    MainForm.HttpClient.RequestVer := '1.0';
    //--���������� ����� HTTP ������ � ����
    MainForm.HttpClient.Proxy := '';
    MainForm.HttpClient.ProxyPort := '80';
    //--���������� ����������� HTTP ������
    MainForm.HttpClient.ProxyAuth := httpAuthNone;
    MainForm.HttpClient.ProxyUsername := '';
    MainForm.HttpClient.ProxyPassword := '';
    //--���������� ��� SOCKS ������
    MainForm.HttpClient.SocksLevel := '';
    //--���������� ����� SOCKS ������ � ����
    MainForm.HttpClient.SocksServer := '';
    MainForm.HttpClient.SocksPort := '';
    //--���������� ����������� SOCKS ������
    MainForm.HttpClient.SocksAuthentication := socksNoAuthentication;
    MainForm.HttpClient.SocksUsercode := '';
    MainForm.HttpClient.SocksPassword := '';
  end;
  //----------------------------------------------------------------------------
  //--��������� ����� ���������
  //--���� "��������� ��� ������ �������", �� ������ ��� � �������
  if StartOnWinStartCheckBox.Checked then DoAppToRun('IMadering', MyPath + 'Imadering.exe')
  else DelAppFromRun('IMadering');
  //--��������� ��������� ��� ������ ���������
  if AlwaylTopCheckBox.Checked then MainForm.FormStyle := fsStayOnTop
  else MainForm.FormStyle := fsNormal;
  //--��������� ��������� ������������
  if TransparentTrackBar.Position > 0 then
  begin
    RoasterAlphaBlend := true;
    MainForm.AlphaBlend := true;
    RoasterAlphaValue := 255 - TransparentTrackBar.Position;
  end
  else
  begin
    RoasterAlphaBlend := false;
    MainForm.AlphaBlend := false;
    MainForm.AlphaBlendValue := 255;
    RoasterAlphaValue := 255;
  end;
  AlphaBlendInactive := TransparentNotActiveCheckBox.Checked;
  //--��������� ��������� ����������� ������ ���������
  MainForm.JvTimerList.Events[8].Enabled := AutoHideCLCheckBox.Checked;
  MainForm.JvTimerList.Events[8].Interval := (StrToInt(AutoHideCLEdit.Text) * 1000);
  //--��������� ��������� ��������� ���� ������ ���������
  MainForm.Caption := HeaderTextEdit.Text;



  //----------------------------------------------------------------------------
  //--���������� ���������
  if ApplyBitBtn.Enabled then
  begin
    //--���������� ��������� ������
    if not NoReSave then
    begin
      try
        Xml := CreateXmlDocument('xml');
        //--��������� ��������� ������
        XmlElem := Xml.DocumentElement.AppendElement('proxy');
        XmlElem.SetBoolAttr('proxy-enable', ProxyEnableCheckBox.Checked);
        XmlElem1 := XmlElem.AppendElement('proxy-addres');
        XmlElem1.SetAttr('name', ProxyAddresEdit.Text);
        XmlElem1.SetAttr('port', ProxyPortEdit.Text);
        XmlElem1 := XmlElem.AppendElement('proxy-type');
        XmlElem1.SetAttr('type', ProxyTypeComboBox.Text);
        XmlElem1.SetIntAttr('type-index', ProxyTypeComboBox.ItemIndex);
        XmlElem1.SetAttr('version', ProxyVersionComboBox.Text);
        XmlElem1.SetIntAttr('version-index', ProxyVersionComboBox.ItemIndex);
        XmlElem1 := XmlElem.AppendElement('proxy-auth');
        XmlElem1.SetBoolAttr('proxy-auth-enable', ProxyAuthCheckBox.Checked);
        XmlElem1.SetAttr('proxy-login', ProxyLoginEdit.Text);
        XmlElem1.SetAttr('proxy-password', ProxyPasswordEdit.Text);
        XmlElem1.SetBoolAttr('proxy-ntlm-auth', NTLMCheckBox.Checked);
        //--���������� ��� ����
        Xml.Save(MyPath + 'Profile\Proxy.xml');
      except
      end;
      //--��������� ���������
      try
        Xml := CreateXmlDocument('xml');
        //--��������� ������ �������� � ����
        XmlElem := Xml.DocumentElement.AppendElement('hide-in-tray-program-start');
        XmlElem.SetBoolAttr('boolean', HideInTrayProgramStartCheckBox.Checked);
        //--��������� ��������������� ��� ������� ����������
        XmlElem := Xml.DocumentElement.AppendElement('reconnect');
        XmlElem.SetBoolAttr('boolean', ReconnectCheckBox.Checked);
        //--��������� ��������� ������� ����� ������ ��� �������
        XmlElem := Xml.DocumentElement.AppendElement('auto-update-check');
        XmlElem.SetBoolAttr('boolean', AutoUpdateCheckBox.Checked);
        //--��������� ������ ���� ����
        XmlElem := Xml.DocumentElement.AppendElement('always-top');
        XmlElem.SetBoolAttr('boolean', AlwaylTopCheckBox.Checked);
        //--��������� ��������� ������������ ������ ���������
        XmlElem := Xml.DocumentElement.AppendElement('transparent-value');
        XmlElem.SetIntAttr('value', TransparentTrackBar.Position);
        //--��������� ������������ ����������� ���� ������ ���������
        XmlElem := Xml.DocumentElement.AppendElement('transparent-active');
        XmlElem.SetBoolAttr('boolean', TransparentNotActiveCheckBox.Checked);
        //--��������� ����������� ������ ���������
        XmlElem := Xml.DocumentElement.AppendElement('auto-hide-cl');
        XmlElem.SetBoolAttr('boolean', AutoHideCLCheckBox.Checked);
        XmlElem := Xml.DocumentElement.AppendElement('auto-hide-cl-value');
        XmlElem.SetAttr('value', AutoHideCLEdit.Text);
        //--��������� ��������� ���� ������ ���������
        XmlElem := Xml.DocumentElement.AppendElement('header-cl-form');
        XmlElem.SetAttr('text', HeaderTextEdit.Text);
        //--���������� ��� ����
        Xml.Save(MyPath + 'Profile\Settings.xml');
      except
      end;
    end;
  end;
  //--������������ ������ ���������� ��������
  ApplyBitBtn.Enabled := false;
end;

procedure TSettingsForm.AutoHideClEditExit(Sender: TObject);
begin
  //--���� ���� ������, �� ������ �� �������
  if AutoHideClEdit.Text = '' then AutoHideClEdit.Text := '10';
end;

procedure TSettingsForm.AutoHideClEditKeyPress(Sender: TObject; var Key: Char);
const
  ValidAsciiChars = ['0'..'9'];
begin
  //--������ ���, ��� ������� ����� ������ �����
  if (not (Key in ValidAsciiChars)) and (Key <> #8) then Key := #0;
end;

procedure TSettingsForm.CancelBitBtnClick(Sender: TObject);
begin
  //--��������� ���� ��������
  Close;
end;

procedure TSettingsForm.DeleteProtoBitBtnClick(Sender: TObject);
begin
  //--� ������� ������� ��������� � �������� ������
  ShowMessage(DevelMess);
end;

procedure TSettingsForm.OKBitBtnClick(Sender: TObject);
begin
  //--��������� ���������
  ApplySettings;
  //--��������� ���� ��������
  Close;
end;

procedure TSettingsForm.AddProtoBitBtnClick(Sender: TObject);
begin
  //--� ������� ��������� ��������� � �������� ������
  ShowMessage(DevelMess);
end;

procedure TSettingsForm.ApplyBitBtnClick(Sender: TObject);
begin
  //--��������� ���������
  ApplySettings;
end;

procedure TSettingsForm.SettingButtonGroupButtonClicked(Sender: TObject;
  Index: Integer);
begin
  //--�������� �������� �������� ������������� ��������� �������
  if Index <= JvPageList1.PageCount then JvPageList1.ActivePageIndex := Index;
end;

procedure TSettingsForm.SettingButtonGroupKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  //--�������� �������� �������� ������������� ��������� �������
  if SettingButtonGroup.ItemIndex <= JvPageList1.PageCount then JvPageList1.ActivePageIndex := SettingButtonGroup.ItemIndex;
end;

procedure TSettingsForm.SettingsProtoBitBtnClick(Sender: TObject);
begin
  //--��������� ���� ��������� ���������� ���������
  if ProtocolsListView.Selected.Index = 0 then MainForm.ICQSettingsClick(self)
  else if ProtocolsListView.Selected.Index = 1 then MainForm.MRASettingsClick(self)
  else if ProtocolsListView.Selected.Index = 2 then MainForm.JabberSettingsClick(self);
end;

procedure TSettingsForm.ProtocolsListViewClick(Sender: TObject);
begin
  //--��������� ���������� � ����������� ����������
  //--ICQ
  if (not ProtocolsListView.Items[0].Checked) and (MainForm.ICQToolButton.Visible) then
    MainForm.ICQEnable(false)
  else if (ProtocolsListView.Items[0].Checked) and (not MainForm.ICQToolButton.Visible) then
    MainForm.ICQEnable(true);
  //--MRA
  if (not ProtocolsListView.Items[1].Checked) and (MainForm.MRAToolButton.Visible) then
    MainForm.MRAEnable(false)
  else if (ProtocolsListView.Items[1].Checked) and (not MainForm.MRAToolButton.Visible) then
    MainForm.MRAEnable(true);
  //--Jabber
  if (not ProtocolsListView.Items[2].Checked) and (MainForm.JabberToolButton.Visible) then
    MainForm.JabberEnable(false)
  else if (ProtocolsListView.Items[2].Checked) and (not MainForm.JabberToolButton.Visible) then
    MainForm.JabberEnable(true);
end;

procedure TSettingsForm.ProtocolsListViewDblClick(Sender: TObject);
begin
  //--���� ������� ���� �� ��������� ���� ����� ��� � ��� ��������
  ProtocolsListViewClick(self);
end;

procedure TSettingsForm.ProtocolsListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //--���� �������� ������ �� �������� � ��������� ���������, �� ��������� ������� �� ����� �� �������
  if key = 32 then ProtocolsListViewClick(self);
end;

procedure TSettingsForm.ProtocolsListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  //--���������� ��� ������������ ������ �������� ���������
  if Selected then SettingsProtoBitBtn.Enabled := true
  else SettingsProtoBitBtn.Enabled := false;
end;

procedure TSettingsForm.ProxyAddresEditChange(Sender: TObject);
begin
  //--���������� ������ ���������
  ApplyBitBtn.Enabled := true;
end;

procedure TSettingsForm.ProxyAuthCheckBoxClick(Sender: TObject);
begin
  //--��������� ���������� ����������� �� ������
  if ProxyAuthCheckBox.Checked then
  begin
    ProxyLoginEdit.Enabled := true;
    ProxyLoginEdit.Color := clWindow;
    ProxyPasswordEdit.Enabled := true;
    ProxyPasswordEdit.Color := clWindow;
    NTLMCheckBox.Enabled := true;
  end
  else
  begin
    ProxyLoginEdit.Enabled := false;
    ProxyLoginEdit.Color := clBtnFace;
    ProxyPasswordEdit.Enabled := false;
    ProxyPasswordEdit.Color := clBtnFace;
    NTLMCheckBox.Enabled := false;
  end;
  //--���������� ������ ���������� ��������
  ApplyBitBtn.Enabled := true;
end;

procedure TSettingsForm.ProxyEnableCheckBoxClick(Sender: TObject);
begin
  //--��������� ������������� ������
  if ProxyEnableCheckBox.Checked then
  begin
    ProxyAddresEdit.Enabled := true;
    ProxyAddresEdit.Color := clWindow;
    ProxyPortEdit.Enabled := true;
    ProxyPortEdit.Color := clWindow;
    ProxyTypeComboBox.Enabled := true;
    ProxyTypeComboBox.Color := clWindow;
    ProxyVersionComboBox.Enabled := true;
    ProxyVersionComboBox.Color := clWindow;
    ProxyAuthCheckBox.Enabled := true;
    if ProxyAuthCheckBox.Checked then
    begin
      ProxyLoginEdit.Enabled := true;
      ProxyLoginEdit.Color := clWindow;
      ProxyPasswordEdit.Enabled := true;
      ProxyPasswordEdit.Color := clWindow;
      NTLMCheckBox.Enabled := true;
    end;
    ProxyShowPassCheckBox.Enabled := true;
  end
  else
  begin
    ProxyAddresEdit.Enabled := false;
    ProxyAddresEdit.Color := clBtnFace;
    ProxyPortEdit.Enabled := false;
    ProxyPortEdit.Color := clBtnFace;
    ProxyTypeComboBox.Enabled := false;
    ProxyTypeComboBox.Color := clBtnFace;
    ProxyVersionComboBox.Enabled := false;
    ProxyVersionComboBox.Color := clBtnFace;
    ProxyAuthCheckBox.Enabled := false;
    if ProxyAuthCheckBox.Checked then
    begin
      ProxyLoginEdit.Enabled := false;
      ProxyLoginEdit.Color := clBtnFace;
      ProxyPasswordEdit.Enabled := false;
      ProxyPasswordEdit.Color := clBtnFace;
      NTLMCheckBox.Enabled := false;
    end;
    ProxyShowPassCheckBox.Enabled := false;
  end;
  //--���������� ������ ���������� ��������
  ApplyBitBtn.Enabled := true;
end;

procedure TSettingsForm.ProxyShowPassCheckBoxClick(Sender: TObject);
begin
  //--���������� ������ ������ � ������
  if ProxyShowPassCheckBox.Checked then ProxyPasswordEdit.PasswordChar := #0
  else ProxyPasswordEdit.PasswordChar := '*';
end;

procedure TSettingsForm.ProxyTypeComboBoxSelect(Sender: TObject);
begin
  //--������������� ��������� ���� ������
  case ProxyTypeComboBox.ItemIndex of
    0: ProxyPortEdit.Text := '80';
    1: ProxyPortEdit.Text := '443';
  else ProxyPortEdit.Text := '';
  end;
end;

procedure TSettingsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //--���������� ����������� �������� ������������ ������ ���������
  MainForm.AlphaBlendValue := RoasterAlphaValue;
  MainForm.AlphaBlend := RoasterAlphaBlend;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  //--��������� ���������
  LoadSettings;
  ProxyTypeComboBox.OnSelect := ProxyTypeComboBoxSelect;
  //--������������� �������
  TranslateForms;
  //--������������ ������ ���������� ��������
  ApplyBitBtn.Enabled := false;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  //--������������� ������ ����
  MainForm.AllImageList.GetIcon(2, Icon);
  //--������������� ������ �� ������
  MainForm.AllImageList.GetBitmap(3, CancelBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(6, ApplyBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(140, OKBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(186, AddProtoBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(2, SettingsProtoBitBtn.Glyph);
  MainForm.AllImageList.GetBitmap(139, DeleteProtoBitBtn.Glyph);
  //--�������������� ������� ���������� ���������
  LoadSettings;
  ProxyTypeComboBox.OnSelect := ProxyTypeComboBoxSelect;
  //--������������ ������ ���������� ��������
  ApplyBitBtn.Enabled := false;
  //--���������� �� ������ �������
  JvPageList1.ActivePageIndex := 0;
  SettingButtonGroup.ItemIndex := 0;
end;

procedure SetStringPropertyIfExists(AComp: TComponent; APropName: string;
  AValue: string);
var
  PropInfo: PPropInfo;
  TK: TTypeKind;
begin
  PropInfo := GetPropInfo(AComp.ClassInfo, APropName);
  if PropInfo <> nil then
  begin
    TK := PropInfo^.PropType^.Kind;
    if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
      SetStrProp(AComp, PropInfo, AValue);
  end;
end;

procedure TSettingsForm.TransparentTrackBarChange(Sender: TObject);
begin
  //--���������� ������ ���������
  ApplyBitBtn.Enabled := true;
  //--���������� ����� ������������ � ������ ���������
  MainForm.AlphaBlend := true;
  MainForm.AlphaBlendValue := 255 - TransparentTrackBar.Position;
end;

procedure TSettingsForm.TranslateForms;
var
  i, c: integer;
  Xml: IXmlDocument;
  XmlElem: IXmlNode;
begin
  //--��������� ������� ���������� ���������
  if CurrentLang <> '' then
  begin
    if FileExists(MyPath + 'Langs\' + CurrentLang + '.xml') then
    begin
      try
        Xml := CreateXmlDocument;
        Xml.Load(MyPath + 'Langs\' + CurrentLang + '.xml');
        //--��������� ������� ����
        XmlElem := Xml.DocumentElement.SelectSingleNode('main-form');
        if XmlElem <> nil then
        begin
          if XmlElem.ChildNodes.Count > 0 then
          begin
            c := 0;
            for i := 0 to MainForm.ComponentCount - 1 do
            begin
              if (c < XmlElem.ChildNodes.Count) and (MainForm.Components[i].Tag > 0) then
              begin
                if MainForm.Components[i].Tag = XmlElem.ChildNodes.Item[c].GetIntAttr('tag') then
                begin
                  SetStringPropertyIfExists(MainForm.Components[i], 'Hint', '<b>' + XmlElem.ChildNodes.Item[0].GetAttr('hint') + '</b>');
                end;
                Inc(c);
              end;
            end;
          end;
        end;
        //--��������� ���� ��������

      except
      end;
    end;
  end;
end;

end.

