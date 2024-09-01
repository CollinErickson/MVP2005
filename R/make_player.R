library(dplyr)
if (!exists('typeout2')) {
  source("./R/helpers.R")
}

# Make one player

make_player_from_row <- function(df) {
  stopifnot(is.data.frame(df), nrow(df)==1)
  
  if (file.exists("./autohotkey/make_player_p1_done.txt")) {
    file.remove("./autohotkey/make_player_p1_done.txt")
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

# addescape <- function() {
#   add("  If (Interrupted > 0) {
#   return      
# }")
# }

# Need to start on create player button, before pressing
# Enter create player
add('
    SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
    SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up
    SendEvent "k"
      Sleep 3000')

# First name
# Enter and Delete name
add(
  '\t; first name
	SendEvent "k" ; Enter first name
	Sleep 1000
    SendEvent "lllll" ; delete "sskkkkk"
  '
)

# Type first name
add(
  typeout2(df$First)
)

# Last name

# Enter and Delete name
add(
  '\n\n\t; last name
	SendEvent "sk" ; \tenter last name
	Sleep 1000
    SendEvent "lllll" ; delete "sskkkkk"
	
  '
)

# Type last name
add(
  typeout2(df$Last, start = substring(df$First, nchar(df$First), nchar(df$First)))
)

# Birth month (before date to get right number of days)

add(
  '\n\n\t; Birth month
	SendEvent "ss" ; \t move to birth month
  '
)
add(adjustLR(df$`Birth Month` - 8))

# Birth date (after month to get right number of days)

add(
  '\n\n\t; Birth date
	SendEvent "w" ; \t move to birth date
  '
)
add(adjustLR(df$`Birth Date` - 15))

# Birth year: Don't use real year since max year is 1987. Use age they 
#   would have been in 2005
add(
  '\n\n\t; Birth year
	SendEvent "ss" ; \t move to birth year
  '
)
# Don't let it wrap around (starts on 1974, from 1961 to 1987)
add(adjustLR(
  max(-13,
      min(13,
          df$`Birth Year` - 1974 - as.integer(substring(Sys.Date(),
                                                        1,4)) + 2005))))

# First position
add(
  '\n\n\t; First position
	SendEvent "s" ; \t move to first position
  '
)
fpos <- which(first_position_order == df$`First Position`)
stopifnot(length(fpos) == 1)
add(adjustLR(fpos - 1))

# Second position
add(
  '\n\n\t; Second position
	SendEvent "s" ; \t move to first position
  '
)
spos <- which(second_position_order == df$`Second Position`)
stopifnot(length(spos) <= 1)
if (length(spos) >= 1) {
  # If 1B, secondary starts at none
  if (df$`First Position` == "1B") {
    if (df$`Second Position` == "C") {
      add(adjustLR(1))
    } else {
      add(adjustLR(spos - 1))
    }
  } else if (df$`First Position` == "C") {
    # If C, secondary starts at none
    add(adjustLR(spos - 1))
  } else if (df$`First Position` %in% c("SP", "RP")) {
    # If RP/SP, can't have secondary
  } else {
    # If 2B to RF, secondary starts at 1B, but it skips their position
    if (df$`Second Position` == "C") {
      add(adjustLR(-1))
    } else {
      fpos_in_spos <- which(second_position_order == df$`First Position`)
      if (spos < fpos_in_spos) {
        add(adjustLR(spos - 2))
      } else {
        add(adjustLR(spos - 3))
      }
    }
  }
} # End second position


# Throws, starts on right
add(
  '\n\n\t; Throws
	SendEvent "s" ; \t move to throws
  '
)
if (df$Throws == "L") {
  add(adjustLR(1))
}

# Bats, starts on right
add(
  '\n\n\t; Bats
	SendEvent "s" ; \t move to throws
  '
)
if (df$Bats == "L") {
  add(adjustLR(1))
}

# Career potential, starts on 1
add(
  '\n\n\t; Career potential
	SendEvent "s" ; \t move to throws
  '
)
add(adjustLR(df$`Career Potential` - 1))


# Move to Appearance tab ---------
add(
  '\n\n\t; Appearance tab
	SendEvent "9" ; \t move to throws
  '
)

# Jersey number, starts on 15
add(
  '\n\n\t; Jersey number
  '
)
if (df$`Jersey Number` <= 70) {
  add(adjustLR(df$`Jersey Number` - 15))
} else {
  add(adjustLR(-(115 - df$`Jersey Number`)))
}

# Height, starts on 6'0" (72)
add(
  '\n\n\t; Career potential
	SendEvent "s" ; \t move to car pot
  '
)
add(adjustLR(pmax(-6, pmin(12,df$Height - 72))))




# Move to Body Build tab ----------
add(
  '\n\n\t; Body build tab
	SendEvent "9" ; \t move to throws
  '
)


# Move to Equipment tab --------
add(
  '\n\n\t; Equipment tab
	SendEvent "9" ; \t move to equipment tab
  '
)


# Batter/Fielder Ratings tab -----------
add(
  '\n\n\t; Batter/Fielder Ratings tab
	SendEvent "9" ; \t move to Batter/Fielder Ratings tab
  '
)


# Batter stance
add(
  '\n\n\t; Batter stance
      ')
which_bs <- which(df$`Batter Stance` == names(batter_stance_options))
stopifnot(length(which_bs), is.integer(which_bs))
add(adjustLRcts(1,
                which_bs,
                minval=1, maxval=length(batter_stance_options)))


# Contact v R, 50
add(
  '\n\n\t; Contact v R
	SendEvent "s" ; \t move to Contact v R
  '
)
add(adjustLR(df$`Contact vs RHP` - 50))

# Contact v L, 50
add(
  '\n\n\t; Contact v L
	SendEvent "s" ; \t move to Contact v R
  '
)
add(adjustLR(df$`Contact vs LHP` - 50))

# Power v R, 50
add(
  '\n\n\t; Power v R
	SendEvent "s" ; \t move to Power v R
  '
)
add(adjustLR(df$`Power vs RHP` - 50))

# Power v L, 50
add(
  '\n\n\t; Power v L
	SendEvent "s" ; \t move to Power v R
  '
)
add(adjustLR(df$`Power vs LHP` - 50))

# Bunting
add(
  '\n\n\t; Bunting
	SendEvent "s" ; \t move to Bunting
  '
)
add(adjustLRdiscrete(50, df$Bunting))

# Plate Discipline
add(
  '\n\n\t; Plate Discipline
	SendEvent "s" ; \t move to Plate Discipline
  '
)
add(adjustLRdiscrete(50, df$`Plate Discipline`))

# Durability
add(
  '\n\n\t; Durability
	SendEvent "s" ; \t move to Durability
  '
)
add(adjustLRdiscrete(50, df$Durability))

# Speed
add(
  '\n\n\t; Speed
	SendEvent "s" ; \t move to Speed
  '
)
add(adjustLRcts(50, df$Speed, maxval=99))

# Stealing Tendency
add(
  '\n\n\t; Stealing Tendency
	SendEvent "s" ; \t move to Stealing Tendency
  '
)
add(adjustLRdiscrete(50, df$`Stealing Tendency`))

# Baserunning Ability
add(
  '\n\n\t; Baserunning Ability
	SendEvent "s" ; \t move to Baserunning Ability
  '
)
add(adjustLRdiscrete(50, df$`Baserunning Ability`))

# Fielding
add(
  '\n\n\t; Fielding
	SendEvent "s" ; \t move to Fielding
  '
)
add(adjustLRdiscrete(50, df$Fielding))

# Range
add(
  '\n\n\t; Range
	SendEvent "s" ; \t move to Range
  '
)
add(adjustLRdiscrete(50, df$Range))

# Throwing Strength
add(
  '\n\n\t; Throwing Strength
	SendEvent "s" ; \t move to Throwing Strength
  '
)
add(adjustLRdiscrete(50, df$`Throwing Strength`))

# Throwing Accuracy
add(
  '\n\n\t; Throwing Accuracy
	SendEvent "s" ; \t move to Throwing Accuracy
  '
)
add(adjustLRdiscrete(50, df$`Throwing Accuracy`))


# Move to Batter Tendencies tab --------
add(
  '\n\n\t; Batter Tendencies tab
	SendEvent "9" ; \t move to Batter Tendencies tab
  '
)

# FB Take vL
add(
  '\n\n\t; FB Take vL
	SendEvent "s" ; \t move to FB Take vL
  '
)
add(adjustLRdiscrete(50, df$`Fastball Take vs LHP`))

# FB Take vR
add(
  '\n\n\t; FB Take vR
	SendEvent "s" ; \t move to FB Take vR
  '
)
add(adjustLRdiscrete(50, df$`Fastball Take vs RHP`))

# FB Miss vL
add(
  '\n\n\t; FB Miss vL
	SendEvent "s" ; \t move to FB Miss vL
  '
)
add(adjustLRdiscrete(50, df$`Fastball Miss vs LHP`))

# FB Miss vR
add(
  '\n\n\t; FB Miss vR
	SendEvent "s" ; \t move to FB Miss vR
  '
)
add(adjustLRdiscrete(50, df$`Fastball Miss vs RHP`))

# FB Chase vL
add(
  '\n\n\t; FB Chase vL
	SendEvent "s" ; \t move to FB Chase vL
  '
)
add(adjustLRdiscrete(50, df$`Fastball Chase vs LHP`))

# FB Chase vR
add(
  '\n\n\t; FB Chase vR
	SendEvent "s" ; \t move to FB Chase vR
  '
)
add(adjustLRdiscrete(50, df$`Fastball Chase vs RHP`))

# CB Take vL
add(
  '\n\n\t; CB Take vL
	SendEvent "ss" ; \t move to CB Take vL
  '
)
add(adjustLRdiscrete(50, df$`Curveball Take vs LHP`))

# CB Take vR
add(
  '\n\n\t; CB Take vR
	SendEvent "s" ; \t move to CB Take vR
  '
)
add(adjustLRdiscrete(50, df$`Curveball Take vs RHP`))

# CB Miss vL
add(
  '\n\n\t; CB Miss vL
	SendEvent "s" ; \t move to CB Miss vL
  '
)
add(adjustLRdiscrete(50, df$`Curveball Miss vs LHP`))

# CB Miss vR
add(
  '\n\n\t; CB Miss vR
	SendEvent "s" ; \t move to CB Miss vR
  '
)
add(adjustLRdiscrete(50, df$`Curveball Miss vs RHP`))

# CB Chase vL
add(
  '\n\n\t; CB Chase vL
	SendEvent "s" ; \t move to CB Chase vL
  '
)
add(adjustLRdiscrete(50, df$`Curveball Chase vs LHP`))

# CB Chase vR
add(
  '\n\n\t; CB Chase vR
	SendEvent "s" ; \t move to CB Chase vR
  '
)
add(adjustLRdiscrete(50, df$`Curveball Chase vs RHP`))

# SL Take vL
add(
  '\n\n\t; SL Take vL
	SendEvent "ss" ; \t move to SL Take vL
  '
)
add(adjustLRdiscrete(50, df$`Slider Take vs LHP`))

# SL Take vR
add(
  '\n\n\t; SL Take vR
	SendEvent "s" ; \t move to SL Take vR
  '
)
add(adjustLRdiscrete(50, df$`Slider Take vs RHP`))

# SL Miss vL
add(
  '\n\n\t; SL Miss vL
	SendEvent "s" ; \t move to SL Miss vL
  '
)
add(adjustLRdiscrete(50, df$`Slider Miss vs LHP`))

# SL Miss vR
add(
  '\n\n\t; SL Miss vR
	SendEvent "s" ; \t move to SL Miss vR
  '
)
add(adjustLRdiscrete(50, df$`Slider Miss vs RHP`))

# SL Chase vL
add(
  '\n\n\t; SL Chase vL
	SendEvent "s" ; \t move to SL Chase vL
  '
)
add(adjustLRdiscrete(50, df$`Slider Chase vs LHP`))

# SL Chase vR
add(
  '\n\n\t; SL Chase vR
	SendEvent "s" ; \t move to SL Chase vR
  '
)
add(adjustLRdiscrete(50, df$`Slider Chase vs RHP`))

# Pitcher tab ----
if (df$`First Position` %in% c("SP", "RP")) {
  add(
    '\n\n\t; Pitcher tab
	SendEvent "999" ; \t move to Pitcher tab
  '
  )
  
  # Pitcher Delivery
  add(
    '\n\n\t; Pitcher Delivery
      ')
  which_pd <- which(df$`Pitcher Delivery` == names(pitcher_delivery_options))
  stopifnot(length(which_pd), is.integer(which_pd))
  add(adjustLRcts(1,
                  which_pd,
                  minval=1, maxval=length(pitcher_delivery_options)))
  
  # Stamina
  add(
    '\n\n\t; Stamina
	    SendEvent "s" ; \t move to Stamina
      ')
  add(adjustLR(df$Stamina - 50))
  
  # Pickoff
  add(
    '\n\n\t; Pickoff
	    SendEvent "s" ; \t move to Pickoff
      ')
  add(adjustLRdiscrete(50, df$Pickoff))
  
  # Fastball Control
  add(
    '\n\n\t; Fastball Control
	    SendEvent "s" ; \t move to Fastball Control
      ')
  add(adjustLR(df$`Fastball Control` - 50))
  
  # Fastball Velocity
  add(
    '\n\n\t; Fastball Velocity
	    SendEvent "s" ; \t move to Fastball Velocity
      ')
  add(adjustLR(df$`Fastball Velocity` - 84))
  
  pitches_added <- 1
  current_pitcher_order_ind <- 1
  for (i in 1:length(pitch_order)) {
    # Not all pitches are in MVPdf (2-seam, knuckle, palm, etc)
    if (paste0(pitch_order[i], " Control") %in% colnames(df)) {
      # Check if player has that pitch
      if (!is.na(df[[paste0(pitch_order[i], " Control")]])) {
        # browser()
        # Add that pitch
        pitches_added <- pitches_added + 1
        
        # Select pitch type
        add(
          '\n\n\t; Pitch type
      	    SendEvent "s" ; \t move to pitch type
            ')
        add(adjustLR(i - ifelse(pitches_added==2, 1, 0)))
        
        # Pitch Movement
        add(
          '\n\n\t; Pitch Movement
      	    SendEvent "s" ; \t move to Pitch Movement
            ')
        add(adjustLRdiscrete(50, df[[paste0(pitch_order[i], " Movement")]]))
        
        # Pitch Trajectory (pick something random)
        add(
          '\n\n\t; Pitch Trajectory
      	    SendEvent "s" ; \t move to Pitch Trajectory
            ')
        add(adjustLR(sample((-3):3, 1)))
        
        # Pitch Control
        add(
          '\n\n\t; Pitch Control
      	    SendEvent "s" ; \t move to Pitch Control
            ')
        add(adjustLR(df[[paste0(pitch_order[i], " Control")]] - 50))
        
        # Pitch Velocity
        add(
          '\n\n\t; Pitch Velocity
      	    SendEvent "s" ; \t move to Pitch Velocity
            ')
        add(adjustLR(df[[paste0(pitch_order[i], " Velocity")]] - pitch_speed_default[i]))
      }
    }
    if (pitches_added >= 5) {
      break
    }
  }
  
} # End is pitcher

# End ahk
# Write out file ----
add('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/make_player_p1_done.txt")
  ')
# Beep when done
add("
      SoundBeep(523, 500)")
# Close 1
add("}", interrupt=FALSE)

# # Return
# out


# Write it ----
write(x=out, file="./autohotkey/make_player_p1.ahk")

# Execute it ----
# system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
#        wait=FALSE)
system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/make_player_p1.ahk',
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
  format="Waiting for ahk make_player p1 :elapsed", total=NA, clear=F, width=60
)
while (as.numeric(Sys.time()-trigger_time,units="secs") < 240) {
  # cat('p3 wait ahk', 
  #     as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
  cat_progress$tick()
  if (file.exists("./autohotkey/make_player_p1_done.txt")) {
    ahk_done <- TRUE
    cat("\nFound ahk done!", "\n")
    file.remove("./autohotkey/make_player_p1_done.txt")
    rm(cat_progress)
    break
  }
  Sys.sleep(.5)
}
if (!ahk_done) {
  stop("make_player ahk failed to finish in 120 seconds")
}


cat("Finished make_player_from_row", "\n")

# Done ----
return()
}
# player_ahk <- make_player_from_row(players[1,])
# cat(player_ahk)
# write(x=player_ahk, file="./autohotkey/write_player.ahk")

if (T) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  make_player_from_row(players[1,])
}
