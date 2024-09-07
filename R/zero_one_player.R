if (!exists("is_pitcher_on_edit_player_page")) {
  source('./R/is_pitcher_on_edit_player_page.R')
}
# if (!exists("nerf_one_pitcher")) {
#   source('./R/nerf_one_pitcher.R')
# }
# if (!exists("nerf_one_batter")) {
#   source('./R/nerf_one_batter.R')
# }


is_zeroed_pitcher_on_edit_player_page <- function(img) {
  # Sys.sleep(2); screenshot::screenshot(file="./images/tmp_is_zeroed_pitcher_on_edit_player_page.png")
  # ss <- magick::image_read("./images/tmp_is_zeroed_pitcher_on_edit_player_page.png")
  # magick::image_crop(ss, "50x60+660+410")[[1]][1:3,,] %>% as.integer %>% mean
  # magick::image_crop(ss, "50x60+660+410") %>% magick::image_threshold() %>% .[[1]] %>% .[1:3,,] %>% as.integer %>% mean
  return(
    # abs(
    #   (magick::image_crop(img, "50x60+660+410")[[1]][1:3,,] %>%
    #      as.integer %>% mean) - 85.83267) < 0.75
    abs(
      (magick::image_threshold(magick::image_crop(img, "50x60+660+410")
      )[[1]][1:3,,] %>%
        as.integer %>% mean) - 11.79278) < 0.75
  )
}
if (F) {
  # Sys.sleep(2); is_zeroed_pitcher_on_edit_player_page()
}

is_zeroed_batter_on_edit_player_page <- function(img) {
  Sys.sleep(2); screenshot::screenshot(file="./images/tmp_is_zeroed_batter_on_edit_player_page.png")
  ss <- magick::image_read("./images/tmp_is_zeroed_batter_on_edit_player_page.png")
  magick::image_crop(ss, "50x140+822+350")[[1]][1:3,,] %>% as.integer %>% mean
  # 82.363 for 0/80/0
  return(
    abs(
      (magick::image_crop(img, "50x60+660+410")[[1]][1:3,,] %>%
         as.integer %>% mean) - 81.15795) < 0.75
  )
}
if (F) {
  # Sys.sleep(2); is_zeroed_pitcher_on_edit_player_page()
}


zero_one_player <- function(add_at_end=NULL,
                            add_at_beginning=NULL) {
  zero_start_time <- Sys.time()
  # Check pitcher/hitter, if already zeroed ----
  # screenshot::screenshot(file="./images/tmp_zero_one_player.png")
  # cat("Took screenshot", "\n")
  # Wait a second for it to get the screenshot
  # Sys.sleep(2)
  # Read in screenshot
  img <- screenshot_and_read("./images/tmp_zero_one_player.png")
  
  is_pitcher <- is_pitcher_on_edit_player_page(img)
  
  # Check if zeroed
  if (is_pitcher) {
    cat("is pitcher", "\n")
    # browser()
    # nerf_one_pitcher(add_at_end=add_at_end)
    is_zeroed <- is_zeroed_pitcher_on_edit_player_page(img)
  } else {
    cat("is batter\n")
    # nerf_one_batter(add_at_end=add_at_end)
    is_zeroed <- is_zeroed_batter_on_edit_player_page(img)
  }
  if (is_zeroed) {
    return("already_done")
  }
  
  image_down_pixels <- c(435,508,580,652,727,800)
  
  # Next basically go through all pages of the edit player
  
  # Enter edit player
  r <- run_ahk_object$new()
  r$add("SendEvent 'k' ; enter edit player
        Sleep 2500 ; wait for player to load")
  r$run_ahk('zero_one_player', kill_before=TRUE) # Kill before first one only
  rm(r)
  
  is_editable <- is_editable_player()
  
  something_failed <- FALSE
  
  # General Inf p1 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  if (is_editable) {
    # Birth month
    magick::image_crop(ss, "220x40+1190+655")
    birth_month <- edit_player_read_ocr_objects$birth_month$ocr(ss, "220x40+1190+655")
    r$add_SendEvent("sss")
    if (!is.na(birth_month)) {
      r$add(adjustLRcts(month_to_int(birth_month), 1, minval=1, maxval=12))
    } else {
      something_failed <- FALSE
    }
    # Birth day
    # magick::image_crop(ss, "65x45+1270+580")
    birth_day <- edit_player_read_ocr_objects$birth_day$ocr(ss, "65x45+1270+580")
    r$add_SendEvent('w')
    if (!is.na(birth_day)) {
      r$add(adjustLR(-(birth_day - 15)))
    } else {
      something_failed <- FALSE
    }
    # Birth year
    # magick::image_crop(ss, "110x40+1250+730")
    r$add_SendEvent("ss")
    birth_year <- edit_player_read_ocr_objects$birth_year$ocr(ss, "110x40+1250+730")
    if (!is.na(birth_year)) {
      r$add(adjustLRcts(birth_year, 1975, minval=1961, maxval=1987))
    } else {
      something_failed <- FALSE
    }
  }
  # First position
  # magick::image_crop(ss, "80x45+1260+800")
  r$add_SendEvent("s")
  if (is_editable) {
    # browser()
    first_position <- edit_player_read_ocr_objects$position$ocr(ss, "80x45+1260+800")
    if (!is.na(first_position)) {
      if (first_position == "SP") {
        # good
      } else if (first_position == "RP") {
        r$add_SendEvent("a")
      } else if (first_position == "C" ) {
        # good
      } else {
        pos <- which(first_position_order == first_position)
        stopifnot(length(pos)==1, !is.na(pos))
        r$add(adjustLR(-pos))
      }
    } else {
      something_failed <- FALSE
    }
  }
  
  # End page
  
  # Move to next page
  r$add("SendEvent 'ssssssssssw'")
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  # stop('stopp1')
  # General Inf p2 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  if (is_editable) {
    # Second position
    # magick::image_crop(ss, "80x45+1260+505")
    r$add_SendEvent("www") # move to second pos
    if (!is_pitcher && is_editable) {
      second_position <- edit_player_read_ocr_objects$position$ocr(ss,
                                                                   "80x45+1260+505")
      if (!is.na(second_position) && second_position != "None") {
        pos <- which(second_position_order == second_position)
        stopifnot(length(pos)==1, !is.na(pos))
        r$add(adjustLR(-(pos - 1)))
        
      } else {
        something_failed <- FALSE
      }  
    }
    
    
    # Throws
    r$add_SendEvent('s')
    if (is_pitcher) {
      # magick::image_crop(ss, "120x45+1240+580")
      throws <- edit_player_read_ocr_objects$throws_bats$ocr(ss, "120x45+1240+580")
      if (!is.na(throws)) {
        if (throws == 'LEFT') {
          r$add_SendEvent('a')
        }
      } else {
        something_failed <- FALSE
      }
      rm(throws)
    } else {
      # Skip Throws, all C are RIGHT
    }
    
    # Bats
    r$add_SendEvent("s") # move to bats
    # magick::image_crop(ss, "120x45+1240+655")
    bats <- edit_player_read_ocr_objects$throws_bats$ocr(ss, "120x45+1240+655")
    if (!is.na(bats)) {
      if (bats == 'LEFT') {
        r$add_SendEvent('a')
      } else if (bats == 'SWITCH') {
        r$add_SendEvent('d')
      }
    } else {
      something_failed <- FALSE
    }
  }
  
  # Career potential: set to 1 for real players, 5 for editables
  r$add_SendEvent('s')
  if (is_editable) {
    r$add_SendEvent("dddd")
  } else {
    r$add_SendEvent("aaaa")
  }
  
  # Batter ditty type
  r$add_SendEvent('s')
  if (is_editable) {
    # magick::image_crop(ss, "240x45+1180+800")
    bdt <- edit_player_read_ocr_objects$batter_ditty_type$ocr(ss, "240x45+1180+800")
    if (!is.na(bdt)) {
      r$add(adjustLRcts(which(bdt==batter_ditty_type_options), 1, minval=1, 
                        maxval=length(batter_ditty_type_options)))
    } else {
      something_failed <- FALSE
    }
  }
  
  # End page
  
  # Move to next page, move down to height
  r$add_SendEvent('9s')
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  
  
  # Appearance ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  if (is_editable) {
    # Jersey number
    # browser()
    r$add_SendEvent('w')
    # magick::image_crop(ss, "80x45+1260+435")
    jersey <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+435")
    if (!is.na(jersey)) {
      r$add(adjustLRcts(jersey, 15, minval=1, 
                        maxval=99))
    } else {
      something_failed <- FALSE
    }
    
    # Face
    r$add_SendEvent('ssss')
    # magick::image_crop(ss, "80x45+1260+727")
    face <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
    if (!is.na(face)) {
      r$add("SetKeyDelay 275, 40 ; slower for face")
      r$add(adjustLRcts(face, 1, minval=1, 
                        maxval=15))
      r$add("SetKeyDelay 95, 40 ; slower for face")
    } else {
      something_failed <- FALSE
    }
    rm(face)
    
    # Hair color
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+800")
    hair <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+800")
    if (!is.na(hair)) {
      # browser()
      # Move slower for hair
      r$add("SetKeyDelay 175, 40 ; slower for hair")
      r$add(adjustLRcts(hair, 1, minval=1, 
                        maxval=7))
      r$add("SetKeyDelay 95, 40 ; slower for hair")
    } else {
      something_failed <- FALSE
    }
    rm(hair)
    
    r$add_SendEvent('ssww')
    r$run_ahk('zero_one_player', kill_before=FALSE)
    rm(r, ss)
    
    # Appearance p2 ----
    ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
    r <- run_ahk_object$new()
    
    # Hair Style
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+727")
    hair <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
    if (!is.na(hair)) {
      r$add("SetKeyDelay 175, 40 ; slower for hair")
      r$add(adjustLRcts(hair, 1, minval=1, 
                        maxval=10))
      r$add("SetKeyDelay 95, 40 ; slower for hair")
    } else {
      something_failed <- FALSE
    }
    rm(hair)
    
    # Facial hair
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+800")
    facialhair <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+800")
    if (!is.na(facialhair)) {
      # browser()
      r$add(adjustLRcts(facialhair, 1, minval=1, 
                        maxval=8))
    } else {
      something_failed <- FALSE
    }
    rm(facialhair)
  }
  
  r$add_SendEvent('9sssss') # Move to next tab
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  # stop('hsty')
  
  # Equipment p1 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  # Bat Color
  r$add_SendEvent('wwwww')
  # magick::image_crop(ss, "80x45+1260+435")
  batcolor <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+435")
  if (!is.na(batcolor)) {
    r$add(adjustLRcts(batcolor, 1, minval=1, 
                      maxval=8))
  } else {
    something_failed <- FALSE
  }
  
  # Fielding glove
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+508")
  fglove <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+508")
  if (!is.na(fglove)) {
    r$add(adjustLRcts(fglove, 1, minval=1, 
                      maxval=5))
  } else {
    something_failed <- FALSE
  }
  
  # Elbow guard
  r$add_SendEvent('s')
  # magick::image_crop(ss, "95x45+1255+580")
  elbowguard <- edit_player_read_ocr_objects$none_or_cts$ocr(ss, "95x45+1255+580")
  if (!is.na(elbowguard)) {
    r$add(adjustLRnoneorcts(elbowguard, "NONE"))
  } else {
    something_failed <- FALSE
  }
  rm(elbowguard)
  
  # Shin guard
  r$add_SendEvent('s')
  # magick::image_crop(ss, "95x45+1255+652")
  shinguard <- edit_player_read_ocr_objects$none_or_cts$ocr(ss, "95x45+1255+652")
  if (!is.na(shinguard)) {
    r$add(adjustLRnoneorcts(shinguard, "NONE"))
  } else {
    something_failed <- FALSE
  }
  rm(shinguard)
  
  # Wrist guard
  r$add_SendEvent('s')
  magick::image_crop(ss, "95x45+1255+727")
  wristguard <- edit_player_read_ocr_objects$none_or_cts$ocr(ss, "95x45+1255+727")
  if (!is.na(wristguard)) {
    # browser()
    r$add(adjustLRnoneorcts(wristguard, "NONE"))
  } else {
    something_failed <- FALSE
  }
  rm(wristguard)
  
  r$add_SendEvent('ssswww')
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  
  # Equipment p2 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  # Socks
  r$add_SendEvent('s')
  # magick::image_crop(ss, "180x40+1210+655")
  socks <- edit_player_read_ocr_objects$socks$ocr(ss, "180x40+1210+655")
  if (!is.na(socks)) {
    r$add(adjustLRcharlist(socks, "REGULAR",
                           edit_player_read_ocr_objects$socks$char_list))
  } else {
    something_failed <- FALSE
  }
  rm(socks)
  
  # Catcher mask 1/2
  r$add_SendEvent('s')
  magick::image_crop(ss, "80x45+1260+727")
  catchermask <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
  if (!is.na(catchermask)) {
    stopifnot(catchermask %in% c(1,2))
    r$add(adjustLR(catchermask - 1))
  } else {
    something_failed <- FALSE
  }
  rm(catchermask)
  
  # Batting gloves on/off
  r$add_SendEvent('s')
  magick::image_crop(ss, "80x45+1260+800")
  bgloves <- edit_player_read_ocr_objects$on_off$ocr(ss, "80x45+1260+800")
  if (!is.na(bgloves)) {
    r$add(adjustLRcharlist(bgloves, "ON", c("ON", "OFF")))
  } else {
    something_failed <- FALSE
  }
  rm(bgloves)
  
  r$add_SendEvent('9sssss')
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  
  # Bat/Field p1 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  
  # Batting stance
  r$add_SendEvent('wwwww')
  magick::image_crop(ss, "250x45+1175+435")
  battingstance <- edit_player_read_ocr_objects$batting_stance$ocr(ss, "250x45+1175+435")
  if (!is.na(battingstance)) {
    r$add("SetKeyDelay 175, 40 ; slower for stance")
    r$add(adjustLRcharlist(battingstance, toupper(names(batter_stance_options[1])), 
                           char_list = toupper(names(batter_stance_options))))
    r$add("SetKeyDelay 75, 40 ; slower for stance")
  } else {
    something_failed <- FALSE
  }
  rm(battingstance)
  
  # Contact vs RHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+508")
  ConR <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+508")
  if (!is.na(ConR)) {
    r$add(adjustLRapprox(ConR, 0, minval=0,
                         maxval=100, careful=FALSE))
  } else {
    something_failed <- FALSE
  }
  rm(ConR)
  
  # Contact vs LHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+580")
  ConL <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+580")
  if (!is.na(ConL)) {
    r$add(adjustLRapprox(ConL, 0, minval=0,
                         maxval=100, careful=FALSE))
  } else {
    something_failed <- FALSE
  }
  rm(ConL)
  
  # Power vs RHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+652")
  PowR <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+652")
  if (!is.na(PowR)) {
    r$add(adjustLRapprox(PowR, 0, minval=0,
                         maxval=100, careful=FALSE))
  } else {
    something_failed <- FALSE
  }
  rm(PowR)
  
  # Power vs LHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+727")
  PowL <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
  if (!is.na(PowL)) {
    r$add(adjustLRapprox(PowL, 0, minval=0,
                         maxval=100, careful=FALSE))
  } else {
    something_failed <- FALSE
  }
  rm(PowL)
  
  r$add_SendEvent('wwww')
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  
  # Bat/Field p1b ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  # Contact vs RHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+508")
  ConR <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+508")
  if (!is.na(ConR)) {
    r$add(adjustLRcts(ConR, 0, minval=0,
                      maxval=100))
  } else {
    something_failed <- FALSE
  }
  rm(ConR)
  
  # Contact vs LHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+580")
  ConL <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+580")
  if (!is.na(ConL)) {
    r$add(adjustLRcts(ConL, 0, minval=0,
                      maxval=100))
  } else {
    something_failed <- FALSE
  }
  rm(ConL)
  
  # Power vs RHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+652")
  PowR <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+652")
  if (!is.na(PowR)) {
    r$add(adjustLRcts(PowR, 0, minval=0,
                      maxval=100))
  } else {
    something_failed <- FALSE
  }
  rm(PowR)
  
  # Power vs LHP
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+727")
  PowL <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
  if (!is.na(PowL)) {
    r$add(adjustLRcts(PowL, 0, minval=0,
                      maxval=100))
  } else {
    something_failed <- FALSE
  }
  rm(PowL)
  
  # Bunting
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+800")
  bunting <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+800")
  if (!is.na(bunting)) {
    r$add(adjustLRdiscrete(bunting, 0))
  } else {
    something_failed <- FALSE
  }
  rm(bunting)
  
  r$add_SendEvent('ssssswwwww') # End on bunting, at top
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  
  # Bat/Field p2 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  # Plate discipline
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+508")
  platediscipline <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+508")
  if (!is.na(platediscipline)) {
    r$add(adjustLRdiscrete(platediscipline, 0))
  } else {
    something_failed <- FALSE
  }
  rm(platediscipline)
  
  # Durability
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+580")
  durability <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+580")
  if (!is.na(durability)) {
    r$add(adjustLRdiscrete(durability, 0))
  } else {
    something_failed <- FALSE
  }
  rm(durability)
  
  # Speed
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+652")
  speed <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+652")
  if (!is.na(speed)) {
    r$add(adjustLRcts(speed, 0, minval=0, maxval=99))
  } else {
    something_failed <- FALSE
  }
  rm(speed)
  
  # Stealing Tendency
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+727")
  stealingtendency <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+727")
  if (!is.na(stealingtendency)) {
    r$add(adjustLRdiscrete(stealingtendency, 0))
  } else {
    something_failed <- FALSE
  }
  rm(stealingtendency)
  
  # brability
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+800")
  brability <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+800")
  if (!is.na(brability)) {
    r$add(adjustLRdiscrete(brability, 0))
  } else {
    something_failed <- FALSE
  }
  rm(brability)
  
  
  r$add_SendEvent('sssswwww') # End on br ability, 2nd from top
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  
  # Bat/Field p3 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  # Fielding
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+580")
  fielding <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+580")
  if (!is.na(fielding)) {
    r$add(adjustLRdiscrete(fielding, 0))
  } else {
    something_failed <- FALSE
  }
  rm(fielding)
  
  # Range
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+652")
  range1 <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+652")
  if (!is.na(range1)) {
    r$add(adjustLRdiscrete(range1, 0))
  } else {
    something_failed <- FALSE
  }
  rm(range1)
  
  # Throw Strength
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+727")
  throwstrength <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+727")
  if (!is.na(throwstrength)) {
    r$add(adjustLRdiscrete(throwstrength, 0))
  } else {
    something_failed <- FALSE
  }
  rm(throwstrength)
  
  # Throw acc
  r$add_SendEvent('s')
  # magick::image_crop(ss, "80x45+1260+800")
  throwacc <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+800")
  if (!is.na(throwacc)) {
    r$add(adjustLRdiscrete(throwacc, 0))
  } else {
    something_failed <- FALSE
  }
  rm(throwacc)
  
  r$add_SendEvent('9')
  r$run_ahk('zero_one_player', kill_before=FALSE)
  rm(r, ss)
  
  # Bat tendencies ----
  
  # Loop over FB/Curve/Slider
  
  for (i in 1:3) {
    # Bat tend p1 ----
    
    ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
    r <- run_ahk_object$new()
    
    # TakeL
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+508")
    TakeL <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+508")
    if (!is.na(TakeL)) {
      r$add(adjustLRdiscrete(TakeL, 0))
    } else {
      something_failed <- FALSE
    }
    rm(TakeL)
    
    # TakeR
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+580")
    TakeR <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+580")
    if (!is.na(TakeR)) {
      r$add(adjustLRdiscrete(TakeR, 0))
    } else {
      something_failed <- FALSE
    }
    rm(TakeR)
    
    # MissL
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+652")
    MissL <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+652")
    if (!is.na(MissL)) {
      r$add(adjustLRdiscrete(MissL, 0))
    } else {
      something_failed <- FALSE
    }
    rm(MissL)
    
    # MissR
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+727")
    MissR <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+727")
    if (!is.na(MissR)) {
      r$add(adjustLRdiscrete(MissR, 0))
    } else {
      something_failed <- FALSE
    }
    rm(MissR)
    
    # ChaseL
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+800")
    ChaseL <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+800")
    if (!is.na(ChaseL)) {
      r$add(adjustLRdiscrete(ChaseL, 0))
    } else {
      something_failed <- FALSE
    }
    rm(ChaseL)
    
    r$add_SendEvent('sw')
    r$run_ahk('zero_one_player', kill_before=FALSE)
    rm(r, ss)
    
    # Bat tend p2 ----
    
    ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
    r <- run_ahk_object$new()
    
    # ChaseR
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+800")
    ChaseR <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+800")
    if (!is.na(ChaseR)) {
      r$add(adjustLRdiscrete(ChaseR, 0))
    } else {
      something_failed <- FALSE
    }
    rm(ChaseR)
    
    if (i >= 3) {
      r$add_SendEvent('9sssss')
    } else {
      r$add_SendEvent('sssssswwwww')
    }
    r$run_ahk('zero_one_player', kill_before=FALSE)
    rm(r, ss)
    
  }; rm(i)
  
  # Hot/Cold Zones ----
  # Leave existing players alone
  if (is_editable) {
    # v LHP first, then v RHP
    for (i in 1:2) {
      
      # Hot/Cold p1 ----
      
      ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
      r <- run_ahk_object$new()
      
      
      for (j in 1:5) {
        
        # Hot/Cold
        if (j == 1) {
          r$add_SendEvent('wwwww')
        } else {
          r$add_SendEvent('s')
        }
        # magick::image_crop(ss, "160x45+1220+800")
        HotCold <- edit_player_read_ocr_objects$hot_cold$ocr(ss, paste0("160x45+1220+", image_down_pixels[j]))
        if (!is.na(HotCold)) {
          r$add(adjustLRcharlist(HotCold, "NEUTRAL", char_list = c('COLD', 'NEUTRAL', 'HOT')))
        } else {
          something_failed <- FALSE
        }
        rm(HotCold)
      }; rm(j)
      
      r$add_SendEvent("sssswwww")
      r$run_ahk('zero_one_player', kill_before=FALSE)
      rm(r, ss)
      
      # Hot/Cold p2 ----
      
      ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
      r <- run_ahk_object$new()
      
      for (j in 1:4) {
        # Hot/Cold
        r$add_SendEvent('s')
        # magick::image_crop(ss, "160x45+1220+800")
        HotCold <- edit_player_read_ocr_objects$hot_cold$ocr(ss, paste0("160x45+1220+", image_down_pixels[j+2]))
        if (!is.na(HotCold)) {
          r$add(adjustLRcharlist(HotCold, "NEUTRAL", char_list = c('COLD', 'NEUTRAL', 'HOT')))
        } else {
          something_failed <- FALSE
        }
        rm(HotCold)
      }; rm(j)
      
      
      if (i >= 2) { # Done with 2nd heatmap, move on to pitching
        r$add_SendEvent('9sssss')
      } else { # Done with 1st heatmap, move to second
        r$add_SendEvent('9sssss')
      }
      r$run_ahk('zero_one_player', kill_before=FALSE)
      rm(r, ss)
    }; rm(i)
  }
  
  # Pitcher ----
  if (is_pitcher) {
    # Pitcher p1 ----
    # Fastball
    ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
    r <- run_ahk_object$new()
    
    # Pitcher delivery
    r$add_SendEvent('wwwww')
    # magick::image_crop(ss, "250x45+1175+435")
    pitcherdelivery <- edit_player_read_ocr_objects$pitcher_delivery$ocr(ss, "250x45+1175+435")
    if (!is.na(pitcherdelivery)) {
      r$add("SetKeyDelay 175, 40 ; slower for pdel")
      r$add(adjustLRcharlist(pitcherdelivery, toupper(names(pitcher_delivery_options[1])), 
                             char_list = toupper(names(pitcher_delivery_options))))
      r$add("SetKeyDelay 75, 40 ; slower for pdel")
    } else {
      something_failed <- FALSE
    }
    rm(pitcherdelivery)
    
    # Stamina
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+508")
    stamina <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+508")
    if (!is.na(stamina)) {
      r$add(adjustLRapprox(stamina, 1, minval=1,
                           maxval=99, careful=FALSE))
    } else {
      something_failed <- FALSE
    }
    rm(stamina)
    
    # Pickoff
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+580")
    pickoff <- edit_player_read_ocr_objects$reg_discrete$ocr(ss, "80x45+1260+580")
    if (!is.na(pickoff)) {
      r$add(adjustLRdiscrete(pickoff, 0))
    } else {
      something_failed <- FALSE
    }
    rm(pickoff)
    
    # fbcontrol
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+652")
    fbcontrol <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+652")
    if (!is.na(fbcontrol)) {
      r$add(adjustLRapprox(fbcontrol, 0, minval=0,
                           maxval=100, careful=FALSE))
    } else {
      something_failed <- FALSE
    }
    rm(fbcontrol)
    
    # fbvelo
    r$add_SendEvent('s')
    # magick::image_crop(ss, "80x45+1260+727")
    fbvelo <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
    if (!is.na(fbvelo)) {
      r$add(adjustLRcts(fbvelo, 77, minval=77,
                        maxval=101))
    } else {
      something_failed <- FALSE
    }
    rm(fbvelo)
    
    r$run_ahk('zero_one_player', kill_before=FALSE)
    rm(r, ss)
    
    # Pitcher p1b ----
    # Do it again carefully
    # Fastball
    ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
    r <- run_ahk_object$new()
    
    
    # Stamina
    r$add_SendEvent('www')
    # magick::image_crop(ss, "80x45+1260+508")
    stamina <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+508")
    if (!is.na(stamina)) {
      r$add(adjustLRcts(stamina, 1, minval=1,
                        maxval=99))
    } else {
      something_failed <- FALSE
    }
    rm(stamina)
    
    # fbcontrol
    r$add_SendEvent('ss')
    # magick::image_crop(ss, "80x45+1260+652")
    fbcontrol <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+652")
    if (!is.na(fbcontrol)) {
      r$add(adjustLRcts(fbcontrol, 0, minval=0,
                        maxval=100))
    } else {
      something_failed <- FALSE
    }
    rm(fbcontrol)
    
    # Pitch 2
    r$add_SendEvent('ss')
    r$add_SendEvent('da') # Reset pitch. So if already changeup, still works
    # magick::image_crop(ss, "250x45+1175+800")
    pitch2 <- edit_player_read_ocr_objects$pitch_type$ocr(ss, "250x45+1175+800")
    if (!is.na(pitch2)) {
      # Move to changeup
      r$add(adjustLRcharlist(pitch2, toupper(pitch_order[1]), 
                             char_list = toupper(pitch_order)))
      # Nerf changeup
      # Movement to 0
      r$add_SendEvent("saaaaa")
    } else {
      r$add_SendEvent("s")
      something_failed <- FALSE
    }
    rm(pitch2)
    
    r$add_SendEvent("sssssssssw")
    r$run_ahk('zero_one_player', kill_before=FALSE)
    rm(r, ss)
    
    # Pitcher p2 ----
    ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
    r <- run_ahk_object$new()
    
    # Pitch 3
    r$add_SendEvent('wwww')
    # magick::image_crop(ss, "250x45+1175+435")
    pitch3 <- edit_player_read_ocr_objects$pitch_type$ocr(ss, "250x45+1175+435")
    if (!is.na(pitch3)) {
      # Move to None
      r$add(adjustLRcharlist(pitch3, "NONE", 
                             char_list = toupper(c("NONE", pitch_order)), cts = T))
    } else {
      something_failed <- FALSE
    }
    rm(pitch3)
    
    # Pitch 4
    r$add_SendEvent('sssss')
    # magick::image_crop(ss, "250x45+1175+800")
    pitch4 <- edit_player_read_ocr_objects$pitch_type$ocr(ss, "250x45+1175+800")
    if (!is.na(pitch4)) {
      # Move to None
      r$add(adjustLRcharlist(pitch4, "NONE", 
                             char_list = toupper(c("NONE", pitch_order)), cts = T))
    } else {
      something_failed <- FALSE
    }
    rm(pitch4)
    
    r$add_SendEvent("sssssw")
    r$run_ahk('zero_one_player', kill_before=FALSE)
    rm(r, ss)
    
    # Pitcher p3 ----
    ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
    r <- run_ahk_object$new()
    
    # Pitch 5
    r$add_SendEvent('s')
    # magick::image_crop(ss, "250x45+1175+800")
    pitch5 <- edit_player_read_ocr_objects$pitch_type$ocr(ss, "250x45+1175+800")
    if (!is.na(pitch5)) {
      # Move to None
      r$add(adjustLRcharlist(pitch5, "NONE", 
                             char_list = toupper(c("NONE", pitch_order)), cts = T))
    } else {
      something_failed <- FALSE
    }
    rm(pitch5)
    
    r$run_ahk('zero_one_player', kill_before=FALSE)
    rm(r, ss)
    
  }
  
  # x----
  
  # Template
  
  # "
  # #
  # r$add_SendEvent('s')
  # # magick::image_crop(ss, "")
  #  <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "")
  # if (!is.na()) {
  #   r$add(adjustLRcts(, 1, minval=1,
  #                     maxval=))
  # } else {
  #   something_failed <- FALSE
  # }
  # rm()
  # "
  
  # End ----
  cat("Done with zero_one_player", "\n")
  
  cat("zero_one_player finished after", 
      diff(c(zero_start_time, Sys.time()), units='sec'),
      "seconds", "\n")
  stop('done')
  if (something_failed) {
    r$add_SendEvent("isk")
  } else {
    r$add_SendEvent("usk")
  }
  r$run_ahk('zero_one_player', kill_after=TRUE) # Last one, kill after
  rm(r)
  
  
  cat("zero_one_player finished after", 
      diff(c(zero_start_time, Sys.time()), units='sec'),
      "seconds", "\n")
  
  if (something_failed) {
    return("failure")
  }
  return("success")
  
}
if (F) { # Test ----
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  zero_one_player()
}