#Requires AutoHotkey v2.0

thread "interrupt", 2000, -1
Toggle := 1

^+1::{
Global Toggle
Toggle := 1
SoundBeep(523, 1500)
Sleep 1000
If (Toggle < 1) 
	SoundBeep(300, 500)
SoundBeep(523, 500)
return
}

^+2::{
Global Toggle
Toggle := 0
SoundBeep(700, 500)
}
