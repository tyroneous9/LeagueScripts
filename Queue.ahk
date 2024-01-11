#Include BotUtil\ImageFinder.ahk
#Include BotUtil\Settings.ahk
#SingleInstance, force

loop {
	if(WinExist("League of Legends (TM) Client")) {
		Sleep 10000
	}
	else {
		AcceptQueue()
		sleep 1000
	}
}
Return

Del::exitapp
