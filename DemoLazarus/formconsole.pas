unit formconsole;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus;

type
  { TfmConsole }
  TfmConsole = class(TForm)
    edConsole: TEdit;
    memoConsole: TMemo;
    panelConsole: TPanel;
    PopupMenu1: TPopupMenu;
    procedure edConsoleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edConsoleKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure memoConsoleChange(Sender: TObject);
    procedure memoConsoleDblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { private declarations }
    procedure MenuClick(Sender: TObject);
  public
    { public declarations }
    FList: TStringList;
    procedure DoLogConsoleLine(const Str: string);
    procedure DoExecuteConsoleLine(Str: string);
  end;

var
  fmConsole: TfmConsole;

implementation

uses
  LclType, PythonEngine, proc_py;

{$R *.lfm}

const
  cPyConsoleMaxLines = 1000;
  cPyConsolePrompt = '>>> ';


procedure TfmConsole.DoLogConsoleLine(const Str: string);
begin
  with memoConsole do
  begin
    Lines.BeginUpdate;
    while Lines.Count>cPyConsoleMaxLines do
      Lines.Delete(0);
    Lines.Add(Str);
    Lines.EndUpdate;

    SelStart:= Length(Lines.Text)-1;
  end;
end;

procedure TfmConsole.DoExecuteConsoleLine(Str: string);
var
  i: integer;
begin
  DoLogConsoleLine(cPyConsolePrompt+Str);
  edConsole.Text:= '';

  i:= FList.IndexOf(Str);
  if i>=0 then
    FList.Delete(i);
  FList.Insert(0, Str);

  if (Str<>'') and (Str[1]='=') then
    Str:= 'print('+Copy(Str, 2, MaxInt) + ')';

  try
    GetPythonEngine.ExecString(Str);
  except
  end;
end;


{ TfmConsole }

procedure TfmConsole.edConsoleKeyPress(Sender: TObject; var Key: char);
begin
end;

procedure TfmConsole.edConsoleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  p: TPoint;
begin
  if Key=vk_return then
  begin
    DoExecuteConsoleLine(edConsole.Text);
    Key:= 0;
  end;

  if (Key=vk_down) or (Key=vk_up) then
  begin
    p:= edConsole.ClientToScreen(Point(0, 0));
    PopupMenu1.Popup(p.x, p.y);
    Key:= 0;
  end;
end;

procedure TfmConsole.FormCreate(Sender: TObject);
begin
  FList:= TStringList.Create;
end;

procedure TfmConsole.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FList);
end;

procedure TfmConsole.memoConsoleChange(Sender: TObject);
begin
end;

procedure TfmConsole.memoConsoleDblClick(Sender: TObject);
var
  n: Integer;
  s: string;
begin
  with memoConsole do
  begin
    n:= CaretPos.y;
    if (n>=0) and (n<Lines.Count) then
    begin
      s:= Lines[n];
      if SBegin(s, cPyConsolePrompt) then
      begin
        Delete(s, 1, Length(cPyConsolePrompt));
        DoExecuteConsoleLine(s);
      end;
    end;
  end;
end;

procedure TfmConsole.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
  mi: TMenuItem;
begin
  with PopupMenu1 do
  begin
    Items.Clear;
    for i:= 0 to FList.Count-1 do
    begin
      mi:= TMenuItem.Create(Self);
      mi.Caption:= FList[i];
      mi.Tag:= i;
      mi.OnClick:= @MenuClick;
      Items.Add(mi);
    end;
  end;
end;

procedure TfmConsole.MenuClick(Sender: TObject);
var
  n: integer;
  s: string;
begin
  n:= (Sender as TMenuItem).Tag;
  if n<FList.Count then
  begin
    s:= FList[n];
    DoExecuteConsoleLine(s);
  end;
end;

end.

