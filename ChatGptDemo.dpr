program ChatGptDemo;

uses
  Vcl.Forms,
  ChatGptDemoMain in 'ChatGptDemoMain.pas' {ChatGptDemoMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TChatGptDemoMainForm, ChatGptDemoMainForm);
  Application.Run;
end.
