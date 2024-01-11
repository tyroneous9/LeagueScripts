#SingleInstance, force
#NoEnv
#InstallKeybdHook
#UseHook
CoordMode Pixel Window
CoordMode Mouse Window
SendMode Event
SetBatchLines -1
SetMouseDelay 1
SetDefaultMouseSpeed 0


;Psuedo Constants
global CLIENT_PROCESS
global GAME_PROCESS
global CHAMP_NAME
global SCREEN_CENTER
global ATTACK_MOVE
global CENTER_CAMERA
global HOLD_TO_LEVEL
global ITEM_SLOTS_ARR
global RECALL
global SCROLL_CAM_ARR
global SELECT_ALLY_ARR
global SHOP
global SPELL_1
global SPELL_2
global SPELL_3
global SPELL_4
global SUM_1
global SUM_2

LoadScript() {
    ; A_ScriptDir MUST BE IN LEAGUE_SCRIPTS
    infile := FileOpen(A_ScriptDir "\config.cfg", "r")
    if (!infile)
    {
        MsgBox, Error reading config file.
        return
    }
    configFileContent := infile.read()
    infile.Close()
    ; Parsing the configuration file
    lines := StrSplit(configFileContent, "`n", "`r")
    for index, line in lines {
        keyValue := StrSplit(line, "=")
        if (keyValue.Length() >= 2) {
            switch keyValue[1]
            {
                case "Attack Move":
                    ATTACK_MOVE := keyValue[2]
                case "Center camera":
                    CENTER_CAMERA := keyValue[2]
                case "Hold to Level":
                    HOLD_TO_LEVEL := keyValue[2]
                case "Item slots":
                    ITEM_SLOTS_ARR := StrSplit(keyValue[2], ",")
                case "Recall":
                    RECALL := keyValue[2]
                case "Scroll Camera":
                    SCROLL_CAM_ARR := StrSplit(keyValue[2], ",")
                case "Select Ally":
                    SELECT_ALLY_ARR := StrSplit(keyValue[2], ",")
                case "Shop":
                    SHOP := keyValue[2]
                case "Spell 1":
                    SPELL_1 := keyValue[2]
                case "Spell 2":
                    SPELL_2 := keyValue[2]
                case "Spell 3":
                    SPELL_3 := keyValue[2]
                case "Spell 4":
                    SPELL_4 := keyValue[2]
                case "Sum 1":
                    SUM_1 := keyValue[2]
                case "Sum 2":
                    SUM_2 := keyValue[2]
            }
        }
    }
    
    ; Metadata
    SCREEN_CENTER := [A_ScreenWidth/2, (A_ScreenHeight/2)-10]
    CLIENT_PROCESS := "ahk_exe LeagueClientUx.exe"
    GAME_PROCESS := "League of Legends (TM) Client"
}

PrintKeys() {
    infile := FileOpen(A_ScriptDir "\config.cfg", "r")
    if (!infile)
    {
        MsgBox, Error reading config file.
        return
    }
    configFileContent := infile.read()
    infile.Close()

    msgbox % configFileContent
}