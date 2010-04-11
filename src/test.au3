WinWait("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]", "", 30)
WinActivate("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]")
WinWaitActive("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]", "", 30)
ControlClick("[REGEXPTITLE:AnyDVD.*?; CLASS:#32770]", "OK", 2)

WinWait("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]", "", 30)
WinActivate("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]")
WinWaitActive("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]", "", 30)
ControlClick("[REGEXPTITLE:AnyDVD.*?; CLASS:TMainForm]", "OK", 3410720)