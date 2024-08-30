#Requires AutoHotkey v2.0
^1::{
  
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SendEvent "k"
      Sleep 3000
  	; first name
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "k"
	Sleep 1000
    SendEvent "sskkkkk"
	
  
    SendEvent "aaaaw" ; 	move from back to z
  SendEvent "wk" ; 	a
  SendEvent "k" ; 	a
  SendEvent "wdddk" ; 	r
  SendEvent "dddddk" ; 	o
  SendEvent "ssaaak" ; 	n
  SendEvent "wddddddk" ; 	Done
  

	; last name
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "sk" ; 	enter last name
	Sleep 1000
    SendEvent "sskkkkk" ; 	 clear
	
  
    SendEvent "aaaaw" ; 	move from back to z
  SendEvent "wddddddk" ; 	j
  SendEvent "wk" ; 	u
  SendEvent "saaaak" ; 	d
  SendEvent "ddk" ; 	g
  SendEvent "waak" ; 	e
  SendEvent "sdddddddddk" ; 	Done
  

	; Birth month
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "ss" ; 	 move to birth month
  
    SendEvent "aa"

  

	; Birth date
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "w" ; 	 move to birth date
  
    SendEvent "aaaaaaaaaaa"

  

	; Birth month
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "ss" ; 	 move to birth month
  
    SendEvent "dddddddddddddddddd"

  

	; First position
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to first position
  
    SendEvent "ddddd"

  

	; Second position
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
	SendEvent "s" ; 	 move to first position
  
    SendEvent "dddddddd"
}
