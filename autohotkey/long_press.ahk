#Requires AutoHotkey v2.0

thread "interrupt", 2000, -1
Toggle := 1

^+1::{
Global Toggle
Toggle := 1


    SetKeyDelay 75, 875  ; Hold for 2 seconds to get near 0 faster than 
                          ; repeated presses, this gets it to 5 or 6 when 
                          ; running PCSX2 at 2x speed
    SendEvent "d" ; Set movement to 0

return
}

^+2::{
Global Toggle
Toggle := 0
SoundBeep(700, 500)
}
