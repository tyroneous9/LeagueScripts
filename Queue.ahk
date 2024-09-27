#Include <ImageFinder>
#Include <Settings>
#SingleInstance force

finder := ImageFinder()
Loop{
	if(WinExist("League of Legends (TM) Client")) {
		Sleep(10000)
	}
	else {
		finder.AcceptQueue()
		Sleep(1000)
	}
}
Return

Del::ExitApp()
