object CLSearchForm: TCLSearchForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1081#1090#1080' '#1082#1086#1085#1090#1072#1082#1090#1099
  ClientHeight = 258
  ClientWidth = 413
  Color = clBtnFace
  Constraints.MinHeight = 230
  Constraints.MinWidth = 420
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 11
      Top = 9
      Width = 110
      Height = 13
      Caption = #1059#1095#1105#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100', '#1053#1080#1082':'
    end
    object CLSearchEdit: TEdit
      Left = 10
      Top = 28
      Width = 392
      Height = 21
      TabOrder = 0
      OnChange = CLSearchEditChange
    end
  end
  object CLSearchJvListView: TJvListView
    Left = 0
    Top = 57
    Width = 413
    Height = 201
    Align = alClient
    Columns = <
      item
        Caption = #1059#1095#1105#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100
        Width = 180
      end
      item
        Caption = #1053#1080#1082
        Width = 225
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SmallImages = MainForm.AllImageList
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = CLSearchJvListViewColumnClick
    OnDblClick = CLSearchJvListViewDblClick
    OnSelectItem = CLSearchJvListViewSelectItem
    AutoSelect = False
    ColumnsOrder = '0=180,1=225'
    HeaderImagePosition = hipRight
    HeaderImages = MainForm.AllImageList
    Groups = <>
    ExtendedColumns = <
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end
      item
        HeaderImagePosition = hipRight
        UseParentHeaderImagePosition = False
      end>
    ExplicitLeft = 8
    ExplicitTop = 63
    ExplicitWidth = 397
    ExplicitHeight = 107
  end
end