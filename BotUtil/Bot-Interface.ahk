#Include BotUtil\ImageFinder.ahk
#Include BotUtil\BehaviorLib.ahk
#Include BotUtil\Settings.ahk

/*
-------------------------------
        Initialization
-------------------------------
*/

LoadScript()
;Constants
global MAX_ORDER := []
global CAST_ORDER := []
global ACTIVE_RANGE := 0

/*
-------------------------------
      Game & Client Loop
-------------------------------
*/

RunGame() {
	;Run client w/ initial load
	static loaded := false
	if (!WinActive(GAME_PROCESS) && WinActive(CLIENT_PROCESS)) {
		RunClient()
		return
	} else if (loaded == false) {
		while(!FindPlayerXY()) {
			Sleep 1000
		}
		loaded := True
		BuyRecommended()
		LevelUp(MAX_ORDER) 
	}	
	
	; Shop/level
	if () {
		BuyRecommended()
		LevelUp(MAX_ORDER) 
	}

	; Combat
	if (EnemyPosXY := FindEnemyXY()) {
		Send {%CENTER_CAMERA% down}
		if (EnemyPosXY := FindEnemyXY()) {
			EnemyDistance := GetDistance(SCREEN_CENTER, EnemyPosXY)
			if (EnemyDistance < ACTIVE_RANGE) {
				
			}
		}
		Send {%CENTER_CAMERA% up} 
	} else if (AllyPosXY := FindAllyXY()) { ; look for ally
		
	} else { ; no enemy or ally
		
	}

}

/*
-------------------------------
          Execution
-------------------------------
*/

RunTest() {
	StartTime := A_TickCount


	
	;MsgBox % A_TickCount - StartTime " milliseconds have elapsed."
}

;testing
Ins::
RunTest() 
return

;run script
Home::
loop
	RunGame()
return
Del::ExitApp
End::Reload

