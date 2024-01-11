#SingleInstance, force
;Init
Gui, Font, s10
controlDict := {"Spell 1":"q","Spell 2":"w","Spell 3":"e","Spell 4":"r","Sum 1":"d","Sum 2":"f","Attack Move":"a","Hold to Level":"ctrl","Shop":"p","Center camera":"space","Item slots":"1,2,3,4,5,6,7","Select Ally":"F2,F3,F4,F5","Scroll Camera":"up,down,left,right","Recall":"b"}
defaultDict := controlDict.Clone()
path := A_ScriptDir "\config.cfg"

;Notes
notes := "Make sure camera lock is dead center. `nOptions > Game > Camera Lock Mode > Fixed Offset`n`n"
Gui add, text,, %notes%

;Create GUI
infile := FileOpen(path, "r")
for control, key in controlDict {
    string := StrSplit(infile.ReadLine(), "=")[2]
    string := StrSplit(string, "`n")[1]
    controlDict[control] := string
    Gui add, text, xm r1 w130, % control
    Gui add, edit, x+m r1 w130 lowercase vEdit%A_Index%, % string
}
infile.Close()
Gui add, button, xm r1 gDefault, Default
Gui add, button, x+m r1 gSave, Save
Gui show, , Settings
return

GuiClose:
ExitApp
return

Default:
for control, key in defaultDict {
    GuiControl Text, Edit%A_Index%, % key 
}
return

Save:
Gui Submit
infile := FileOpen(path, "w")
infile.Write("")
for control, key in controlDict {
    currentInput := "Edit" . A_Index
    currentInput := RTrim(%currentInput%, OmitChars = ["`r`n"," ", "`r", "`n"])
    writeLine := Format("{1}={2}", control, currentInput)
    infile.WriteLine(writeLine)
}
infile.Close()
ExitApp
return

