// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program ThrdDemo;

{$I Definition.Inc}

uses
{$IFDEF MSWINDOWS}
  Forms,
{$ENDIF}
{$IFDEF LINUX}
  QForms,
{$ENDIF}
  ThSort in 'ThSort.pas' {ThreadSortForm},
  SortThds in 'SortThds.pas';

{$R *.res}

begin
  Application.CreateForm(TThreadSortForm, ThreadSortForm);
  Application.Run;
end.
