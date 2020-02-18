unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, PairSplitter, PythonGUIInputOutput, PythonEngine,
  Messages, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PythonDelphiVar1: TPythonDelphiVar;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonDelphiVar2: TPythonDelphiVar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure PythonDelphiVar1Change(Sender: TObject);
    procedure PythonDelphiVar1GetData(Sender: TObject; var Data: Variant);
    procedure PythonDelphiVar1SetData(Sender: TObject; Data: Variant);
    procedure PythonDelphiVar2ExtGetData(Sender: TObject;
      var Data: PPyObject);
    procedure PythonDelphiVar2ExtSetData(Sender: TObject; Data: PPyObject);
    procedure FormCreate(Sender: TObject);
  private
    FMyPythonObject : PPyObject;
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

procedure TForm1.PythonDelphiVar1Change(Sender: TObject);
begin
  with Sender as TPythonDelphiVar do
    ShowMessage( 'Var test changed: ' + ValueAsString );
end;

procedure TForm1.PythonDelphiVar1GetData(Sender: TObject;
  var Data: Variant);
begin
  Data := Edit1.Text;
end;

procedure TForm1.PythonDelphiVar1SetData(Sender: TObject; Data: Variant);
begin
  Edit1.Text := Data;
end;

procedure TForm1.PythonDelphiVar2ExtGetData(Sender: TObject;
  var Data: PPyObject);
begin
  with GetPythonEngine do
    begin
      Data := FMyPythonObject;
      Py_XIncRef(Data); // This is very important
    end;
end;

procedure TForm1.PythonDelphiVar2ExtSetData(Sender: TObject;
  Data: PPyObject);
begin
  with GetPythonEngine do
    begin
      Py_XDecRef(FMyPythonObject); // This is very important
      FMyPythonObject := Data;
      Py_XIncRef(FMyPythonObject); // This is very important
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
