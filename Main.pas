unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ShellCtrls, StdCtrls, XPMan, ioplug, Menus,
  ShellAPI;

type
  TMainForm = class(TForm)
    BottomPanel: TPanel;
    XPManifest: TXPManifest;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    Options1: TMenuItem;
    Plugins1: TMenuItem;
    pbPos: TProgressBar;
    Internet1: TMenuItem;
    N2: TMenuItem;
    LPHomePage1: TMenuItem;
    LPHomePageRus1: TMenuItem;
    N3: TMenuItem;
    ProductHomePageEng1: TMenuItem;
    ProductHomePageRus1: TMenuItem;
    N4: TMenuItem;
    EMailUs1: TMenuItem;
    BugReport1: TMenuItem;
    RightPanel: TPanel;
    TopPanel: TPanel;
    CentralPanel: TPanel;
    stvTree: TShellTreeView;
    Splitter1: TSplitter;
    slvFile: TShellListView;
    LeftPanel: TPanel;
    lbInfo: TLabel;
    lbTime: TLabel;
    imgPlay: TImage;
    imgPause: TImage;
    imgStop: TImage;
    pbBottom: TPaintBox;
    imgSymbol: TImage;
    pbRight: TPaintBox;
    pbTop: TPaintBox;
    pbLeft: TPaintBox;
    btnBrowser: TImage;
    pbVolume: TPaintBox;
    procedure slvFileChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure bnPlayClick(Sender: TObject);
    procedure bnPauseClick(Sender: TObject);
    procedure bnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure pbPosMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPlayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPlayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPauseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPauseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgStopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgStopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbBottomPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure imgSymbolClick(Sender: TObject);
    procedure pbTopPaint(Sender: TObject);
    procedure pbLeftPaint(Sender: TObject);
    procedure pbRightPaint(Sender: TObject);
    procedure pbVolumeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbVolumePaint(Sender: TObject);
    procedure pbVolumeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbVolumeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnBrowserMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnBrowserMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TSkin = record
    Symbol:TBitmap;
    
    PlayDef,PlayPressed:TBitmap;
    PauseDef,PauseDown,PausePressed:TBitmap;
    StopDef,StopPressed:TBitmap;
    VolumeNo,VolumeFull:TBitmap;

    TopFill,TopLeft,TopRight:TBitmap;
    BottomFill,BottomLeft,BottomRight:TBitmap;
    LeftFill,LeftTop,LeftBottom:TBitmap;
    RightFill,RightTop,RightBottom:TBitmap;

    BtnBrowser,BtnBrowserActive:TBitmap;
  end;

const
  ProgName='LP Media Explorer';

var
  MainForm: TMainForm;
  plIn:^TIn_module;
  plOut:^TOut_module;
  _FileName:String;
  FileExt(*,InPlugs(*,OutPlugs*):TStringList;
  Skin:TSkin;
  VolChng:Boolean;
  br:integer;

implementation

uses About, splash;

{$R *.dfm}
{$R DefSkin.res}

(*----- Plugin Func START ------------------*)
procedure SetInfo1(bitrate,srate,stereo,synched:integer);cdecl; // if -1, changes ignored? :)
begin
  if bitrate<>-1 then
    br:=bitrate;
  MainForm.lbInfo.Caption:=ExtractFileName(_FileName)+' ('+inttostr(br)+ ' kbps)';
end;

function dsp_isactive1:integer;cdecl;
begin
  result:=0;
end;

function dsp_dosamples1(samples:pointer; numsamples, bps,  nch, srate:integer):integer;cdecl;
begin
  result:=numsamples;
end;

procedure SAVSAInit1(maxlatency_in_ms:integer;srate:integer);cdecl;
begin
end;

procedure SAVSADeInit1;cdecl;	// call in Stop()
  (* OnStop *)
begin
end;

procedure SAAddPCMData1(PCMData:pointer;nch:integer;bps:integer;timestamp:integer);cdecl;
begin
end;

function SAGetMode1:integer;cdecl;		// gets csa (the current type (4=ws,2=osc,1=spec))
begin
end;

procedure SAAdd1(data:pointer; timestamp:integer;csa:integer);cdecl; // sets the spec data, filled in by winamp
begin
end;

procedure VSAAddPCMData1(PCMData:pointer;nch: integer ; bps:integer;timestamp:integer);cdecl; // sets the vis data directly from PCM data
begin
end;

function VSAGetMode1(var specNch:integer; var waveNch:integer):integer;cdecl; // use to figure out what to give to VSAAdd
begin
end;

procedure VSAAdd1(data:pointer; timestamp:integer);cdecl; // filled in by winamp, called by plug-in
begin
end;

procedure VSASetInfo1(nch:integer;srate:integer);cdecl;
begin
end;
(*----- Plugin Func FINISH -----------------*)

(*----- Plugin Load START ------------------*)
procedure AppendExtList(ExtList,PlugName:String);
var
  el,ext:string;
  i:integer;
begin
  el:=extlist;
  ext:='';
  for i:=1 to Length(el) do
  begin
    if el[i]<>';' then
      ext:=ext+el[i]
    else
    begin
      FileExt.Add(UpperCase(ext)+':'+PlugName);
      ext:='';
    end;
  end;
  if ext<>'' then
  begin
    FileExt.Add(UpperCase(ext)+':'+PlugName);
  end;
end;

procedure LoadINPlugins();
var
  in_dll:TSearchRec;
  dllname,extstr:String;
  dll:^TIn_module;
begin
  if (FindFirst(ExtractFilePath(Application.ExeName)+'Plugins\in_*.dll',faAnyFile,in_dll)=0)
  then
    repeat
      dllname:=ExtractFilePath(Application.ExeName)+'Plugins\'+in_dll.Name;
      if (initInputDll(dllname)) then
      begin
        dll:=getinmodule;
        dll.hMainWindow:=Application.Handle;
        dll.hDllInstance:=InputDllHandle;
        dll.outMod:=plOut;
        dll.init;
        extstr:=dll.FileExtensions;
        dll.Quit();
        AppendExtList(extstr,dllname);
      end;
    until (FindNext(in_dll)<>0);
  FindClose(in_dll);
end;

procedure LoadOUTPlugins();
begin
//
end;
(*----- Plugin Load FINISH -----------------*)

(*----- File Opening START -----------------*)

procedure SetInPlugin(FileName:String);
       (* Input Plugin Init *)
function GetExtention(FileName:String):String;
var
  PointIndex,n:Integer;
  Ext:String;
begin
  if not (Pos('.',FileName)>0)
  then begin
    Result:='';
    exit;
  end;
  PointIndex:=Length(FileName);
  for n:=1 to Length(FileName)
  do begin
    if FileName[n]='.' then PointIndex:=n;
  end;
  if PointIndex=Length(FileName)
  then begin
    Result:='';
    exit;
  end;;
  Ext:='';
  for n:=PointIndex+1 to Length(FileName)
  do begin
    Ext:=Ext+FileName[n];
  end;
  Result:=UpperCase(Ext);
end;

var
  plFileName,ext:String;
  i:integer;
begin
  if ((plIn<>nil)and(plOut.IsPlaying=1))
  then begin
    plIn.Stop;
  end;
  plFileName:='';
//-- Get Plugin Name -------------------------
  ext:=GetExtention(FileName);
  for i:=0 to FileExt.Count-1 do
  begin
    if (Copy(FileExt.Strings[i],1,Pos(':',FileExt.Strings[i])-1)=ext) then
    begin
      plFileName:=Copy(FileExt.Strings[i],Pos(':',FileExt.Strings[i])+1,
            Length(FileExt.Strings[i])-Pos(':',FileExt.Strings[i]));
      break;
    end;
  end;
  (*dummy*)
  if plFileName='' then
  begin
    plFileName:=ExtractFilePath(Application.ExeName)+'\Plugins\in_mp3.dll';
  end;
  (*dummy end*)
//-- Get Plugin Name End----------------------
  if (not(initInputDll(plFileName)))
  then begin
    Application.MessageBox('Error loading input plugin',PChar(ProgName),MB_ICONERROR);
    plIn := nil;
  end;

  plIn:=getinmodule;

  plIn.hMainWindow:=Application.Handle;
  plIn.hDllInstance:=InputDllHandle;
  plIn.outMod:=plOut;
  plIn.init;

  plIn.SetInfo:=SetInfo1;
  plIn.dsp_IsActive:=dsp_isactive1;
  plIn.dsp_dosamples:=dsp_dosamples1;
  plIn.SAVSAInit:=SAVSAInit1;
  plIn.SAVSADeInit:=SAVSADeinit1;
  plIn.SAAddPCMData:=SAAddPCMData1;
  plIn.SAGetMode:=SAGetMode1;
  plIn.SAAdd:=SAADD1;
  plIn.VSASetInfo:=VSASetInfo1;
  plIn.VSAAddPCMData:=VSAAddPCMData1;
  plIn.VSAGetMode:=VSAGetMode1;
  plIn.VSAAdd:=VSAAdd1;
end;

procedure SetOutPlugin();
     (* Output Plugin Init *)
var
  plFileName:String;
begin
  //----- dummy start ----------------
  plFileName:=ExtractFilePath(Application.ExeName)+'\Plugins\out_wave.dll';
  //----- dummy finish ---------------
  if (not(initOutputDll(plFileName)))
  then begin
    Application.MessageBox('Error loading output plugin',PChar(ProgName),MB_ICONERROR);
    plOut := nil;
  end;

  plOut:=getoutmodule;

  plOut.hMainWindow:=application.Handle;
  plOut.hDllInstance:=OutputDllHandle;
  plOut.init;
  plOut.setvolume(MainForm.pbVolume.Tag);
//  plOut.setvolume(128);

  if (plIn<>nil)
  then
    plIn.outMod:=plOut;
end;

procedure OpenFile(FileName:String);
begin
  if plIn<>nil
  then begin
    plIn.Stop();
    plIn.Quit();
  end;
  if plOut<>nil
  then begin
    plOut.Quit();
  end;
  SetInPlugin(FileName);
  SetOutPlugin();
  if ((plIn=nil)or(plOut=nil))
  then begin
    exit;
  end;
  _FileName:=FileName;
  plIn.Play(PChar(FileName));
//  plIn.GetFileInfo(NULL,Title,Len);
//  MainForm.lbFileName.Caption:=Title;
end;

(*----- File Opening FINISH ----------------*)

(*----- Common Subprograms -----------------*)

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SplashForm:=TSplashForm.Create(nil);
  SplashForm.Show;
  Application.ProcessMessages;

  FileExt:=TStringList.Create;
  LoadINPlugins();
  LoadOUTPlugins();

//  SendMessage(pbPos.Handle, PBM_SETBARCOLOR, 0, $FF00FF);  
//----- Skin Loading --------------
  Skin.Symbol:=TBitmap.Create;
  Skin.PlayDef:=TBitmap.Create;
  Skin.PlayPressed:=TBitmap.Create;
  Skin.PauseDef:=TBitmap.Create;
  Skin.PauseDown:=TBitmap.Create;
  Skin.PausePressed:=TBitmap.Create;
  Skin.StopDef:=TBitmap.Create;
  Skin.StopPressed:=TBitmap.Create;
  Skin.VolumeNo:=TBitmap.Create;
  Skin.VolumeFull:=TBitmap.Create;
  Skin.TopFill:=TBitmap.Create;
  Skin.TopLeft:=TBitmap.Create;
  Skin.TopRight:=TBitmap.Create;
  Skin.BottomFill:=TBitmap.Create;
  Skin.BottomLeft:=TBitmap.Create;
  Skin.BottomRight:=TBitmap.Create;
  Skin.LeftFill:=TBitmap.Create;
  Skin.LeftTop:=TBitmap.Create;
  Skin.LeftBottom:=TBitmap.Create;
  Skin.RightFill:=TBitmap.Create;
  Skin.RightTop:=TBitmap.Create;
  Skin.RightBottom:=TBitmap.Create;
  Skin.BtnBrowser:=TBitmap.Create;
  Skin.BtnBrowserActive:=TBitmap.Create;

  Skin.Symbol.LoadFromResourceName(HInstance,'SYMBOL');

  Skin.PlayDef.LoadFromResourceName(HInstance,'PLAYDEF');
  Skin.PlayPressed.LoadFromResourceName(HInstance,'PLAYPRESSED');

  Skin.PauseDef.LoadFromResourceName(HInstance,'PAUSEDEF');
  Skin.PauseDown.LoadFromResourceName(HInstance,'PAUSEDOWN');
  Skin.PausePressed.LoadFromResourceName(HInstance,'PAUSEPRESSED');

  Skin.StopDef.LoadFromResourceName(HInstance,'STOPDEF');
  Skin.StopPressed.LoadFromResourceName(HInstance,'STOPPRESSED');

  Skin.VolumeNo.LoadFromResourceName(HInstance,'VOLUMENO');
  Skin.VolumeFull.LoadFromResourceName(HInstance,'VOLUMEFULL');

  Skin.TopFill.LoadFromResourceName(HInstance,'TOPFILL');
  Skin.TopLeft.LoadFromResourceName(HInstance,'TOPLEFT');
  Skin.TopRight.LoadFromResourceName(HInstance,'TOPRIGHT');

  Skin.BottomFill.LoadFromResourceName(HInstance,'BOTTOMFILL');
  Skin.BottomLeft.LoadFromResourceName(HInstance,'BOTTOMLEFT');
  Skin.BottomRight.LoadFromResourceName(HInstance,'BOTTOMRIGHT');

  Skin.LeftFill.LoadFromResourceName(HInstance,'LEFTFILL');
  Skin.LeftTop.LoadFromResourceName(HInstance,'LEFTTOP');
  Skin.LeftBottom.LoadFromResourceName(HInstance,'LEFTBOTTOM');

  Skin.RightFill.LoadFromResourceName(HInstance,'RIGHTFILL');
  Skin.RightTop.LoadFromResourceName(HInstance,'RIGHTTOP');
  Skin.RightBottom.LoadFromResourceName(HInstance,'RIGHTBOTTOM');

  Skin.BtnBrowser.LoadFromResourceName(HInstance,'BTNBROWSER');
  Skin.BtnBrowserActive.LoadFromResourceName(HInstance,'BTNBROWSERACTIVE');

  imgSymbol.Picture.Assign(Skin.Symbol);
  imgPlay.Picture.Assign(Skin.PlayDef);
  imgPause.Picture.Assign(Skin.PauseDef);
  imgStop.Picture.Assign(Skin.StopDef);

  btnBrowser.Picture.Assign(Skin.BtnBrowser);
//----- Skin Loading END ----------

  SplashForm.Timer1.Enabled:=true;
  while (true) do
  begin
    sleep(0);
    Application.ProcessMessages;
    if not SplashForm.Visible then break;
  end;
  SplashForm.Free;
end;

procedure TMainForm.slvFileChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if (slvFile.SelectedFolder = nil) then exit;
//  if (not FileExists(slvFile.SelectedFolder.PathName())) then exit;
  try
    OpenFile(slvFile.SelectedFolder.PathName());
  finally
  end;
end;

procedure TMainForm.bnPlayClick(Sender: TObject);
begin
  if plIn=nil then exit;
  if (plIn.IsPaused<>0)
  then
    plIn.UnPause;
  if (plOut.IsPlaying=1) then
    exit;
  plIn.Play(PChar(_FileName));
end;

procedure TMainForm.bnPauseClick(Sender: TObject);
begin
  if (plIn=nil) then exit;
  if (plIn.IsPaused<>0)
  then
    plIn.UnPause
  else
    plIn.Pause;
end;

procedure TMainForm.bnStopClick(Sender: TObject);
begin
  if plIn=nil then exit;
  plIn.Stop();
  imgPause.Picture.Assign(Skin.PauseDef)
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (plOut<>nil) then
    if (plOut.IsPlaying=1)
    then
      plIn.Stop();
  FileExt.Free;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  Len,Pos:integer;
  min1,min2:string;
begin
  if plIn=nil then exit;
(*  if (plOut.IsPlaying=1)
  then begin*)
    Len:=plIn.GetLength;
    Pos:=plIn.GetOutputTime;
(*  end
  else begin
    Len:=0;
    Pos:=0;
  end;*)
  if (Len<0) then
    Len:=0;
  if (Pos<0) then
    Pos:=0;
  if (Pos>Len) then
    Pos:=Len;
  pbPos.Max:=Len;
  pbPos.Position:=Pos;
  //----- Time ---------
  len:=len div 1000;
  pos:=pos div 1000;
  min1:=IntToStr(Pos mod 60);
  if ((Pos mod 60)<10) then
    min1:='0'+min1;
  min2:=IntToStr(Len mod 60);
  if ((Len mod 60)<10) then
    min2:='0'+min2;
  lbTime.Caption:=IntToStr(Pos div 60)+':'+min1+' / '+IntToStr(Len div 60)+':'+min2;
  //----- Time End ------
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal();
end;

procedure TMainForm.pbPosMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NewPos:Integer;
begin
  if plIn=nil then exit;
  //if plOut=nil then exit;
  //if (plOut.IsPlaying=0) then exit;
  if (plIn.IsPaused=1)
  then begin
    plIn.UnPause();
  end;
  NewPos:=trunc(pbPos.Max/(pbPos.Width-4)*(x-2));
  plIn.SetOutputTime(NewPos);
(*  if (Pause) then
    plIn.Pause();*)
end;

procedure TMainForm.imgPlayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgPlay.Picture.Assign(Skin.PlayPressed);
end;

procedure TMainForm.imgPlayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgPlay.Picture.Assign(Skin.PlayDef);
end;

procedure TMainForm.imgPauseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imgPause.Picture.Assign(Skin.PausePressed);
end;

procedure TMainForm.imgPauseMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if plIn=nil then
    imgPause.Picture.Assign(Skin.PauseDef)
  else
    if (plIn.IsPaused=0) then
      imgPause.Picture.Assign(Skin.PauseDef)
    else
      imgPause.Picture.Assign(Skin.PauseDown);;
end;

procedure TMainForm.imgStopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgStop.Picture.Assign(Skin.StopPressed);
end;

procedure TMainForm.imgStopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgStop.Picture.Assign(Skin.StopDef);
end;

procedure TMainForm.pbBottomPaint(Sender: TObject);
var
  x:Integer;
begin
  x:=0;
  while x < pbBottom.Width do
  begin
    pbBottom.Canvas.Draw(x, 0, Skin.BottomFill);
    x := x + Skin.BottomFill.Width;
  end;
  pbBottom.Canvas.Draw(pbBottom.Width-Skin.BottomRight.Width, 0, Skin.BottomRight);
  pbBottom.Canvas.Draw(0, 0, Skin.BottomLeft);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  MainForm.Repaint;
end;

procedure TMainForm.imgSymbolClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', PChar((Sender as TControl).Hint), '', '', SW_SHOW);
end;

procedure TMainForm.pbTopPaint(Sender: TObject);
var
  x:Integer;
begin
  x:=0;
  while x < pbTop.Width do
  begin
    pbTop.Canvas.Draw(x, 0, Skin.TopFill);
    x := x + Skin.TopFill.Width;
  end;
  pbTop.Canvas.Draw(pbTop.Width-Skin.TopRight.Width, 0, Skin.TopRight);
  pbTop.Canvas.Draw(0, 0, Skin.TopLeft);
end;

procedure TMainForm.pbLeftPaint(Sender: TObject);
var
  y:Integer;
begin
  y:=0;
  while y < pbLeft.Height do
  begin
    pbLeft.Canvas.Draw(0, y, Skin.LeftFill);
    y := y + Skin.LeftFill.Height;
  end;
  pbLeft.Canvas.Draw(0, pbLeft.Height-Skin.LeftBottom.Height, Skin.LeftBottom);
  pbLeft.Canvas.Draw(0, 0, Skin.LeftTop);
end;

procedure TMainForm.pbRightPaint(Sender: TObject);
var
  y:Integer;
begin
  y:=0;
  while y < pbRight.Height do
  begin
    pbRight.Canvas.Draw(0, y, Skin.RightFill);
    y := y + Skin.RightFill.Height;
  end;
  pbRight.Canvas.Draw(0, pbRight.Height-Skin.RightBottom.Height, Skin.RightBottom);
  pbRight.Canvas.Draw(0, 0, Skin.RightTop);
end;

procedure TMainForm.pbVolumeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  VolChng:=true;
  pbVolume.Tag:=trunc(x/pbVolume.Width*255);
  if pbVolume.Tag>255 then pbVolume.Tag:=255;
  if pbVolume.Tag<0 then pbVolume.Tag:=0;  
  pbVolume.Repaint;
  if (plIn=nil) then exit;
  plIn.SetVolume(pbVolume.Tag);
end;

procedure TMainForm.pbVolumePaint(Sender: TObject);
var
  Rect:TRect;
  Bitmap:TBitmap;
begin
  Bitmap:=Skin.VolumeFull;
  Rect.Top:=0;
  Rect.Bottom:=Bitmap.Height;
  Rect.Left:=0;
  Rect.Right:=trunc(pbVolume.Tag/255 * pbVolume.Width);
  pbVolume.Canvas.BrushCopy(Rect,Bitmap,Rect,-1);
  Bitmap:=Skin.VolumeNo;
  Rect.Left:=Rect.Right;
  Rect.Right:=pbVolume.Width;
  pbVolume.Canvas.BrushCopy(Rect,Bitmap,Rect,-1);
end;

procedure TMainForm.pbVolumeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (not VolChng) then exit;
  pbVolume.Tag:=trunc(x/pbVolume.Width*255);
  if pbVolume.Tag>255 then pbVolume.Tag:=255;
  if pbVolume.Tag<0 then pbVolume.Tag:=0;  
  pbVolume.Repaint;
  if (plIn=nil) then exit;
  plIn.SetVolume(pbVolume.Tag);
end;

procedure TMainForm.pbVolumeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  VolChng:=false;
  pbVolume.Repaint;
end;

procedure TMainForm.btnBrowserMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  btnBrowser.Picture.Assign(Skin.BtnBrowserActive);
end;

procedure TMainForm.btnBrowserMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  btnBrowser.Picture.Assign(Skin.BtnBrowser);
end;

end.
