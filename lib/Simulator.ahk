#Include <ImageFinder>
#Include <Settings>

class Simulator {

    __New() {
        ; Metadata
        this.CHAMPION := ""
        this.SCREEN_CENTER := [A_ScreenWidth / 2, (A_ScreenHeight / 2) - 10]
        this.CLIENT_PROCESS := "ahk_exe LeagueClientUx.exe"
        this.GAME_PROCESS := "League of Legends (TM) Client"
        
        ; Controls
        this.ATTACK_MOVE := ""
        this.CENTER_CAMERA := ""
        this.HOLD_TO_LEVEL := ""
        this.ITEM_SLOTS_ARR := []
        this.RECALL := ""
        this.SCROLL_CAM_ARR := []
        this.SELECT_ALLY_ARR := []
        this.SHOP := ""
        this.SPELL_1 := ""
        this.SPELL_2 := ""
        this.SPELL_3 := ""
        this.SPELL_4 := ""
        this.SUM_1 := ""
        this.SUM_2 := ""
        
        ; Other
        this.ImageFinder := ImageFinder()

        ; Load config file
        infile := FileOpen(A_ScriptDir "\config\controls.cfg", "r")
        if (!infile) {
            MsgBox("Error reading config file.")
            return
        }
        configFileContent := infile.read()
        infile.Close()

        ; Parsing config file
        lines := StrSplit(configFileContent, "`n", "`r")
        for index, line in lines {
            keyValue := StrSplit(line, "=")
            if (keyValue.Length >= 2) {
                Switch keyValue[1] {
                    case "Attack Move":
                        this.ATTACK_MOVE := keyValue[2]
                    case "Center camera":
                        this.CENTER_CAMERA := keyValue[2]
                    case "Hold to Level":
                        this.HOLD_TO_LEVEL := keyValue[2]
                    case "Item slots":
                        this.ITEM_SLOTS_ARR := StrSplit(keyValue[2], ",")
                    case "Recall":
                        this.RECALL := keyValue[2]
                    case "Scroll Camera":
                        this.SCROLL_CAM_ARR := StrSplit(keyValue[2], ",")
                    case "Select Ally":
                        this.SELECT_ALLY_ARR := StrSplit(keyValue[2], ",")
                    case "Shop":
                        this.SHOP := keyValue[2]
                    case "Spell 1":
                        this.SPELL_1 := keyValue[2]
                    case "Spell 2":
                        this.SPELL_2 := keyValue[2]
                    case "Spell 3":
                        this.SPELL_3 := keyValue[2]
                    case "Spell 4":
                        this.SPELL_4 := keyValue[2]
                    case "Sum 1":
                        this.SUM_1 := keyValue[2]
                    case "Sum 2":
                        this.SUM_2 := keyValue[2]
                    case "Champion":
                        this.CHAMPION := keyValue[2]
                }
            }
        }
    }

/*
-------------------------------
            Client
-------------------------------
*/

;Accepts queue and picks champ
RunClient(champName := "") {
    if this.ImageFinder.IsPickingChamp() {
        while (this.ImageFinder.IsPickingChamp() == True) {
            this.MousePercentMove(60, 14, this.CLIENT_PROCESS) ;search bar
            Click("left")
            Sleep(500)
            this.MousePercentMove(30, 22, this.CLIENT_PROCESS) ;random champ icon
            Click("left")
            Sleep(500)
            this.MousePercentMove(60, 14, this.CLIENT_PROCESS) ;search bar
            Click("left")
            Send(champName)
            Sleep(500)
            this.MousePercentMove(30, 22, this.CLIENT_PROCESS) ;user champ icon
            Click("left")
            Sleep(500)
            this.MousePercentMove(50, 85, this.CLIENT_PROCESS) ;lock in
            Click("Left")
            Sleep(500)
        }
    } else {
        this.MousePercentMove(46, 95, this.CLIENT_PROCESS)
        Click("left")
        this.MousePercentMove(50, 78, this.CLIENT_PROCESS) 
        Click("left")
        Sleep(1000)
        this.ImageFinder.CloseFeedback()
    }
}

;Move mouse % window distance
MousePercentMove(xPercent, yPercent, window) {
    if (!WinActive(window)) {
        Sleep 1000
    } else {
        WinGetPos(&X, &Y, &W, &H, window)
        xFlat := W*1/100*xPercent
        yFlat := H*1/100*yPercent
        MouseMove(xFlat, yFlat)
    }
}

;Gets cursor pos by reference
GetCursorPos(&x, &y) {
    point := Buffer(8)
    if DllCall("GetCursorPos", "Ptr", point) {
        x := NumGet(point, 0, "Int")
        y := NumGet(point, 4, "Int")
        return true
    }
    return false
}

;Move mouse by a percentage of the screen distance from the current position
MoveCursorRelative(xPercent, yPercent) {
    xMove := A_ScreenWidth * (xPercent / 100)
    yMove := A_ScreenHeight * (yPercent / 100)
    if this.GetCursorPos(&currentX, &currentY) {
        newX := currentX + xMove
        newY := currentY + yMove
        DllCall("SetCursorPos", "Int", Round(newX), "Int", Round(newY))
    } else {
        MsgBox("Failed to get the current cursor position")
    }
}

;Move mouse randomly some offset away from (x,y)
MoveCursorRandom(x, y, offset) {
    RandX := Random(x - offset, x + offset)
    RandY := Random(y - offset, y + offset)
    DllCall("SetCursorPos", "int", RandX, "int", RandY)
}

;Pan camera some distance toward (x,y)
PanCameraToward(x, y) {
    xKey := (x < this.SCREEN_CENTER[1]) ? this.SCROLL_CAM_ARR[3] : this.SCROLL_CAM_ARR[4]
    yKey := (y < this.SCREEN_CENTER[2]) ? this.SCROLL_CAM_ARR[1] : this.SCROLL_CAM_ARR[2]
    Send("{" xKey " down}")
    Send("{" yKey " down}")
    Sleep(250)
    Send("{" xKey " up}")
    Send("{" yKey " up}")
}

GetDistance(point1, point2) {
    return Sqrt((point1[1] - point2[1])**2 + (point1[2] - point2[2])**2)
}

;Level all four abilities
LevelUp(MAX_ORDER) {
    Send("{" this.HOLD_TO_LEVEL " down}")
    if(!MAX_ORDER) {
        Send(this.SPELL_4)
        Send(this.SPELL_1)
        Send(this.SPELL_2)
        Send(this.SPELL_3)
    } else {
        Send(MAX_ORDER[1])
        Send(MAX_ORDER[2])
        Send(MAX_ORDER[3])
        Send(MAX_ORDER[4])
    }
    Send("{" this.HOLD_TO_LEVEL " up}")
}

;Level the given ability
LevelUpSingle(spell) {
    Send("{" this.HOLD_TO_LEVEL " down}")
    Send(spell)
    Send("{" this.HOLD_TO_LEVEL " up}")
    Sleep(500)
}

;Buy all of a given list of items
BuyList(ITEM_LIST) {
    Send("{" this.SHOP "}")
    Sleep(500)
    Loop ITEM_LIST.Length {
        Send("^l")
        Sleep(200)
        Send(ITEM_LIST[A_Index])
        Sleep(500)
        Send("{Enter}")
        Sleep(200)
    }
    Send("{" this.SHOP "}")
    Sleep(500)
}

;Buy the middle recommended item, offset to the right
BuyRecommended() {
    Send("{" this.SHOP "}")
    Sleep(500)
    if(ShopFlag := this.ImageFinder.ShopOpen()) {
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        Sleep(500)
        this.MoveCursorRelative(0, -62)
        Click("left")
        Sleep(500)
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        this.MoveCursorRelative(17, -20)
        Loop 5 {
            Click("Right down")
            Sleep(200)
            Click("Right up")
        }
    }
    Sleep(500)
    Send("{" this.SHOP "}")
}

;Buy legendary anvil in Arena
BuyLegendaryAnvil() {
    if(ShopFlag := this.ImageFinder.ShopOpen()) {
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        Sleep(500)
        this.MoveCursorRelative(14, -62)
        Click
        Sleep(500)
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        this.MoveCursorRelative(5, -25)
        Click("Right down")
        Sleep(200)
        Click("Right up")
        Sleep(500)
        Send("{" this.SHOP "}")
        Sleep(500)
        DllCall("SetCursorPos", "int", this.SCREEN_CENTER[1], "int", this.SCREEN_CENTER[2])
        Click
        Sleep 400
    }
}

;Follow ally based on SelectAlly key
FollowAlly(ally, offset) {
    Send("{" ally " down}")
    this.MoveCursorRandom(this.SCREEN_CENTER[1], this.SCREEN_CENTER[2], offset)
    Click("Right")
    Send("{" ally " up}")
}

;Attack enemy with specified cast order and items
AttackEnemy(CAST_ORDER, &EnemyPosXY) {
    Loop CAST_ORDER.Length {
        DllCall("SetCursorPos", "int", EnemyPosXY[1], "int", EnemyPosXY[2])
        Send("{" this.ATTACK_MOVE "}")
        ability := CAST_ORDER[A_Index]
        Send(ability)
        Sleep(100)
    }
    Loop this.ITEM_SLOTS_ARR.Length {
        SlotKey := this.ITEM_SLOTS_ARR[A_Index]
        Send("{" SlotKey "}")
    }
}

AttackMove(msDelay) {
    Send("{" this.ATTACK_MOVE "}")
    Sleep(msDelay)
    Click("Right")
    Sleep(msDelay)
}

;Moves in opposite direction of enemy
Retreat(duration) {
    Send("{" this.CENTER_CAMERA " down}")
    EnemyPosXY := this.ImageFinder.FindEnemyXY()
    awayX := this.SCREEN_CENTER[1] + ((this.SCREEN_CENTER[1] - EnemyPosXY[1]) << 3)
    awayY := this.SCREEN_CENTER[2] + ((this.SCREEN_CENTER[2] - EnemyPosXY[2]) << 3)
    DllCall("SetCursorPos", "int", awayX, "int", awayY)
    Click("down, Right")
    Sleep(duration)
    Click("up, Right")
    Send("{" this.CENTER_CAMERA " up}")
}

;Attempts recall. breaks if enemy OR ally is present
AttemptRecall() {
    if (this.ImageFinder.FindEnemyXY() || this.ImageFinder.FindAllyXY()) {
        return false
    }
    Send("{" this.RECALL "}")
    startTime := A_TickCount
    while (!this.ImageFinder.FindEnemyXY() && !this.ImageFinder.FindAllyXY()) {
        if (A_TickCount - startTime > 9000) {
            this.BuyRecommended()
            this.LevelUp(MAX_ORDER)
            return true
        }
    }
    return false
}

;Types in surrender vote /ff
Surrender() {
    Send("{Enter}")
    Sleep 200
    Send("/ff")
    Send("{Enter}")
}

/*
-------------------------------
  Testing and Utility
-------------------------------
*/

; tests speed of a run
TimeTest() {
    NumRuns := 30
    TotalRuntime := 0
    loop NumRuns {
        StartTime := A_TickCount
        ;RUN FUNCTION HERE
        /*****************/

        /*****************/
        TotalRuntime := TotalRuntime + (A_TickCount - StartTime)
    }
    MsgBox "Total Time: " TotalRuntime " ms"
        .  "`n`nAverage Time: " TotalRuntime / NumRuns " ms"
}

; Checks image found + info
ImageFound(searchResult) {
    MsgBox "Found:`t" (IsObject(searchResult)?searchResult.Length:searchResult)
      . "`n`nTime:`t" (A_TickCount - t1) " ms"
      . "`n`nPos:`t" foundX ", " foundY
      . "`n`nResult:`t<" (IsObject(searchResult)?searchResult[1].id:"") ">", "Tip", 4096
}

; Prints all keys
PrintKeys() {
    controls := [
        this.ATTACK_MOVE,
        this.CENTER_CAMERA,
        this.HOLD_TO_LEVEL,
        this.RECALL,
        this.SHOP,
        this.SPELL_1,
        this.SPELL_2,
        this.SPELL_3,
        this.SPELL_4,
        this.SUM_1,
        this.SUM_2
    ]

    ; Print keys string
    pressedKeys := "List of keys:`n"

    ; Press single keys
    for index, control in controls {
        if (control != "") {
            pressedKeys .= control . "`n" 
        }
    }

    ; Press item slots
    for index, slot in this.ITEM_SLOTS_ARR {
        if (slot != "") {
            pressedKeys .= slot . "`n"
        }
    }

    ; Press select ally controls
    for index, ally in this.SELECT_ALLY_ARR {
        if (ally != "") {
            pressedKeys .= ally . "`n"
        }
    }

    ; Press scroll camera controls
    for index, scroll in this.SCROLL_CAM_ARR {
        if (scroll != "") {
            pressedKeys .= scroll . "`n"
        }
    }

    ; Display the pressed keys in a message box
    MsgBox pressedKeys
}

; Prints config file content
PrintConfig() {
    infile := FileOpen(A_ScriptDir "\config.cfg", "r")
    if (!infile) {
        MsgBox("Error reading config file.")
        return
    }
    configFileContent := infile.read()
    infile.Close()

    MsgBox(configFileContent)
}

; Prints metadata
PrintMetaData() {
    constants .= "Client Process: " . this.CLIENT_PROCESS . "`n"
    constants .= "Game Process: " . this.GAME_PROCESS . "`n"
    constants .= "Screen Center: " . this.SCREEN_CENTER[1] . ", " . this.SCREEN_CENTER[2] . "`n"
    MsgBox(constants)
}

; Prints a_script dir
PrintADir(){
    currentDir := A_ScriptDir
    fileList := ""
    Loop Files, currentDir "\*.*", "FD"
    {
        fileList .= A_LoopFileName "`n" 
    }
    MsgBox "Files in " currentDir ":`n`n" fileList
}

} ; End class