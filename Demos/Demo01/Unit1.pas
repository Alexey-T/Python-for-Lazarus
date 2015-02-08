unit Unit1;

{$I Definition.Inc}

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
{$ENDIF}
{$IFDEF LINUX}
  QForms, QDialogs, QStdCtrls, QControls, QExtCtrls,
{$ENDIF}
  PythonEngine, PythonGUIInputOutput;

type
  TForm1 = class(TForm)
    PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Splitter1: TSplitter;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PythonEngine1SysPathInit(Sender: TObject;
      PathList: PPyObject);
    procedure PythonEngine1BeforeLoad(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;



var
  Form1: TForm1;

implementation

{$IFDEF MSWINDOWS}
{$R *.DFM}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}

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

    procedure TForm1.PythonEngine1SysPathInit(Sender: TObject;
      PathList: PPyObject);
    var
      folder1, folder2, folder3: PPyObject;
    begin
      with GetPythonEngine do
      begin
        folder1 := PyString_FromString(PChar(ExtractFilePath(ParamStr(0))+'Libs'));
        folder2 := PyString_FromString(PChar(ExtractFilePath(ParamStr(0))+'Lib'));
        folder3 := PyString_FromString(PChar(ExtractFilePath(ParamStr(0))+'DLLs'));
        PyList_Append(PathList, folder1); // or insert, or clear…
        PyList_Append(PathList, folder2); // or insert, or clear…
        PyList_Append(PathList, folder3); // or insert, or clear…
        Py_XDecRef(folder1);
        Py_XDecRef(folder2);
        Py_XDecRef(folder3);
      end;
    end;


procedure TForm1.PythonEngine1BeforeLoad(Sender: TObject);
begin
  with PythonEngine1 do
  begin
    DllPath:= ExtractFilePath(ParamStr(0));
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var i:integer;
begin
  for i:= 1 to 20 do memo2.lines.add(inttostr(i));
  memo2.Perform(EM_LINESCROLL, 0, Memo2.Lines.Count);
end;

end.
