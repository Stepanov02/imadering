object IcqReqAuthForm: TIcqReqAuthForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
  ClientHeight = 211
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object HeadLabel: TLabel
    Left = 9
    Top = 8
    Width = 34
    Height = 13
    Caption = #1058#1077#1082#1089#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object InfoMemo: TMemo
    Left = 8
    Top = 27
    Width = 288
    Height = 145
    TabStop = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object YesBitBtn: TBitBtn
    Left = 199
    Top = 178
    Width = 97
    Height = 25
    Caption = #1044#1072
    Default = True
    TabOrder = 1
    TabStop = False
    OnClick = YesBitBtnClick
  end
  object NoBitBtn: TBitBtn
    Left = 8
    Top = 178
    Width = 97
    Height = 25
    Caption = #1053#1077#1090
    ModalResult = 2
    TabOrder = 2
    TabStop = False
    OnClick = NoBitBtnClick
  end
end