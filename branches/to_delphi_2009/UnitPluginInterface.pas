{******************************************}
{*************IMadeRing project************}
{*********UnitPluginInterface.pas**********}
{**  @author: Sergey Melnikov            **}
{**  @EMail: Melnikov.Sergey.V@gmail.com **}
{**  @Created: 09.2009                   **}
{******************************************}
{******************************************}

unit UnitPluginInterface;

interface

{

  �������, �� ������� ����� ����� ������ ������� �������:
    1. �������� ����������
    2. �����������
    3. ������������
    4. ������� ������� ������
    5. ������� ������� ���������
    6. ...

    ��� ������� �� ������� ����� 1, 3 ������� ���� Continue ��������� Context, ���������� ������
    ����������� ��������� ������� �����������. 

  ��� ���������� ������������� �������:
    1.1. ������ ����������
    1.2. ���� � �������
    1.3. ...
    2.1. ����� ������������
    2.2. ������
    2.3. ����
    2.4. ���������� SSL
    2.5. ...
    3.1. ��� ������
    3.2. ������
    3.3. ����
    3.4. ���������� SSL
    3.5. ...
    4.1. ID ��������
    4.2. ������������ ���
    4.3. ������� ������
    4.4. ����� ������
    4.5. ...
    5.1. ID ��������
    5.2. ������������ ���
    5.3. ����� ���������
    5.4. ������� � �������-�����?
    5.5. ...
 }
const
  PluginIDMagicConst: HRESULT = 788112009;
  IID_IIMRPlugin = '{58DC42FE-AA44-4996-8048-CB9455010B78}';
  CONST_EVENTS_COUNT = 5;

type

  TEventType = (eApplicationLoaded, eAuthorization, eDisconnect, eContactChangeStatus,
    eWriteMessage);
  TProtocol = (pICQ, pMRA, pJabber, pAny);
  TMessageDirection = (mdTOme, mdFROMme);

  PApplicationLoadedParams = ^TApplicationLoadedParams;
  TApplicationLoadedParams = packed record
    cSize: Cardinal;
    AppVersion: Cardinal;
    ProfilePath: PWideChar;
  end;

  PAuthorizationParams = ^TAuthorizationParams;
  TAuthorizationParams = packed record
    cSize: Cardinal;
    UserLogin: PWideChar;
    Server: PWideChar;
    Port: Cardinal;
    IsSSLActive: Cardinal;
  end;

  PDisconnectParams = ^TDisconnectParams;
  TDisconnectParams = packed record
    cSize: Cardinal;
    ErrorCode: Cardinal;
    Server: PWideChar;
    Port: Cardinal;
    IsSSLActive: Cardinal;
  end;

  PContactChangeStatusParams = ^TContactChangeStatusParams;
  TContactChangeStatusParams = packed record
    cSize: Cardinal;
    ContactID: PWideChar;
    ContactCaption: PWideChar;
    LastStatus: PWideChar;
    NewStatus: PWideChar;
  end;

  PContactWriteMessageParams = ^TContactWriteMessageParams;
  TContactWriteMessageParams = packed record
    cSize: Cardinal;
    FromContactID: PWideChar;
    FromContactCaption: PWideChar;
    ToContactID: PWideChar;
    ToContactCaption: PWideChar;
    MessageText: PWideChar;
    Direction: TMessageDirection;
  end;

  //�������� ���������. ���������� ����.
  TContext = record
    /// <summary>������ ������. ��� �������� ������� � ������ � ������������
    /// ������ ������</summary>
    cSize: Integer;
    /// <summary>�������� ��������</summary>
    ActiveProtocol: TProtocol;
    /// <summary>���� ����������� ���������</summary>
    ContinueExecution: Cardinal;
  end;

  //TCallBackFunction = function(const Context: TContext; Event: TEventType; Data: Pointer): HRESULT; stdcall;

  IIMRPlugin = interface(IUnknown)
    [IID_IIMRPlugin]
      function Init(AppVersion: Integer): HRESULT; stdcall;
      function Configure(ProfilePath: PWideChar): HRESULT; stdcall;
      function Quit: HRESULT; stdcall;

      /// <summary>�������� ��� WinApi. ������ ��� ������ ������, ����� � ��� ���������� �������!</summary>
      function GetPluginName(Data: PWideChar): Integer; stdcall;

      /// <summary>���������� ���������� �������, �� ������� ��������� ������</summary>
      function GetEventsCount: Integer; stdcall;
      /// <summary>���������� ���������� � ���, �� ����� ��������� ������� �������� ������</summary>
      function RegisterCallBack(var EventTime: TEventType; const i: Integer): HRESULT; stdcall;

      /// <summary>��������� ������ � �������</summary>
      function NotifyPlugin(const Context: TContext; Event: TEventType; Data: Pointer): HRESULT; stdcall;
  end;

implementation

end.
