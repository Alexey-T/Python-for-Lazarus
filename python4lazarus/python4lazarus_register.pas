unit Python4Lazarus_register;

interface

uses SysUtils, Classes;

procedure Register;

implementation

uses PythonEngine, PythonGUIInputOutput;

procedure Register;
begin
  RegisterComponents('Python', [TPythonEngine, TPythonInputOutput,
                                TPythonType, TPythonModule, TPythonDelphiVar]);
  RegisterComponents('Python', [TPythonGUIInputOutput]);
end;

end.
