object frmPesquisa: TfrmPesquisa
  Left = 0
  Top = 0
  Caption = 'Pesquisa'
  ClientHeight = 355
  ClientWidth = 586
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 586
    Height = 76
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 755
    object Label6: TLabel
      Left = 23
      Top = 13
      Width = 85
      Height = 13
      Caption = 'PESQUISAR POR:'
    end
    object btnPesquisa: TSpeedButton
      Left = 487
      Top = 32
      Width = 78
      Height = 26
      Caption = 'Pesquisar'
      NumGlyphs = 2
    end
    object mednme_pesquisa: TMaskEdit
      Left = 23
      Top = 33
      Width = 458
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = ''
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 76
    Width = 586
    Height = 238
    Align = alClient
    TabOrder = 1
    ExplicitTop = 92
    ExplicitWidth = 755
    ExplicitHeight = 222
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 584
      Height = 236
      Align = alClient
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 314
    Width = 586
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 272
    ExplicitTop = 192
    ExplicitWidth = 185
    object BitBtn1: TBitBtn
      Left = 373
      Top = 6
      Width = 90
      Height = 25
      Caption = 'Confirmar'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 475
      Top = 6
      Width = 90
      Height = 25
      Caption = '&Fechar'
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 164
    Top = 124
  end
  object DataSource1: TDataSource
    Left = 164
    Top = 176
  end
end
