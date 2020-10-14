unit Unit1;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, StdCtrls,strUtils,
  PythonEngine,Testthds;

type

  { TForm1 }

  TForm1 = class(TForm)
    ScriptBtn: TButton;
    ThreadBtn: TButton;
    StopThreadBtn: TButton;
    Memo1: TMemo;
    PythonEngine1: TPythonEngine;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ScriptBtnClick(Sender: TObject);
    procedure StopThreadBtnClick(Sender: TObject);
    procedure ThreadBtnClick(Sender: TObject);

  private
    OwnThreadState: PPyThreadState;
    ThreadsRunning: Integer;
    procedure ThreadDone(Sender: TObject);
    procedure InitThreads(ThreadExecMode: TThreadExecMode);


  public
    Thread1 : TTestThread;
    Thread2 : TTestThread;
    Thread3 : TTestThread;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.InitThreads(ThreadExecMode: TThreadExecMode);
var script1,script2,script3  : TStringList;
begin
script1 := TStringList.Create();
script2 := TStringList.Create();
script3 := TStringList.Create();
script1.LoadFromFile('testThread.py');
ThreadsRunning := 3;
Memo1.Clear;
Memo1.Append('Starting 3 threads');
with GetPythonEngine do
  begin
    OwnThreadState := PyEval_SaveThread();

  Thread1 := TTestThread.Create( ThreadExecMode, script1);
  Thread1.OnTerminate := @ThreadDone;
  script2.Text := ReplaceStr(script1.Text,'Thread1','Thread2');
  script2.Text := ReplaceStr(script2.Text,'(1.0)','(1.4)');
  Thread2 := TTestThread.Create( ThreadExecMode, script2);
  Thread2.OnTerminate := @ThreadDone;
  script3.Text := ReplaceStr(script1.Text,'Thread1','Thread3');
  script3.Text := ReplaceStr(script3.Text,'(1.0)','(1.9)');
  Thread3 := TTestThread.Create( ThreadExecMode, script3);
  Thread3.OnTerminate := @ThreadDone;

end;
ScriptBtn.Enabled := False;
ThreadBtn.Enabled := False;
StopThreadBtn.Enabled := True;

end;
procedure TForm1.ThreadDone(Sender: TObject);
begin
  Dec(ThreadsRunning);
  if ThreadsRunning = 0 then
  begin
    Memo1.Append('all the threads Terminated');
    GetPythonEngine.PyEval_RestoreThread(OwnThreadState);
    ScriptBtn.Enabled := True;
    ThreadBtn.Enabled := True;
    StopThreadBtn.Enabled := False;
    Thread1 := nil;
    Thread2 := nil;
    Thread3 := nil;
  end;
end;

procedure TForm1.ScriptBtnClick(Sender: TObject);
var  script  : TStringList;
begin
script := TStringList.Create();
script.LoadFromFile('testThread.py');
script.Text := ReplaceStr(script.Text,'Thread1','Script');
Memo1.Clear;
Memo1.Append('Starting Python Script');
GetPythonEngine.ExecStrings(script);
Memo1.Append('Python Script Terminated');
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := ThreadsRunning = 0;
end;


procedure TForm1.ThreadBtnClick(Sender: TObject);
begin
   InitThreads(emNewInterpreter);
end;

procedure TForm1.StopThreadBtnClick(Sender: TObject);
begin
  if Assigned(Thread1) and not Thread1.Finished then Thread1.Stop();
  if Assigned(Thread2) and not Thread2.Finished then Thread2.Stop();
  if Assigned(Thread3) and not Thread3.Finished then Thread3.Stop();
end;


end.

