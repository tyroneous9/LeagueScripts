;A_ScriptDir MUST BE IN LEAGUE_SCRIPTS
SetWorkingDir % A_ScriptDir "\resources"

;Functions
TestImageFinder() {
    ShopCoords := ShopOpen()
    Mousemove ShopCoords[1], ShopCoords[2]
}

FindPlayerXY(){
    ImageSearch, playerHealthX, playerHealthY, 0,0,A_ScreenWidth,A_ScreenHeight, *10 player_health.PNG
    if !ErrorLevel
        return [playerHealthX+.02*A_ScreenWidth,playerHealthY+.13*A_ScreenHeight]
}

FindAllyXY(){
    ImageSearch, allyHealthX, allyHealthY, 0,0,A_ScreenWidth,A_ScreenHeight, *10 ally_health.PNG
    if !ErrorLevel
        return [allyHealthX+.02*A_ScreenWidth,allyHealthY+.13*A_ScreenHeight]
}

FindEnemyXY(){
    ImageSearch, enemyHealthX, enemyHealthY, 0,0,A_ScreenWidth,A_ScreenHeight, *10 enemy_health.PNG	
    if !ErrorLevel
        return [enemyHealthX+.02*A_ScreenWidth,enemyHealthY+.13*A_ScreenHeight]
        
}

ShopOpen(){
    ImageSearch, shopX, shopY, 0,0,A_ScreenWidth,A_ScreenHeight, *10 shop_flag.PNG
    if !ErrorLevel
        return [shopX, shopY]
}

ExitArena(){
    ImageSearch, ExitArenaX, ExitArenaY, 0,0,A_ScreenWidth,A_ScreenHeight, *10 arena_exit.PNG
    if !ErrorLevel {
        Click %ExitArenaX%, %ExitArenaY%
        Sleep 15000
    }
}

IsDead(){
    ImageSearch, isDeadX, isDeadY, 0,0,A_ScreenWidth,A_ScreenHeight, *5 death_flag.PNG
    if !ErrorLevel
        return True
}

IsPickingChamp(){
    ImageSearch, isPickingChampX, isPickingChampY, 0,0,A_ScreenWidth,A_ScreenHeight, inactive_lock.PNG
        if !Errorlevel
            return True
}

AcceptQueue(){
    ImageSearch, AcceptQueueX, AcceptQueueY, 0,0,A_ScreenWidth,A_ScreenHeight, match_found.PNG
        if !Errorlevel {
            Click %AcceptQueueX%, %AcceptQueueY%
            Mousemove 0,0
        }
}

Surrender(){
    ImageSearch, SurrenderX, SurrenderY, 0,0,A_ScreenWidth,A_ScreenHeight, surrender.PNG
        if !Errorlevel 
            Click %SurrenderX%, %SurrenderY%
}


