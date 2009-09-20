{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit VarsUnit;

interface

uses
  SysUtils, Classes, ExtCtrls, JvDesktopAlert, Graphics;

const
  Bild_Version = '5.0.0 alpha';
  Update_Version = 500;
  PassKey = 12345;

const
  SecsPerDay = 86400;
  Hour = 3600000 / MSecsPerDay;
  Minute = 60000 / MSecsPerDay;
  Second = 1000 / MSecsPerDay;
  DTseconds = 1 / (SecsPerDay);
  dblClickTime = 0.6 * DTseconds;

var
  //--���������� ����� ��� ���� ���������
  MyPath: string;
  ProfilePath: string;
  ProgramKey: string = '\SoftWare\IMadering';
  cProfile: string = 'ProfilePath';
  CurrentIcons: string = 'Imadering';
  CurrentLang: string = 'Russian';
  CurrentSmiles: string = 'Imadering';
  CurrentSounds: string = 'Imadering';
  ProgramCloseCommand: boolean = false;
  FirstStart: boolean = false;
  TrayProtoClickMenu: string;
  AlphaBlendInactive: boolean = false;
  RoasterAlphaBlend: boolean = false;
  RoasterAlphaValue: integer = 255;
  AccountToNick: TStringList;
  AvatarServiceDisable: boolean = false;
  UpdateAuto: boolean = true;
  SettingsFileName: string = 'Profile\IMadeSettings.xml';
  UpdateVersionPath: string = 'Update_%s_%s.z';
  UpdateFile: TMemoryStream;
  NoReSave: boolean = true;
  ZipThreadStop: boolean = false;
  GroupHeaderColor: TColor = $00FFEAFF;
  RoasterReady: boolean = false;

  //--���������� �������
  TrafSend: real;
  TrafRecev: real;
  SesDataTraf: TDateTime;
  AllTrafSend: real;
  AllTrafRecev: real;
  AllSesDataTraf: string;

  //--���������� ������
  SoundON: boolean = true;
  SoundStartProg: boolean = true;
  SoundStartProgPath: string = '';
  SoundIncMsg: boolean = true;
  SoundIncMsgPath: string = '';

  //--���������� ��� �����
  RestoreFromTrayStr: string = '�������� IMadering';
  HideInTrayStr: string = '������ IMadering';
  DevelMess: string = '������ ������� ��������� � ����������! ������� �� ������������ �������.';
  SoundOnHint: string = '<b>�������� �����</b>';
  SoundOffHint: string = '<b>��������� �����</b>';
  OnlyOnlineOn: string = '<b>�������� ������� ��������</b>';
  OnlyOnlineOff: string = '<b>������ ������� ��������</b>';
  GroupCLOn: string = '<b>���������� ������ ���������</b>';
  GroupCLOff: string = '<b>�������� ������ ���������</b>';
  TopPanelOn: string = '<b>�������� ������� ������</b>';
  TopPanelOff: string = '<b>������ ������� ������</b>';
  FirstStartNextButton: string = '�����';
  FirstStartProtoSelectAlert: string = '�� ������ �� ���� ��������! � ����� ������ �������� ICQ ����� ������ �������������.';
  NewVersionIMaderingYES1: string = '�������� ����� ������ IMadering.' + #13#10 + #13#10 + '��� ������������ ������� �� ���� www.imadering.com';
  NewVersionIMaderingYES2: string = '�������� ����� ������ IMadering.' + #13#10 + #13#10 + '��� ������������ ������� �� ���� www.imadering.com';
  NewVersionIMaderingNO: string = '����� ������ �� ����������.';
  NewVersionIMaderingErr: string = '������ ��������� ������ � ����� ������.';
  InformationHead: string = '����������';
  ErrorHead: string = '������';
  AlertHead: string = '�������� ����������';
  WarningHead: string = '��������!';
  ICQAccountInfo: string = '������� ������ ICQ#:';
  ICQAccountInfo_1: string = '����� ��� ��� ������������ � ICQ �������, ������� ������� � ���������� ���� ICQ ����� � ������!';
  JabberAccountInfo: string = '������� ������ JID:';
  JabberAccountInfo_1: string = '����� ��� ��� ������������ � Jabber �������, ������� ������� � ���������� ���� JID ������� � ������!';
  PassLabelInfo: string = '������:';
  ParsingPktError: string = '��������� ���������� ������ ������ ������ ���������� �� �������.';
  SocketConnErrorInfo_1: string = '���������� �� �����������.';
  RegNewAlert_1: string = '������� ������ ��� ����� ������� ������.';
  UnknownError: string = '����������� ������';
  AddContactError: string = '������ ��� ���������� ��������.';
  AddGroupError: string = '������ ��� ���������� ������.';
  DelGroupError: string = '������ ��� �������� ������.';
  ICQxUIN: string = '��� ����� ICQ ������������ �� ������ ����������.';
  PassChangeAlert_1: string = '������ �� ��� ������. ������� ��� ����� ������ ����� �������.';
  PassChangeAlert_2: string = '������ ������.';
  OnlineAlert: string = '��� ���������� ����� �������� ���������� ������������.';
  HideContactGroupCaption: string = '���������';
  NoInListGroupCaption: string = '�� � ������';
  ConnTimeL: string = '���������:';
  RegDateL: string = '���. ����:';
  ChatDateL: string = '��������� ���:';
  ProtoVerL: string = '������ ���������:';
  ClientVariableL: string = '��������� ������:';
  CellularPhoneL: string = '�������:';
  NoteL: string = '�������:';
  EmailL: string = 'Email:';
  UpDate1L: string = '�������� ������ �������������?';
  UpDate2L: string = '�� ����������� ����� www.imadering.com �������� ���������� ��������� IMadering';
  UpDate3L: string = '����������';
  QReply1L: string = '������!';
  QReply2L: string = '��� ����?';
  QReply3L: string = '����';
  HistoryDelL: string = '�� ������������� ������ ������� ������� ���������?';
  CloseChatWindowsL: string = '���������� ������ ���� ����!';
  TypingTextL: string = '��������...';
  ClientL: string = '������:';
  StatusL: string = '������:';
  OnlineInfo1L: string = '���� ������ ����� ����������';
  OnlineInfo2L: string = '���� ��������� � ����';
  OnlineInfo3L: string = '����� ���������� Away ���������';
  OnlineInfo4L: string = 'URL ������ �� �������';
  OnlineInfo5L: string = 'IP ����� ICQ �������';
  OnlineInfo6L: string = 'Hash �������';
  OnlineInfo7L: string = '������� � ��������� ������ ���������';
  PassChangeOKL: string = '������ ������';
  AnketaSaveOKL: string = '���� ������ ������� ��������� �� �������.';
  InfoOKL: string = '���������� � �������� �������!';
  InfoReqL: string = '��������� ����������...';
  InfoCaptionL: string = '���������� � ��������';
  InfoNickL: string = '���:';
  InfoNameL: string = '���:';
  InfoHomeL: string = '���:';
  InfoAdressL: string = '�����:';
  InfoStateL: string = '����:';
  InfoZipL: string = '������:';
  InfoGenderL: string = '���:';
  InfoGender1L: string = '�������';
  InfoGender2L: string = '�������';
  InfoAgeL: string = '�������:';
  InfoBirDate: string = '���� ��������:';
  InfoOHomeL: string = '����� ��������:';
  InfoWorkL: string = '������:';
  InfoCompanyL: string = '��������:';
  InfoDeportL: string = '�����:';
  InfoPositionL: string = '���������:';
  InfoOccupationL: string = '���������:';
  InfoWebSiteL: string = '����:';
  InfoPhoneL: string = '�������:';
  InfoFaxL: string = '����:';
  InfoCellularL: string = '�������:';
  InfowPhoneL: string = '������� �������:';
  InfowFaxL: string = '������� ����:';
  InfoInterestsL: string = '��������:';
  InfoAboutL: string = '� ����:';
  InfoHomePageL: string = '�������� ���������:';
  InfoLastUpDateL: string = '���� ���������� ���������� ������:';
  InfoLangL: string = '�������� �������:';
  InfoMaritalL: string = '����:';
  InfoSexualL: string = '����������� ����������:';
  InfoHeightL: string = '����:';
  InfoReligL: string = '�������:';
  InfoSmokL: string = '�������:';
  InfoHairL: string = '���� �����:';
  InfoChildrenL1: string = '�����:';
  InfoChildrenL2: string = '�����, ��� 8';
  InfoChildrenL3: string = '���';
  DellContactL: string = '������� "%s" ����� �����. �� �������?';
  DellYourSelfL: string = '������� ���� �� ������ ��������: %s. �� �������?';
  HistoryNotFileL: string = '������� ��������� � ���� ��������� �����������';
  GroupInv: string = ' �� ';
  HistorySearchNoL: string = '����� ����� �� ������.';
  HistoryLoadFileL: string = '����������� �������...';
  UpDateStartL: string = '�������� ����������...';
  UpDateAbortL: string = '�������� ���������� ��������.';
  UpDateLoadL: string = '���� ���������� ������� �������.';
  UpDateUnL: string = '��������� ����������...';
  UpDateOKL: string = '��������� ���������� ���������.' + #13#10 + #13#10 + '��� ���������� ���������� ���������� ������������� ��������� IMadering!';
  ProxyConnectErrL1: string = '�������� ����� ��� ������ ��� ������.';
  ProxyConnectErrL2: string = '����������� ������ ������.';
  JabberLoginErrorL: string = '������������ JID ��� ������.';
  HttpSocketErrCodeL: string = '��� ������: %d';
  SelectDirL: string = '�������� ����� ��� �������� ������ �������';
  DelProfile: string = '������� ������ �������?';
  URLOpenErrL: string = '������� ��� �������� ������ �� ������.' + #13#10 + '������ ����������� � ����� ������.';
  SearchInfoGoL: string = '��� ����� ...';
  SearchInfoEndL: string = '����� ��������';
  SearchInfoNoL: string = '�� ������';
  SearchInfoAuthL: string = '�����������';
  SearchInfoAuthNoL: string = '�� �����';

  ConnectErrors_0001: string = '������������ ����� ICQ ��� ������.';
  ConnectErrors_0002: string = '������ �������� ����������.';
  ConnectErrors_0003: string = '������ �����������.';
  ConnectErrors_0004: string = '�������� ����� ICQ ��� ������.';
  ConnectErrors_0005: string = '�������� ����� ICQ ��� ������.';
  ConnectErrors_0006: string = '���������� ������.';
  ConnectErrors_0007: string = '��� �������� ������� ������.';
  ConnectErrors_0008: string = '��� ������� ������ ���� �������.';
  ConnectErrors_0009: string = '��� ������������ ������� ������.';
  ConnectErrors_000A: string = '��� ������� � ����.';
  ConnectErrors_000B: string = '��� ������� � ����������.';
  ConnectErrors_000C: string = '�������� ���� � ���� ������.';
  ConnectErrors_000D: string = '�������� ������ ����.';
  ConnectErrors_000E: string = '�������� ������ ����������.';
  ConnectErrors_000F: string = '���������� ��������� ������.';
  ConnectErrors_0010: string = '������ �������� ��������.';
  ConnectErrors_0011: string = '������������ ���� ������� ������ ��������������.';
  ConnectErrors_0012: string = '������ ��������������� � ����.';
  ConnectErrors_0013: string = '������ �������� � ����.';
  ConnectErrors_0014: string = '������ ��������� �����.';
  ConnectErrors_0015: string = '������ ��������� ��������.';
  ConnectErrors_0016: string = '��������� ������ ����������� � ����� IP-������.';
  ConnectErrors_0017: string = '��������� ������ ����������� � ����� IP-������.';
  ConnectErrors_0018: string = '�������� ����� �����������! ���������� ������������ �����.';
  ConnectErrors_0019: string = '��� ������� ������ ����� ��������� ������� ��������������. ���������� �����.';
  ConnectErrors_001A: string = '�������� �������� ���������� � ����.';
  ConnectErrors_001B: string = '�� ����������� ������ ������ �������. �������� ������.';
  ConnectErrors_001C: string = '�� ����������� ������ ������ �������. ������������� �������� ������.';
  ConnectErrors_001D: string = '�������� ����� �����������! ���������� ������������ �����.';
  ConnectErrors_001E: string = '���������� ������������������ � ����. ���������� �����.';
  ConnectErrors_0020: string = '�������� SecureID.';
  ConnectErrors_0022: string = '��� ������� ������ ���������� ��-�� ������ �������� (������ 13).';

  LStatus1: string = '����� ���������';
  LStatus2: string = '����';
  LStatus3: string = '���������';
  LStatus4: string = '����';
  LStatus5: string = '�� ������';
  LStatus6: string = '�����';
  LStatus7: string = '������';
  LStatus8: string = '����������';
  LStatus9: string = '�����';
  LStatus10: string = '�� ����������';
  LStatus11: string = '� ����';
  LStatus12: string = '���������';
  LStatus13: string = '��������� ��� ����';
  LStatus14: string = '�� � ����';
  LStatus15: string = '�������������';
  LStatus16: string = '������������';
  LStatus17: string = '���������� �����������';

  //--������ http �������
  Err400: string = '�������� ������.';
  Err401: string = '������������������.';
  Err402: string = '��������� ������.';
  Err403: string = '���������.';
  Err404: string = '�� �������.';
  Err405: string = '����� �� �����������.';
  Err406: string = '�� ���������.';
  Err407: string = '��������� ����������� �� ������.';
  Err408: string = '����� �������� ������� �������.';
  Err409: string = '��������.';
  Err410: string = '������.';
  Err411: string = '��������� �����.';
  Err412: string = '����������� �������.';
  Err413: string = '������ ������� ������� �������.';
  Err414: string = 'URI ������� ������� �������.';
  Err415: string = '���������������� ��� �����.';
  Err416: string = '�������� �� �������� �����������.';
  Err417: string = '��������� �� ������������� ����������.';
  Err500: string = '���������� ������ �������.';
  Err501: string = '�� �����������.';
  Err502: string = '������ �����.';
  Err503: string = '������ ����������.';
  Err504: string = '������� ����� �������� �� �����.';
  Err505: string = '�� �������������� ������ HTTP.';

  //--���������� ���������� ����������� ���������
  FDAOptions: TJvDesktopAlertOptions;
  DACount: integer = 0;
  DATimeShow: integer = 7000;
  DAPos: integer = 3;
  DAStyle: integer = 0;

  //--���������� ��� ���� ����
  NoAvatar: TImage;
  OutMessage2: TMemoryStream;
  OutMessage3: TMemoryStream;
  QReplyAutoSend: boolean = false;
  SmilesList: TStringList;
  InMessList: TStringList;
  TextSmilies: boolean = false;
  YouAt: string = '�';
  ChatFontSize: string = '9';

  //--������ ��� ����������� � About
  AboutList: array[1..14] of string = (
    '����� ������� � ������� �����������;������ ��������',
    '����������������;������ ������',
    '����������������;Francois PIETTE (Ics components)',
    '����������������;David Baldwin (HTML components)',
    '����������������;Project Jedi (jvcl components)',
    '����������������;������ ������ (SimpleXML ���������)',
    '����������������;Polaris Software (rXML ���������)',
    '����������������;Anders Melander (GIFImage component)',
    '������;ϸ�� ��������',
    '������;Michael Niedermayr (www.greensmilies.com)',
    '������������ � ���������;����� �������',
    '����������� �������������;��������� ����������',
    '����������� �������������;�������� ����������',
    'IMadering;������� ����!'
    );

  //--Http ������ ��� ������� ����������
  HttpProxy_Enable: boolean = false;
  HttpProxy_Address: string;
  HttpProxy_Port: string;
  HttpProxy_Auth: boolean = false;
  HttpProxy_Login: string;
  HttpProxy_Password: string;

implementation

end.

