{*******************************************************************************
  Copyright (c) 2004-2009 by Edyard Tolmachev
  IMadering project
  http://imadering.com
  ICQ: 118648
  E-mail: imadering@mail.ru
*******************************************************************************}

unit IcqRegNewUINUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, OverbyteIcsWndControl, OverbyteIcsWSocket,
  Buttons, ShellApi;

type
  TIcqRegNewUINForm = class(TForm)
    RegInfoPanel: TPanel;
    RegPassLabel: TLabel;
    RegPassEdit: TEdit;
    ReqSecretImageButton: TButton;
    RegImagePanel: TPanel;
    RegImage: TImage;
    ImageWordLabel: TLabel;
    SecretWordEdit: TEdit;
    NewUINRegButton: TButton;
    ICQRegWSocket: TWSocket;
    CopyUINSpeedButton: TSpeedButton;
    Bevel1: TBevel;
    WebRegLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReqSecretImageButtonClick(Sender: TObject);
    procedure ICQRegWSocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure NewUINRegButtonClick(Sender: TObject);
    procedure CopyUINSpeedButtonClick(Sender: TObject);
    procedure WebRegLabelMouseEnter(Sender: TObject);
    procedure WebRegLabelMouseLeave(Sender: TObject);
    procedure WebRegLabelClick(Sender: TObject);
    procedure ICQRegWSocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure ICQRegWSocketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure ICQRegWSocketSocksError(Sender: TObject; Error: Integer;
      Msg: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IcqRegNewUINForm: TIcqRegNewUINForm;

implementation

uses UtilsUnit, VarsUnit, MainUnit, IcqProtoUnit;

{$R *.dfm}

procedure TIcqRegNewUINForm.CopyUINSpeedButtonClick(Sender: TObject);
var
  ed: TEdit;
begin
  //--��� ��������� ��� �� ������ ������ � ������ �������
  //� �������� ���� ��� ����������� � ����� ������
  ed := TEdit.Create(nil);
  ed.Visible := false;
  ed.Parent := IcqRegNewUINForm;
  ed.Text := RegInfoPanel.Caption;
  ed.SelectAll;
  ed.CopyToClipboard;
  FreeAndNil(ed);
end;

procedure TIcqRegNewUINForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //--���� ����� ��� ���������, �� ��������� ��� � ���� ����� �� ���������
  ICQRegWSocket.Close;
  ICQRegWSocket.WaitForClose;
  //--��������� ������������ ���� ��� ��������
  Action := caFree;
  IcqRegNewUINForm := nil;
end;

procedure TIcqRegNewUINForm.FormCreate(Sender: TObject);
begin
  //--����������� ������ ���� � �������
  MainForm.AllImageList.GetIcon(81, Icon);
  MainForm.AllImageList.GetBitmap(144, CopyUINSpeedButton.Glyph);
  //--�������� ������ ����� � ������� � ������ �����������
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TIcqRegNewUINForm.ICQRegWSocketDataAvailable(Sender: TObject;
  ErrCode: Word);
label
  x, z;
var
  Pkt, HexPkt, SubPkt, ImageData, NewUin: string;
  PktLen, Len: integer;
  StreamImg: TMemoryStream;
begin
  //--�������� ��������� �� ������� ������ � ������
  Pkt := ICQRegWSocket.ReceiveStr;
  //--���� ������ ���� ������ ����� ����, ������� �� ���� :)
  if Length(Pkt) = 0 then Exit;
  //--����������� ������ �� ��������� ������� � HEX ������ � ����������
  //�� � ������������ ������ ���������� ����� ��������������� ������
  ICQ_RegUIN_HexPkt := ICQ_RegUIN_HexPkt + Text2Hex(Pkt);
  //--���� ������ � ������ �������
  if ((ICQ_RegUIN_HexPkt > EmptyStr) and (HexToInt(LeftStr(ICQ_RegUIN_HexPkt, 2)) <> $2A)) or
    ((Length(ICQ_RegUIN_HexPkt) > 2) and ((HexToInt(ICQ_RegUIN_HexPkt[3] + ICQ_RegUIN_HexPkt[4]) = $0)
    or (HexToInt(ICQ_RegUIN_HexPkt[3] + ICQ_RegUIN_HexPkt[4]) > $05))) then
  begin
    //--���� � ������ ���� ������, �� ��������� ����� � ������� ��������� �� ������
    DAShow(ErrorHead, ParsingPktError, EmptyStr, 134, 2, 0);
    ICQRegWSocket.Close;
    Exit;
  end;
  //--���� ����� ��� ��������, �� � ������ ���� ��� ������, �� ������������ ����
  //��� �������� ���� ������ �� ������� ���������� ������ ������ ������
  x: ;
  //--��������� ���� �� � ������ ���� ���� ����� �����
  if (Length(ICQ_RegUIN_HexPkt) >= ICQ_FLAP_HEAD_SIZE) and (Length(ICQ_RegUIN_HexPkt) >= ICQ_FLAP_HEAD_SIZE + ICQ_BodySize2) or
    ((HexToInt(ICQ_RegUIN_HexPkt[3] + ICQ_RegUIN_HexPkt[4]) = $04) and (ICQ_BodySize2 = 0)) then
  begin
    //--�������� �� ������ ���� ����� �����
    HexPkt := NextData(ICQ_RegUIN_HexPkt, ICQ_FLAP_HEAD_SIZE + ICQ_BodySize2);
    //--��������� ����� ������ ���� ��� ������ ������ ����
    if Length(HexPkt) > 0 then
    begin
      //--��� ��� ������ �������� �� ������ ������ ICQ ��������� �� ����� $2A
      if HexToInt(NextData(HexPkt, 2)) = $2A then
      begin
        //--������� ����� ����� � ������
        case HexToInt(NextData(HexPkt, 2)) of
          $01:
            begin
              //--���������� Seq (�������)
              NextData(HexPkt, 4);
              //--����� ������ ������ � ����������� � � ���� ��� HEX �������
              PktLen := HexToInt(NextData(HexPkt, 4));
              PktLen := PktLen * 2;
              //--�������� ���� ������
              SubPkt := NextData(HexPkt, PktLen);
              //--���� AOL ������� �����������
              if SubPkt = '00000001' then
              begin
                //--�������� ��� ���� "������" + ���-�� ����� � ���������
                SendFLAP_Reg('1', '00000001' + '8003000400100000');
                //--����� �������� ������ �� ��������
                SendFLAP_Reg('2', '0017000C0000000000000000');
              end;
            end;
          $02:
            begin
              //--���������� Seq (�������)
              NextData(HexPkt, 4);
              //--����� ������ ������ � ����������� � � ���� ��� HEX �������
              PktLen := HexToInt(NextData(HexPkt, 4));
              PktLen := PktLen * 2;
              //--�������� ���� ������
              SubPkt := NextData(HexPkt, PktLen);
              //--������� ����� ������ � ������
              case HexToInt(NextData(SubPkt, 4)) of
                $0017:
                  begin
                    //--������� ����� ��������� � ������
                    case HexToInt(NextData(SubPkt, 4)) of
                      $0001: //--�������� ��� ������ ������� � �����������
                        begin
                          //--����������, �� ������, ��� � ����������� ���� ��������
                          if Assigned(IcqRegNewUINForm) then RegInfoPanel.Caption := ICQRegNewInfo_1;
                        end;
                      $0005: //--����� �������� ����� ��������� UIN
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--���������� ������ ���������� ������ � ������
                          NextData(SubPkt, 92);
                          //--�������������� ����� UIN
                          NewUin := FloatToStr(Swap32(HexToInt(NextData(SubPkt, 8))));
                          //--���� ����� ����� ������������� ����, �� ���������� ��� �� ������
                          if NewUin > EmptyStr then
                          begin
                            //--��������� �� ������ ������ �� ���� �� ����� �������
                            if Assigned(IcqRegNewUINForm) then
                            begin
                              //--���������� UIN � ������ �� ������
                              RegInfoPanel.Caption := 'ICQ#: ' + NewUin + '  ' + PassLabelInfo + ' ' + RegPassEdit.Text;
                              //--������ ������ ����������� ������ UIN � ������ ��������
                              CopyUINSpeedButton.Visible := true;
                              //--�� ������ ������ ����� � ���� ��� ����������� ������� ICQ
                              AppendOrWriteTextToFile(MyPath + 'Profile\Icq Registered Accounts.txt', NewUin + ';' + RegPassEdit.Text);
                            end;
                          end;
                        end;
                      $000D: //--�������� �������� � ��������� �����
                        begin
                          //--���������� ������ ������
                          NextData(SubPkt, 12);
                          //--���������� ������ ���������� ������ � ������
                          NextData(SubPkt, 32);
                          //--����� ������ ������ � ��������� � ����������� � � ���� ��� HEX �������
                          Len := HexToInt(NextData(SubPkt, 4));
                          Len := Len * 2;
                          //--�������� ������ �������� ��������� ������
                          ImageData := Hex2Text(NextData(SubPkt, Len));
                          //--���� ��� ������ ������� ����, �� ����� �� � ������
                          if ImageData > EmptyStr then
                          begin
                            //--������� ���� ������
                            StreamImg := TMemoryStream.Create;
                            try
                              //--��������� ������
                              StreamImg.Write(ImageData[1], Length(ImageData));
                              //--��������� �� ������ �������� �� ������ ����
                              StreamImg.SaveToFile(Mypath + 'Profile\RegImage.jpg');
                              //--���� ���� ���������� ��� �� ���������� �������� �� �����
                              if Assigned(IcqRegNewUINForm) then
                              begin
                                //--��������� �������� �� ����������� �����
                                RegImage.Picture.LoadFromFile(Mypath + 'Profile\RegImage.jpg');
                                //--���� ���� ����� ���������� ����� �������� ��� ������ �� ����� ������ � ����
                                if SecretWordEdit.CanFocus then SecretWordEdit.SetFocus;
                              end;
                            finally
                              //--������������ ���� ������
                              StreamImg.Free;
                            end;
                            //--���������� ������ ���������� ������ ������ icq
                            NewUINRegButton.Enabled := true;
                          end;
                        end;
                    end;
                  end;
              end;
            end;
          $04: //--������ ��������� � ���� � ������� "�� ��������"
            begin
              //--���������� Seq (�������)
              NextData(HexPkt, 4);
              //--������� ������ ������
              PktLen := HexToInt(NextData(HexPkt, 4));
              //--���� ������ ����� ����, �� ����� ��������� :)
              if PktLen = 0 then
              begin
                //--���� ����� ��� ���������, �� ���� ���������� ��������
                if ICQRegWSocket.State = wsConnected then ICQRegWSocket.SendStr(Hex2Text('2A04' + IntToHex(ICQ_Seq2, 4) + '0000'));
                //--��������� ����� � ���� ���� ���������
                ICQRegWSocket.Close;
                ICQRegWSocket.WaitForClose;
              end
              else
              begin
                //--����������� ������ ������ � ���� ��� HEX �������
                PktLen := PktLen * 2;
                //--�������� ���� ������
                SubPkt := NextData(HexPkt, PktLen);
                //--��� �� ������ ���� �� ������ ������ TLV
                while Length(SubPkt) > 0 do
                begin
                  case HexToInt(NextData(SubPkt, 4)) of
                    $0008: //--TLV � ����� ������
                      begin
                        //--�������� ������ TLV � ����������� � � ����
                        Len := HexToInt(NextData(SubPkt, 4));
                        Len := Len * 2;
                        //--���������� ��������� �� ���� ������
                        RegInfoPanel.Caption := ICQ_NotifyAuthCookieError(NextData(SubPkt, Len));
                        DAShow(ErrorHead, RegInfoPanel.Caption, EmptyStr, 134, 2, 0);
                        //--��������� ����� � ���� ���� ���������
                        ICQRegWSocket.Close;
                        ICQRegWSocket.WaitForClose;
                      end
                  else
                    begin
                      //--���� ���������� ������ TLV, �� ���������� ��
                      Len := HexToInt(NextData(SubPkt, 4));
                      Len := Len * 2;
                      NextData(SubPkt, Len);
                    end;
                  end;
                end;
              end;
            end
        else
          //--���� ����� ������ ������ ������, �� ��������� � ������ ������ �����
          goto z;
        end;
      end
      else
      begin
        //--���� ��������� ����� ������ �� ����������,
        //�� ������� ��������� �� ������ ������� � �������
        DAShow(ErrorHead, ParsingPktError, EmptyStr, 134, 2, 0);
        //--��������� ����� � ���� ���� ���������
        ICQRegWSocket.Close;
        ICQRegWSocket.WaitForClose;
        Exit;
      end;
    end;
    //--���� � ����� ������� ������ � ��� ��� �������� ������, �� ������������ ��� �������� ������
    z: ;
    if Length(ICQ_RegUIN_HexPkt) > 0 then goto x;
  end;
end;

procedure TIcqRegNewUINForm.ReqSecretImageButtonClick(Sender: TObject);
begin
  //--�������� ��������
  CopyUINSpeedButton.Visible := false;
  RegImage.Picture.Assign(nil);
  SecretWordEdit.Clear;
  //--��������� ������ �� ������ ��� ������ ICQ#
  if RegPassEdit.Text = EmptyStr then
  begin
    //--�������� � ��� ��� ����� ������ ������
    DAShow(AlertHead, RegNewAlert_1, EmptyStr, 134, 2, 0);
    //--������ ����� � ���� �����
    if RegPassEdit.CanFocus then RegPassEdit.SetFocus;
    //--�������
    Exit;
  end;
  //--��������� ������� ��������� �������� � �����
  RegInfoPanel.Caption := RegPanelInfo_1;
  if ICQRegWSocket.State = wsConnected then
  begin
    //--���� ����� ��� ���������, �� ��������� ��� � ���� ����� �� ���������
    ICQRegWSocket.Close;
    ICQRegWSocket.WaitForClose;
  end;
  try
    //--��������� ��������� ������
    ICQRegWSocket.Addr := 'login.icq.com';
    ICQRegWSocket.Port := '5190';
    //--���������� �����
    ICQRegWSocket.Connect;
  except
    on E: Exception do
    begin
      //--���� ��� ����������� ��������� ������, �� �������� �� ���� � ��������� �����
      //E.Message;
      DAShow(ErrorHead, ICQ_NotifyConnectError(WSocket_WSAGetLastError), EmptyStr, 134, 2, 0);
      ICQRegWSocket.Close;
    end;
  end;
end;

procedure TIcqRegNewUINForm.NewUINRegButtonClick(Sender: TObject);
begin
  //--��������� ������� �� ����� � ��������
  if SecretWordEdit.Text = EmptyStr then
  begin
    //--�������� �� ���� ������
    DAShow(AlertHead, RegNewAlert_2, EmptyStr, 134, 2, 0);
    //--������ ����� � ���� �����
    if SecretWordEdit.CanFocus then SecretWordEdit.SetFocus;
    //--�������
    Exit;
  end;
  //--���������� ��������
  NewUINRegButton.Enabled := false;
  RegImage.Picture.Assign(nil);
  //--���� ����� ��� ���������, �� ���������� ��������������� ������ � ��� ������ UIN :)
  if ICQRegWSocket.State = wsConnected then ICQ_SendRegNewUIN(RegPassEdit.Text, SecretWordEdit.Text)
  else
  begin
    //--���� ����� ��� ���������, �� �������� �� ����
    DAShow(AlertHead, SocketConnErrorInfo_1, EmptyStr, 134, 2, 0);
    //--����������� ����� ��������
    ReqSecretImageButton.Click;
  end;
end;

procedure TIcqRegNewUINForm.WebRegLabelClick(Sender: TObject);
begin
  //--��������� ����������� �� ��� ����� ICQ
  ShellExecute(Application.Handle, 'open', PChar('http://www.icq.com/register'), nil, nil, SW_SHOWNORMAL);
end;

procedure TIcqRegNewUINForm.WebRegLabelMouseEnter(Sender: TObject);
begin
  WebRegLabel.Font.Color := clBlue;
end;

procedure TIcqRegNewUINForm.WebRegLabelMouseLeave(Sender: TObject);
begin
  WebRegLabel.Font.Color := clNavy;
end;

procedure TIcqRegNewUINForm.ICQRegWSocketSessionClosed(Sender: TObject;
  ErrCode: Word);
begin
  //--���� ��� ���������� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(WSocket_WSAGetLastError), EmptyStr, 134, 2, 0);
  end;
end;

procedure TIcqRegNewUINForm.ICQRegWSocketSessionConnected(Sender: TObject;
  ErrCode: Word);
begin
  //--���� ��� ����������� �������� ������, �� �������� �� ����
  if ErrCode <> 0 then
  begin
    DAShow(ErrorHead, ICQ_NotifyConnectError(WSocket_WSAGetLastError), EmptyStr, 134, 2, 0);
  end;
end;

procedure TIcqRegNewUINForm.ICQRegWSocketSocksError(Sender: TObject;
  Error: Integer; Msg: string);
begin
  //--���������� ������ ����������� ����� Socks ������
  
end;

end.

