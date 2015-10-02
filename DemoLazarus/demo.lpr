program demo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FormMain, FormConsole,
  p_str, p_py
  { you can add units after this };

{$R *.res}

begin
  Application.Title:= 'PyLazarus';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.

