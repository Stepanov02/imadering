unit IcsLogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TIcsLogForm = class(TForm)
    IcsLogMemo: TMemo;
    Panel1: TPanel;
    SocketLabel: TLabel;
    SocketComboBox: TComboBox;
    LogEnableCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure IcsLogMemoDblClick(Sender: TObject);
    procedure SocketComboBoxChange(Sender: TObject);
    procedure LogEnableCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IcsLogForm: TIcsLogForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TIcsLogForm.FormCreate(Sender: TObject);
begin
  //--������ ������ ����
  MainForm.AllImageList.GetIcon(227, Icon);
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TIcsLogForm.IcsLogMemoDblClick(Sender: TObject);
begin
  //--������� ��� ������
  IcsLogMemo.Clear;
end;

procedure TIcsLogForm.LogEnableCheckBoxClick(Sender: TObject);
begin
  //--�������� ��� ��������� �����������
  SocketComboBoxChange(self);
end;

procedure TIcsLogForm.SocketComboBoxChange(Sender: TObject);
begin
  with MainForm do
  begin
    //--������� ����������� �� ���� �������
    ICQWSocket.IcsLogger := nil;
    ICQAvatarWSocket.IcsLogger := nil;
    MRAWSocket.IcsLogger := nil;
    JabberWSocket.IcsLogger := nil;
    UpdateHttpClient.IcsLogger := nil;
    MRAAvatarHttpClient.IcsLogger := nil;
    //--������ ��������� ����������� ���������� ������
    if LogEnableCheckBox.Checked then
    begin
      case SocketComboBox.ItemIndex of
        1: ICQWSocket.IcsLogger := WIcsLogger;
        2: ICQAvatarWSocket.IcsLogger := WIcsLogger;
        3: MRAWSocket.IcsLogger := WIcsLogger;
        4: JabberWSocket.IcsLogger := WIcsLogger;
        5: UpdateHttpClient.IcsLogger := WIcsLogger;
        6: MRAAvatarHttpClient.IcsLogger := WIcsLogger;
      end;
    end;
  end;
end;

end.

