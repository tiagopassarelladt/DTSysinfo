object Form7: TForm7
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Demo - DTSysinfo'
  ClientHeight = 611
  ClientWidth = 669
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 653
    Height = 564
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 504
    Top = 578
    Width = 157
    Height = 25
    Cursor = crHandPoint
    Caption = 'Obtem informa'#231#245'es do PC'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DTSysinfo1: TDTSysinfo
    iTipoArmazenamento = 0
    iTipoConexao = 0
    Left = 336
    Top = 216
  end
end
