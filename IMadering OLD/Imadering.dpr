﻿// JCL_DEBUG_EXPERT_INSERTJDBG ON
// JCL_DEBUG_EXPERT_DELETEMAPFILE ON

program Imadering;

uses
  ShareMem, // Закомментировать этот юнит при проверке утечек памяти
  SysUtils,
  Windows,
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  ChatUnit in 'ChatUnit.pas' {ChatForm},
  CLSearchUnit in 'CLSearchUnit.pas' {CLSearchForm},
  FloatingUnit in 'FloatingUnit.pas' {FloatingForm},
  HistoryUnit in 'HistoryUnit.pas' {HistoryForm},
  AddContactUnit in 'AddContactUnit.pas' {AddContactForm},
  ContactInfoUnit in 'ContactInfoUnit.pas' {ContactInfoForm},
  IcqOptionsUnit in 'IcqOptionsUnit.pas' {IcqOptionsForm},
  MemoUnit in 'MemoUnit.pas' {MemoForm},
  ContactSearchUnit in 'ContactSearchUnit.pas' {ContactSearchForm},
  XStatusUnit in 'XStatusUnit.pas' {XStatusForm},
  SmilesUnit in 'SmilesUnit.pas' {SmilesForm},
  JabberOptionsUnit in 'JabberOptionsUnit.pas' {JabberOptionsForm},
  TrafficUnit in 'TrafficUnit.pas' {TrafficForm},
  ProfileUnit in 'ProfileUnit.pas' {ProfileForm},
  LoginUnit in 'LoginUnit.pas' {LoginForm},
  ProfilesFolderUnit in 'ProfilesFolderUnit.pas' {ProfilesFolderForm},
  SMSUnit in 'SMSUnit.pas' {SMSForm},
  IcqProtoUnit in 'IcqProtoUnit.pas',
  JabberProtoUnit in 'JabberProtoUnit.pas',
  VarsUnit in 'VarsUnit.pas',
  RosterUnit in 'RosterUnit.pas',
  UtilsUnit in 'UtilsUnit.pas',
  OverbyteIcsLIBEAY in 'lib\OverbyteIcsLIBEAY.pas',
  Menus in 'lib\Menus.pas',
  JvListView in 'lib\JvListView.pas',
  JvHint in 'lib\JvHint.pas',
  JvDesktopAlertForm in 'lib\JvDesktopAlertForm.pas',
  JvDesktopAlert in 'lib\JvDesktopAlert.pas',
  ComCtrls in 'lib\ComCtrls.pas',
  CategoryButtons in 'lib\CategoryButtons.pas',
  ButtonGroup in 'lib\ButtonGroup.pas',
  ImgList in 'lib\ImgList.pas',
  ConfUnit in 'ConfUnit.pas' {ConfForm},
  JBrowseUnit in 'JBrowseUnit.pas' {JBrowseForm},
  BimoidOptionsUnit in 'BimoidOptionsUnit.pas' {BimoidOptionsForm},
  BimoidProtoUnit in 'BimoidProtoUnit.pas',
  MraOptionsUnit in 'MraOptionsUnit.pas' {MraOptionsForm},
  BugReportUnit in 'BugReportUnit.pas' {BugReportForm};

{$R *.res}
{$SETPEFLAGS IMAGE_FILE_RELOCS_STRIPPED or IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.Title := 'IMadering';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

