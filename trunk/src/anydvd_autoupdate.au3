#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icon.ico
#AutoIt3Wrapper_Outfile=c:\anydvd-auto-updater.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=--ultra-brute
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Comment=http://code.google.com/p/anydvd-auto-updater/
#AutoIt3Wrapper_Res_Description=AnyDVD Auto Updater
#AutoIt3Wrapper_Res_Fileversion=0.8.9.12
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=GPL
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Res_Field=Homepage|http://code.google.com/p/anydvd-auto-updater/
#AutoIt3Wrapper_Res_Field=Build Date|%date%
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Before=echo %fileversion% > ..\build\anydvd-auto-updater.ver
#AutoIt3Wrapper_Run_After=copy "%out%" "..\build\anydvd-auto-updater.exe"
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/bdir c:\windows\temp\ /kv 1
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/cs=0 /cn=1 /cf=1 /cv=1 /sf=1 /sv=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <INet.au3>
#include <Crypt.au3>

Global Const $s_VersionURL = "http://anydvd-auto-updater.googlecode.com/svn/tags/latest/anydvd-auto-updater.ver"
Global Const $_verURL = "http://update.slysoft.com/update/AnyDVD.ver"
Global Const $_getURL = "http://static.slysoft.com/SetupAnyDVD.exe"
Global Const $g_szName = "AnyDVD Auto Updater"
Global Const $g_szVersion = FileGetVersion(@ScriptFullPath, "FileVersion")
Global Const $g_szTitle = $g_szName & " " & $g_szVersion
Global Const $s_liveVersion = _INetGetSource($s_VersionURL, 1)
Global $_ProgramFilesDir = "C:\Program Files" ; I know AutoIt has a macro for this, but it doesn't work well
Global $_installedVersion = ""
Global $_qResult = -1

If @OSArch == "X64" Then
	$_ProgramFilesDir = "C:\Program Files (x86)"
EndIf

If FileExists($_ProgramFilesDir) == 0 Then
	$_ProgramFilesDir = @ProgramFilesDir
EndIf

If WinExists($g_szTitle) Then
	MsgBox(16, "Error", "Another instance of this program is already running.", 10) ; It's already running
	Exit 1
EndIf

AutoItWinSetTitle($g_szTitle)
AutoItSetOption("WinTitleMatchMode", 2)

If FileExists(@ScriptDir & "\Update.exe") Then
	FileDelete(@ScriptDir & "\Update.exe")
EndIf

If StringStripCR(StringStripWS($g_szVersion, 8)) <> StringStripCR(StringStripWS($s_liveVersion, 8)) And $s_liveVersion <> "" And $g_szVersion <> "" Then
	$_qResult = MsgBox(292, "Update Available", "An update is available for " & $g_szName & "." & @LF & @LF & "Update to v" & StringStripCR(StringStripWS($s_liveVersion, 8)) & " now?", 30)
	; 6 = Yes
	; 7 = No
	If $_qResult == 6 Or $_qResult == -1 Then
		FileInstall(".\Update.exe", @ScriptDir & "\Update.exe", 0)
		Run(@ScriptDir & "\Update.exe", @ScriptDir)
		Exit
	EndIf
	$_qResult = -1
EndIf

RunWait(@ComSpec & ' /c ' & 'SCHTASKS /Create /SC Daily /ST 00:00:00 /TR "' & @ScriptFullPath & '" /RU "" /TN AnyDVDUpdater /F', @SystemDir, @SW_HIDE)

If FileExists($_ProgramFilesDir & "\SlySoft\AnyDVD\AnyDVD.exe") Then
	$_installedVersion = FileGetVersion($_ProgramFilesDir & "\SlySoft\AnyDVD\AnyDVD.exe", "FileVersion")
EndIf

If $_installedVersion == "" Then
	$_installedVersion = "Not Installed"
EndIf

HttpSetUserAgent("AnyDVD " & StringReplace($_installedVersion, ".", "0") & ":" & _Crypt_HashData(_Now(), $CALG_SHA1) & ":00c43efe")

Global $downloadPage = _INetGetSource($_verURL, 1)
Global $verArray = StringRegExp($downloadPage, 'VER:([0-9.]+)', 1)
Global $_liveVersion = $verArray[0]

If $_liveVersion == "" Or $_liveVersion == "0.0.0.0" Then
	MsgBox(16, "Error", "Unable to determine version from Web.", 10)
	Exit 1
EndIf

Global $dwnldrGUI = GUICreate("AnyDVD", 380, 80, -1, -1, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
Global $cap_Installed = GUICtrlCreateLabel("v. Installed", 8, 8, 52, 20, $SS_CENTERIMAGE)
Global $cap_Live = GUICtrlCreateLabel("v. Live", 189, 8, 33, 20, $SS_CENTERIMAGE)
Global $la_vInstalled = GUICtrlCreateLabel($_installedVersion, 64, 8, 122, 20, $SS_SUNKEN)
Global $la_vLive = GUICtrlCreateLabel($_liveVersion, 248, 8, 126, 20, $SS_SUNKEN)
Global $cap_fileSize = GUICtrlCreateLabel("File size", 8, 32, 41, 20, $SS_CENTERIMAGE)
Global $la_fileSize = GUICtrlCreateLabel("", 64, 32, 122, 20, $SS_SUNKEN)
Global $cap_Transferred = GUICtrlCreateLabel("Transferred", 189, 32, 58, 17, $SS_CENTERIMAGE)
Global $la_Transferred = GUICtrlCreateLabel("", 248, 32, 126, 20, $SS_SUNKEN)
Global $dwnldProgress = GUICtrlCreateProgress(8, 62, 367, 12, $PBS_SMOOTH)
GUISetIcon("Icon.ico", $dwnldrGUI)
GUISetState(@SW_SHOW)

If $_liveVersion == $_installedVersion Then
	_WinAPI_SetWindowText($dwnldrGUI, "AnyDVD - No update available")
	Sleep(10000)
	GUIDelete()
	Exit
Else
	_WinAPI_SetWindowText($dwnldrGUI, "AnyDVD " & $_liveVersion & " - Update available!")
	FileDelete(@TempDir & "\SetupAnyDVD*.exe")
EndIf

Global $_targetFile = @TempDir & "\SetupAnyDVD" & StringReplace($_liveVersion, ".", "") & ".exe"
Global $_dwnldSize = InetGetSize($_getURL)
GUICtrlSetData($la_fileSize, Round(($_dwnldSize / 1048576), 2) & " MB")
Global $hDownload = InetGet($_getURL, $_targetFile, 1, 1) ;1 = Forces a reload from the remote site, 1 = Return immediately and download in the background
While Not InetGetInfo($hDownload, 2) ;2 = Set to True if the download is complete, False if the download is still ongoing.
	Global $_transferred = InetGetInfo($hDownload, 0)
	Global $_progress = Ceiling(($_transferred / $_dwnldSize) * 100)
	GUICtrlSetData($dwnldProgress, $_progress) ;0 = Bytes read so far (this is updated while the download progresses).
	_WinAPI_SetWindowText($dwnldrGUI, "AnyDVD " & $_liveVersion & " - Downloading " & Round($_progress, 0) & "%")
	GUICtrlSetData($la_Transferred, Round(($_transferred / 1048576), 2) & " MB")
	Sleep(250)
WEnd
GUIDelete()

RunWait('"' & @TempDir & '\SetupAnyDVD' & StringReplace($_liveVersion, ".", "") & '.exe" /S', @TempDir)

Global $pid = ProcessWait("AnyDVDtray.exe", 30)
If $pid == 0 Then
	Run('"' & $_ProgramFilesDir & '\SlySoft\AnyDVD\AnyDVD.exe"')
EndIf

WinWait("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]", "", 30)
WinActivate("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]")
WinWaitActive("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]", "", 30)
ControlClick("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]", "OK", 2)

WinWait("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]", "", 30)
WinActivate("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]")
WinWaitActive("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]", "", 30)
ControlClick("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]", "&OK", "[CLASS:TButton; INSTANCE:8]")

Exit