; InstallKeybdHook()
; InstallMouseHook()
; #UseHook True
; CoordMode("Pixel", "Window")
; CoordMode("Mouse", "Window")
; SendMode("Event")
; SetMouseDelay(1)
; SetDefaultMouseSpeed(0)
; #Warn All, Off
#SingleInstance force
#Include <FindText>
SetWorkingDir(A_ScriptDir "\assetsTEST")
Home::Test()

Test(){
    FindText().Screenshot(100,100,500,500) ; Take a new screenshot between coordinates 100,100 and 500,500
    FindText().ShowScreenShot(100, 100,500, 500, 0) ; Shows the taken screenshot on the screen. Since we specified 0 as the last argument, the function will use the screenshot taken previously by the Screenshot function.
    Sleep 3000
    FindText().ShowScreenShot() ; Hide the screenshot after 3 seconds
    FindText().SavePic(A_WorkingDir "\TestScreenShot.png", 100, 100, 400, 400, 0) ; Save a portion of the taken screenshot into a file in the script directory.
}

ShopOpen1(){
    t1:=A_TickCount
    originalWidth := 35
    originalHeight := 13
    WinGetPos &X, &Y, &W, &H, "A"
    scaledWidth := Round(originalWidth * (W / 1920))
    scaledHeight := Round(originalHeight * (H / 1080))
    ;ok := ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*w%scaledWidth% *h%scaledHeight% shop_flagPC.PNG")
    ok := ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "shop_flagPC.BMP")
    if ok {
        DllCall("SetCursorPos", "int", foundX, "int", foundY)
        Mousemove foundX, foundY
    }   
    ; MsgBox "Found:`t" (IsObject(ok)?ok.Length:ok)
    ;   . "`n`nTime:`t" (A_TickCount-t1) " ms"
    ;   . "`n`nPos:`t" X ", " Y
    ;   . "`n`nResult:`t<" (IsObject(ok)?ok[1].id:"") ">", "Tip", 4096
}



ShopOpen2(){
    t1:=A_TickCount, Text:=X:=Y:=""
    Text:="|<>*60$35.ks3XwT0trbwwxnzDttzbyTnkzDwzbky3tzDsQznyTstzbwztnzDtvnbyTnk70M10Ew1k60U"
    if (ok:=FindText(&foundX, &foundY, ;Output
                    0, 0, A_ScreenWidth, A_ScreenHeight, ;Search Scope
                    .2, .2, ;Fault Tolerance
                    Text,, ;Text,Screenshot
                    0 ;FindAll 0/1
                    ,,,,
                    1.0, 1.0 ;Zoom W/H
                    ))
    {
        FindText().Click(foundX, foundY, "L")
    }
    ; MsgBox "Found:`t" (IsObject(ok)?ok.Length:ok)
    ;   . "`n`nTime:`t" (A_TickCount-t1) " ms"
    ;   . "`n`nPos:`t" foundX ", " foundY
    ;   . "`n`nResult:`t<" (IsObject(ok)?ok[1].id:"") ">", "Tip", 4096

    ; ok:=FindText(&X:="wait", &Y:=3, 0,0,0,0,0,0,Text)  ; Wait 3 seconds for appear
    ; ok:=FindText(&X:="wait0", &Y:=-1, 0,0,0,0,0,0,Text)  ; Wait indefinitely for disappear
}

TimeTest(){
    NumRuns := 100
    TotalRuntime := 0
    loop NumRuns {
        StartTime := A_TickCount
        ;RUN FUNCTION HERE
        /*****************/
        ShopOpen2()
        /*****************/
        TotalRuntime := TotalRuntime + (A_TickCount - StartTime)
    }
    MsgBox "Total Time: " TotalRuntime " ms"
        .  "`n`nAverage Time: " TotalRuntime / NumRuns " ms"
}


