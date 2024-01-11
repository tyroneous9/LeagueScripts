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
global MAX_ORDER := ["r", "q", "w", "e"]
global CAST_ORDER := [SPELL_4, SPELL_3, SPELL_2, SPELL_1]
global ACTIVE_RANGE := 615

/*
-------------------------------
      Game & Client Loop
-------------------------------
*/

RunGame() {
	if (!WinActive(GAME_PROCESS)) { ;Run client when not ingame
		RunClient()
		return
	}	
	
	;Look for gameover
	ExitArena()

	;Shop phase
	if (ShopOpen()) {
		Sleep 1000
		Send {%SHOP%}
		Sleep 1000
		BuyRecommended()
		LevelUp(MAX_ORDER) 
	}

	; Combat
	if (EnemyPosXY := FindEnemyXY()) { 
		;move toward enemy if seen
		Mousemove EnemyPosXY[1], EnemyPosXY[2]
		Click Right
		Send {%CENTER_CAMERA% down}
		if (EnemyPosXY := FindEnemyXY()) {
			EnemyDistance := GetDistance(SCREEN_CENTER, EnemyPosXY)
			if (EnemyDistance < ACTIVE_RANGE) {
				AttackEnemy(CAST_ORDER)
				MoveMouseRandom(SCREEN_CENTER[1], SCREEN_CENTER[2], 300)
				AttackMove(300)
			}
		}
		Send {%CENTER_CAMERA% up}
	} else if (AllyPosXY := FindAllyXY()) { 
		;move toward ally
		MoveMouseRandom(AllyPosXY[1], AllyPosXY[2], 300)
		AttackMove(500)
		Send {%CENTER_CAMERA% down}
		Send {%CENTER_CAMERA% up}
	} else { 
		;move randomly
		Send {%CENTER_CAMERA% down}
		MoveMouseRandom(SCREEN_CENTER[1], SCREEN_CENTER[2], 300)
		AttackMove(500)
		Send {%CENTER_CAMERA% up}
	}
}

/*
-------------------------------
          Execution
-------------------------------
*/

RunTest() {
	

	BuyRecommended()
	

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

