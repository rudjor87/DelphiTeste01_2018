unit uCadProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, Classe.Produto;

type
  TfrmCadProduto = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtProdCodigo: TEdit;
    edtProdNome: TEdit;
    edtProdValor: TEdit;
    pnlComandos: TPanel;
    spdBtnIncluir: TSpeedButton;
    spdBtnAlterar: TSpeedButton;
    spdBtnExcluir: TSpeedButton;
    spdBtnSalvar: TSpeedButton;
    spdBtnCancelar: TSpeedButton;
    spdBtnFechar: TSpeedButton;
    cmbProdMoeda: TComboBox;
    Label4: TLabel;
    dbNvgCadProduto: TDBNavigator;
    procedure spdBtnIncluirClick(Sender: TObject);
    procedure spdBtnAlterarClick(Sender: TObject);
    procedure spdBtnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spdBtnCancelarClick(Sender: TObject);
    procedure spdBtnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtProdValorExit(Sender: TObject);
    procedure spdBtnExcluirClick(Sender: TObject);
    procedure dbNvgCadProdutoClick(Sender: TObject; Button: TNavigateBtn);
    procedure edtProdValorEnter(Sender: TObject);
  private
    { Private declarations }

    chrStTela: char;
    intProdCodigoEdicao: Integer;
    ProdCadastro: TProduto;

    procedure SetLimpaTela;

  public
    { Public declarations }

    { Descri��o..: Configura Situ��o da Tela
      Autor......: Rudnei C�sar Jord�o
      Dt. Cria��o: 21/07/2018
      Par�metros.:
      - strStTela >> I = Inclus�o; A = Altera��o; e V = Visualiza��o }
    procedure SetSituacaoTela(chrSituacao: char);

    { Descri��o..: Carrega Produto Cadastrado
      Autor......: Rudnei C�sar Jord�o
      Dt. Cria��o: 21/07/2018
      Par�metros.:
      - intProdCodigo >> C�digo do Produto }
    procedure SetProdCadastro(intProdCodigo: integer);

  end;

var
  frmCadProduto: TfrmCadProduto;

implementation

uses
  uPrincipal, uFuncoesTela;

{$R *.dfm}

procedure TfrmCadProduto.dbNvgCadProdutoClick(Sender: TObject;
  Button: TNavigateBtn);
begin
  if frmPrincipal.qProduto.RecNo = 1 then
  begin
    frmPrincipal.qProduto.First;
  end;

  if frmPrincipal.qProduto.RecNo = frmPrincipal.qProduto.RecordCount then
  begin
    frmPrincipal.qProduto.Last;
  end;

  SetProdCadastro(frmPrincipal.qProdutoPROD_CODIGO.AsInteger);
end;

procedure TfrmCadProduto.edtProdValorEnter(Sender: TObject);
begin
  if edtProdValor.Text <> '' then
  begin
    edtProdValor.Text := GetVlMonetarioLimpo(edtProdValor.Text);
    edtProdValor.SelectAll;
  end;
end;

procedure TfrmCadProduto.edtProdValorExit(Sender: TObject);
var
  strProdValor: string;
  dblProdValor: Double;
begin
  strProdValor := GetVlMonetarioLimpo(edtProdValor.Text);

  if strProdValor <> '' then
  begin
    dblProdValor := 0;

    try
      dblProdValor := StrToFloat(strProdValor);
    except
      ShowMessage('Valor do Produto inv�lido.');
      edtProdValor.SetFocus;
      Abort;
    end;

    edtProdValor.Text := GetVlMonetarioFormatado(dblProdValor);
  end;
end;

procedure TfrmCadProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (chrStTela = 'I') or (chrStTela = 'A') then
  begin
    ShowMessage('Cadastro em edi��o.');
    Abort;
  end;
end;

procedure TfrmCadProduto.FormCreate(Sender: TObject);
begin
  SetSituacaoTela(' ');

  intProdCodigoEdicao := 0;
end;

procedure TfrmCadProduto.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    if (chrStTela = 'I') or (chrStTela = 'A') then
    begin
      spdBtnCancelar.OnClick(spdBtnCancelar);
    end
    else
    begin
      spdBtnFechar.OnClick(spdBtnFechar);
    end;
  end;

  if (chrStTela = 'I') or (chrStTela = 'A') then
  begin
    if (Key = #13) then
    begin
      spdBtnSalvar.OnClick(spdBtnSalvar);
    end;

  end;
end;

procedure TfrmCadProduto.SetLimpaTela;
begin
  edtProdCodigo.Clear;
  edtProdNome.Clear;
  edtProdValor.Clear;
end;

procedure TfrmCadProduto.spdBtnIncluirClick(Sender: TObject);
begin
  SetLimpaTela;

  SetSituacaoTela('I');
end;

procedure TfrmCadProduto.spdBtnSalvarClick(Sender: TObject);
var
  strDmlSql, strDsAcao: string;
begin
  pnlComandos.SetFocus;
  if not pnlComandos.Focused then
  begin
    Abort;
  end;

  case chrStTela of
    'I': strDsAcao := 'Inclus�o';
    'A': strDsAcao := 'Altera��o';
  end;

  ProdCadastro := TProduto.Create;
  try
    ProdCadastro.SetProdCodigoValidado(edtProdCodigo.Text);

    if chrStTela = 'I' then
    begin
      strDmlSql := 'SELECT PROD_CODIGO FROM PRODUTO ';
      strDmlSql := strDmlSql + 'WHERE PROD_CODIGO = ' + IntToStr(ProdCadastro.ProdCodigo);

      frmPrincipal.ZQuery1.SQL.Clear;
      frmPrincipal.ZQuery1.SQL.Add(strDmlSql);

      try
        frmPrincipal.ZQuery1.Open;
      except
        on e: Exception do
        begin
          ShowMessage('N�o foi poss�vel verificar se o C�digo do Produto j� existe. Motivo ' + e.Message);
          Abort;
        end;
      end;

      try
        if frmPrincipal.ZQuery1.RecordCount > 0 then
        begin
          ShowMessage('C�digo do Produto j� utilizado.');
          Abort;
        end;
      finally
        frmPrincipal.ZQuery1.Close;
      end;
    end;

    ProdCadastro.ProdNome := edtProdNome.Text;
    ProdCadastro.ProdMoeda := (cmbProdMoeda.ItemIndex + 1);
    ProdCadastro.SetProdValorValidado(edtProdValor.Text);

    if (chrStTela = 'I') then
    begin
      strDmlSql := 'INSERT INTO PRODUTO (PROD_CODIGO, PROD_NOME, PROD_MOEDA, PROD_VALOR) VALUES';
      strDmlSql := strDmlSql + ' (' + IntToStr(ProdCadastro.ProdCodigo);
      strDmlSql := strDmlSql + ', ' + QuotedStr(ProdCadastro.ProdNome);
      strDmlSql := strDmlSql + ', ' + IntToStr(ProdCadastro.ProdMoeda);
      strDmlSql := strDmlSql + ', ' + StringReplace(FloatToStr(ProdCadastro.ProdValor), ',', '.', [rfReplaceAll]);
      strDmlSql := strDmlSql + ')';
    end
    else
    begin
      strDmlSql := 'UPDATE PRODUTO SET PROD_NOME = ' + QuotedStr(ProdCadastro.ProdNome);
      strDmlSql := strDmlSql + ', PROD_MOEDA = ' + IntToStr(ProdCadastro.ProdMoeda);
      strDmlSql := strDmlSql + ', PROD_VALOR = ' + StringReplace(FloatToStr(ProdCadastro.ProdValor), ',', '.', [rfReplaceAll]);
      strDmlSql := strDmlSql + 'WHERE PROD_CODIGO = ' + IntToStr(ProdCadastro.ProdCodigo);
    end;

    frmPrincipal.ZQuery1.SQL.Clear;
    frmPrincipal.ZQuery1.SQL.Add(strDmlSql);

    try
      frmPrincipal.ZQuery1.ExecSQL;
    except
      on e: Exception do
      begin
        ShowMessage(strDsAcao + ' n�o realizada. ' + sLineBreak  + sLineBreak + 'Motivo: ' + e.Message);
        Abort;
      end;
    end;

    intProdCodigoEdicao := ProdCadastro.ProdCodigo;
  finally
    ProdCadastro.Free;
  end;

  ShowMessage(strDsAcao + ' realizada com sucesso.');

  frmPrincipal.qProduto.Refresh;

  SetProdCadastro(intProdCodigoEdicao);
end;

procedure TfrmCadProduto.spdBtnAlterarClick(Sender: TObject);
begin
  SetSituacaoTela('A');
end;

procedure TfrmCadProduto.spdBtnCancelarClick(Sender: TObject);
begin
  if (intProdCodigoEdicao = 0) then
  begin
    if frmPrincipal.qProduto.RecordCount > 0 then
    begin
      frmPrincipal.qProduto.First;

      SetProdCadastro(frmPrincipal.qProdutoPROD_CODIGO.AsInteger);
    end
    else
    begin
      SetLimpaTela;
    end;
  end
  else
  begin
    SetProdCadastro(intProdCodigoEdicao);
  end;

  SetSituacaoTela('V');
end;

procedure TfrmCadProduto.spdBtnExcluirClick(Sender: TObject);
var
  strDmlSql: string;
begin
  if (chrStTela = 'I') or (chrStTela = 'A') then
  begin
    ShowMessage('Cadastro em edi��o.');
    Abort;
  end;

  if intProdCodigoEdicao = 0 then
  begin
    ShowMessage('Nenhum Produto para excluir.');
    Abort;
  end;

  if Application.MessageBox('Deseja realmente excluir o cadastro?', 'Confirma��o', MB_YESNO) = mrNo then
  begin
    Abort;
  end;

  strDmlSql := 'DELETE FROM PRODUTO WHERE PROD_CODIGO = ' + IntToStr(intProdCodigoEdicao);

  frmPrincipal.ZQuery1.SQL.Clear;
  frmPrincipal.ZQuery1.SQL.Add(strDmlSql);

  try
    frmPrincipal.ZQuery1.ExecSQL;
  except
    on e: Exception do
    begin
      ShowMessage('Exclus�o n�o realizada. Motivo: ' + e.Message);
      Abort;
    end;
  end;

  ShowMessage('Exclus�o realizada com sucesso.');

  frmPrincipal.qProduto.Refresh;

  if frmPrincipal.qProduto.RecordCount > 0 then
  begin
    SetProdCadastro(frmPrincipal.qProdutoPROD_CODIGO.AsInteger);
  end
  else
  begin
    SetSituacaoTela(' ');

    intProdCodigoEdicao := 0;
  end;
end;

procedure TfrmCadProduto.spdBtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadProduto.SetSituacaoTela(chrSituacao: char);
begin
  chrStTela := chrSituacao;

  SetHabilitaComponente(edtProdCodigo, False);
  SetHabilitaComponente(edtProdNome, False);
  SetHabilitaComponente(cmbProdMoeda, False);
  SetHabilitaComponente(edtProdValor, False);

  spdBtnIncluir.Enabled := False;
  spdBtnAlterar.Enabled := False;
  spdBtnExcluir.Enabled := False;

  dbNvgCadProduto.Enabled := True;

  spdBtnSalvar.Enabled := False;
  spdBtnCancelar.Enabled := False;

  spdBtnFechar.Enabled := True;

  if (chrStTela = 'I') or (chrStTela = 'A') then
  begin
    //Inclus�o ou Altera��o
    if chrStTela = 'I' then
    begin
      SetHabilitaComponente(edtProdCodigo, True);
    end;

    SetHabilitaComponente(edtProdNome, True);
    SetHabilitaComponente(cmbProdMoeda, True);
    SetHabilitaComponente(edtProdValor, True);

    dbNvgCadProduto.Enabled := False;

    spdBtnSalvar.Enabled := True;
    spdBtnCancelar.Enabled := True;

    spdBtnFechar.Enabled := False;
  end
  else if (chrStTela = 'V') then
  begin
    //Visualiza��o
    spdBtnIncluir.Enabled := True;
    spdBtnAlterar.Enabled := True;
    spdBtnExcluir.Enabled := True;
  end;

  if Self.Active and ((chrStTela = 'I') or (chrStTela = 'A'))then
  begin
    if not edtProdCodigo.ReadOnly then
    begin
      edtProdCodigo.SetFocus;
    end
    else
    begin
      edtProdNome.SetFocus;
    end;
  end;
end;

procedure TfrmCadProduto.SetProdCadastro(intProdCodigo: integer);
begin
  ProdCadastro := TProduto.Create;
  try
    ProdCadastro.GetProduto(intProdCodigo);

    edtProdCodigo.Text := IntToStr(ProdCadastro.ProdCodigo);
    edtProdNome.Text := ProdCadastro.ProdNome;
    edtProdValor.Text := GetVlMonetarioFormatado(ProdCadastro.ProdValor);
  finally
    ProdCadastro.Free;
  end;

  intProdCodigoEdicao := intProdCodigo;

  SetSituacaoTela('V');
end;

end.
