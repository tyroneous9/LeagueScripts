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
global CAST_ORDER := [SPELL_4, SPELL_3, SPELL_2, SPELL_1, SUM_1, SUM_2]
global ACTIVE_RANGE := 615

/*
-------------------------------
      Game & Client Loop
-------------------------------
*/

RunGame() {
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
	
	;Look for surrender
	Surrender()

	;Shop phase
	if (IsDead()) {
		BuyRecommended()
		LevelUp(MAX_ORDER) 
	}

	; Combat
	static AllyCurrent := 0
	; determine ally presence
	AllyPosXY := FindAllyXY()
	if (AllyPosXY) { ; ally
		; determine enemy presence
		if (EnemyPosXY := FindEnemyXY()) {
			; determine enemy proximity
			Send {%CENTER_CAMERA% down}
			Sleep 10
			if (EnemyPosXY := FindEnemyXY()) {
				EnemyDistance := GetDistance(SCREEN_CENTER, EnemyPosXY)
				; attack if close, retreat if too close
				if (EnemyDistance < ACTIVE_RANGE) {
					AttackEnemy(CAST_ORDER)
					Retreat(200)
					if (EnemyDistance < (ACTIVE_RANGE >> 2)) {
						Retreat(1500)
						Send {%SUM_1%}{%SUM_2%}
					}
				}
			}
			Send {%CENTER_CAMERA% up}
		} else { ; ally no enemy
			Random, num, 1, 4
			AllyCurrent := SELECT_ALLY_ARR[num]
		}
		AttackMove(400)
	} else { ; no ally no enemy
		Random, num, 1, 4
		AllyCurrent := SELECT_ALLY_ARR[num]
	}
	FollowAlly(AllyCurrent, 250)
}

RunTest() {
	StartTime := A_TickCount

	BuyRecommended()

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

