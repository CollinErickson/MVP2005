if (!exists("read_stat_with_ocr")) {
  source('./R/read_stat_with_ocr.R')
}

# Reduce the stats of a batter down to 0

nerf_one_batter <- function(add_at_end=NULL) {
  # Make sure that file doesn't exist ----
  if (file.exists("./autohotkey/nerf_one_batter_p1_done.txt")) {
    file.remove("./autohotkey/nerf_one_batter_p1_done.txt")
  }
  if (file.exists("./autohotkey/nerf_one_batter_p2_done.txt")) {
    file.remove("./autohotkey/nerf_one_batter_p2_done.txt")
  }
  if (file.exists("./autohotkey/nerf_one_batter_p3_done.txt")) {
    file.remove("./autohotkey/nerf_one_batter_p3_done.txt")
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
  SetKeyDelay 175, 70  ; 75ms between keys, 25ms between down/up.\n'



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
        SendEvent "999" ; move right 3 tabs to batter/fielder ratings
        SendEvent "ssssssw" ; move so contact/power/pltdisc are vis
    ')

# End ahk
# Write out file
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p1_done.txt")
  ')
# Beep when done
add("
      SoundBeep(523, 500)")
# Close 1
add("}", interrupt = F)

# Write it
write(x=out, file="./autohotkey/nerf_one_batter_p1.ahk")

# Execute it
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p1.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

# Trigger it
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()

# Loop, check for file 
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
while (as.numeric(Sys.time()-trigger_time,units="secs") < 120) {
  cat('p1 wait ahk', 
      as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  if (file.exists("./autohotkey/nerf_one_batter_p1_done.txt")) {
    ahk_done <- TRUE
    cat("Found ahk done!", "\n")
    file.remove("./autohotkey/nerf_one_batter_p1_done.txt")
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("nerf_one_batter failed to finish in 120 seconds")
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
screenshot::screenshot(file="./images/tmp_nerf_one_batter_p1.png")
cat("Took screenshot", "\n")
# Wait a second for it to get the screenshot
Sys.sleep(2)
# Read in screenshot
img <- magick::image_read("./images/tmp_nerf_one_batter_p1.png")
img
# 


conR <- read_stat_with_ocr(img, 426)
conL <- read_stat_with_ocr(img, 500)
powR <- read_stat_with_ocr(img, 570)
powL <- read_stat_with_ocr(img, 643)
platedisc <- read_stat_with_ocr(img, 787, is_discrete = TRUE)

# Move faster
add('
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  ')

## Adjust stats ----
# Set conR to 0
add('
    SendEvent "wwww" ; move to conR
    ')
if (!is.na(conR)) {add(adjustLRcts(start = conR, goal = 0))}
# Set conL to 0
add('
    SendEvent "s" ; move to conL
    ')
if (!is.na(conL)) {add(adjustLRcts(start = conL, goal = 0))}
# Set powR to 0
add('
    SendEvent "s" ; move to powR
    ')
if (!is.na(powR)) {add(adjustLRcts(start = powR, goal = 0))}
# Set powL to 0
add('
    SendEvent "s" ; move to powL
    ')
if (!is.na(powL)) {add(adjustLRcts(start = powL, goal = 0))}
# Set platedisc to 0
add('
    SendEvent "ss" ; move to platedisc
    ')
if (!is.na(platedisc)) {add(adjustLRdiscrete(start = platedisc, goal = 0))}

# Move to set up part 3
add('
    SendEvent "ssssssswwww" ; move to stealing tendency, with speed on top
    ')
# Avoid reusing variables later
rm(conR, conL, powR, powL, platedisc)


# End ahk
# Write out file
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p2_done.txt")
  ')
# Beep when done
add("
      SoundBeep(523, 500)")

# Close 1
add("}", interrupt = F)

# Write it
write(x=out, file="./autohotkey/nerf_one_batter_p2.ahk")

# Execute it
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p2.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

# Trigger it
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()

# Loop, check for file 
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
while (as.numeric(Sys.time()-trigger_time,units="secs") < 120) {
  cat('p2 wait ahk',
      as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  if (file.exists("./autohotkey/nerf_one_batter_p2_done.txt")) {
    ahk_done <- TRUE
    cat("Found ahk done!", "\n")
    file.remove("./autohotkey/nerf_one_batter_p2_done.txt")
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("nerf_one_batter failed to finish in 120 seconds")
}

# Part 3 ----
cat("\n\n\nSTARTING PART 3", "\n")

# Create ahk p3
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
# file.remove("./images/tmp_nerf_one_batter_p1.png")
screenshot::screenshot(file="./images/tmp_nerf_one_batter_p2.png")
cat("Took screenshot", "\n")
# Wait a second for it to get the screenshot
Sys.sleep(2)
# Read in screenshot
img <- magick::image_read("./images/tmp_nerf_one_batter_p2.png")

# 

speed <- read_stat_with_ocr(img, 426)
brability <- read_stat_with_ocr(img, 570, is_discrete=T)
fielding <- read_stat_with_ocr(img, 643, is_discrete=T)
rang <- read_stat_with_ocr(img, 713, is_discrete=T)
throwstrength <- read_stat_with_ocr(img, 783, is_discrete=T)

# Move faster
add('
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  ')

## Adjust stats ----
# Set speed to 0
add('
    SendEvent "w" ; move to speed
    ')
if (!is.na(speed)) {add(adjustLRcts(start = speed, goal = 0, max=99))}
# Set brability to 0
add('
    SendEvent "ss" ; move to brability
    ')
if (!is.na(brability)) {add(adjustLRdiscrete(start = brability, goal = 0))}
# Set fielding to 0
add('
    SendEvent "s" ; move to fielding
    ')
if (!is.na(fielding)) {add(adjustLRdiscrete(start = fielding, goal = 0))}
# Set rang to 0
add('
    SendEvent "s" ; move to rang
    ')
if (!is.na(rang)) {add(adjustLRdiscrete(start = rang, goal = 0))}
# Set throwstrength to 0
add('
    SendEvent "s" ; move to throwstrength
    ')
if (!is.na(throwstrength)) {add(adjustLRdiscrete(start = throwstrength, goal = 0))}

# Save
add('
    SendEvent "u" ; save and exit
    Sleep 200 ; wait for popup
    SendEvent "sk"
    ')
# 
# ## Save ----
# add('
#     SendEvent "u" ; save and exit
#     Sleep 200 ; wait for popup
#     SendEvent "sk"
#     ')

# Add something at end if needed
if (!is.null(add_at_end)) {
  add(add_at_end)
}


# End ahk
# Write out file
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p3_done.txt")
  ')
# Beep when done
add("
      SoundBeep(523, 500)")

# Close 1
add("}", interrupt = F)

# Write it
write(x=out, file="./autohotkey/nerf_one_batter_p3.ahk")

# Execute it
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/nerf_one_batter_p3.ahk',
       wait=FALSE)

# Wait a sec
Sys.sleep(1)

# Trigger it
KeyboardSimulator::keybd.press("shift+ctrl+1")
trigger_time <- Sys.time()


# Loop, check for file 
cat("R will now wait for ahk to run", "\n")
ahk_done <- FALSE
while (as.numeric(Sys.time()-trigger_time,units="secs") < 120) {
  cat('p3 wait ahk', 
      as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  if (file.exists("./autohotkey/nerf_one_batter_p3_done.txt")) {
    ahk_done <- TRUE
    cat("Found ahk done!", "\n")
    file.remove("./autohotkey/nerf_one_batter_p3_done.txt")
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("nerf_one_batter failed to finish in 120 seconds")
}


cat("Finished one batter", "\n")

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
  nerf_one_batter()
}
