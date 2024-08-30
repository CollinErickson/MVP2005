
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

  
    SendEvent "s" ; move to stamina
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to pickoff
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "aaaaaaa"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to fbcontrol
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dddddddddddddddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "s" ; move to fbvelo
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

    SendEvent "dddddddddd"

  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
     ; editing pitch 2
    SendEvent "sda" ; Reset pitch
    SendEvent "saaaaa" ; Set movement to 0
    SendEvent "ss" ; Move to control
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SetKeyDelay 75, 2000  ; Hold for 2 seconds to get near 0 faster than 
                          ; repeated presses, this gets it to 5 or 6 when 
                          ; running PCSX2 at 2x speed
    SendEvent "a" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "saaaaaaa" ; Move velo down 7 (slider only goes down 7)
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
     ; editing pitch 3
    SendEvent "sda" ; Reset pitch
    SendEvent "saaaaa" ; Set movement to 0
    SendEvent "ss" ; Move to control
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SetKeyDelay 75, 2000  ; Hold for 2 seconds to get near 0 faster than 
                          ; repeated presses, this gets it to 5 or 6 when 
                          ; running PCSX2 at 2x speed
    SendEvent "a" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "saaaaaaa" ; Move velo down 7 (slider only goes down 7)
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
     ; editing pitch 4
    SendEvent "sda" ; Reset pitch
    SendEvent "saaaaa" ; Set movement to 0
    SendEvent "ss" ; Move to control
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SetKeyDelay 75, 2000  ; Hold for 2 seconds to get near 0 faster than 
                          ; repeated presses, this gets it to 5 or 6 when 
                          ; running PCSX2 at 2x speed
    SendEvent "a" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "saaaaaaa" ; Move velo down 7 (slider only goes down 7)
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
     ; editing pitch 5
    SendEvent "sda" ; Reset pitch
    SendEvent "saaaaa" ; Set movement to 0
    SendEvent "ss" ; Move to control
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SetKeyDelay 75, 2000  ; Hold for 2 seconds to get near 0 faster than 
                          ; repeated presses, this gets it to 5 or 6 when 
                          ; running PCSX2 at 2x speed
    SendEvent "a" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "saaaaaaa" ; Move velo down 7 (slider only goes down 7)
    
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    SendEvent "u" ; save and exit
    Sleep 600 ; wait for popup
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

  
  FileAppend("done\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_pitcher_p2_done.txt")
  
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  
    ; Done, beep  
    SoundBeep(523, 500)
  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }

  }

