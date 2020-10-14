unit Testthds;

 {$mode objfpc}{$H+}


interface

uses
  Classes,
  Graphics, ExtCtrls, Forms,
  PythonEngine;

type

{ TTestThread }

  TTestThread = class(TPythonThread)
  private
    FScript: TStrings;
    running : Boolean;

  protected
    procedure ExecuteWithPython; override;
  public
    constructor Create( AThreadExecMode: TThreadExecMode; script: TStrings);
    procedure Stop;
  end;


implementation


{ TTestThread }

constructor TTestThread.Create( AThreadExecMode: TThreadExecMode; script: TStrings);
begin
  fScript := script;
  FreeOnTerminate := True;
  ThreadExecMode := AThreadExecMode;
  inherited Create(False);
end;

procedure TTestThread.ExecuteWithPython;
begin
  running := true;
  try
    with GetPythonEngine do
    begin
      if Assigned(fScript) then
        ExecStrings(fScript);
    end;
  finally
    running := false;
  end;
end;

procedure TTestThread.Stop;
begin
  with GetPythonEngine do
  begin
    if running then
    begin
      PyEval_AcquireThread(self.ThreadState);
      PyErr_SetString(PyExc_KeyboardInterrupt^, 'Terminated');
      PyEval_ReleaseThread(self.ThreadState);
    end;
  end;
end;


end.
