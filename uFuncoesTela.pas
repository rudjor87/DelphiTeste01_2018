unit uFuncoesTela;

interface

uses
  System.Classes, System.SysUtils, vcl.StdCtrls, Vcl.Graphics;

procedure SetHabilitaComponente(cptObjeto :TComponent; blnHabilita: Boolean);

function GetVlMonetarioLimpo(strVlMonetario: string): string;

function GetVlMonetarioFormatado(dblVlMonetario: Double): string;

implementation

procedure SetHabilitaComponente(cptObjeto :TComponent; blnHabilita: Boolean);
begin
  if cptObjeto is TEdit then
  begin
    if blnHabilita then
    begin
      (cptObjeto as TEdit).ReadOnly := False;
      (cptObjeto as TEdit).TabStop := True;
      (cptObjeto as TEdit).Color := clWindow;
    end
    else
    begin
      (cptObjeto as TEdit).ReadOnly := True;
      (cptObjeto as TEdit).TabStop := False;
      (cptObjeto as TEdit).Color := clBtnFace;
    end;
  end;

  if cptObjeto is TComboBox then
  begin
    if blnHabilita then
    begin
      (cptObjeto as TComboBox).Enabled := True;
      (cptObjeto as TComboBox).TabStop := True;
    end
    else
    begin
      (cptObjeto as TComboBox).Enabled := False;
      (cptObjeto as TComboBox).TabStop := False;
    end;
  end;
end;

function GetVlMonetarioLimpo(strVlMonetario: string): string;
var
  strValor: string;
begin
  strValor := Trim(strVlMonetario);
  strValor := StringReplace(strValor, 'R$', '', [rfReplaceAll]);
  strValor := StringReplace(strValor, '$', '', [rfReplaceAll]);
  strValor := StringReplace(strValor, '.', '', [rfReplaceAll]);

  Result := Trim(strValor);
end;

function GetVlMonetarioFormatado(dblVlMonetario: Double): string;
begin
  Result := FormatFloat('#,##0.00', dblVlMonetario);
end;

end.
