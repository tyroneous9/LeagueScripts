;A_ScriptDir MUST BE IN LEAGUE_SCRIPTS
SetWorkingDir(A_ScriptDir "\resources")

;Functions
TestImageFinder() {
    ShopCoords := ShopOpen()
    MouseMove(ShopCoords[1], ShopCoords[2])
}

FindPlayerXY(){
    ErrorLevel := !ImageSearch(&playerHealthX, &playerHealthY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*10 player_health.PNG")
    if !ErrorLevel
        return [playerHealthX+.02*A_ScreenWidth,playerHealthY+.13*A_ScreenHeight]
}

FindAllyXY(){
    ErrorLevel := !ImageSearch(&allyHealthX, &allyHealthY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*10 ally_health.PNG")
    if !ErrorLevel
        return [allyHealthX+.02*A_ScreenWidth,allyHealthY+.13*A_ScreenHeight]
}

FindEnemyXY(){
    ErrorLevel := !ImageSearch(&enemyHealthX, &enemyHealthY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*10 enemy_health.PNG")
    if !ErrorLevel
        return [enemyHealthX+.02*A_ScreenWidth,enemyHealthY+.13*A_ScreenHeight]
        
}

ShopOpen(){
    ErrorLevel := !ImageSearch(&shopX, &shopY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*10 shop_flag.PNG")
    if !ErrorLevel
        return [shopX, shopY]
}

ExitArena(){
    ErrorLevel := !ImageSearch(&ExitArenaX, &ExitArenaY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*10 arena_exit.PNG")
    if !ErrorLevel {
        DllCall("SetCursorPos", "int", ExitArenaX, "int", ExitArenaY)
        Click
        Sleep(10000)
    }
}

IsDead(){
    ErrorLevel := !ImageSearch(&isDeadX, &isDeadY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*5 death_flag.PNG")
    if !ErrorLevel
        return True
}

IsPickingChamp(){
    ErrorLevel := !ImageSearch(&isPickingChampX, &isPickingChampY, 0, 0, A_ScreenWidth, A_ScreenHeight, "inactive_lock.PNG")
        if !Errorlevel
            return True
}

AcceptQueue(){
    ErrorLevel := !ImageSearch(&AcceptQueueX, &AcceptQueueY, 0, 0, A_ScreenWidth, A_ScreenHeight, "match_found.PNG")
        if !Errorlevel {
            Click(AcceptQueueX ", " AcceptQueueY)
            MouseMove(0, 0)
        }
}

Surrender(){
    ErrorLevel := !ImageSearch(&SurrenderX, &SurrenderY, 0, 0, A_ScreenWidth, A_ScreenHeight, "surrender.PNG")
        if !Errorlevel {
            DllCall("SetCursorPos", "int", SurrenderX, "int", SurrenderY)
            Click
            Sleep(30000)
        }
}

SurrenderArena(){
    ErrorLevel := !ImageSearch(&SurrenderX, &SurrenderY, 0, 0, A_ScreenWidth, A_ScreenHeight, "surrender_arena.PNG")
        if !Errorlevel {
            DllCall("SetCursorPos", "int", SurrenderX, "int", SurrenderY)
            Click
            Sleep(30000)
        }
}

