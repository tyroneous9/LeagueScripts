#Include "BotUtil\ImageFinder.ahk"
#Include "BotUtil\BehaviorLib.ahk"
#Include "BotUtil\Settings.ahk"

/*
-------------------------------
        Initialization
-------------------------------
*/

LoadScript()
;Constants
global MAX_ORDER := ["r", "q", "w", "e"]
global CAST_ORDER := [SPELL_4, SPELL_3, SPELL_2, SPELL_1]
global ACTIVE_RANGE := 615

/*
-------------------------------
      Game & Client Loop
-------------------------------
*/

RunGame() {
	static loaded := false
	if (WinActive(CLIENT_PROCESS)) {
		if (loaded == true) {
			Sleep(10000)
			loaded := false
		}
		RunClient()
		return
	} else if (loaded == false) {
		Sleep(2000)
		loaded := True
	}
	
	;Look for gameover/surrender
	ExitArena()
	Surrender()

	;Shop phase
	if (ShopFlag := ShopOpen()) {
		Sleep(500)
		BuyLegendaryAnvil()
		LevelUp(MAX_ORDER) 
	}

	; Combat
	if (EnemyPosXY := FindEnemyXY()) { 
		;move toward enemy if seen
		Click(EnemyPosXY[1], EnemyPosXY[2], "R")
		Send("{" CENTER_CAMERA " down}")
		if (EnemyPosXY := FindEnemyXY()) {
			EnemyDistance := GetDistance(SCREEN_CENTER, EnemyPosXY)
			if (EnemyDistance < ACTIVE_RANGE) {
				AttackEnemy(CAST_ORDER, &EnemyPosXY)
				MoveCursorRandom(SCREEN_CENTER[1], SCREEN_CENTER[2], 300)
				AttackMove(300)
			}
		}
		Send("{" CENTER_CAMERA " up}")
	} else if (AllyPosXY := FindAllyXY()) { 
		;move toward ally
		MoveCursorRandom(AllyPosXY[1], AllyPosXY[2], 300)
		AttackMove(500)
		Send("{" CENTER_CAMERA " down}")
		Send("{" CENTER_CAMERA " up}")
	} else { 
		;move randomly
		Send("{" CENTER_CAMERA " down}")
		MoveCursorRandom(SCREEN_CENTER[1], SCREEN_CENTER[2], 300)
		AttackMove(500)
		Send("{" CENTER_CAMERA " up}")
	}
}

/*
-------------------------------
          Execution
-------------------------------
*/

RunTest() {
	static loaded := false
	loop {
		if (WinActive(CLIENT_PROCESS)) {
			if (loaded == true) {
				Sleep(10000)
				loaded := false
			}
		} else if (loaded == false) {
				Sleep(2000)
				loaded := True
			}
	}

}

;testing
Ins::
{ 
RunTest()
return
} 

;run script
Home::
{ 
Loop
	RunGame()
return
} 
Del::ExitApp()
End::Reload()

