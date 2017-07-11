{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit python4lazarus_package;

{$warn 5023 off : no warning about unused units}
interface

uses
  PythonEngine, PythonGUIInputOutput, MethodCallBack, TinyWideStrings, 
  Python4Lazarus_register, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Python4Lazarus_register', @Python4Lazarus_register.Register);
end;

initialization
  RegisterPackage('python4lazarus_package', @Register);
end.
