unit FormMain;

{$mode objfpc}{$H+}
{$Codepage utf8}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, PythonEngine, PythonGUIInputOutput;

type
  { TfmMain }
  TfmMain = class(TForm)
    mnuHelpAbout: TMenuItem;
    Panel1: TPanel;
    PythonEngine: TPythonEngine;
    PythonInputOutput1: TPythonInputOutput;
    PythonModule1: TPythonModule;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PythonEngineAfterInit(Sender: TObject);
    procedure PythonInputOutput1SendData(Sender: TObject; const Data: AnsiString);
    procedure PythonInputOutput1SendUniData(Sender: TObject; const Data: UnicodeString);
    procedure PythonModule1Initialization(Sender: TObject);
  private
    { private declarations }
    procedure InitFonts;
    procedure DoPy_InitEngine;
  public
    { public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  LclType, FormConsole, proc_py;

{$R *.lfm}

const
  cPyLibraryWindows = 'python37.dll';
  cPyLibraryLinux = 'libpython3.8.so.1.0'; //default in Ubuntu 20.x
  cPyLibraryMac = '/Library/Frameworks/Python.framework/Versions/3.7/lib/libpython3.7.dylib';
  cPyZipWindows = 'python37.zip';

function Py_s0(Self, Args : PPyObject): PPyObject; cdecl;
begin
  with GetPythonEngine do
    Result:= PyString_FromString('1.0.0');
end;

function Py_s1(Self, Args : PPyObject): PPyObject; cdecl;
const
  S0: string = 'begin.Привет.end';
begin
  with GetPythonEngine do
    Result:= PyString_FromString(PChar(S0));
end;

{ TfmMain }

procedure TfmMain.PythonInputOutput1SendData(Sender: TObject;
  const Data: AnsiString);
begin
  if Assigned(fmConsole) then
    fmConsole.DoLogConsoleLine(Data);
end;

procedure TfmMain.PythonInputOutput1SendUniData(Sender: TObject;
  const Data: UnicodeString);
begin
  if Assigned(fmConsole) then
    fmConsole.DoLogConsoleLine(Data);
end;

procedure TfmMain.PythonModule1Initialization(Sender: TObject);
begin
  with Sender as TPythonModule do
  begin
    AddMethod('s0', @Py_s0, '');
    AddMethod('s1', @Py_s1, '');
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  fmConsole:= TfmConsole.Create(Self);
  fmConsole.Parent:= Self;
  fmConsole.Align:= alClient;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  fmConsole.Show;
  fmConsole.edConsole.SetFocus;

  InitFonts;
  DoPy_InitEngine;
end;

procedure TfmMain.InitFonts;
begin
  fmConsole.Font.Name:= cDefFixedFontName;
  fmConsole.Font.Size:= cDefFixedFontSize;
  fmConsole.edConsole.Font:= fmConsole.Font;
end;

procedure TfmMain.PythonEngineAfterInit(Sender: TObject);
const
  NTest: Longint = 1 shl 30;
var
  dir: string;
begin
  dir:= ExtractFilePath(Application.ExeName);
  {$ifdef windows}
  Py_SetSysPath([dir+'DLLs', dir+cPyZipWindows], false);
  {$endif}
  Py_SetSysPath([dir+'Py'], true);

  //test for LongInt
  //Caption:= BoolToStr(PythonEngine.PyInt_AsLong(PythonEngine.PyInt_FromLong(NTest)) = NTest, true);
end;

procedure TfmMain.DoPy_InitEngine;
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

