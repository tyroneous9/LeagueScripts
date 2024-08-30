;AHK Settings
#SingleInstance force
InstallKeybdHook()
InstallMouseHook()
#UseHook True
CoordMode("Pixel", "Window")
CoordMode("Mouse", "Window")
SendMode("Event")
SetMouseDelay(1)
SetDefaultMouseSpeed(0)
#Warn All, Off
