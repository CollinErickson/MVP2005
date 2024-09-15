# Clear rosters for one org
# Use this to move all players from a roster to the Free Agent list
stop("use clear_rosters2.R")

clear_one_org <- function(norgs=1, nlevels=4) {
  
  # Initiate
  out <- '
#Requires AutoHotkey v2.0

thread "interrupt", 2000, -1
Interrupted := 0

^+2::{
  Global Interrupted
  Interrupted := 1

}

^+1::{
  Global Interrupted
  Interrupted := 0
  SetKeyDelay 275, 70  ; 75ms between keys, 25ms between down/up.\n'



add <- function(x, interrupt=TRUE) {
  out <<- paste0(out, "\n  ", x, "\n")
  if (interrupt) {
    out <<- paste0(out,"  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }\n")
  }
}

  # Start right after clicking the FA tab. Should be in left column.
  # Loop over orgs
  for (h in 1:norgs) {
  # Loop over teams in org
  for (i in 1:nlevels) {
    # Loop over players, 25 max
    for (j in 1:25) {
      # Click right (move to team), x (release), down (move to yes), x (confirm)
      
      add('
    SendEvent "dksk"
    Sleep 450')
    }
    # Move to next team in org
    add('
    SendEvent "0" ; next team
      Sleep 300')
  }
    # Move to next org (move right, R1, move left)
    add('
    SendEvent "d9a" ; next org
      Sleep 300')
  }

  # Beep when done
  add("
      SoundBeep(523, 500)")

  # Close 1
  add("}", interrupt = F)

out
}

clear_ahk <- clear_one_org(norgs = 2, nlevels = 4)
clear_ahk%>% cat


write(x=clear_ahk, file="./autohotkey/clear_org.ahk")
