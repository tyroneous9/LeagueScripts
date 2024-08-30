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
    ACTIVE_RANGE := 615
	
    ;START LOOP
    loop {

	if (WinActive(Sim.CLIENT_PROCESS)) { ;CLIENT UP
		if (loaded == true) {
			;Sleep(20000)
			loaded := false
		}
		Sim.RunClient(Sim.CHAMPION)
		continue
	} else if (loaded == false) { ;NOT INGAME
		;Sleep(20000)
		if (!WinActive(Sim.CLIENT_PROCESS)) { ;GAME DOWN
			loaded := True
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
	} else if (AllyPosXY := Sim.ImageFinder.FindAllyXY()) { 
		;move toward ally
		Sim.MoveCursorRandom(AllyPosXY[1], AllyPosXY[2], 200)
		Click "Right"
		Send("{" Sim.CENTER_CAMERA " down}")
		Send("{" Sim.CENTER_CAMERA " up}")
		Sleep 300
	} else { 
		;move randomly
		Send("{" Sim.CENTER_CAMERA " down}")
		Sim.MoveCursorRandom(Sim.SCREEN_CENTER[1], Sim.SCREEN_CENTER[2], 400)
		Click "Right"
		Click "Left"
		Send("{" Sim.CENTER_CAMERA " up}")
		Sleep 600
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

