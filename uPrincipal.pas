unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ZAbstractConnection, ZConnection,
  Vcl.StdCtrls, Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  Vcl.Menus, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmPrincipal = class(TForm)
    Conexao: TZConnection;
    qProduto: TZQuery;
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Produto1: TMenuItem;
    dsProduto: TDataSource;
    ZQuery1: TZQuery;
    qProdutoPROD_CODIGO: TIntegerField;
    qProdutoPROD_NOME: TWideStringField;
    qProdutoPROD_VALOR: TFloatField;
    pnlComandos: TPanel;
    spdBtnFechar: TSpeedButton;
    qProdutoPROD_MOEDA_DESCRICAO: TWideStringField;
    grbAtalhos: TGroupBox;
    spdIncluirProduto: TSpeedButton;
    GrbProdutosCadastrados: TGroupBox;
    dbGrdProdutosCadastrados: TDBGrid;
    grbInformacoes: TGroupBox;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure dbGrdProdutosCadastradosDblClick(Sender: TObject);
    procedure spdBtnFecharClick(Sender: TObject);
    procedure spdIncluirProdutoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uCadProduto;

{$R *.dfm}

procedure TfrmPrincipal.dbGrdProdutosCadastradosDblClick(Sender: TObject);
begin
  if (not (qProduto.Active) or (qProduto.RecordCount = 0)) then
  begin
    Exit;
  end;

  frmCadProduto := nil;
  frmCadProduto := TfrmCadProduto.Create(frmCadProduto);
  try
    frmCadProduto.SetProdCadastro(qProdutoPROD_CODIGO.AsInteger);

    frmCadProduto.ShowModal;
  finally
    FreeAndNil(frmCadProduto);
  end;

  if qProduto.Active then
  begin
    qProduto.Refresh;
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Conexao.Disconnect;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  cCaminho_e_Base: string;
begin
  cCaminho_e_Base := 'C:\Desenvolvimento\Estoque\Base de Dados\Estoque.fdb';

  Memo1.Lines.Clear;

  Memo1.Lines.Add('Verificando a Base de Dados...');

  Conexao.Protocol := 'firebird-2.5';
  Conexao.LibraryLocation := 'fbclient.dll';
  Conexao.Database := cCaminho_e_Base;

  if not FileExists(cCaminho_e_Base) then
  begin
    Memo1.Lines.Add('Criando Base de Dados...');

    if not DirectoryExists(ExtractFilePath(cCaminho_e_Base)) then
    begin
      ForceDirectories(ExtractFilePath(cCaminho_e_Base));

      if not DirectoryExists(ExtractFilePath(cCaminho_e_Base)) then
      begin
        Memo1.Lines.Add('falha ao criar a diretório da Base de Dados: ' + ExtractFilePath(cCaminho_e_Base));
        Abort;
      end;
    end;

    Conexao.Properties.Clear;
    Conexao.Properties.Values['dialect'] := '3';
    Conexao.Properties.Values['CreateNewDataBase'] := 'CREATE DATABASE ' + QuotedStr(Conexao.Database) +
      ' USER ' + QuotedStr('SYSDBA') + ' PASSWORD ' + QuotedStr('masterkey') +
      ' PAGE_SIZE 4096 DEFAULT CHARACTER SET ISO8859_1';

    Conexao.User := 'SYSDBA';
    Conexao.Password := 'masterkey';

    Conexao.Connect;

    if FileExists(cCaminho_e_Base) then
    begin
      Conexao.Disconnect;

      Memo1.Lines.Add('Base de Dados criada com sucesso.');

      Memo1.Lines.Add('Conectando a Base de Dados...');

      Conexao.Protocol := 'firebird-2.5';
      Conexao.LibraryLocation := 'fbclient.dll';
      Conexao.Database := cCaminho_e_Base;
      Conexao.HostName := 'localhost';

      Conexao.Properties.Clear;

      Conexao.User := 'SYSDBA';
      Conexao.Password := 'masterkey';

      Conexao.Connect;

      //SQL para criar a tabela de Produtos
      Memo1.Lines.Add('Criando da tabela de Produtos...');
      ZQuery1.Close;
      ZQuery1.Connection := Conexao;
      ZQuery1.SQL.Clear;
      ZQuery1.SQL.Add('CREATE TABLE PRODUTO(');
      ZQuery1.SQL.Add('PROD_CODIGO INTEGER NOT NULL,');
      ZQuery1.SQL.Add('PROD_NOME VARCHAR(30) NOT NULL,');
      ZQuery1.SQL.Add('PROD_MOEDA INTEGER NOT NULL,');
      ZQuery1.SQL.Add('PROD_VALOR NUMERIC(7,2) NOT NULL,');
      ZQuery1.SQL.Add('PRIMARY KEY (PROD_CODIGO)');
      ZQuery1.SQL.Add(');');
      ZQuery1.Prepare;
      ZQuery1.ExecSQL;

      Memo1.Lines.Add('Tabela de Produtos criada com sucesso.');
    end
    else
    begin
      Memo1.Lines.Add('falha ao criar a Base de Dados.');
      Abort;
    end;
  end
  else
  begin
    Memo1.Lines.Add('Abrindo Base de Dados...');

    Conexao.Connect;

    Memo1.Lines.Add('Conexação com a Base de Dados estabelecida com sucesso.');
  end;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Aplicação pronta para uso.');

  try
    qProduto.Close;
    qProduto.Open;
  except
    on e: Exception do
    begin
      ShowMessage('Não foi possível carregar os Produtos Cadastrado. Motivo: ' + e.Message);
      Abort;
    end;
  end;
end;

procedure TfrmPrincipal.Produto1Click(Sender: TObject);
begin
  frmCadProduto := nil;
  frmCadProduto := TfrmCadProduto.Create(frmCadProduto);
  try
    if (not (qProduto.Active) or (qProduto.RecordCount = 0)) then
    begin
      frmCadProduto.SetSituacaoTela('I');
    end
    else
    begin
      qProduto.First;

      frmCadProduto.SetProdCadastro(qProdutoPROD_CODIGO.AsInteger);
    end;

    frmCadProduto.ShowModal;
  finally
    FreeAndNil(frmCadProduto);
  end;

  if qProduto.Active then
  begin
    qProduto.Refresh;
  end;
end;

procedure TfrmPrincipal.spdBtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.spdIncluirProdutoClick(Sender: TObject);
begin
  frmCadProduto := nil;
  frmCadProduto := TfrmCadProduto.Create(frmCadProduto);
  try
    frmCadProduto.SetSituacaoTela('I');

    frmCadProduto.ShowModal;
  finally
    FreeAndNil(frmCadProduto);
  end;

  if qProduto.Active then
  begin
    qProduto.Refresh;
  end;
end;

end.
