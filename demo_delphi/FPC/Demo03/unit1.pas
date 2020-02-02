unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SynHighlighterPython, PythonGUIInputOutput, PythonEngine;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    PythonDelphiVar: TPythonDelphiVar;
    PythonEngine: TPythonEngine;
    PythonGUIInputOutput: TPythonGUIInputOutput;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PythonGUIInputOutputReceiveData(Sender: TObject;
      var Data: AnsiString);
  private
    procedure DoPy_InitEngine;
  public

  end;

var
  Form1: TForm1;

implementation

uses
  LclType, proc_py;

{$R *.lfm}


const
  cPyLibraryWindows = 'python37.dll';
  cPyLibraryLinux = 'libpython3.7m.so.1.0';
  cPyLibraryMac = '/Library/Frameworks/Python.framework/Versions/3.7/lib/libpython3.7.dylib';
  cPyZipWindows = 'python37.zip';

{ TForm1 }

procedure TForm1.PythonGUIInputOutputReceiveData(Sender: TObject;
  var Data: AnsiString);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var
 Result : PPyObject;
 cmd : TStrings;
begin
 with PythonEngine do
    begin
       cmd := Memo1.Lines;
       Result := EvalStrings(cmd);
       if Assigned(Result) then
           begin
             Memo2.Lines.Add('%s',[PyObjectAsString(Result)]);
             Py_DECREF(Result);
           end
        else
           Memo2.Lines.Add('Could not evaluate the script');
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage( 'Value = ' + PythonDelphiVar.ValueAsString );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoPy_InitEngine;
end;

procedure TForm1.DoPy_InitEngine;
var
  S: string;
begin
  S:=
    {$ifdef windows} cPyLibraryWindows {$endif}
    {$ifdef linux} cPyLibraryLinux {$endif}
    {$ifdef darwin} cPyLibraryMac {$endif} ;
  PythonEngine.DllPath:= ExtractFileDir(S);
  PythonEngine.DllName:= ExtractFileName(S);
  PythonEngine.LoadDll;
end;

end.

