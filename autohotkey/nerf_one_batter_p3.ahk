
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
  SetKeyDelay 275, 70  ; 75ms between keys, 25ms between down/up.

  
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "w" ; move to speed
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dddddddddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "ss" ; move to brability
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to fielding
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to rang
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "aaaaaa"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to throwstrength
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "u" ; save and exit
    Sleep 200 ; wait for popup
    SendEvent "sk"
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    Sleep 3000 ; Wait for roster page to load
    SendEvent "98" ; Reset to top of this roster
  
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
  FileAppend("done\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p3_done.txt")
  
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

