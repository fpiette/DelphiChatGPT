program ChatGptDemo;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  ChatGptDemoMain in 'ChatGptDemoMain.pas' {ChatGptDemoMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TChatGptDemoMainForm, ChatGptDemoMainForm);
  Application.Run;
end.
