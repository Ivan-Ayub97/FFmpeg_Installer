
#define MyAppName "FFmpeg Binaries"
#define MyAppVersion "2025.10.21" 
#define MyAppPublisher "Unofficial Utility by Ivan-Ayub97"
#define MyInstallDirName "FFmpeg"
#define FfmpegWebURL "https://ffmpeg.org"

[Setup]
AppId={{CB6CAC20-DE75-45B0-AD32-95F8F30A6F86} 


AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#FfmpegWebURL}
AppSupportURL={#FfmpegWebURL}    
AppUpdatesURL={#FfmpegWebURL} 

DefaultDirName={autopf}\{#MyInstallDirName} 
DisableDirPage=no

SetupIconFile={src}\logo.ico
UninstallDisplayIcon={app}\logo.ico
Compression=lzma2/ultra64
SolidCompression=yes
OutputDir={src}
OutputBaseFilename=FFmpeg_Setup_{#MyAppVersion}

ChangesEnvironment=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "{src}\LICENSE.txt"

[Files]

Source: "{src}\ffmpeg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{src}\ffplay.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{src}\ffprobe.exe"; DestDir: "{app}"; Flags: ignoreversion


Source: "{src}\logo.ico"; DestDir: "{app}"; Flags: ignoreversion

[Code]

const
  EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

procedure EnvAddPath(Path: string);
var
  Paths: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    Paths := '';
  if Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';') = 0 then
  begin
    if (Paths <> '') and (Paths[Length(Paths)] <> ';') then
      Paths := Paths + ';';
    Paths := Paths + Path;
    RegWriteExpandStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths);
  end;
end;

procedure EnvRemovePath(Path: string);
var
  Paths: string;
  P: Integer;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then exit;
  P := Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';');
  if P = 0 then exit;
  if P > 1 then P := P - 1;
  Delete(Paths, P, Length(Path) + 1);
  RegWriteExpandStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths);
end;
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    EnvAddPath(ExpandConstant('{app}'));
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    EnvRemovePath(ExpandConstant('{app}'));
  end;
end;