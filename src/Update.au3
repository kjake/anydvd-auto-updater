#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icon.ico
#AutoIt3Wrapper_Outfile=c:\Update.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_UseUpx=Y
#AutoIt3Wrapper_UPX_Parameters=--ultra-brute
#AutoIt3Wrapper_Res_Comment=http://code.google.com/p/anydvd-auto-updater/
#AutoIt3Wrapper_Res_Description=AnyDVD Auto Updater Updater
#AutoIt3Wrapper_Res_Fileversion=1.0.0.5
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=GPL
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Res_Field=Homepage|http://code.google.com/p/anydvd-auto-updater/
#AutoIt3Wrapper_Res_Field=Build Date|%date%
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_After=copy "%out%" ".\Update.exe"
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/bdir c:\windows\temp\ /kv 1
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/cs=1 /cn=1 /cf=1 /cv=1 /sf=1 /sv=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global $g_szTitle = "AnyDVD Auto Updater Updater"
If WinExists($g_szTitle) Then Exit ; It's already running
AutoItWinSetTitle($g_szTitle)

SplashTextOn("", "Updating...", 120, 40, -1, -1, 33, "", "10", 800)

Global Const $s_UpdateURL = "http://anydvd-auto-updater.googlecode.com/svn/tags/latest/anydvd-auto-updater.exe"
Global $pid = ProcessExists("anydvd-auto-updater.exe")
If $pid <> 0 Then
	ProcessClose($pid)
EndIf
FileDelete(@ScriptDir & "\anydvd-auto-updater.exe")
InetGet($s_UpdateURL, @ScriptDir & "\anydvd-auto-updater.exe")
Run(@ScriptDir & "\anydvd-auto-updater.exe", @ScriptDir)

Exit