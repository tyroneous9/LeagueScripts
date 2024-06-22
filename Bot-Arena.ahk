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
		Sleep(10000)
		loaded := True
	}
	
	;Look for gameover
	ExitArena()

	;Shop phase
	if (ShopFlag := ShopOpen()) {
		Send("{" Shop "}")
        Sleep(500)
        BuyRecommended()
		LevelUp(MAX_ORDER) 
		Surrender()
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
				MoveCursorRandom(SCREEN_CENTER[1], SCREEN_CENTER[2], 200)
				AttackMove(300)
			}
		}
		Send("{" CENTER_CAMERA " up}")
	} else if (AllyPosXY := FindAllyXY()) { 
		;move toward ally
		MoveCursorRandom(AllyPosXY[1], AllyPosXY[2], 150)
		Click Right
		Send("{" CENTER_CAMERA " down}")
		Send("{" CENTER_CAMERA " up}")
	} else { 
		;move randomly
		Send("{" CENTER_CAMERA " down}")
		MoveCursorRandom(SCREEN_CENTER[1], SCREEN_CENTER[2], 150)
		Click Right
		Click Left
		Send("{" CENTER_CAMERA " up}")
	}
}

/*
-------------------------------
          Execution
-------------------------------
*/

RunTest() {
	Surrender()
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

