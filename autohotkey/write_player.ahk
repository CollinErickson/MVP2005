
#Requires AutoHotkey v2.0

thread "interrupt", 2000, -1
Interrupted := 0

^+2::{
  Global Interrupted
  Interrupted := 1

}

^+1::{
  Global Interrupted

  
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SendEvent "k"
      Sleep 3000
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  	; first name
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "k"
	Sleep 1000
    SendEvent "sskkkkk"
	
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaw" ; 	move from back to z
  SendEvent "wk" ; 	a
  SendEvent "k" ; 	a
  SendEvent "wdddk" ; 	r
  SendEvent "dddddk" ; 	o
  SendEvent "ssaaak" ; 	n
  SendEvent "wddddddk" ; 	Done
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; last name
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "sk" ; 	enter last name
	Sleep 1000
    SendEvent "sskkkkk" ; 	 clear
	
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaw" ; 	move from back to z
  SendEvent "wddddddk" ; 	j
  SendEvent "wk" ; 	u
  SendEvent "saaaak" ; 	d
  SendEvent "ddk" ; 	g
  SendEvent "waak" ; 	e
  SendEvent "sdddddddddk" ; 	Done
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Birth month
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "ss" ; 	 move to birth month
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aa"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Birth date
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "w" ; 	 move to birth date
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaaaaaaa"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Birth year
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "ss" ; 	 move to birth year
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "a"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; First position
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to first position
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Second position
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to first position
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Throws
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to throws
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Bats
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to throws
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Career potential
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to throws
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Appearance tab
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "9" ; 	 move to throws
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Jersey number
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaaaaaaaaaaaa"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Career potential
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to throws
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Body build tab
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "9" ; 	 move to throws
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Equipment tab
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "9" ; 	 move to equipment tab
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Appearance tab
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "9" ; 	 move to appearance tab
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Contact v R
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to Contact v R
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddddddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Contact v L
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to Contact v R
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddddddddddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Power v R
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to Power v R
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddddddddddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  

	; Power v L
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to Power v R
  
  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddddddddddddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    
    SoundBeep(523, 500)
    return      
  }

  }

