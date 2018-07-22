unit Classe.Produto;

interface

uses
  System.SysUtils, Vcl.Dialogs;

type

  TProduto = class
    private
      FProdCodigo: Integer;
      FProdNome: string;
      FProdValor: Double;

      function GetProdCodigo: Integer;
      procedure SetProdCodigo(intProdCodigo: Integer); overload;

      function GetProdNome: string;
      procedure SetProdNome(strProdNome: string);

      function GetProdValor: Double;
      procedure SetProdValor(dblProdValor: Double);
    public
      ProdMoeda: Integer;

      property ProdCodigo: integer read GetProdCodigo write SetProdCodigo;
      property ProdNome: string read GetProdNome write SetProdNome;
      property ProdValor: Double read GetProdValor write SetProdValor;

      procedure SetProdCodigoValidado(strProdCodigo: string);

      procedure SetProdValorValidado(strProdValor: string);

      procedure GetProduto(intProdCodigo: integer);
  end;

implementation

uses
  uPrincipal, uFuncoesTela;

{ TProduto }

procedure TProduto.GetProduto(intProdCodigo: integer);
var
  strDmlSql: string;
begin
  strDmlSql := 'SELECT PROD_CODIGO, PROD_NOME, PROD_VALOR FROM PRODUTO ';
  strDmlSql := strDmlSql + 'WHERE PROD_CODIGO = ' + IntToStr(intProdCodigo);

  frmPrincipal.ZQuery1.SQL.Clear;
  frmPrincipal.ZQuery1.SQL.Add(strDmlSql);

  try
    frmPrincipal.ZQuery1.Open;
  except
    on e: Exception do
    begin
      ShowMessage('Produto n�o carregado. Motivo: ' + e.Message);
      Abort;
    end;
  end;

  try
    if frmPrincipal.ZQuery1.RecordCount = 0 then
    begin
      ShowMessage('Produto n�o encontrado.');
      Abort;
    end;

    ProdCodigo := frmPrincipal.ZQuery1.FieldByName('PROD_CODIGO').AsInteger;
    ProdNome := frmPrincipal.ZQuery1.FieldByName('PROD_NOME').AsString;
    ProdValor := frmPrincipal.ZQuery1.FieldByName('PROD_VALOR').AsFloat;
  finally
    frmPrincipal.ZQuery1.Close;
  end;
end;

function TProduto.GetProdCodigo: Integer;
begin
  Result := FProdCodigo;
end;

procedure TProduto.SetProdCodigo(intProdCodigo: Integer);
begin
  if intProdCodigo <= 0 then
  begin
    ShowMessage('C�digo do Produto deve ser superior � zero.');
    Abort;
  end;

  FProdCodigo := intProdCodigo;
end;

procedure TProduto.SetProdCodigoValidado(strProdCodigo: string);
var
  strValor: string;
  intValor: Integer;
begin
  strValor := Trim(strProdCodigo);
  intValor := 0;

  if Trim(strValor) = '' then
  begin
    ShowMessage('C�digo do Produto n�o informado.');
    Abort;
  end;

  try
    intValor := StrToInt(strValor);
  except
    ShowMessage('C�digo do Produto inv�lido.');
    Abort;
  end;

  ProdCodigo := intValor;
end;

function TProduto.GetProdNome: string;
begin
  Result := FProdNome;
end;

procedure TProduto.SetProdNome(strProdNome: string);
var
  strValor: string;
begin
  strValor := Trim(strProdNome);

  if strValor = '' then
  begin
    ShowMessage('Nome do Produto n�o informado.');
    Abort;
  end;

  FProdNome := strProdNome;
end;

function TProduto.GetProdValor: Double;
begin
  Result := FProdValor;
end;

procedure TProduto.SetProdValor(dblProdValor: Double);
begin
  if dblProdValor <= 0 then
  begin
    ShowMessage('Valor do Produto deve ser superior � zero.');
    Abort;
  end;

  FProdValor := dblProdValor;
end;

procedure TProduto.SetProdValorValidado(strProdValor: string);
var
  strValor: string;
  intValor: Double;
begin
  strValor := GetVlMonetarioLimpo(strProdValor);
  intValor := 0;

  if Trim(strValor) = '' then
  begin
    ShowMessage('Valor do Produto n�o informado.');
    Abort;
  end;

  try
    intValor := StrToFloat(strValor);
  except
    ShowMessage('Valor do Produto inv�lido.');
    Abort;
  end;

  ProdValor := intValor;
end;

end.
