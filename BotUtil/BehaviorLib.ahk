#Include "ImageFinder.ahk"
#Include "Settings.ahk"

/*
-------------------------------
            Client
-------------------------------
*/

;accepts queue and picks champ
RunClient(champName := "") {
    if IsPickingChamp() {
        while (IsPickingChamp() == True) {
            MousePercentMove(60,14)
            Click("left")
            Send(champName)
            Sleep(500)
            MousePercentMove(30,22)
            Click("left")
            Sleep(500)
            MousePercentMove(50,85)
            Click("Left")
            Sleep(500)
            MousePercentMove(60,14)
            Click("left")
            Sleep(500)
            Send("^a{Delete}")
            Sleep(500)
        }
    } else {
        MousePercentMove(46,95)
        Click("left")
        MousePercentMove(50,78)
        Click("left")
        Sleep(1000)
    }
}

;move mouse % window distance
MousePercentMove(xPercent, yPercent) {
    WinGetPos(&X, &Y, &W, &H, CLIENT_PROCESS)
    xFlat := W*1/100*xPercent
    yFlat := H*1/100*yPercent
    MouseMove(xFlat, yFlat)
}

/*
-------------------------------
        Ingame Utility
-------------------------------
*/

; gets cursor pos by reference
GetCursorPos(&x, &y) {
    point := Buffer(8)
    if DllCall("GetCursorPos", "Ptr", point) {
        x := NumGet(point, 0, "Int")
        y := NumGet(point, 4, "Int")
        return true
    }
    return false
}

; Move mouse by a percentage of the screen distance from the current position
MoveCursorRelative(xPercent, yPercent) {
    xMove := A_ScreenWidth * (xPercent / 100)
    yMove := A_ScreenHeight * (yPercent / 100)
    if GetCursorPos(&currentX, &currentY) {
        newX := currentX + xMove
        newY := currentY + yMove
        DllCall("SetCursorPos", "Int", Round(newX), "Int", Round(newY))
    } else {
        MsgBox("Failed to get the current cursor position")
    }
}

;move mouse randomly some offset away from (x,y)
MoveCursorRandom(x, y, offset) {
    RandX := Random(x-offset, x+offset)
    RandY := Random(y-offset, y+offset)
    DllCall("SetCursorPos", "int", RandX, "int", RandY)
}

;pan camera some distance toward (x,y)
PanCameraToward(x, y) {
    xKey := (x < SCREEN_CENTER[1]) ? SCROLL_CAM_ARR[3] : SCROLL_CAM_ARR[4]
	yKey := (y < SCREEN_CENTER[2]) ? SCROLL_CAM_ARR[1] : SCROLL_CAM_ARR[2]
    Send("{" xKey " down}")
    Send("{" yKey " down}")
    Sleep(250)
    Send("{" xKey " up}")
    Send("{" yKey " up}")
}

GetDistance(point1, point2) {
    return Sqrt((point1[1] - point2[1])**2 + (point1[2] - point2[2])**2)
}

/*
-------------------------------
        Ingame Actions
-------------------------------
*/

;level all four abilities
LevelUp(MAX_ORDER) {
    Send("{" HOLD_TO_LEVEL " down}")
    if(!MAX_ORDER) {
        Send(SPELL_4)
        Send(SPELL_1)
        Send(SPELL_2)
        Send(SPELL_3)
    } else {
        Send(MAX_ORDER[1])
        Send(MAX_ORDER[2])
        Send(MAX_ORDER[3])
        Send(MAX_ORDER[4])
    }
    Send("{" HOLD_TO_LEVEL " up}")
}

;level the given ability
LevelUpSingle(spell) {
    Send("{" HOLD_TO_LEVEL " down}")
    Send(spell)
    Send("{" HOLD_TO_LEVEL " up}")
    Sleep(500)
}

;buy all of a given list of items
BuyList(ITEM_LIST) {
    Send("{" SHOP "}")
    Sleep(500)
    Loop ITEM_LIST.Length {
        Send("^l")
        Sleep(200)
        Send(ITEM_LIST[A_Index])
        Sleep(500)
        Send("{Enter}")
        Sleep(200)
    }
    Send("{" SHOP "}")
    Sleep(500)
}

;buy the middle recommended item, offset to the right
BuyRecommended() {
    Send("{" SHOP "}")
    Sleep(500)
    if(ShopFlag := ShopOpen()) {
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        Sleep(500)
        MoveCursorRelative(0, -62)
        Click("left")
        Sleep(500)
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        MoveCursorRelative(17, -20)
        Loop 5 {
            Click("Right down")
            Sleep(200)
            Click("Right up")
        }
    }
    Sleep(500)
    Send("{" SHOP "}")
}

;buy legendary anvil (ARENA ONLY)
BuyLegendaryAnvil() {
    if(ShopFlag := ShopOpen()) {
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        Sleep(500)
        MoveCursorRelative(14, -62)
        Click
        Sleep(500)
        DllCall("SetCursorPos", "int", ShopFlag[1], "int", ShopFlag[2])
        MoveCursorRelative(5, -25)
        Click("Right down")
        Sleep(200)
        Click("Right up")
        Sleep(500)
        Send("{" SHOP "}")
        Sleep(500)
        DllCall("SetCursorPos", "int", SCREEN_CENTER[1], "int", SCREEN_CENTER[2])
        loop 5 {
            Click
            Sleep 400
        }
    }
}

;follow ally based on SelectAlly key
FollowAlly(ally, offset) {
    Send("{" ally " down}")
    MoveCursorRandom(SCREEN_CENTER[1], SCREEN_CENTER[2], offset)
    Click("Right")
    Send("{" ally " up}")
}

;attack enemy with specified cast order and items
;requires enemypos
AttackEnemy(CAST_ORDER, &EnemyPosXY) {
    Send("{" ATTACK_MOVE "}")
    Loop CAST_ORDER.Length {
        DllCall("SetCursorPos", "int", EnemyPosXY[1], "int", EnemyPosXY[2])
        ability := CAST_ORDER[A_Index]
        Send(ability)
        Sleep(100)
    }
    Loop ITEM_SLOTS_ARR.Length {
        SlotKey := ITEM_SLOTS_ARR[A_Index]
        Send("{" SlotKey "}")
    }
}

AttackMove(msDelay) {
    Send("{" ATTACK_MOVE "}")
    Sleep(msDelay)
    Click("Right")
    Sleep(msDelay)
}
;moves in opposite direction of enemy
;requires enemypos
Retreat(duration) {
    Send("{" CENTER_CAMERA " down}")
    EnemyPosXY := FindEnemyXY()
    awayX := SCREEN_CENTER[1] + ((SCREEN_CENTER[1]-EnemyPosXY[1]) << 3)
    awayY := SCREEN_CENTER[2] + ((SCREEN_CENTER[2]-EnemyPosXY[2]) << 3)
    DllCall("SetCursorPos", "int", awayX, "int", awayY)
    Click("down, Right")
    Sleep(duration)
    Click("up, Right")
    Send("{" CENTER_CAMERA " up}")
}

;attempts recall. breaks if enemy OR ally is present
AttemptRecall() {
    if (FindEnemyXY() || FindAllyXY()) {
        return false
    }
    Send("{" RECALL "}")
    startTime := A_TickCount
    while (!FindEnemyXY() && !FindAllyXY()) {
        if (A_TickCount-startTime > 9000) {
            BuyRecommended()
            LevelUp(MAX_ORDER)
            return true
        }
    }
    return false
}


/*
-------------------------------
      Testing and Utility
-------------------------------
*/

; prints user keybindings
PrintKeys() {
    infile := FileOpen(A_ScriptDir "\config.cfg", "r")
    if (!infile)
    {
        MsgBox("Error reading config file.")
        return
    }
    configFileContent := infile.read()
    infile.Close()

    MsgBox(configFileContent)
}

; prints metadata
PrintMetaData() {
    constants .= "Client Process: " . CLIENT_PROCESS . "`n"
    constants .= "Game Process: " . GAME_PROCESS . "`n"
    constants .= "Screen Center: " . SCREEN_CENTER . "`n"
    MsgBox(constants)
}

; moves mouse in various contexts
TestMouseMove() {

}