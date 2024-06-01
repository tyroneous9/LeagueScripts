#Include "BotUtil\ImageFinder.ahk"
#Include "BotUtil\Settings.ahk"
#SingleInstance force

Loop{
	if(WinExist("League of Legends (TM) Client")) {
		Sleep(10000)
	}
	else {
		AcceptQueue()
		Sleep(1000)
	}
}
Return

Del::ExitApp()
