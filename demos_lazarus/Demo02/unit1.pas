unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, PairSplitter, PythonEngine, PythonGUIInputOutput;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Splitter1: TSplitter;
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PythonEngine1: TPythonEngine;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure DoPy_InitEngine;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

uses
  LclType, proc_py;

{$R unit1.lfm}

const
    cPyLibraryWindows = 'python37.dll';
    cPyLibraryLinux = 'libpython3.7m.so.1.0';
    cPyLibraryMac = '/Library/Frameworks/Python.framework/Versions/3.7/lib/libpython3.7.dylib';
    cPyZipWindows = 'python37.zip';

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
 Result : PPyObject;
 cmd : TStrings;
begin
 with PythonEngine1 do
    begin
       cmd := Memo1.Lines;
       Result := EvalStrings(cmd);
       if Assigned(Result) then
           begin
             ShowMessage(Format('Eval: %s',[PyObjectAsString(Result)]));
             //Memo2.Lines.Add('%s',[PyObjectAsString(Result)]);
             Py_DECREF(Result);
           end
        else
           ShowMessage('Could not evaluate the script');
           //Memo2.Lines.Add('Could not evaluate the script');
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    if Execute then
      Memo1.Lines.LoadFromFile( FileName );
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with SaveDialog1 do
  begin
    if Execute then
      Memo1.Lines.SaveToFile( FileName );
  end;
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
  PythonEngine1.DllPath:= ExtractFileDir(S);
  PythonEngine1.DllName:= ExtractFileName(S);
  PythonEngine1.LoadDll;
end;

end.

