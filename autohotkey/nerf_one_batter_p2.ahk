
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

  
    SendEvent "wwww" ; move to conR
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "ddddddddddddddddddddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to conL
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dddddddddddddddddddddddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to powR
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "ddddddddddddddddddddddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to powL
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "ss" ; move to platedisc
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "aaaaaaaa"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "ssssssswwww" ; move to stealing tendency, with speed on top
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
  FileAppend("done\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p2_done.txt")
  
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

