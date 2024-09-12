
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
  SendEvent "wk" ; 	a
  SendEvent "wddddddk" ; 	u
  SendEvent "saaaaak" ; 	s
  SendEvent "wdddk" ; 	t
  SendEvent "dddk" ; 	i
  SendEvent "ssaak" ; 	n
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

  
  SendEvent "wwaaaak" ; 	w
  SendEvent "dk" ; 	e
  SendEvent "sddddddk" ; 	l
  SendEvent "k" ; 	l
  SendEvent "aaaaaaak" ; 	s
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

    SendEvent "a"

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

    SendEvent "aaa"

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

    SendEvent "dddddd"

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

    SendEvent "ddddddddd"

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

    SendEvent "d"

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

    SendEvent "d"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Batter ditty type
	SendEvent "s" ; 	 move to Batter ditty type
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "d"

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

    SendEvent "ddddddddddddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Height
	SendEvent "s" ; 	 move to Height
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "dd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Body type
	SendEvent "ss" ; 	 move to face
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Face
	SendEvent "s" ; 	 move to face
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Hair color
	SendEvent "s" ; 	 move to Hair color
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "ddd"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Hair style
	SendEvent "s" ; 	 move to Hair style
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Facial hair
	SendEvent "s" ; 	 move to Facial hair
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Body build tab
	SendEvent "9" ; 	 move to body build tab
	Sleep 40 ;
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Equipment tab
	SendEvent "9" ; 	 move to equipment tab
	Sleep 40 ;
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Batter/Fielder Ratings tab
	SendEvent "9" ; 	 move to Batter/Fielder Ratings tab
	Sleep 40 ;
  
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Batter stance
      
  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

    SendEvent "aaaaaaaaaaaaaaaaaaaaaaaaa"

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

  
    SetKeyDelay 75, 944.757  ; Hold for X seconds to move fast than
                          ; repeated presses, should get within 1, need to be
                          ; running PCSX2 at 2x speed
    SendEvent "d" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  
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

    SendEvent "dddddddd"

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

  
    SetKeyDelay 75, 1403.261  ; Hold for X seconds to move fast than
                          ; repeated presses, should get within 1, need to be
                          ; running PCSX2 at 2x speed
    SendEvent "d" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  
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

  
    SetKeyDelay 75, 1028.121  ; Hold for X seconds to move fast than
                          ; repeated presses, should get within 1, need to be
                          ; running PCSX2 at 2x speed
    SendEvent "d" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  
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

    SendEvent "aaaa"

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

    SendEvent "dddddd"

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

    SendEvent "ddddd"

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

    SendEvent "dddddddd"

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

    SendEvent "ddd"

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

    SendEvent "ddd"

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

    SendEvent "aa"

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

    SendEvent "a"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Batter Tendencies tab
	SendEvent "9" ; 	 move to Batter Tendencies tab
	Sleep 40 ;
  
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

    SendEvent "ddddd"

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

    SendEvent "ddd"

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

    SendEvent "aa"

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

    SendEvent "aa"

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

    SendEvent "dddd"

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

    SendEvent "dddddd"

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

    SendEvent "dd"

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

    SendEvent "d"

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

    SendEvent "a"

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

    SendEvent "aaaa"

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

    SendEvent "dddddddd"

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

    SendEvent "aaaaaa"

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

    SendEvent "a"

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

    SendEvent "aaaa"

  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }

  

	; Save player
      	    SendEvent "usk" ; 	 Save player
            
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

