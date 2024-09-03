move_fa_to_roster <- function(org_id, level_id, nplayers=25) {
  stopifnot(length(org_id) == 1, length(level_id) == 1,
            between(level_id, 1,4),
            between(org_id, 1, 30))
  
  if (file.exists("./autohotkey/move_fa_to_roster_done.txt")) {
    file.remove("./autohotkey/move_fa_to_roster_done.txt")
  }
  
  # Initiate
  out <- '
#Requires AutoHotkey v2.0

#SingleInstance Force

thread "interrupt", 2000, -1
Interrupted := 0

^+2::{
  Global Interrupted
  Interrupted := 1

}

^+1::{
  Global Interrupted\n'



add <- function(x, interrupt=TRUE) {
  out <<- paste0(out, "\n  ", x, "\n")
  if (interrupt)
    out <<- paste0(out,"  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }\n")
}

# Need to start on create player button, before pressing
# Enter create player
add('
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SetKeyDelay 135, 40  ; 75ms between keys, 25ms between down/up
    
    SendEvent "isk" ; back to roster menu, then to FA page
    Sleep 1000 ; wait for FA page to load
    SendEvent "d" ; move to roster side
    SendEvent "777" ; Move from Modesto Nuts to Col Rockies
    '
    )

# Move to org
org_index <- which(OOTP_MLB_team_order[org_id] == MVP_org_order)
add(adjustLR(org_index - 25, keyright = '9', keyleft = '8'))

# Move to level
add(adjustLR(level_id - 1, keyleft='7', keyright='0'))

# Clear roster
for (i in 1:nplayers) {
  add('
    SendEvent "kskd" ; remove one player
    Sleep 100
    '
  )
}

# Move to FA side
add('
    SendEvent "a" ; move to FA side
    Sleep 100
    '
)

# Add 25 best FA to roster
for (i in 1:nplayers) {
  add('
    SendEvent "ksk" ; add one player
    Sleep 100
    '
  )
}

# Move back to create/edit player menu
add('
    SendEvent "issssk" ; move back to create/edit player menu
    Sleep 300
    '
)

# End ahk
# Write out file ----
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/move_fa_to_roster_done.txt")
  ')
# Beep when done
add("
      SoundBeep(523, 500)")
# Close 1
add("}", interrupt=FALSE)

# # Return
# out


# Write it ----
write(x=out, file="./autohotkey/move_fa_to_roster.ahk")

# Execute it ----
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/move_fa_to_roster.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

# Trigger it ----
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()


# Loop, check for file 
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
cat_progress <- progress::progress_bar$new(
  format="Waiting for ahk move_fa_to_roster p1 :elapsed", total=NA, clear=F, width=80
)
while (as.numeric(Sys.time()-trigger_time,units="secs") < 240) {
  # cat('p3 wait ahk', 
  #     as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  cat_progress$tick()
  if (file.exists("./autohotkey/move_fa_to_roster_done.txt")) {
    ahk_done <- TRUE
    cat("\nFound ahk done!", "\n")
    file.remove("./autohotkey/move_fa_to_roster_done.txt")
    rm(cat_progress)
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("move_fa_to_roster ahk failed to finish in 120 seconds")
}


cat("Finished move_fa_to_roster", "\n")

# Done ----
return()

}
if (F) {
  Sys.sleep(2)
  move_fa_to_roster(3,2)
}