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
global ALLY_MAIN := SELECT_ALLY_ARR[4] ;bot lane ally

/*
-------------------------------
      Game & Client Loop
-------------------------------
*/

RunGame() {
	static loaded := false
	if (!WinActive(GAME_PROCESS)) { ;Run client when not ingame
		RunClient()
		
		return
	} else if (loaded == false) {
		while(!FindPlayerXY()) {
			Sleep 1000
		}
		loaded := True
		BuyRecommended()
		LevelUpSingle(MAX_ORDER[4])
	}	

	;Shop phase
	if (IsDead()) {
		BuyRecommended()
		LevelUp(MAX_ORDER) 
	}

	; Combat
	Send {%ALLY_MAIN%}
	Sleep 10
	AllyPosXY := FindAllyXY()
	if (AllyPosXY) {
		if (EnemyPosXY := FindEnemyXY()) {
			Send {%CENTER_CAMERA% down}
			Sleep 10
			if (EnemyPosXY := FindEnemyXY()) {
				EnemyDistance := GetDistance(SCREEN_CENTER, EnemyPosXY)
				if (EnemyDistance < ACTIVE_RANGE) {
					AttackEnemy(CAST_ORDER)
					Retreat(200)
					if (EnemyDistance < (ACTIVE_RANGE >> 1)) {
						Retreat(2000)
						Send {%SUM_1%}{%SUM_2%}
					}
				}
			}
			Send {%CENTER_CAMERA% up}
			FollowAlly(ALLY_MAIN, 150)
		} else {
			FollowAlly(ALLY_MAIN, 300)
		}
		AttackMove(400)
	} else {
		; play safe without ally, then recall
		if (EnemyPosXY := FindEnemyXY()) {
			Retreat(2000)
		}
		Recall()
	}
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

