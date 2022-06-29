program CMT2SD_CHECK;

uses
  System.StartUpCopy,
  FMX.Forms,
  CMT2SD_CHECK1 in 'CMT2SD_CHECK1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
