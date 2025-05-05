unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DTSysInfo;

type
  TForm7 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    DTSysinfo1: TDTSysinfo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
  Memo1.Lines.add('=============================================');
  Memo1.Lines.add('Computer Name: ' + DTSysinfo1.GetComputerName);
  Memo1.Lines.add('Description: ' + DTSysinfo1.ProductName);
  Memo1.Lines.add('User Name: ' + DTSysinfo1.UserName);
  Memo1.Lines.add('MAC Address: ' + DTSysinfo1.MACAddress);
  Memo1.Lines.add('Processor Count: ' + Integer(DTSysinfo1.ProcessorCount).ToString);
 // Memo1.Lines.add('Processor Architecture: ' + cProcessors[DTSysinfo1.Processor]);
  Memo1.Lines.add('Processor Identifier: ' + DTSysinfo1.ProcessorIdentifier);
  Memo1.Lines.add('Processor Name: ' + DTSysinfo1.ProcessorName);
  Memo1.Lines.add('Processor Speed (MHz): ' + DTSysinfo1.ProcessorSpeedMHz.ToString);
  Memo1.Lines.add('Is 64 Bit?: ' + BoolToStr( DTSysinfo1.Is64Bit ));
  Memo1.Lines.add('Is Network Present?: ' + BoolToStr( DTSysinfo1.IsNetworkPresent ));
 // Memo1.Lines.add('Boot Mode: ' + cBootModes[DTSysinfo1.BootMode]);
  Memo1.Lines.add('Is Administrator?: ' + BoolToStr( DTSysinfo1.IsAdmin) );
  Memo1.Lines.add('Is UAC active?: ' + BoolToStr( DTSysinfo1.IsUACActive));
  Memo1.Lines.add('BIOS Vender: ' + DTSysinfo1.BiosVendor);
  Memo1.Lines.add('System Manufacturer: ' + DTSysinfo1.SystemManufacturer);
  Memo1.Lines.add('System Product Name: ' + DTSysinfo1.SystemProductName);
  Memo1.Lines.add('=============================================');
  DTSysinfo1.Armazenamento;
  Memo1.Lines.Add('Tipo de HD: '         + DTSysinfo1.ArmazenamentoHD.Tipo);
  Memo1.Lines.Add('Espaço Total: '       + DTSysinfo1.ArmazenamentoHD.Total);
  Memo1.Lines.Add('Espaço Livre: '       + DTSysinfo1.ArmazenamentoHD.Livre);
  Memo1.Lines.Add('Espaço Usado: '       + DTSysinfo1.ArmazenamentoHD.EmUso);
  Memo1.Lines.Add('Memoria RAM Total: '  + FormatFloat('#0.00 GB', DTSysinfo1.GetTotalPhysicalMemory ));
  Memo1.Lines.Add('Memoria RAM Livre: '  + FormatFloat('#0.00 GB', DTSysinfo1.GetFreePhysicalMemory ));
  Memo1.Lines.Add('Memoria RAM Em Uso: ' + FormatFloat('#0.00 GB',( DTSysinfo1.GetTotalPhysicalMemory - DTSysinfo1.GetFreePhysicalMemory )));
  if DTSysinfo1.proxyativo then
      Memo1.Lines.Add('Proxy Ativo: SIM')
  else
      Memo1.Lines.Add('Proxy Ativo: NAO');
  Memo1.Lines.Add('Tipo de Conexao : ' + DTSysinfo1.TPConexao);
  Memo1.Lines.Add('IP Local: '         + DTSysinfo1.GetLocalIP);
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
       Memo1.Lines.Clear;
end;

end.
