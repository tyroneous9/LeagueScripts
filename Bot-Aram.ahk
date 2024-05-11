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
global ACTIVE_RANGE := 500

/*
-------------------------------
      Game & Client Loop
-------------------------------
*/

RunGame() {
	static loaded := false
	if (!WinActive(GAME_PROCESS) && WinActive(CLIENT_PROCESS)) {
		if (loaded == true) {
			Sleep 10000
			loaded := false
		}
		RunClient()
		return
	} else if (loaded == false) {
		Sleep 10000
		loaded := True
	}
	
	; Look for surrender
	Surrender()

	; Shop/level
	if (IsDead()) {
		BuyRecommended()
		LevelUp(MAX_ORDER) 
	}

	; Combat
	static AllyCurrent := 0
	; determine ally presence
	AllyPosXY := FindAllyXY()
	if (AllyPosXY) { ; ally
		; determine enemy proximity
		Send {%CENTER_CAMERA% down}
		Sleep 10
		if (EnemyPosXY := FindEnemyXY()) {
			EnemyDistance := GetDistance(SCREEN_CENTER, EnemyPosXY)
			; attack if close
			if (EnemyDistance < ACTIVE_RANGE) {
				AttackEnemy(CAST_ORDER)
			}
		} else { ; look for ally
			Random, num, 1, 4
			AllyCurrent := SELECT_ALLY_ARR[num]
			Sleep 100
		}
		Send {%CENTER_CAMERA% up}
	} else { ; look for ally
		Random, num, 1, 4
		AllyCurrent := SELECT_ALLY_ARR[num]
		Sleep 400
	}
	FollowAlly(AllyCurrent, 256)
}

RunTest() {
	StartTime := A_TickCount

	;MsgBox % A_TickCount - StartTime " milliseconds have elapsed."
}

/*
-------------------------------
          Execution
-------------------------------
*/

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

