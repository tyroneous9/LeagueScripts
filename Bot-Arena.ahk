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
    ACTIVE_RANGE := 550
	
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

	;Look for gameover/surrender
	Sim.ImageFinder.ExitArena()

	;Shop phase
	if (ShopFlag := Sim.ImageFinder.ShopOpen()) {
		Send("{" Sim.SHOP "}")
        Sleep(500)
        Sim.BuyRecommended()
		loop 3 {
			Sim.LevelUp(MAX_ORDER) 
		}
		;Sim.Surrender()  ;TURN THIS ON IF DUO
	}

	; Combat
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
	} else { 
		;move toward ally
		Send("{" Sim.SELECT_ALLY_1 "}")
		Sim.MoveCursorRandom(Sim.SCREEN_CENTER[1], Sim.SCREEN_CENTER[2], 200)
		Click("Right")
		Sleep 300
	}

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

