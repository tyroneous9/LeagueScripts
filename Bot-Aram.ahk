#Include <Simulator>

/*
-------------------------------
          Functions
-------------------------------
*/

RunGame() {
    ;INIT
	Sim := Simulator()
    static loaded := false
    MAX_ORDER := [Sim.SPELL_4,Sim.SPELL_1,Sim.SPELL_2,Sim.SPELL_3]
    CAST_ORDER := [Sim.SPELL_4,Sim.SPELL_1,Sim.SPELL_2,Sim.SPELL_3]
	SELECT_ALLY_ARR := [Sim.SELECT_ALLY_1, Sim.SELECT_ALLY_2, Sim.SELECT_ALLY_3, Sim.SELECT_ALLY_4]
    ACTIVE_RANGE := 500
	static AllyCurrent := 0
	
    ;START LOOP
    loop {

	if (!WinActive(Sim.GAME_PROCESS)) { ; GAME DOWN
		if (WinActive(Sim.CLIENT_PROCESS)) { ; CLIENT UP
			Sim.RunClient(Sim.CHAMPION)
			continue
		} else { ; CLIENT DOWN
			while (!WinActive(Sim.GAME_PROCESS) && !WinActive(Sim.CLIENT_PROCESS)) { ; Start/exit phase
				Sleep(1000)
			}
		}
	}

	;Shop phase
	if (IsDead()) {
		BuyRecommended()
		loop 3 {
			Sim.LevelUp(MAX_ORDER) 
		}
		Sim.Surrender()
	}
	
	; Combat
	AllyPosXY := FindAllyXY()
	if (AllyPosXY) { ; ally found
		if (EnemyPosXY := Sim.ImageFinder.FindEnemyXY()) { 
			;move toward enemy if seen
			Click(EnemyPosXY[1], EnemyPosXY[2], "R")
			Send("{" Sim.CENTER_CAMERA " down}")
			if (EnemyPosXY := Sim.ImageFinder.FindEnemyXY()) {
				EnemyDistance := Sim.GetDistance(Sim.SCREEN_CENTER, EnemyPosXY)
				if (EnemyDistance < ACTIVE_RANGE) {
					Sim.AttackEnemy(CAST_ORDER, &EnemyPosXY)
				}
			}
			Send("{" Sim.CENTER_CAMERA " up}")
		} 
	} else { ; look for ally
		num := Random(1, 4)
		AllyCurrent := SELECT_ALLY_ARR[num]
		Sleep(100)
	}
	FollowAlly(AllyCurrent, 250)

    } ;END LOOP
}

RunTest() {

}

/*
-------------------------------
          Execution
-------------------------------
*/

;Run script
Home::
{
RunGame()
return
} 

;Run script tests
Ins::
{ 
RunTest()
return
} 

;Stop script
Del::ExitApp()
End::Reload()

