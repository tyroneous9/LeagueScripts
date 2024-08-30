﻿#SingleInstance force
; Init
myGui := Gui()
myGui.OnEvent("Close", GuiClose)
myGui.SetFont("s10")
controlDict := Map()
controlDict["Spell 1"] := "q"
controlDict["Spell 2"] := "w"
controlDict["Spell 3"] := "e"
controlDict["Spell 4"] := "r"
controlDict["Sum 1"] := "d"
controlDict["Sum 2"] := "f"
controlDict["Hold to Level"] := "ctrl"
controlDict["Shop"] := "p"
controlDict["Center camera"] := "space"
controlDict["Item 1"] := "1"
controlDict["Item 2"] := "2"
controlDict["Item 3"] := "3"
controlDict["Item 4"] := "5"
controlDict["Item 5"] := "6"
controlDict["Item 6"] := "7"
controlDict["Select Ally 1"] := "F2"
controlDict["Select Ally 2"] := "F3"
controlDict["Select Ally 3"] := "F4"
controlDict["Select Ally 4"] := "F5"
controlDict["Recall"] := "b"
controlDict["Champion name"] := " "
defaultDict := controlDict.Clone()

; Create GUI
path := A_ScriptDir "\config\controls.cfg"
infile := FileOpen(path, "r")
if (!infile) {
    infile := FileOpen(path, "w")
    infile.Close()
    infile := FileOpen(path, "r")
}

editControls := Map()

for control, key in controlDict {
    line := infile.ReadLine()
    if (line) {
        str := StrSplit(line, "=")[2]
        str := StrSplit(str, "`n")[1]
        controlDict[control] := str
    } else {
        controlDict[control] := defaultDict[control]
    }
    myGui.add("text", "xm r1 w130", control)
    editControl := myGui.add("edit", "x+m r1 w130 lowercase", controlDict[control])
    editControls[control] := editControl
}
infile.Close()

ogcbuttonDefault := myGui.add("button", "xm r1", "Default")
ogcbuttonDefault.OnEvent("Click", Default.Bind(editControls, defaultDict))
ogcbuttonSave := myGui.add("button", "x+m r1", "Save")
ogcbuttonSave.OnEvent("Click", Save.Bind(editControls, controlDict, path))
myGui.Title := "Settings"
myGui.show()
return

GuiClose(*) {
    ExitApp()
    return
}

Default(editControls, defaultDict, *) {
    for control, editControl in editControls {
        editControl.Text := defaultDict[control]
    }
    return
}

Save(editControls, controlDict, path, *) {
    infile := FileOpen(path, "w")
    for control, editControl in editControls {
        OmitChars := "`r`n "
        currentInput := RTrim(editControl.Text, OmitChars)
        writeLine := Format("{1}={2}", control, currentInput)
        infile.WriteLine(writeLine)
    }
    infile.Close()
    ExitApp()
    return
}
