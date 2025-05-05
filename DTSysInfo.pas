unit DTSysInfo;

interface

uses
  System.SysUtils, System.Classes,DTSysInfoSystem,system.variants,Winapi.ActiveX,System.Win.ComObj,Winapi.Windows,
  Winapi.WinSock,System.Win.Registry;

type TArmazenamento = record
      Total: String;
      Livre: String;
      EmUso: String;
      Tipo: String;
      Modelo: String;
      Serial: String;
end;

type
  TDTSysinfo = class(TComponent)
  private
    FArmazenamentoHD: TArmazenamento;
    FFHDRecomendado: STRING;
    FiArmazenamentoTotal: real;
    FiArmazenamentoEmUso: real;
    FiMemoriaLivre: real;
    FiMemoriaTotal: real;
    FiTipoArmazenamento: Integer;
    FiMemoriaEmUso: real;
    FiTipoConexao: integer;
    FiArmazenamentoLivre: real;
    FModeloDiscoPrincipal: string;
    FNumSerieDiscoPrincipal: string;
    procedure SetArmazenamentoHD(const Value: TArmazenamento);
    procedure SetFHDRecomendado(const Value: STRING);
    procedure SetiArmazenamentoEmUso(const Value: real);
    procedure SetiArmazenamentoLivre(const Value: real);
    procedure SetiArmazenamentoTotal(const Value: real);
    procedure SetiMemoriaEmUso(const Value: real);
    procedure SetiMemoriaLivre(const Value: real);
    procedure SetiMemoriaTotal(const Value: real);
    procedure SetiTipoArmazenamento(const Value: Integer);
    procedure SetiTipoConexao(const Value: integer);
    procedure SetModeloDiscoPrincipal(const Value: string);
    procedure SetNumSerieDiscoPrincipal(const Value: string);
    function HDFisicalSerial: string;
    function HDModelo: string;
    function DiagnosticoDiscoDetalhado: TStringList;

  protected

  public
    function GetComputerName:string;
    function UserName: string;
    function MACAddress: string;
    function Processor: TDTProcessorArchitecture;
    function ProcessorCount: Cardinal;
    function ProcessorIdentifier: string;
    function ProcessorName: string;
    function ProcessorSpeedMHz: Cardinal;
    function Is64Bit: Boolean;
    function IsNetworkPresent: Boolean;
    function BootMode: TDTBootMode;
    function IsAdmin: Boolean;
    function IsUACActive: Boolean;
    function BiosVendor: string;
    function SystemManufacturer: string;
    function SystemProductName: string;
    function ProductName: string;
    function TipoArmazenamento: Integer;
    function Armazenamento:string;
    function TipoArmazenamentoDescricao(const ATipo: Integer): string;
    function GetTotalPhysicalMemory: Extended;
    procedure ResetMemory(out P; Size: Longint);
    function GetFreePhysicalMemory: Extended;
    function ProxyAtivo: Boolean;
    function TipoConexao: Integer;
    function TPConexao:string;
    function GetLocalIP: string;
    function UsuarioLogado : string;

  published
    property ArmazenamentoHD: TArmazenamento read FArmazenamentoHD write SetArmazenamentoHD;
    property FHDRecomendado: string read FFHDRecomendado write SetFHDRecomendado;
    property iArmazenamentoTotal: real read FiArmazenamentoTotal write SetiArmazenamentoTotal;
    property iArmazenamentoEmUso: real read FiArmazenamentoEmUso write SetiArmazenamentoEmUso;
    property iArmazenamentoLivre: real read FiArmazenamentoLivre write SetiArmazenamentoLivre;
    property iMemoriaTotal: real read FiMemoriaTotal write SetiMemoriaTotal;
    property iMemoriaLivre: real read FiMemoriaLivre write SetiMemoriaLivre;
    property iMemoriaEmUso: real read FiMemoriaEmUso write SetiMemoriaEmUso;
    property iTipoArmazenamento: Integer read FiTipoArmazenamento write SetiTipoArmazenamento;
    property iTipoConexao: integer read FiTipoConexao write SetiTipoConexao;
    property NumSerieDiscoPrincipal: string read FNumSerieDiscoPrincipal write SetNumSerieDiscoPrincipal;
    property ModeloDiscoPrincipal: string read FModeloDiscoPrincipal write SetModeloDiscoPrincipal;

  end;

procedure Register;

implementation

const
   COUNT_MEM = 1073741824;
   TIPOS_CONEXAO: array[0..2] of string = ('Indefinida', 'Lan', 'Wi-Fi');
   _HDD = 3;
   _SSD = 4;
   _NVME = 5;

procedure Register;
begin
  RegisterComponents('DT Inovacao', [TDTSysinfo]);
end;

{ TDTSysinfo }

function TDTSysinfo.HDFisicalSerial: string;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
begin
  Result := '';
  try
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
    FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_DiskDrive WHERE Index = 0');
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;

    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      if not VarIsNull(FWbemObject.SerialNumber) then
        Result := Trim(FWbemObject.SerialNumber);
    end;
  except
    Result := '';
  end;

  // Limpa as variáveis OLE
  if not VarIsEmpty(FWbemObject) then FWbemObject := Unassigned;
  if not VarIsEmpty(FWbemObjectSet) then FWbemObjectSet := Unassigned;
  if not VarIsEmpty(FWMIService) then FWMIService := Unassigned;
  if not VarIsEmpty(FSWbemLocator) then FSWbemLocator := Unassigned;
end;

function TDTSysinfo.HDModelo: string;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
  PNPDeviceID: string;
begin
  Result := '';
  try
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
    FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_DiskDrive WHERE Index = 0');
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;

    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      if not VarIsNull(FWbemObject.Model) then
        Result := Trim(FWbemObject.Model);

      // Para dispositivos NVMe, às vezes o PNPDeviceID contém informações mais precisas
      if (Result = '') or (Pos('NVME', UpperCase(Result)) > 0) then
      begin
        if not VarIsNull(FWbemObject.PNPDeviceID) then
        begin
          PNPDeviceID := Trim(FWbemObject.PNPDeviceID);

          // Extrai o modelo do PNPDeviceID para dispositivos NVMe
          // Geralmente está no formato NVME\VEN_XXXX&DEV_YYYY&SUBSYS_ZZZZ
          if Pos('NVME\', UpperCase(PNPDeviceID)) > 0 then
          begin
            // Poderia extrair informações mais detalhadas do PNPDeviceID se necessário
            if Result = '' then
              Result := Copy(PNPDeviceID, 6, Length(PNPDeviceID) - 5); // Remove o prefixo "NVME\"
          end;
        end;
      end;
    end;
  except
    Result := 'Erro ao obter modelo';
  end;

  // Limpa as variáveis OLE
  if not VarIsEmpty(FWbemObject) then FWbemObject := Unassigned;
  if not VarIsEmpty(FWbemObjectSet) then FWbemObjectSet := Unassigned;
  if not VarIsEmpty(FWMIService) then FWMIService := Unassigned;
  if not VarIsEmpty(FSWbemLocator) then FSWbemLocator := Unassigned;
end;

function VarToInt(const AVariant: Variant): INT64;
begin
  Result := StrToIntDef(Trim(VarToStr(AVariant)), 0);
end;

function TDTSysinfo.DiagnosticoDiscoDetalhado: TStringList;
var
  FSWbemLocator, FWMIService, FWbemObjectSet, FWbemObject, FStorageObj: OLEVariant;
  oEnum, oStorageEnum: IEnumvariant;
  iValue: LongWord;
  PNPDeviceID, _Interface: string;
  Lista: TStringList;
begin
  Lista := TStringList.Create;

  try
    Lista.Add('=== Diagnóstico detalhado do disco principal ===');

    // Informações do Win32_DiskDrive
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
    FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_DiskDrive WHERE Index = 0');
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;

    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      Lista.Add('--- Informações WMI básicas ---');

      if not VarIsNull(FWbemObject.Model) then
        Lista.Add('Modelo: ' + Trim(FWbemObject.Model));

      if not VarIsNull(FWbemObject.SerialNumber) then
        Lista.Add('Número de Série: ' + Trim(FWbemObject.SerialNumber));

      if not VarIsNull(FWbemObject.InterfaceType) then
      begin
        _Interface := Trim(FWbemObject.InterfaceType);
        Lista.Add('Interface: ' + _Interface);
      end;

      if not VarIsNull(FWbemObject.PNPDeviceID) then
      begin
        PNPDeviceID := Trim(FWbemObject.PNPDeviceID);
        Lista.Add('PNP Device ID: ' + PNPDeviceID);

        if Pos('NVME', UpperCase(PNPDeviceID)) > 0 then
          Lista.Add('* Detectado como NVMe pelo PNP Device ID');
      end;
    end;

    // Informações da Storage API
    try
      Lista.Add('');
      Lista.Add('--- Informações Windows Storage API ---');

      FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\Microsoft\Windows\Storage', '', '');
      FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM MSFT_PhysicalDisk WHERE DeviceID = 0');
      oStorageEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;

      if oStorageEnum.Next(1, FStorageObj, iValue) = 0 then
      begin
        if not VarIsNull(FStorageObj.MediaType) then
        begin
          Lista.Add('MediaType: ' + VarToStr(FStorageObj.MediaType));

          case VarToInt(FStorageObj.MediaType) of
            3: Lista.Add('* Detectado como HDD pelo MediaType');
            4: Lista.Add('* Detectado como SSD pelo MediaType');
            5: Lista.Add('* Detectado como NVMe pelo MediaType');
          else
            Lista.Add('* Tipo desconhecido pelo MediaType');
          end;
        end;

        if not VarIsNull(FStorageObj.BusType) then
        begin
          Lista.Add('BusType: ' + VarToStr(FStorageObj.BusType));

          if VarToInt(FStorageObj.BusType) = 17 then
            Lista.Add('* BusType 17 (PCIe) geralmente indica NVMe');
        end;
      end;
    except
      Lista.Add('Erro ao acessar Storage API - possivelmente não disponível neste sistema');
    end;

    // Conclusão do diagnóstico
    Lista.Add('');
    Lista.Add('=== Resultado da detecção ===');
    Lista.Add('Tipo detectado: ' + TipoArmazenamentoDescricao(TipoArmazenamento));
    Lista.Add('Modelo detectado: ' + HDModelo);
    Lista.Add('Número de Série detectado: ' + HDFisicalSerial);
  except
    on E: Exception do
      Lista.Add('Erro durante diagnóstico: ' + E.Message);
  end;

  Result := Lista;
end;

function TDTSysinfo.Armazenamento: string;
begin
   try
     try
         FiTipoArmazenamento := TipoArmazenamento;
         FiArmazenamentoTotal := (DiskSize(0)/(1024 * 1024));
         FiArmazenamentoLivre := (DiskFree(0)/(1024 * 1024));
         FiArmazenamentoEmUso := (FiArmazenamentoTotal - FiArmazenamentoLivre) / 1024;

         // Atualiza o número de série e modelo do disco principal
         FNumSerieDiscoPrincipal := HDFisicalSerial;
         FModeloDiscoPrincipal := HDModelo;

         FArmazenamentoHD.Total := FormatFloat('###,###,##0 GB', FiArmazenamentoTotal) + ' / ' + TipoArmazenamentoDescricao(FiTipoArmazenamento);
         FArmazenamentoHD.Livre := FormatFloat('###,###,##0 GB', FiArmazenamentoLivre);
         FArmazenamentoHD.EmUso := FormatFloat('###,###,##0 GB', FiArmazenamentoEmUso);
         FFHDRecomendado := FormatFloat('###,###,##0 GB', 240);
         FArmazenamentoHD.Tipo := TipoArmazenamentoDescricao(FiTipoArmazenamento);
         FArmazenamentoHD.Modelo := FModeloDiscoPrincipal;
         FArmazenamentoHD.Serial := FNumSerieDiscoPrincipal;

         if (FiTipoArmazenamento = _SSD) or (FiTipoArmazenamento = _NVME) then
            // Se já é SSD ou NVMe, está ok
         else if (FiTipoArmazenamento = _HDD) and (FiArmazenamentoTotal < 240) then
            // HDD pequeno = ruim

         // Recomendação para quem não tem SSD ou NVMe
         if (FiTipoArmazenamento <> _SSD) and (FiTipoArmazenamento <> _NVME) then
           FHDRecomendado := FHDRecomendado + ' / ' + TipoArmazenamentoDescricao(_SSD);
     except
         Result := 'NO';
     end;
   finally
   end;
end;

function TDTSysinfo.BiosVendor: string;
begin
       Result := TDTComputerInfo.BiosVendor;
end;

function TDTSysinfo.BootMode: TDTBootMode;
begin
       Result := TDTComputerInfo.BootMode;
end;

function TDTSysinfo.GetComputerName: string;
begin
       Result := TDTComputerInfo.ComputerName;
end;

function TDTSysinfo.GetFreePhysicalMemory: Extended;
var
  MemoryStatusEx: TMemoryStatusEx;
  Res:extended;
begin
  ResetMemory(MemoryStatusEx, SizeOf(MemoryStatusEx));
  MemoryStatusEx.dwLength := SizeOf(MemoryStatusEx);
  if not GlobalMemoryStatusEx(MemoryStatusEx) then
    RaiseLastOSError;
  Res := MemoryStatusEx.ullAvailPhys;
  Res := Res / COUNT_MEM;
  Result :=res;
end;

function TDTSysinfo.GetLocalIP: string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  i: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then
    Exit;
  pptr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pptr^[i] <> nil do
  begin
    Result := StrPas(inet_ntoa(pptr^[i]^));
    Inc(i);
  end;
  WSACleanup;
end;

function TDTSysinfo.GetTotalPhysicalMemory: Extended;
var
  MemoryStatusEx: TMemoryStatusEx;
  Res:extended;
begin
  ResetMemory(MemoryStatusEx, SizeOf(MemoryStatusEx));
  MemoryStatusEx.dwLength := SizeOf(MemoryStatusEx);
  if not GlobalMemoryStatusEx(MemoryStatusEx) then
    RaiseLastOSError;
  Res := MemoryStatusEx.ullTotalPhys;
  Res := Res / COUNT_MEM;
  Result :=res;
end;

function TDTSysinfo.Is64Bit: Boolean;
begin
       Result := TDTComputerInfo.Is64Bit;
end;

function TDTSysinfo.IsAdmin: Boolean;
begin
       Result := TDTComputerInfo.IsAdmin;
end;

function TDTSysinfo.IsNetworkPresent: Boolean;
begin
       Result := TDTComputerInfo.IsNetworkPresent;
end;

function TDTSysinfo.IsUACActive: Boolean;
begin
       Result := TDTComputerInfo.IsUACActive;
end;

function TDTSysinfo.MACAddress: string;
begin
       Result := TDTComputerInfo.MACAddress;
end;

function TDTSysinfo.Processor: TDTProcessorArchitecture;
begin
       Result := TDTComputerInfo.Processor;
end;

function TDTSysinfo.ProcessorCount: Cardinal;
begin
       Result := TDTComputerInfo.ProcessorCount;
end;

function TDTSysinfo.ProcessorIdentifier: string;
begin
       Result := TDTComputerInfo.ProcessorIdentifier;
end;

function TDTSysinfo.ProcessorName: string;
begin
       Result := TDTComputerInfo.ProcessorName
end;

function TDTSysinfo.ProcessorSpeedMHz: Cardinal;
begin
       Result := TDTComputerInfo.ProcessorSpeedMHz
end;

function TDTSysinfo.ProductName: string;
begin
     try
         try
             Result := TDTOSInfo.ProductName;
         except
             Result := 'NO';
         end;
     finally

     end;
end;

function TDTSysinfo.ProxyAtivo: Boolean;
var
  FRegistro: TRegistry;
begin
  FRegistro := nil;
  try
    FRegistro := TRegistry.Create;
    FRegistro.RootKey := HKEY_CURRENT_USER;
    FRegistro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings',False);
    Result := FRegistro.ReadBool('ProxyEnable');
  finally
    FRegistro.Free;
  end;
end;

procedure TDTSysinfo.ResetMemory(out P; Size: Longint);
begin
  if Size > 0 then
  begin
    Byte(P) := 0;
    FillChar(P, Size, 0);
  end;
end;

procedure TDTSysinfo.SetArmazenamentoHD(const Value: TArmazenamento);
begin
  FArmazenamentoHD := Value;
end;

procedure TDTSysinfo.SetFHDRecomendado(const Value: STRING);
begin
  FFHDRecomendado := Value;
end;

procedure TDTSysinfo.SetiArmazenamentoEmUso(const Value: real);
begin
  FiArmazenamentoEmUso := Value;
end;

procedure TDTSysinfo.SetiArmazenamentoLivre(const Value: real);
begin
  FiArmazenamentoLivre := Value;
end;

procedure TDTSysinfo.SetiArmazenamentoTotal(const Value: real);
begin
  FiArmazenamentoTotal := Value;
end;

procedure TDTSysinfo.SetiMemoriaEmUso(const Value: real);
begin
  FiMemoriaEmUso := Value;
end;

procedure TDTSysinfo.SetiMemoriaLivre(const Value: real);
begin
  FiMemoriaLivre := Value;
end;

procedure TDTSysinfo.SetiMemoriaTotal(const Value: real);
begin
  FiMemoriaTotal := Value;
end;

procedure TDTSysinfo.SetiTipoArmazenamento(const Value: Integer);
begin
  FiTipoArmazenamento := Value;
end;

procedure TDTSysinfo.SetiTipoConexao(const Value: integer);
begin
  FiTipoConexao := Value;
end;

procedure TDTSysinfo.SetModeloDiscoPrincipal(const Value: string);
begin
  FModeloDiscoPrincipal := Value;
end;

procedure TDTSysinfo.SetNumSerieDiscoPrincipal(const Value: string);
begin
  FNumSerieDiscoPrincipal := Value;
end;

function TDTSysinfo.SystemManufacturer: string;
begin
       Result := TDTComputerInfo.SystemManufacturer
end;

function TDTSysinfo.SystemProductName: string;
begin
       Result := TDTComputerInfo.SystemProductName;
end;

function TDTSysinfo.TipoArmazenamento: Integer;
function VarToInt(const AVariant: Variant): INT64;
begin
   Result := StrToIntDef(Trim(VarToStr(AVariant)), 0);
end;

const
   WbemUser = ''; WbemPassword = ''; WbemComputer = 'localhost';
   wbemFlagForwardOnly = $00000020;
var
   FSWbemLocator, FWMIService, FWbemObjectSet, FWbemObject, FWMIDiskDrive : OLEVariant;
   oEnum: IEnumvariant;
   iValue: LongWord;
   Modelo, _Interface, PNPDeviceID: string;
begin
   // Valor padrão caso nada seja detectado
   Result := _HDD;

   try
      // Primeiro verifica se é um dispositivo NVMe pelo PNP Device ID
      FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
      FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
      FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_DiskDrive WHERE Index = 0');
      oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;

      if oEnum.Next(1, FWbemObject, iValue) = 0 then
      begin
         // Verifica o PNPDeviceID pelo qual podemos detectar definitivamente um NVMe
         if not VarIsNull(FWbemObject.PNPDeviceID) then
         begin
            PNPDeviceID := UpperCase(Trim(FWbemObject.PNPDeviceID));
            if (Pos('NVME', PNPDeviceID) > 0) then
            begin
               Result := _NVME;
               Exit; // Se encontrou NVMe no PNPDeviceID, encerra
            end;
         end;

         // Verifica pelo modelo e interface
         if not VarIsNull(FWbemObject.Model) then
            Modelo := UpperCase(Trim(FWbemObject.Model));

         if not VarIsNull(FWbemObject.InterfaceType) then
            _Interface := UpperCase(Trim(FWbemObject.InterfaceType));

         // Determina o tipo baseado no modelo e interface
         if (Pos('NVME', Modelo) > 0) or (Pos('PCIE', _Interface) > 0) then
            Result := _NVME
         else if (Pos('SSD', Modelo) > 0) then
            Result := _SSD;
      end;
   except
      // Se falhou no método anterior, tenta o Storage API
   end;

   // Se ainda não identificou definitivamente, tenta pela API Storage
   if Result = _HDD then
   try
      FWMIService := FSWbemLocator.ConnectServer(WbemComputer, 'root\Microsoft\Windows\Storage', WbemUser, WbemPassword);
      FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM MSFT_PhysicalDisk WHERE DeviceID = 0','WQL',wbemFlagForwardOnly);
      oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;

      if oEnum.Next(1, FWbemObject, iValue) = 0 then
      begin
         if not VarIsNull(FWbemObject.MediaType) then
         begin
            Result := VarToInt(FWbemObject.MediaType);
            if Result = 0 then
               Result := _HDD; // Se não conseguiu determinar, assume HDD
         end;

         // Verifica se é um BusType PCIe, que geralmente indica NVMe
         if (Result <> _NVME) and (not VarIsNull(FWbemObject.BusType)) then
         begin
            // BusType 17 é PCIe, que geralmente indica NVMe
            if VarToInt(FWbemObject.BusType) = 17 then
               Result := _NVME;
         end;
      end;
   except
      // Se falhou, mantém o resultado atual
   end;
end;
function TDTSysinfo.TipoArmazenamentoDescricao(const ATipo: Integer): string;
begin
   case ATipo of
       3: Result := 'HDD';
       4: Result := 'SSD';
       5: Result := 'NVMe';
    else
       Result := 'N/A';
    end;

end;

function TDTSysinfo.TipoConexao: Integer;
const
  wbemFlagForwardOnly = $00000020;
  STATUS_CONNECTED    = 02;
  TYPE_UNKNOWN  = 0;
  TYPE_ETHERNET = 1;
  TYPE_WIFI     = 2;
  TYPE_VIRTUAL  = 3;
var
  FSWbemLocator, FWMIService, FWbemObjectSet, FWbemObject : OLEVariant;
  oEnum : IEnumvariant;
  iValue: LongWord;
begin;
   Result := TYPE_UNKNOWN;
   FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
   try
      FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
      FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapter','WQL',wbemFlagForwardOnly);
      oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
      while (oEnum.Next(1, FWbemObject, iValue) = 0) and (Result = 0) do
      begin
         if not VarIsNull(FWbemObject.NetConnectionStatus) Then
         begin
            if FWbemObject.NetConnectionStatus = 02 then
            begin
                if Pos('ETHERNET', UpperCase( String(FWbemObject.NetConnectionID) ) ) > 0 then
                  Result := TYPE_ETHERNET
                else if Pos('WI-FI', UpperCase( String(FWbemObject.NetConnectionID) ) ) > 0 then
                  Result := TYPE_WIFI
                else if Pos('VIRTUAL', UpperCase( String(FWbemObject.NetConnectionID) ) ) > 0 then
                  Result := TYPE_VIRTUAL
            end;
         end;
         FWbemObject :=  Unassigned;
      end;
   finally
      FSWbemLocator  := Unassigned;
      FWMIService    := Unassigned;
      FWbemObjectSet := Unassigned;
      FWbemObject    := Unassigned;
   end;
end;

function TDTSysinfo.TPConexao: string;
begin
       Result := TIPOS_CONEXAO[TipoConexao];
end;

function TDTSysinfo.UserName: string;
begin
       Result := TDTComputerInfo.UserName;
end;

function TDTSysinfo.UsuarioLogado: string;
var
  nsize: Cardinal;
  UserName: string;
begin
  nsize := 255;
  SetLength(UserName,nsize);
  if GetUserName(PChar(UserName), nsize) then
  begin
    SetLength(UserName,nsize-1);
    Result := UserName;
  end;
end;

end.
