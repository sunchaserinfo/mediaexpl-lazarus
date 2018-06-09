unit About;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellAPI;

type
  TAboutBox = class(TForm)
    imgHdr: TImage;
    imgIcon: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    lbAllMem: TLabel;
    lbFreeMem: TLabel;
    lbURL: TLabel;
    lbEMail: TLabel;
    lbURLRus: TLabel;
    Label5: TLabel;
    procedure lbURLMouseEnter(Sender: TObject);
    procedure lbURLMouseLeave(Sender: TObject);
    procedure lbURLClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.lfm}

procedure TAboutBox.lbURLMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color:=$0000FF;
end;

procedure TAboutBox.lbURLMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color:=$FF0000;
end;

procedure TAboutBox.lbURLClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', PChar((Sender as TLabel).Caption), '', '', SW_SHOW);
end;

procedure TAboutBox.FormActivate(Sender: TObject);
var
  MS: TMemoryStatus;
begin
  GlobalMemoryStatus(MS);
  lbAllMem.Caption := FormatFloat('#,###" KB"', MS.dwTotalPhys / 1024);
  lbFreeMem.Caption := Format('%d %%', [MS.dwMemoryLoad]);
  imgIcon.Picture.Assign(Application.Icon);
end;

end.
