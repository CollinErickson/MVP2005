
#Requires AutoHotkey v2.0

#SingleInstance Force

thread "interrupt", 2000, -1
Interrupted := 0

^+2::{
  Global Interrupted
  Interrupted := 1

}

^+1::{
  SoundBeep(523, 500)
  Global Interrupted
  Interrupted := 0
  SetKeyDelay 100, 50  ; 75ms between keys, 25ms between down/up.

  
        SendEvent "k" ; enter player
        Sleep 4000 ; wait for player to load
        SendEvent "8" ; move left 1 tab to pitcher ratings
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
  FileAppend("done\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_pitcher_p1_done.txt")
  
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
      SoundBeep(523, 500)
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  }

