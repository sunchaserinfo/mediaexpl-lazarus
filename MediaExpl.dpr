program MediaExpl;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  About in 'About.pas' {AboutBox},
  splash in 'Splash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Multimedia Explorer';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
