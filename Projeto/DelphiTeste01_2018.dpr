program DelphiTeste01_2018;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uCadProduto in 'uCadProduto.pas' {frmCadProduto},
  Classe.Produto in 'Classe.Produto.pas',
  uFuncoesTela in 'uFuncoesTela.pas',
  uRelCadProduto in 'uRelCadProduto.pas' {frmRelCadProduto};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
