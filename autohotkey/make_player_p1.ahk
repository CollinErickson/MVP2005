
#Requires AutoHotkey v2.0

#SingleInstance Force

thread "interrupt", 2000, -1
Interrupted := 0

^+2::{
  Global Interrupted
  Interrupted := 1

}

^+1::{
  Global Interrupted

  
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up
    SendEvent "k"
      Sleep 3000
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  	; first name
	SendEvent "k" ; Enter first name
	Sleep 1000
    SendEvent "lllll" ; delete "sskkkkk"
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ds" ; 	move from done to z
  SendEvent "wddddk" ; 	g
  SendEvent "waak" ; 	e
  SendEvent "dk" ; 	r
  SendEvent "k" ; 	r
  SendEvent "ddddk" ; 	i
  SendEvent "aaak" ; 	t
	SendEvent "u" ; 	Done
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; last name
	SendEvent "sk" ; 	enter last name
	Sleep 1000
    SendEvent "lllll" ; delete "sskkkkk"
	
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  
  SendEvent "ssaak" ; 	c
  SendEvent "wwddddddk" ; 	o
  SendEvent "sk" ; 	l
  SendEvent "waaaaaak" ; 	e
	SendEvent "u" ; 	Done
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Birth month
	SendEvent "ss" ; 	 move to birth month
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "d"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Birth date
	SendEvent "w" ; 	 move to birth date
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Birth year
	SendEvent "ss" ; 	 move to birth year
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; First position
	SendEvent "s" ; 	 move to first position
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Second position
	SendEvent "s" ; 	 move to first position
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Throws
	SendEvent "s" ; 	 move to throws
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Bats
	SendEvent "s" ; 	 move to throws
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Career potential
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

    SendEvent "dddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Career potential
	SendEvent "s" ; 	 move to car pot
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Body build tab
	SendEvent "9" ; 	 move to throws
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Equipment tab
	SendEvent "9" ; 	 move to equipment tab
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Appearance tab
	SendEvent "9" ; 	 move to appearance tab
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Contact v R
	SendEvent "s" ; 	 move to Contact v R
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Contact v L
	SendEvent "s" ; 	 move to Contact v R
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Power v R
	SendEvent "s" ; 	 move to Power v R
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Power v L
	SendEvent "s" ; 	 move to Power v R
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Bunting
	SendEvent "s" ; 	 move to Bunting
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "d"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Plate Discipline
	SendEvent "s" ; 	 move to Plate Discipline
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "a"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Durability
	SendEvent "s" ; 	 move to Durability
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Speed
	SendEvent "s" ; 	 move to Speed
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Stealing Tendency
	SendEvent "s" ; 	 move to Stealing Tendency
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Baserunning Ability
	SendEvent "s" ; 	 move to Baserunning Ability
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Fielding
	SendEvent "s" ; 	 move to Fielding
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Range
	SendEvent "s" ; 	 move to Range
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Throwing Strength
	SendEvent "s" ; 	 move to Throwing Strength
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Throwing Accuracy
	SendEvent "s" ; 	 move to Throwing Accuracy
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Batter Tendencies tab
	SendEvent "9" ; 	 move to Batter Tendencies tab
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; FB Take vL
	SendEvent "s" ; 	 move to FB Take vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; FB Take vR
	SendEvent "s" ; 	 move to FB Take vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; FB Miss vL
	SendEvent "s" ; 	 move to FB Miss vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; FB Miss vR
	SendEvent "s" ; 	 move to FB Miss vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; FB Chase vL
	SendEvent "s" ; 	 move to FB Chase vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; FB Chase vR
	SendEvent "s" ; 	 move to FB Chase vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; CB Take vL
	SendEvent "ss" ; 	 move to CB Take vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; CB Take vR
	SendEvent "s" ; 	 move to CB Take vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; CB Miss vL
	SendEvent "s" ; 	 move to CB Miss vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; CB Miss vR
	SendEvent "s" ; 	 move to CB Miss vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; CB Chase vL
	SendEvent "s" ; 	 move to CB Chase vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; CB Chase vR
	SendEvent "s" ; 	 move to CB Chase vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; SL Take vL
	SendEvent "ss" ; 	 move to SL Take vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; SL Take vR
	SendEvent "s" ; 	 move to SL Take vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; SL Miss vL
	SendEvent "s" ; 	 move to SL Miss vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; SL Miss vR
	SendEvent "s" ; 	 move to SL Miss vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; SL Chase vL
	SendEvent "s" ; 	 move to SL Chase vL
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; SL Chase vR
	SendEvent "s" ; 	 move to SL Chase vR
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitcher tab
	SendEvent "999" ; 	 move to Pitcher tab
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Stamina
	    SendEvent "s" ; 	 move to Stamina
      
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddddddddddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pickoff
	    SendEvent "s" ; 	 move to Pickoff
      
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Fastball Control
	    SendEvent "s" ; 	 move to Fastball Control
      
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Fastball Velocity
	    SendEvent "s" ; 	 move to Fastball Velocity
      
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch type
      	    SendEvent "s" ; 	 move to pitch type
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Movement
      	    SendEvent "s" ; 	 move to Pitch Movement
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Trajectory
      	    SendEvent "s" ; 	 move to Pitch Trajectory
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Control
      	    SendEvent "s" ; 	 move to Pitch Control
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Velocity
      	    SendEvent "s" ; 	 move to Pitch Velocity
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch type
      	    SendEvent "s" ; 	 move to pitch type
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Movement
      	    SendEvent "s" ; 	 move to Pitch Movement
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Trajectory
      	    SendEvent "s" ; 	 move to Pitch Trajectory
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Control
      	    SendEvent "s" ; 	 move to Pitch Control
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Velocity
      	    SendEvent "s" ; 	 move to Pitch Velocity
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch type
      	    SendEvent "s" ; 	 move to pitch type
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Movement
      	    SendEvent "s" ; 	 move to Pitch Movement
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Trajectory
      	    SendEvent "s" ; 	 move to Pitch Trajectory
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Control
      	    SendEvent "s" ; 	 move to Pitch Control
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddddddddddddddddddddddddddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Pitch Velocity
      	    SendEvent "s" ; 	 move to Pitch Velocity
            
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  
  FileAppend("done\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/make_player_p1_done.txt")
  
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

