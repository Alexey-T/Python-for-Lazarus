unit FormMain;

{$mode objfpc}{$H+}

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
  cPyLibraryWindows = 'python33.dll';
  cPyLibraryLinux = 'libpython3.4m.so.1.0';
  cPyLibraryMac = '/Library/Frameworks/Python.framework/Versions/3.4/lib/libpython3.4.dylib';
  cPyZipWindows = 'python33.zip';

function Py_app_version(Self, Args : PPyObject): PPyObject; cdecl;
begin
  with GetPythonEngine do
    Result:= PyString_FromString('1.0.0');
end;

function Py_app_api_version(Self, Args : PPyObject): PPyObject; cdecl;
begin
  with GetPythonEngine do
    Result:= PyString_FromString('1.100');
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
    AddMethod('app_version', @Py_app_version, '');
    AddMethod('app_api_version', @Py_app_api_version, '');
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
var
  dir: string;
begin
  dir:= ExtractFilePath(Application.ExeName);
  {$ifdef windows}
  Py_SetSysPath([dir+'DLLs', dir+cPyZipWindows], false);
  {$endif}
  Py_SetSysPath([dir+'Py'], true);
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

