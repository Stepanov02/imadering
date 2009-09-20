unit MraProtoUnit;

interface

uses
  Windows, MainUnit, MraOptionsUnit, SysUtils, JvTrayIcon,
  Dialogs, OverbyteIcsWSocket, ChatUnit, MmSystem, Forms,
  ComCtrls, Messages, Classes, IcqContactInfoUnit, UnitCrypto, VarsUnit,
  Graphics, CategoryButtons, rXML, JvZLibMultiple, RosterUnit;

var
  MRA_Bos_IP: string;
  MRA_Bos_Port: string;
  MRA_myBeautifulSocketBuffer: string;
  MRA_LoginServerAddr: string = 'mrim.mail.ru';
  MRA_LoginServerPort: string = '2042';
  MRA_HexPkt: string;
  MRA_LoginUIN: string = '';
  MRA_LoginPassword: string = '';
  //--���� ������ ������
  MRA_Connect_Phaze: boolean = false;
  MRA_HTTP_Connect_Phaze: boolean = false;
  MRA_BosConnect_Phaze: boolean = false;
  MRA_Work_Phaze: boolean = false;
  MRA_Offline_Phaze: boolean = true;
  //--���� ������ �����
  MRA_CurrentStatus: integer = 23;
  MRA_CurrentStatus_bac: integer = 23;
  MRA_Reconnect: boolean = false;

procedure MRA_GoOffline;

implementation

uses
  UtilsUnit;

procedure MRA_GoOffline;
var
  i: integer;
begin
  //--��������� ������ ����������, ������
  MainForm.UnstableMRAStatus.Checked := false;
  with MainForm.JvTimerList do
  begin
    Events[10].Enabled := false;
  end;
  //--���� ���������� ����� �������� ��������� MRA, �� ��������� ��� ��������
  if Assigned(MraOptionsForm) then
  begin
    with MraOptionsForm do
    begin
      MRAEmailEdit.Enabled := true;
      MRAEmailEdit.Color := clWindow;
      PassEdit.Enabled := true;
      PassEdit.Color := clWindow;
    end;
  end;
  //--���������� ���� ������� � �������� ������ �������
  MRA_Connect_Phaze := false;
  MRA_HTTP_Connect_Phaze := false;
  MRA_BosConnect_Phaze := false;
  MRA_Work_Phaze := false;
  MRA_Offline_Phaze := true;
  MRA_myBeautifulSocketBuffer := EmptyStr;
  MRA_HexPkt := EmptyStr;
  //--���� ����� ���������, �� �������� ����� "�� ��������"
  with MainForm do
  begin
    {if MRAWSocket.State = wsConnected then
      MRAWSocket.SendStr();}
    //--��������� �����
    MRAWSocket.Abort;
    //--������ ������ � �������� ������� �������
    MRA_CurrentStatus := 23;
    MRAToolButton.ImageIndex := MRA_CurrentStatus;
    MRATrayIcon.IconIndex := MRA_CurrentStatus;
    //--������������ � ���� ������� MRA ������ �������
    MRAStatusOffline.Default := true;
  end;
  //--���������� ���� ��������� ������ ������ �������
  ZipThreadStop := true;
  //--���� ����� ������ ������� �� ����������� ���, �� ��� ��� ���������
  while not MainForm.ZipHistoryThread.Terminated do Sleep(10);
  //--��������� ������� ���������, �� ��� �� � ������
  ZipThreadStop := false;
  MainForm.ZipHistory;
  //--�������� ������� � ���������� � �������
  with RosterForm.RosterJvListView do
  begin
    for i := 0 to Items.Count - 1 do
    begin
      if Items[i].SubItems[3] = 'Mra' then
      begin
        Items[i].SubItems[6] := '23';
        Items[i].SubItems[7] := '-1';
        Items[i].SubItems[8] := '-1';
        Items[i].SubItems[13] := '';
        Items[i].SubItems[15] := '';
        Items[i].SubItems[16] := '';
        Items[i].SubItems[18] := '0';
        Items[i].SubItems[19] := '0';
        Items[i].SubItems[35] := '0';
      end;
    end;
  end;
  //--��������� ��������� �������
  RosterForm.UpdateFullCL;
end;

end.
