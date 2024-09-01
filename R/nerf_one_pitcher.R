if (!exists("read_stat_with_ocr")) {
  source('./R/read_stat_with_ocr.R')
}


# Reduce the stats of a batter down to 0

nerf_one_pitcher <- function(add_at_end=NULL) {
  cat("Starting nerf_one_pitcher\n")
  
  # Make sure that file doesn't exist ----
  if (file.exists("./autohotkey/nerf_one_pitcher_p1_done.txt")) {
    file.remove("./autohotkey/nerf_one_pitcher_p1_done.txt")
  }
  if (file.exists("./autohotkey/nerf_one_pitcher_p2_done.txt")) {
    file.remove("./autohotkey/nerf_one_pitcher_p2_done.txt")
  }
  
  
  # Part 1 ----
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
  SoundBeep(523, 500)
  Global Interrupted
  Interrupted := 0
  SetKeyDelay 100, 50  ; 75ms between keys, 25ms between down/up.\n'



add <- function(x, interrupt=TRUE) {
  out <<- paste0(out, "\n  ", x, "\n")
  if (interrupt) {
    out <<- paste0(out,"  If (Interrupted > 0) {
      SoundBeep(523, 500)
      return      
    }\n")
  }
}

# Enter player
add('
        SendEvent "k" ; enter player
        Sleep 4000 ; wait for player to load
        SendEvent "8" ; move left 1 tab to pitcher ratings
    ')

# End ahk
# Write out file
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_pitcher_p1_done.txt")
  ')
# Beep when done
add("
      SoundBeep(523, 500)")
# Close 1
add("}", interrupt = F)

# Write it
write(x=out, file="./autohotkey/nerf_one_pitcher_p1.ahk")

# Execute it
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_pitcher_p1.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

# Trigger it
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()

# Loop, check for file 
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
cat_progress <- progress::progress_bar$new(
  format="Waiting for ahk p1 :elapsed", total=NA, clear=F, width=60
)
while (as.numeric(Sys.time()-trigger_time,units="secs") < 120) {
  # cat('wait ahk',
  #     as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  cat_progress$tick()
  if (file.exists("./autohotkey/nerf_one_pitcher_p1_done.txt")) {
    ahk_done <- TRUE
    cat("\nFound ahk done!", "\n")
    rm(cat_progress)
    file.remove("./autohotkey/nerf_one_pitcher_p1_done.txt")
    kill_all_ahk()
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("p1 nerf_one_pitcher failed to finish in 120 seconds")
}


# stop("killed it")
# Part 2 ----

# Create ahk p2

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
  SoundBeep(523, 500)
  Global Interrupted
  Interrupted := 0
  SetKeyDelay 275, 70  ; 75ms between keys, 25ms between down/up.\n'

# Get screenshot
screenshot::screenshot(file="./images/tmp_nerf_one_pitcher.png")
cat("Took screenshot", "\n")
# Wait a second for it to get the screenshot
Sys.sleep(2)
# Read in screenshot
img <- magick::image_read("./images/tmp_nerf_one_pitcher.png")
img
# 


# conR <- read_stat_with_ocr(img, 426)
stamina <- read_stat_with_ocr(img, 500)
pickoff <- read_stat_with_ocr(img, 570, is_discrete=T)
fbcontrol <- read_stat_with_ocr(img, 643)
fbvelo <- read_stat_with_ocr(img, 714)

print(data.frame(stat=c('stamina', 'pickoff', 'fbcontrol', 'fbvelo'), 
                 value=c(stamina, pickoff, fbcontrol, fbvelo)))

# Move faster
add('
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  ')

## Adjust stats ----
# Set stamina to 1 (1-99 scale)
add('
    SendEvent "s" ; move to stamina
    ')
if (!is.na(stamina)) {add(adjustLRcts(start = stamina, goal = 1, maxval = 99, minval = 1))}
# Set pickoff to 0
add('
    SendEvent "s" ; move to pickoff
    ')
if (!is.na(pickoff)) {add(adjustLRdiscrete(start = pickoff, goal = 0))}
# Set fbcontrol to 0
add('
    SendEvent "s" ; move to fbcontrol
    ')
if (!is.na(fbcontrol)) {add(adjustLRcts(start = fbcontrol, goal = 0))}
# Set fbvelo to 0
add('
    SendEvent "s" ; move to fbvelo
    ')
if (!is.na(fbvelo)) {add(adjustLRcts(start = fbvelo, goal = 77, minval=77, maxval=101))}

## Clear pitches 2-5 -----
for (i in 2:5) {
  add(paste0('
     ; editing pitch ', i,'
    SendEvent "sda" ; Reset pitch
    SendEvent "saaaaa" ; Set movement to 0
    SendEvent "ss" ; Move to control
    '))
  # add(adjustLRcts(start=50, goal=0)) # Set control to 0
  add('
    SetKeyDelay 75, 2000  ; Hold for 2 seconds to get near 0 faster than 
                          ; repeated presses, this gets it to 5 or 6 when 
                          ; running PCSX2 at 2x speed
    SendEvent "a" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
    ')
  add('
    SendEvent "saaaaaaa" ; Move velo down 7 (slider only goes down 7)
    ')
}


## Save ----
add('
    SendEvent "u" ; save and exit
    Sleep 600 ; wait for popup
    SendEvent "sk"
    ')

# Add something at end if needed
if (!is.null(add_at_end)) {
  add(add_at_end)
}

# End ahk
# Write out file
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_pitcher_p2_done.txt")
  ')
# Beep when done
add("
    ; Done, beep  
    SoundBeep(523, 500)")

# Close 1
add("}", interrupt = F)

# Write it
write(x=out, file="./autohotkey/nerf_one_pitcher_p2.ahk")

# Execute it
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_pitcher_p2.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

# Trigger it
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()

# Loop, check for file 
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
cat_progress <- progress::progress_bar$new(
  format="Waiting for ahk p2 :elapsed", total=NA, clear=F, width=60
)
while (as.numeric(Sys.time()-trigger_time,units="secs") < 120) {
  # cat('wait for ahk',
  #     as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  cat_progress$tick()
  if (file.exists("./autohotkey/nerf_one_pitcher_p2_done.txt")) {
    ahk_done <- TRUE
    cat("\nFound ahk done!", "\n")
    rm(cat_progress)
    file.remove("./autohotkey/nerf_one_pitcher_p2_done.txt")
    kill_all_ahk()
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("p2 nerf_one_pitcher failed to finish in 120 seconds")
}
cat("Finished one pitcher", "\n")



# Done ----
return()
}

# clear_ahk <- clear_one_org(norgs = 2, nlevels = 4)
# clear_ahk%>% cat
# 
# 
# write(x=clear_ahk, file="./autohotkey/clear_org.ahk")
if (F) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  nerf_one_pitcher()
}
