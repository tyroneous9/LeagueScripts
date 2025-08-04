class ImageFinder {

__New() {
    WinGetPos &X, &Y, &W, &H, "A"
    this.X1 := X
    this.Y1 := Y
    this.X2 := X+W
    this.Y2 := Y+H
    this.ImagesFolder := "assets"
}

TestImageFinder() {
    if (image := this.ShopOpen())
        MouseMove(image[1], image[2])
    else 
        msgbox "test image not found"
}

FindPlayerXY(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, "*10 " this.ImagesFolder "\player_health.PNG")
    if ok
        return [foundX+.02*A_ScreenWidth,foundY+.13*A_ScreenHeight]
}

FindAllyXY(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, "*10 " this.ImagesFolder "\ally_health.PNG")
    if ok
        return [foundX+.02*A_ScreenWidth,foundY+.13*A_ScreenHeight]
}

FindEnemyXY(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, "*10 " this.ImagesFolder "\enemy_health.PNG")
    if ok
        return [foundX+.02*A_ScreenWidth,foundY+.13*A_ScreenHeight]
        
}

ShopOpen(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, "*10 " this.ImagesFolder "\shop_flag.PNG")
    if ok
        return [foundX, foundY]
}

ExitArena(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, "*10 " this.ImagesFolder "\arena_exit.PNG")
    if ok {
        DllCall("SetCursorPos", "int", foundX, "int", foundY)
        Click
        Sleep(10000)
    }
}

IsDead(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, "*5 " this.ImagesFolder "\death_flag.PNG")
    if ok
        return True
}

IsPickingChamp(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, this.ImagesFolder "\inactive_lock.PNG")
    if ok
        return True
}

AcceptQueue(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, this.ImagesFolder "\match_found.PNG")
        if ok {
            Click(foundX ", " foundY)
            MouseMove(0, 0)
        }
}

CloseFeedback(){
    ok := ImageSearch(&foundX, &foundY, this.X1, this.Y1, this.X2, this.Y2, this.ImagesFolder "\close_feedback.PNG")
        if ok {
            Click(foundX ", " foundY)
        }
}



}