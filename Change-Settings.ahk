#SingleInstance force
; Init
myGui := Gui()
myGui.OnEvent("Close", GuiClose)
myGui.SetFont("s10")
configMap := Map()
configMap["Spell 1"] := "q"
configMap["Spell 2"] := "w"
configMap["Spell 3"] := "e"
configMap["Spell 4"] := "r"
configMap["Sum 1"] := "d"
configMap["Sum 2"] := "f"
configMap["Hold to Level"] := "ctrl"
configMap["Shop"] := "p"
configMap["Center camera"] := "space"
configMap["Item 1"] := "1"
configMap["Item 2"] := "2"
configMap["Item 3"] := "3"
configMap["Item 4"] := "5"
configMap["Item 5"] := "6"
configMap["Item 6"] := "7"
configMap["Select Ally 1"] := "F2"
configMap["Select Ally 2"] := "F3"
configMap["Select Ally 3"] := "F4"
configMap["Select Ally 4"] := "F5"
configMap["Recall"] := "b"
configMap["Champion name"] := " "
defaultMap := configMap.Clone()

/*
; Add general settings
MyGui.Add("Text", "r2", "GENERAL")
myGui.add("text", "xm r1 w130", "Surrender?")
MyGui.Add("CheckBox", "vSurrender", "Always Surrender?")
*/

; Add controls
MyGui.Add("Text", "r2", "CONTROLS")
path := A_ScriptDir "\config.cfg"
infile := FileOpen(path, "r")
if (!infile) {
    infile := FileOpen(path, "w")
    infile.Close()
    infile := FileOpen(path, "r")
}

guiMap := Map()

for key in configMap {
    text := infile.ReadLine()
    if (text) {
        str := StrSplit(text, "=")[2]
        str := StrSplit(str, "`n")[1]
        configMap[key] := str
    } else {
        configMap[key] := defaultMap[key]
    }
    myGui.add("text", "xm r1 w130", key)
    line := myGui.add("edit", "x+m r1 w130 lowercase", configMap[key])
    guiMap[key] := line
}
infile.Close()

ogcbuttonDefault := myGui.add("button", "xm r1", "Default")
ogcbuttonDefault.OnEvent("Click", Default.Bind(guiMap, defaultMap))
ogcbuttonSave := myGui.add("button", "x+m r1", "Save")
ogcbuttonSave.OnEvent("Click", Save.Bind(guiMap, configMap, path))
myGui.Title := "Settings"
myGui.show()
return

GuiClose(*) {
    ExitApp()
    return
}

Default(guiMap, defaultMap, *) {
    for key, line in guiMap {
        line.Text := defaultMap[key]
    }
    return
}

Save(guiMap, configMap, path, *) {
    infile := FileOpen(path, "w")
    for key, line in guiMap {
        OmitChars := "`r`n "
        currentInput := RTrim(line.Text, OmitChars)
        writeLine := Format("{1}={2}", key, currentInput)
        infile.WriteLine(writeLine)
    }
    infile.Close()
    ExitApp()
    return
}
