unit proc_py;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  PythonEngine;

procedure Py_SetSysPath(const Dirs: array of string; DoAdd: boolean);

const
  cDefFixedFontName = {$ifdef windows} 'Consolas' {$else} {$ifdef linux} 'Ubuntu Mono' {$else} 'Monaco' {$endif} {$endif};
  cDefFixedFontSize = {$ifdef windows} 9 {$else} 11 {$endif};

  cDefVarFontName = {$ifdef windows} 'Tahoma' {$else} {$ifdef linux} 'Ubuntu' {$else} 'default' {$endif} {$endif};
  cDefVarFontSize = {$ifdef windows} 9 {$else} 10 {$endif};


implementation

procedure Py_SetSysPath(const Dirs: array of string; DoAdd: boolean);
var
  Str, Sign: string;
  i: Integer;
begin
  Str:= '';
  for i:= 0 to Length(Dirs)-1 do
    Str:= Str + 'r"' + Dirs[i] + '"' + ',';
  if DoAdd then
    Sign:= '+='
  else
    Sign:= '=';
  Str:= Format('sys.path %s [%s]', [Sign, Str]);
  GetPythonEngine.ExecString(Str);
end;



end.

