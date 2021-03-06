unit About;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, System.win.Registry,
  ComCtrls, ShellAnimations, xmldom, XMLIntf, XML.Win.msxmldom, XMLDoc,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.ImgList, AdvGlowButton, EllipsLabel, JvComponentBase, JvThreadTimer,
  IdAntiFreezeBase, Vcl.IdAntiFreeze, System.ImageList, ShellAPI, Math, System.win.ComObj;

type
  TAboutBox = class(TForm)
    Image1: TImage;
    PhysMem: TLabel;
    OS: TLabel;
    Label3: TLabel;
    cre_b: TLabel;
    processador: TLabel;
    XMLDoc: TXMLDocument;
    Bevel1: TBevel;
    we_version: TLabel;
    IdHTTP1: TIdHTTP;
    updateinfo: TMemo;
    ImageList1: TImageList;
    UserAgent: TEllipsLabel;
    FooterPanel: TPanel;
    UpdateButton: TAdvGlowButton;
    we_update: TLabel;
    LicensingInfLabel: TLabel;
    CreditsLabel: TLabel;
    SystemLabel: TLabel;
    updatecheck: TJvThreadTimer;
    OKButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure UserAgentClick(Sender: TObject);
    procedure UserAgentMouseEnter(Sender: TObject);
    procedure UserAgentMouseLeave(Sender: TObject);
    procedure CreditsLabelClick(Sender: TObject);
    procedure updatecheckTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LicensingInfLabelClick(Sender: TObject);
    procedure SystemLabelClick(Sender: TObject);
    procedure LicensingInfLabelMouseEnter(Sender: TObject);
    procedure LicensingInfLabelMouseLeave(Sender: TObject);
    procedure CreditsLabelMouseEnter(Sender: TObject);
    procedure CreditsLabelMouseLeave(Sender: TObject);
    procedure SystemLabelMouseLeave(Sender: TObject);
    procedure SystemLabelMouseEnter(Sender: TObject);
  private
    procedure InitializeCaptions;
    procedure LoadIMGDLL;
    procedure Loadcurrent;
    function GetTotalRAM: Int64;
    function FormatByteSize(const bytes: int64): string;
    procedure GetLanguage;
    procedure GetUpdates;
    function ConvertVerToInt(VerStr: string): int64;
  protected
   //procedure CreateParams(var Params: TCreateParams); override;
  end;

procedure ShowAboutBox;

type
  TMemoryStatusEx = record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    ullTotalPhys: Int64;
    ullAvailPhys: Int64;
    ullTotalPageFile: Int64;
    ullAvailPageFile: Int64;
    ullTotalVirtual: Int64;
    ullAvailVirtual: Int64;
    ullAvailExtendedVirtual: Int64;
  end;

implementation

uses UnitMainForm;

{$R *.dfm}

type
  TFileVersionInfo = record
    FileType,
    CompanyName,
    FileDescription,
    FileVersion,
    InternalName,
    LegalCopyRight,
    LegalTradeMarks,
    OriginalFileName,
    ProductName,
    ProductVersion,
    Comments,
    SpecialBuildStr,
    PrivateBuildStr,
    FileFunction : string;
    DebugBuild,
    PreRelease,
    SpecialBuild,
    PrivateBuild,
    Patched,
    InfoInferred : Boolean;
  end;

procedure ShowAboutBox;
begin
  with TAboutBox.Create(Application) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

function FileVersionInfo(const sAppNamePath: TFileName): TFileVersionInfo;
var
  rSHFI: TSHFileInfo;
  iRet: Integer;
  VerSize: Integer;
  VerBuf: PChar;
  VerBufValue: Pointer;
  VerHandle: Cardinal;
  VerBufLen: Cardinal;
  VerKey: string;
  FixedFileInfo: PVSFixedFileInfo;

  function GetFileSubType(FixedFileInfo: PVSFixedFileInfo) : string;
  begin
    case FixedFileInfo.dwFileType of

      VFT_UNKNOWN: Result := 'Unknown';
      VFT_APP: Result := 'Application';
      VFT_DLL: Result := 'DLL';
      VFT_STATIC_LIB: Result := 'Static-link Library';

      VFT_DRV:
        case
          FixedFileInfo.dwFileSubtype of
          VFT2_UNKNOWN: Result := 'Unknown Driver';
          VFT2_DRV_COMM: Result := 'Communications Driver';
          VFT2_DRV_PRINTER: Result := 'Printer Driver';
          VFT2_DRV_KEYBOARD: Result := 'Keyboard Driver';
          VFT2_DRV_LANGUAGE: Result := 'Language Driver';
          VFT2_DRV_DISPLAY: Result := 'Display Driver';
          VFT2_DRV_MOUSE: Result := 'Mouse Driver';
          VFT2_DRV_NETWORK: Result := 'Network Driver';
          VFT2_DRV_SYSTEM: Result := 'System Driver';
          VFT2_DRV_INSTALLABLE: Result := 'InstallableDriver';
          VFT2_DRV_SOUND: Result := 'Sound Driver';
        end;
      VFT_FONT:
         case FixedFileInfo.dwFileSubtype of
          VFT2_UNKNOWN: Result := 'Unknown Font';
          VFT2_FONT_RASTER: Result := 'Raster Font';
          VFT2_FONT_VECTOR: Result := 'Vector Font';
          VFT2_FONT_TRUETYPE: Result :='Truetype Font';
          else;
        end;
      VFT_VXD: Result :='Virtual Defice Identifier = ' +
          IntToHex(FixedFileInfo.dwFileSubtype, 8);
    end;
  end;


  function HasdwFileFlags(FixedFileInfo: PVSFixedFileInfo; Flag : Word) : Boolean;
  begin
    Result := (FixedFileInfo.dwFileFlagsMask and
              FixedFileInfo.dwFileFlags and
              Flag) = Flag;
  end;

  function GetFixedFileInfo: PVSFixedFileInfo;
  begin
    if not VerQueryValue(VerBuf, '', Pointer(Result), VerBufLen) then
      Result := nil
  end;

  function GetInfo(const aKey: string): string;
  begin
    Result := '';
    VerKey := Format('\StringFileInfo\%.4x%.4x\%s',
              [LoWord(Integer(VerBufValue^)),
               HiWord(Integer(VerBufValue^)), aKey]);
    if VerQueryValue(VerBuf, PChar(VerKey),VerBufValue,VerBufLen) then
      Result := StrPas(pchar(VerBufValue));
  end;

  function QueryValue(const aValue: string): string;
  begin
    Result := '';
    // obtain version information about the specified file
    if GetFileVersionInfo(PChar(sAppNamePath), VerHandle, VerSize, VerBuf) and
       // return selected version information
       VerQueryValue(VerBuf, '\VarFileInfo\Translation', VerBufValue, VerBufLen) then
         Result := GetInfo(aValue);
  end;


begin
  // Initialize the Result
  with Result do
  begin
    FileType := '';
    CompanyName := '';
    FileDescription := '';
    FileVersion := '';
    InternalName := '';
    LegalCopyRight := '';
    LegalTradeMarks := '';
    OriginalFileName := '';
    ProductName := '';
    ProductVersion := '';
    Comments := '';
    SpecialBuildStr:= '';
    PrivateBuildStr := '';
    FileFunction := '';
    DebugBuild := False;
    Patched := False;
    PreRelease:= False;
    SpecialBuild:= False;
    PrivateBuild:= False;
    InfoInferred := False;
  end;

  // Get the file type
  if SHGetFileInfo(PChar(sAppNamePath), 0, rSHFI, SizeOf(rSHFI),
    SHGFI_TYPENAME) <> 0 then
  begin
    Result.FileType := rSHFI.szTypeName;
  end;

  iRet := SHGetFileInfo(PChar(sAppNamePath), 0, rSHFI, SizeOf(rSHFI), SHGFI_EXETYPE);
  if iRet <> 0 then
  begin
    // determine whether the OS can obtain version information
    VerSize := GetFileVersionInfoSize(PChar(sAppNamePath), VerHandle);
    if VerSize > 0 then
    begin
      VerBuf := AllocMem(VerSize);
      try
        with Result do
        begin
          CompanyName      := QueryValue('CompanyName');
          FileDescription  := QueryValue('FileDescription');
          FileVersion      := QueryValue('FileVersion');
          InternalName     := QueryValue('InternalName');
          LegalCopyRight   := QueryValue('LegalCopyRight');
          LegalTradeMarks  := QueryValue('LegalTradeMarks');
          OriginalFileName := QueryValue('OriginalFileName');
          ProductName      := QueryValue('ProductName');
          ProductVersion   := QueryValue('ProductVersion');
          Comments         := QueryValue('Comments');
          SpecialBuildStr  := QueryValue('SpecialBuild');
          PrivateBuildStr  := QueryValue('PrivateBuild');
          // Fill the  VS_FIXEDFILEINFO structure
          FixedFileInfo    := GetFixedFileInfo;
          DebugBuild       := HasdwFileFlags(FixedFileInfo,VS_FF_DEBUG);
          PreRelease       := HasdwFileFlags(FixedFileInfo,VS_FF_PRERELEASE);
          PrivateBuild     := HasdwFileFlags(FixedFileInfo,VS_FF_PRIVATEBUILD);
          SpecialBuild     := HasdwFileFlags(FixedFileInfo,VS_FF_SPECIALBUILD);
          Patched          := HasdwFileFlags(FixedFileInfo,VS_FF_PATCHED);
          InfoInferred     := HasdwFileFlags(FixedFileInfo,VS_FF_INFOINFERRED);
          FileFunction     := GetFileSubType(FixedFileInfo);
        end;
      finally
        FreeMem(VerBuf, VerSize);
      end
    end;
  end
end;

procedure TAboutBox.CreditsLabelClick(Sender: TObject);
begin
 MessageBox(Application.Handle, Pchar(cre_b.Caption), 'Web Explorer', MB_ICONINFORMATION + MB_OK + MB_DEFBUTTON1);
end;

procedure TAboutBox.CreditsLabelMouseEnter(Sender: TObject);
begin
 CreditsLabel.Font.Style := [fsUnderline];
end;

procedure TAboutBox.CreditsLabelMouseLeave(Sender: TObject);
begin
 CreditsLabel.Font.Style := [];
end;

procedure TAboutBox.SystemLabelClick(Sender: TObject);
begin
 if MainForm.AMD64Mode = true then
  MessageBox(Application.Handle, Pchar('OS: ' + OS.Caption + #13 + '' + #13 + 'CPU: ' + processador.Caption + #13 + '' + #13 + MainForm.LanguageCache.Lines[319] + ' AMD64' + #13 + '' + #13 + Label3.Caption), 'Web Explorer', MB_ICONINFORMATION + MB_OK + MB_DEFBUTTON1)
 else
  MessageBox(Application.Handle, Pchar('OS: ' + OS.Caption + #13 + '' + #13 + 'CPU: ' + processador.Caption + #13 + '' + #13 + MainForm.LanguageCache.Lines[319] + ' x86' + #13 + '' + #13 + Label3.Caption), 'Web Explorer', MB_ICONINFORMATION + MB_OK + MB_DEFBUTTON1);
end;

procedure TAboutBox.SystemLabelMouseEnter(Sender: TObject);
begin
 SystemLabel.Font.Style := [fsUnderline];
end;

procedure TAboutBox.SystemLabelMouseLeave(Sender: TObject);
begin
 SystemLabel.Font.Style := [];
end;

procedure TAboutBox.LicensingInfLabelClick(Sender: TObject);
begin
 MainForm.OpenPopUpWindow('chrome://version', false);
 close;
end;

procedure TAboutBox.LicensingInfLabelMouseEnter(Sender: TObject);
begin
 LicensingInfLabel.Font.Style := [fsUnderline];
end;

procedure TAboutBox.LicensingInfLabelMouseLeave(Sender: TObject);
begin
 LicensingInfLabel.Font.Style := [];
end;

procedure TAboutBox.Loadcurrent;
var
 FvI: TFileVersionInfo;
begin
 {$IFDEF RELEASE}
  //$REVIEW_THIS
  //FvI := FileVersionInfo(ExtractFilePath(Application.ExeName) + 'Web Explorer.exe');
  FvI := FileVersionInfo(ExtractFilePath(Application.ExeName) + 'WebExplorer.exe');
 {$ELSE}
 FvI := FileVersionInfo(ExtractFilePath(Application.ExeName) + 'WebExplorer.exe');
 {$ENDIF}
 if FvI.PrivateBuildStr <> ''  then
   //Copy(FvI.FileVersion, 0, FvI.FileVersion.Length -5)
   //we_version.Caption := MainForm.LanguageCache.Lines[327] + ' ' + FvI.FileVersion +':240714 - (Vishera)' + #13 + FvI.SpecialBuildStr + ' - ' + FvI.PrivateBuildStr
   we_version.Caption := MainForm.LanguageCache.Lines[327] + ': ' + Copy(FvI.FileVersion, 0, FvI.FileVersion.Length -5) + ' (' + Copy(FvI.FileVersion, FvI.FileVersion.Length -3, FvI.FileVersion.Length) + ') - Stradivari' + #13 + FvI.SpecialBuildStr + ' - ' + FvI.PrivateBuildStr
 else
  //we_version.Caption := MainForm.LanguageCache.Lines[327] + ' ' + FvI.FileVersion +':240714 - (Vishera)' + #13 + FvI.SpecialBuildStr;
  we_version.Caption := MainForm.LanguageCache.Lines[327] + ': ' + Copy(FvI.FileVersion, 0, FvI.FileVersion.Length -5) + ' (' + Copy(FvI.FileVersion, FvI.FileVersion.Length -3, FvI.FileVersion.Length) + ') - Stradivari' + #13 + FvI.SpecialBuildStr;
end;

procedure TAboutBox.LoadIMGDLL;
var
 img: thandle;
begin
 img := loadlibrary(PChar(ExtractFilePath(Application.ExeName) + '.\CoreImages.dll'));
 try
  if img <> 0 then
   begin
    image1.Picture.Bitmap.LoadFromResourceName(img,'SOBRE');
    {if MainForm.privatemode = false then
     image1.Picture.Bitmap.LoadFromResourceName(img,'SOBRE')
    else
     image1.Picture.Bitmap.LoadFromResourceName(img,'SOBRE_PRIVATE');}
   end
  else
   begin
    Application.Terminate;
   end;
  except
   freelibrary(img);
  end;
end;

procedure TAboutBox.InitializeCaptions;
begin
  Label3.Caption := MainForm.LanguageCache.Lines[318] + ' ' + FormatByteSize(GetTotalRAM);//Format('Memoria disponível para o Sistema: %f MB',[M.dwTotalPhys / cBytesPorMb]);
  if MainForm.JvComputerInfoEx1.CPU.L3Cache <> 0 then
   processador.Caption := TrimRight(MainForm.JvComputerInfoEx1.CPU.Name) + ', ' + IntToStr(MainForm.JvComputerInfoEx1.CPU.L3Cache) + 'Mb L3 Cahe'
  else
   processador.Caption := TrimRight(MainForm.JvComputerInfoEx1.CPU.Name);
  OS.Caption := MainForm.JvComputerInfoEx1.OS.ProductName; //MainForm.GetPlataform;
end;

procedure TAboutBox.UpdateButtonClick(Sender: TObject);
begin
 we_update.Caption := MainForm.LanguageCache.Lines[326];
 try
  GetUpdates;
 EXCEPT
  we_update.Caption := MainForm.LanguageCache.Lines[321];
 end;
end;

procedure TAboutBox.updatecheckTimer(Sender: TObject);
begin
 updatecheck.Enabled := false;
 UpdateButton.Click;
end;

procedure TAboutBox.UserAgentClick(Sender: TObject);
begin
 if FileExists(Pchar(MainForm.Profile_Pach + '\LegacyBrowser.ini')) = false then
  MessageBox(Application.Handle, Pchar(MainForm.UserAgent), 'Web Explorer User Agent', MB_ICONINFORMATION + MB_OK + MB_DEFBUTTON1)
 else
  MessageBox(Application.Handle, Pchar(StringReplace(MainForm.UserAgent, ' Version/11.0', '', [rfreplaceall])), 'Web Explorer User Agent', MB_ICONINFORMATION + MB_OK + MB_DEFBUTTON1);
end;

procedure TAboutBox.UserAgentMouseEnter(Sender: TObject);
begin
 UserAgent.Font.Color := $00F59A3F;
 UserAgent.Font.Style := [fsUnderline];
end;

procedure TAboutBox.UserAgentMouseLeave(Sender: TObject);
begin
 UserAgent.Font.Color := clBlack;
 UserAgent.Font.Style := [];
end;

function GetGlobalMemoryRecord: TMemoryStatusEx;
type
  TGlobalMemoryStatusEx = procedure(var lpBuffer: TMemoryStatusEx); stdcall;
var
  ms : TMemoryStatus;
  h : THandle;
  gms : TGlobalMemoryStatusEx;
begin
  Result.dwLength := SizeOf(Result);
  h := LoadLibrary(kernel32);
  try
    if h <> 0 then
    begin
      @gms := GetProcAddress(h, 'GlobalMemoryStatusEx');
      if @gms <> nil then
        gms(Result)
      else
      begin
        ms.dwLength := SizeOf(ms);
        GlobalMemoryStatus(ms);
        Result.dwMemoryLoad := ms.dwMemoryLoad;
        Result.ullTotalPhys := ms.dwTotalPhys;
        Result.ullAvailPhys := ms.dwAvailPhys;
        Result.ullTotalPageFile := ms.dwTotalPageFile;
        Result.ullAvailPageFile := ms.dwAvailPageFile;
        Result.ullTotalVirtual := ms.dwTotalVirtual;
        Result.ullAvailVirtual := ms.dwAvailVirtual;
      end
    end;
  finally
    FreeLibrary(h);
  end;
end;

function TAboutBox.FormatByteSize(const bytes: int64): string;
const
   B = 1;
   KB = 1024 * B;
   MB = 1024 * KB;
   GB = 1024 * MB;
begin
 if bytes > GB then
  result := FormatFloat('#.## GB', bytes / GB)
 else
  if bytes > MB then
   result := FormatFloat('#.## MB', bytes / MB)
  else
   if bytes > KB then
    result := FormatFloat('#.## KB', bytes / KB)
   else
    result := FormatFloat('#.## bytes', bytes);
end;

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 updatecheck.Enabled := false;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
Loadcurrent;
LoadIMGDLL;
if FileExists(Pchar(MainForm.Profile_Pach + '\LegacyBrowser.ini')) = false then
 UserAgent.Caption := MainForm.UserAgent
else
 UserAgent.Caption := StringReplace(MainForm.UserAgent, ' Version/12.0', '', [rfreplaceall]);

end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
{if (MainForm.th1.Visible = false) or (MainForm.safemode = true) then
 begin
  Image1.Visible := false;
  we_version.Font.Color := clBlack;
  we_update.Font.Color := clBlack;
  Label1.Font.Color := clBlack;
  OS.Font.Color := clBlack;
  Label3.Font.Color := clBlack;
  PhysMem.Font.Color := clBlack;
  processador.Font.Color := clBlack;
  pc_info.Font.Color := clBlack;
  cre_b.Font.Color := clBlack;
 end
else
 begin
  Image1.Visible := true;
  we_version.Font.Color := clWhite;
  we_update.Font.Color := clWhite;
  Label1.Font.Color := clWhite;
  OS.Font.Color := clWhite;
  Label3.Font.Color := clWhite;
  PhysMem.Font.Color := clWhite;
  processador.Font.Color := clWhite;
  pc_info.Font.Color := clWhite;
  cre_b.Font.Color := clWhite;
 end;  }
InitializeCaptions;
GetLanguage;
SetFocus;
updatecheck.Enabled := true;
end;

procedure TAboutBox.GetLanguage;
begin
 Caption := MainForm.LanguageCache.Lines[317] + ' ™';
 OKButton.Caption := MainForm.LanguageCache.Lines[289];
 CreditsLabel.Caption := MainForm.LanguageCache.Lines[322];
 we_update.Caption := MainForm.LanguageCache.Lines[325];
 LicensingInfLabel.Caption := MainForm.LanguageCache.Lines[440];
 SystemLabel.Caption := MainForm.LanguageCache.Lines[441];
end;

function TAboutBox.GetTotalRAM: Int64;
begin
 Result := GetGlobalMemoryRecord.ullTotalPhys;
end;

procedure TAboutBox.GetUpdates;
var
 FvI: TFileVersionInfo;
 CMDFileStream: TStringList;
begin
 updateinfo.Clear;
 UpdateButton.ImageIndex := 0;
 Application.ProcessMessages;
 try
  updateinfo.Text := IdHTTP1.Get('http://www.webexplorerbrasil.com/FederationServices/we15_update/Update.inf');
 finally
  {$IFDEF RELEASE}
  //$REVIEW_THIS
  //FvI := FileVersionInfo(ExtractFilePath(Application.ExeName) + 'Web Explorer.exe');
  FvI := FileVersionInfo(ExtractFilePath(Application.ExeName) + 'WebExplorer.exe');
  {$ELSE}
  FvI := FileVersionInfo(ExtractFilePath(Application.ExeName) + 'WebExplorer.exe');
  {$ENDIF}
  if ConvertVerToInt(updateinfo.Lines[2]) > ConvertVerToInt(FvI.FileVersion) then
   begin
    UpdateButton.ImageIndex := 2;
    we_update.Caption := MainForm.LanguageCache.Lines[320];
    CMDFileStream := TStringList.Create;
    CMDFileStream.Add(updateinfo.Lines[2]);
    CMDFileStream.SaveToFile(Pchar(MainForm.Profile_Pach + '\NewUpdate.ini'));
    CMDFileStream.Free;
    if MessageBox(Application.Handle, Pchar(MainForm.LanguageCache.Lines[503]), PChar('Web Explorer Update'), MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = mrYes then
     begin
      ShellExecute(handle,'open',PChar(ExtractFilePath(Application.ExeName) + '.\WebExplorerUpdate.exe'), nil, nil,SW_SHOWNORMAL);
      MainForm.StopSessionAndTerminate;
     end;
   end
  else
   begin
    UpdateButton.ImageIndex := 1;
    we_update.Caption := MainForm.LanguageCache.Lines[321];
   end;
 end;
end;

procedure TAboutBox.Button1Click(Sender: TObject);
begin
MessageBox(Application.Handle, Pchar(cre_b.Caption), 'Web Explorer', MB_ICONINFORMATION + MB_OK + MB_DEFBUTTON1);

end;

function TAboutBox.ConvertVerToInt(VerStr: string): int64;
var
 Value: integer;
begin
   VerStr := trim(VerStr);
   if copy(VerStr, VerStr.Length -4, 1) = '.' then
    Value := StrtoInt(copy(VerStr, VerStr.Length -3, VerStr.Length - 4))
   else
    Value := StrtoInt(copy(VerStr, VerStr.Length -4, VerStr.Length - 5));
   Result :=  Value;
end;

{procedure TAboutBox.CreateParams(var Params: TCreateParams);
begin
   inherited CreateParams(Params);
   Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;}

end.

