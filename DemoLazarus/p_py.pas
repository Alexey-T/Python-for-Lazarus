unit p_py;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

procedure Py_SetSysPath(const Dirs: array of string; DoAdd: boolean);


implementation

uses
  PythonEngine,
  p_str;

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

