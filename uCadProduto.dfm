object frmCadProduto: TfrmCadProduto
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produto'
  ClientHeight = 296
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  DesignSize = (
    720
    296)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 33
    Height = 13
    Caption = 'C'#243'digo'
  end
  object Label2: TLabel
    Left = 88
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Produto'
  end
  object Label3: TLabel
    Left = 583
    Top = 8
    Width = 24
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Valor'
    ExplicitLeft = 584
  end
  object Label4: TLabel
    Left = 473
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Moeda'
  end
  object edtProdCodigo: TEdit
    Left = 8
    Top = 27
    Width = 74
    Height = 21
    TabOrder = 0
  end
  object edtProdNome: TEdit
    Left = 88
    Top = 27
    Width = 378
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 379
  end
  object edtProdValor: TEdit
    Left = 583
    Top = 27
    Width = 129
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 3
    OnEnter = edtProdValorEnter
    OnExit = edtProdValorExit
    ExplicitLeft = 584
  end
  object pnlComandos: TPanel
    Left = 0
    Top = 240
    Width = 720
    Height = 56
    Align = alBottom
    TabOrder = 4
    ExplicitWidth = 721
    DesignSize = (
      720
      56)
    object spdBtnIncluir: TSpeedButton
      Left = 0
      Top = 0
      Width = 57
      Height = 57
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Incluir'
      OnClick = spdBtnIncluirClick
    end
    object spdBtnAlterar: TSpeedButton
      Left = 56
      Top = 0
      Width = 57
      Height = 57
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Alterar'
      OnClick = spdBtnAlterarClick
    end
    object spdBtnExcluir: TSpeedButton
      Left = 112
      Top = 0
      Width = 57
      Height = 57
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Excluir'
      OnClick = spdBtnExcluirClick
    end
    object spdBtnSalvar: TSpeedButton
      Left = 353
      Top = 0
      Width = 57
      Height = 57
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Salvar'
      OnClick = spdBtnSalvarClick
    end
    object spdBtnCancelar: TSpeedButton
      Left = 409
      Top = 0
      Width = 57
      Height = 57
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Cancelar'
      OnClick = spdBtnCancelarClick
    end
    object spdBtnFechar: TSpeedButton
      Left = 663
      Top = 0
      Width = 57
      Height = 57
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Fechar'
      OnClick = spdBtnFecharClick
      ExplicitLeft = 664
    end
    object dbNvgCadProduto: TDBNavigator
      Left = 202
      Top = 16
      Width = 116
      Height = 25
      DataSource = frmPrincipal.dsProduto
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      OnClick = dbNvgCadProdutoClick
    end
  end
  object cmbProdMoeda: TComboBox
    Left = 473
    Top = 27
    Width = 105
    Height = 21
    AutoDropDown = True
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = 'Real (R$)'
    Items.Strings = (
      'Real (R$)')
  end
end
