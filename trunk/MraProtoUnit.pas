unit MraProtoUnit;

interface

uses
  Windows, MainUnit, MraOptionsUnit, SysUtils, JvTrayIcon,
  Dialogs, OverbyteIcsWSocket, ChatUnit, MmSystem, Forms,
  ComCtrls, Messages, Classes, IcqContactInfoUnit, Code, VarsUnit,
  Graphics, CategoryButtons, rXML, JvZLibMultiple, RosterUnit;

const
  //--���� ��������
  M_OFFLINE = '00000000';
  M_ONLINE = '010000000D0000005354415455535F4F4E4C494E4506000000CEEDEBE0E9ED';
  M_AWAY = '020000000B0000005354415455535F4157415906000000CEF2EEF8E5EB';
  M_UNDETERMINATED = '03000000';
  M_FFC = '040000000B0000007374617475735F636861740F000000C3EEF2EEE220EFEEE1EEEBF2E0F2FC';
  M_DND = '040000000A0000007374617475735F646E640D000000CDE520E1E5F1EFEEEAEEE8F2FC';
  M_INVISIBLE = '01000080100000005354415455535F494E56495349424C4507000000CDE5E2E8E4E8EC';

  //--���. �������
  M_1 = '04000000080000007374617475735F35';
  M_2 = '04000000090000007374617475735F3138';
  M_3 = '04000000090000007374617475735F3139';
  M_4 = '04000000080000007374617475735F37';
  M_5 = '04000000090000007374617475735F3130';
  M_6 = '04000000090000007374617475735F3437';
  M_7 = '04000000090000007374617475735F3232';
  M_8 = '04000000090000007374617475735F3236';
  M_9 = '04000000090000007374617475735F3234';
  M_10 = '04000000090000007374617475735F3237';
  M_11 = '04000000090000007374617475735F3233';
  M_12 = '04000000080000007374617475735F34';
  M_13 = '04000000080000007374617475735F39';
  M_14 = '04000000080000007374617475735F36';
  M_15 = '04000000090000007374617475735F3231';
  M_16 = '04000000090000007374617475735F3230';
  M_17 = '04000000090000007374617475735F3137';
  M_18 = '04000000080000007374617475735F38';
  M_19 = '04000000090000007374617475735F3135';
  M_20 = '04000000090000007374617475735F3136';
  M_21 = '04000000090000007374617475735F3238';
  M_22 = '04000000090000007374617475735F3531';
  M_23 = '04000000090000007374617475735F3532';
  M_24 = '04000000090000007374617475735F3436';
  M_25 = '04000000090000007374617475735F3132';
  M_26 = '04000000090000007374617475735F3133';
  M_27 = '04000000090000007374617475735F3131';
  M_28 = '04000000090000007374617475735F3134';
  M_29 = '04000000090000007374617475735F3438';
  M_30 = '04000000090000007374617475735F3533';
  M_31 = '04000000090000007374617475735F3239';
  M_32 = '04000000090000007374617475735F3330';
  M_33 = '04000000090000007374617475735F3332';
  M_34 = '04000000090000007374617475735F3333';
  M_35 = '04000000090000007374617475735F3430';
  M_36 = '04000000090000007374617475735F3431';
  M_37 = '04000000090000007374617475735F3334';
  M_38 = '04000000090000007374617475735F3335';
  M_39 = '04000000090000007374617475735F3336';
  M_40 = '04000000090000007374617475735F3337';
  M_41 = '04000000090000007374617475735F3338';
  M_42 = '04000000090000007374617475735F3339';
  M_43 = '04000000090000007374617475735F3432';
  M_44 = '04000000090000007374617475735F3433';
  M_45 = '04000000090000007374617475735F3439';
  M_46 = '04000000090000007374617475735F3434';
  M_47 = '04000000090000007374617475735F3435';
  M_48 = '04000000090000007374617475735F3530';

  MRA_FLAP_HEAD_SIZE = 88;

var
  MRA_Bos_IP: string;
  MRA_Bos_Port: string;
  MRA_myBeautifulSocketBuffer: string;
  MRA_LoginServerAddr: string = 'mrim.mail.ru';
  MRA_LoginServerPort: string = '2042';
  MRA_HexPkt: string;
  MRA_LoginUIN: string = '';
  MRA_LoginPassword: string = '';
  MRA_MagKey: string = 'EFBEADDE';
  MRA_ProtoVer: string = '13000100';
  MRA_Ident: string = 'MRA 5.0 (build 2094);';
  MRA_Seq: LongWord = 1;
  MRA_LastSendedFlap: TDateTime;
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
  //--������ ���������� ���������
  MRA_Bos_Addr: string = '';

procedure MRA_Login_1;  

procedure MRA_GoOffline;

implementation

uses
  UtilsUnit;

procedure MRA_Login_1;
var
  Pkt: string;
begin
  //--��������� ����� ���������� ������
  Pkt := '000000000000000000000000000000000000000000000000';
  //--���������� �����
  SendFLAP_MRA('01100000', Pkt, true);
end;

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
  //--�������� �������� �������
  MRA_Seq := 1;
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
