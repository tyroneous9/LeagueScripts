#Include BotUtil\ImageFinder.ahk
#Include BotUtil\Settings.ahk

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
            Click left
            Send % champName
            Sleep 500
            MousePercentMove(30,22)
            Click left
            Sleep 500
            MousePercentMove(50,85)
            Click Left
            Sleep 500
            MousePercentMove(60,14)
            Click left
            Sleep 500
            Send ^a{Delete}
            Sleep 500
        }
    } else {
        MousePercentMove(46,95)
        Click left
        MousePercentMove(50,78)
        Click left
        Sleep 1000
    }
}

;move mouse % window distance
MousePercentMove(xPercent, yPercent) {
    WinGetPos, X, Y, W, H, %CLIENT_PROCESS%
    xFlat := W*1/100*xPercent
    yFlat := H*1/100*yPercent
    Mousemove xFlat, yFlat
}

/*
-------------------------------
        Ingame Utility
-------------------------------
*/

;move mouse % window distance from current pos
MouseRelativeMove(xPercent, yPercent) {
    xFlat := A_ScreenWidth*1/100*xPercent
    yFlat := A_ScreenHeight*1/100*yPercent
    Mousemove xFlat, yFlat,,R
}

;move mouse randomly some offset away from (x,y)
MoveMouseRandom(x, y, offset) {
    Random, RandX, x-offset, x+offset
    Random, RandY, y-offset, y+offset
    Mousemove RandX, RandY
}

;pan camera some distance toward (x,y)
PanCameraToward(x, y) {
    xKey := (x < SCREEN_CENTER[1]) ? SCROLL_CAM_ARR[3] : SCROLL_CAM_ARR[4]
	yKey := (y < SCREEN_CENTER[2]) ? SCROLL_CAM_ARR[1] : SCROLL_CAM_ARR[2]
    Send {%xKey% down}
    Send {%yKey% down}
    Sleep 250
    Send {%xKey% up}
    Send {%yKey% up}
}

GetDistance(ByRef point1, ByRef point2) {
    return Sqrt((point1[1] - point2[1])**2 + (point1[2] - point2[2])**2)
}

/*
-------------------------------
        Ingame Actions
-------------------------------
*/

;level all four abilities
LevelUp(ByRef MAX_ORDER) {
    Send {%HOLD_TO_LEVEL% down}
    Sleep 100
    Send % MAX_ORDER[1]
    Sleep 100
    Send % MAX_ORDER[2]
    Sleep 100
    Send % MAX_ORDER[3]
    Sleep 100
    Send % MAX_ORDER[4]
    Send {%HOLD_TO_LEVEL% up}
}

;level the given ability
LevelUpSingle(spell) {
    Send {%HOLD_TO_LEVEL% down}
    Send % spell
    Send {%HOLD_TO_LEVEL% up}
    Sleep 500
}

;buy all of a given list of items
BuyList(ByRef ITEM_LIST) {
    Send {%SHOP%}
    Sleep 500
    Loop % ITEM_LIST.Length() {
        Send ^l
        Sleep 200
        Send % ITEM_LIST[A_Index]
        Sleep 500
        Send {Enter}
        Sleep 200
    }
    Send {%SHOP%}
    Sleep 500
}

;buy the middle recommended item
BuyRecommended() {
    Send {%SHOP%}
    Sleep 500
    ShopFlag := ShopOpen()
    Mousemove ShopFlag[1], ShopFlag[2]
    Sleep 500
    MouseRelativeMove(0, -62)
    Click left
    Sleep 500
    Mousemove ShopFlag[1], ShopFlag[2]
    MouseRelativeMove(12, -20)
    loop 5 {
        Click Right down
        Sleep 200
        Click Right up
    }
    Sleep 500
    Send {%SHOP%}
    Sleep 500
}

;follow ally based on SelectAlly key
FollowAlly(ally, offset) {
    Send {%ally% down}
    Random, randX, -offset, offset
    Random, randY, -offset, offset
    Mousemove SCREEN_CENTER[1], SCREEN_CENTER[2]
    Mousemove %randX%, %randY%, , R
    Click Right
    Sleep 20
    Send {%ally% up}
}

;attack enemy with specified cast order and items
;requires enemypos
AttackEnemy(ByRef CAST_ORDER) {
    Send {%ATTACK_MOVE%}
    loop % CAST_ORDER.Length() {
        EnemyPosXY := FindEnemyXY()
        Mousemove EnemyPosXY[1], EnemyPosXY[2]
        ability := CAST_ORDER[A_Index]
        Send % ability
        Sleep 100
    }
    Loop % ITEM_SLOTS_ARR.Length() {
        SlotKey := ITEM_SLOTS_ARR[A_Index]
        Send {%SlotKey%}
    }
}

AttackMove(msDelay) {
    Send {%ATTACK_MOVE%}
    Sleep msDelay
    Click Right
    Sleep msDelay
}
;moves in opposite direction of enemy
;requires enemypos
Retreat(duration) {
    Send {%CENTER_CAMERA% down}
    EnemyPosXY := FindEnemyXY()
    awayX := SCREEN_CENTER[1] + ((SCREEN_CENTER[1]-EnemyPosXY[1]) << 3)
    awayY := SCREEN_CENTER[2] + ((SCREEN_CENTER[2]-EnemyPosXY[2]) << 3)
    Mousemove awayX, awayY
    Click down, Right
    Sleep duration
    Click up, Right
    Send {%CENTER_CAMERA% up}
}

;attempts recall. breaks if enemy OR ally is present
Recall() {
    if (FindEnemyXY() || FindAllyXY()) {
        return false
    }
    Send {%RECALL%}
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
