nerf_career_potential_rosters <- function(norgs=30, nlevels=4, nplayers=25) {
  
  # }
  
  # nerf_career_potential_free_agents <- function(nplayers=400) {
  
  if (file.exists("./autohotkey/nerf_career_potential_done.txt")) {
    file.remove("./autohotkey/nerf_career_potential_done.txt")
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
# browser()

for (i in 1:norgs) {
  cat("org", i, "\n")
  for (j in 1:nlevels) {
    # Start on edit roster page on LAST player
    # Enter create player
    for (k in 1:nplayers) {
      # Move to bottom
      add('
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SetKeyDelay 95, 1840  ; 75ms between keys, 25ms between down/up
    SendEvent "s"
      Sleep 20')
      
      # Move up i-1 spots
      add(paste0('
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up
    SendEvent "', paste0(rep('w', k-1), collapse=''),'"
      Sleep 30'))
      
      # Nerf that player's career potential
      # It doesn't loop around, so no reason to OCR
      add('
      SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up
      SendEvent "k" ; Select player
      Sleep 1200 ;
      SendEvent "sssssssssaaaau" ; Set carpot to 0, save
      Sleep 80 ; 
      SendEvent "sk" ; dialogue box, say yes
      Sleep 1500 ;
      ')
      
    } # End player
    
    # Next level
    if (j == 4) {
      add('
      SendEvent "777"
      ')
    } else {
      add('
      SendEvent "0"
      ')
    }
  } # End level
  
  # Next org
  add('
      SendEvent "9"
      ')
} # End org


# Press space to pause PCSX2
add('
      SendEvent " " ; space to pause
      ')

# End ahk
# Write out file
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_career_potential_done.txt")
  ')
# Beep when done
add("
    ; Done, beep  
    SoundBeep(523, 500)")

# Close 1
add("}", interrupt = F)

# browser()
# Write it ----
write(x=out, file="./autohotkey/nerf_career_potential.ahk")

# Execute it ----
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
kill_all_ahk()
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_career_potential.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

stop('not triggering')

# Trigger it ----
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()

# Loop, check for file  ----
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
cat_progress <- progress::progress_bar$new(
  format="Waiting for ahk nerf car pot :elapsed", total=NA, clear=F, width=60
)
while (as.numeric(Sys.time()-trigger_time,units="secs") < 60*15) {
  # cat('wait for ahk',
  #     as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  cat_progress$tick()
  if (file.exists("./autohotkey/nerf_career_potential_done.txt")) {
    ahk_done <- TRUE
    cat("\nFound ahk done!", "\n")
    rm(cat_progress)
    file.remove("./autohotkey/nerf_career_potential_done.txt")
    kill_all_ahk()
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("nerf_career_potential failed to finish in 120 seconds")
}
cat("Finished nerf career potential", "\n")



# Done ----
return()



} # End function
if (F) {
  cat("Switch windows now", "\n")
  # Sys.sleep(2)
  nerf_career_potential_rosters(25,4,25)
}




nerf_career_potential_free_agents <- function(nplayers=25) {
  
  if (file.exists("./autohotkey/nerf_career_potential_done.txt")) {
    file.remove("./autohotkey/nerf_career_potential_done.txt")
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
# browser()

# Start on edit roster page on LAST player
# Enter create player
for (k in 1:nplayers) {
  # Move to a team and back to top of list
  add('
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up
    SendEvent "07"
      Sleep 3000')
  
  # # Move up i-1 spots
  # add(paste0('
  #   SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
  #   SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up
  #   SendEvent "', paste0(rep('w', k-1), collapse=''),'"
  #     Sleep 30'))
  
  # Nerf the top player's career potential
  # It doesn't loop around, so no reason to OCR
  add('
      SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up
      SendEvent "k" ; Select player
      Sleep 1200 ;
      SendEvent "sssssssssaaaau" ; Set carpot to 0, save
      Sleep 80 ; 
      SendEvent "sk" ; dialogue box, say yes
      Sleep 4500 ;
      ')
  
} # End player



# Press space to pause PCSX2
add('
      SendEvent " " ; space to pause
      ')

# End ahk
# Write out file
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_career_potential_done.txt")
  ')
# Beep when done
add("
    ; Done, beep  
    SoundBeep(523, 500)")

# Close 1
add("}", interrupt = F)

# browser()
# Write it ----
write(x=out, file="./autohotkey/nerf_career_potential.ahk")

# Execute it ----
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
kill_all_ahk()
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_career_potential.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

stop('not triggering')

# Trigger it ----
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()

# Loop, check for file  ----
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
cat_progress <- progress::progress_bar$new(
  format="Waiting for ahk nerf car pot :elapsed", total=NA, clear=F, width=60
)
while (as.numeric(Sys.time()-trigger_time,units="secs") < 60*15) {
  # cat('wait for ahk',
  #     as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  cat_progress$tick()
  if (file.exists("./autohotkey/nerf_career_potential_done.txt")) {
    ahk_done <- TRUE
    cat("\nFound ahk done!", "\n")
    rm(cat_progress)
    file.remove("./autohotkey/nerf_career_potential_done.txt")
    kill_all_ahk()
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("nerf_career_potential failed to finish in 120 seconds")
}
cat("Finished nerf career potential", "\n")



# Done ----
return()



} # End function
if (T) {
  cat("Switch windows now", "\n")
  # Sys.sleep(2)
  nerf_career_potential_free_agents(50)
}