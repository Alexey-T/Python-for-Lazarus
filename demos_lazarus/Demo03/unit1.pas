unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, PairSplitter, PythonGUIInputOutput, PythonEngine;

type

  { TForm1 }

  TForm1 = class(TForm)
    PythonEngine1: TPythonEngine;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonDelphiVar1: TPythonDelphiVar;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure DoPy_InitEngine;
  public
    { Déclarations publiques }
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

procedure TForm1.Button1Click(Sender: TObject);
begin
     PythonEngine1.ExecStrings( Memo1.Lines );
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

procedure TForm1.Button4Click(Sender: TObject);
begin
  ShowMessage( 'Value = ' + PythonDelphiVar1.ValueAsString );
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
