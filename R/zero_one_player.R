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
  return(
    abs(
      (magick::image_crop(img, "50x60+660+410")[[1]][1:3,,] %>%
         as.integer %>% mean) - 85.83267) < 0.75
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
  # Check pitcher/hitter, if already zeroed ----
  screenshot::screenshot(file="./images/tmp_zero_one_player.png")
  cat("Took screenshot", "\n")
  # Wait a second for it to get the screenshot
  Sys.sleep(2)
  # Read in screenshot
  img <- magick::image_read("./images/tmp_zero_one_player.png")
  
  is_pitcher <- is_pitcher_on_edit_player_page(img)
  
  # Check if zeroed
  if (is_pitcher) {
    cat("is pitcher", "\n")
    # nerf_one_pitcher(add_at_end=add_at_end)
    is_zeroed <- is_zeroed_pitcher_on_edit_player_page(img)
  } else {
    cat("is batter\n")
    # nerf_one_batter(add_at_end=add_at_end)
    is_zeroed <- is_zeroed_batter_on_edit_player_page(img)
  }
  if (is_zeroed) {
    return(TRUE)
  }
  
  # Next basically go through all pages of the edit player
  
  # Enter edit player
  r <- run_ahk_object$new()
  r$add("SendEvent 'k' ; enter edit player
        Sleep 2500 ; wait for player to load")
  r$run_ahk("tmp_zero_one_player")
  rm(r)
  
  is_editable <- is_editable_player()
  
  something_failed <- FALSE
  
  # General Inf p1 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  if (is_editable) {
    # Birth month
    # magick::image_crop(ss, "120x40+1240+655")
    birth_month <- edit_player_read_ocr_objects$birth_month$ocr(ss, "120x40+1240+655")
    r$add_SendEvent("sss")
    if (!is.na(birth_month)) {
      r$add(adjustLRcts(month_to_int(birth_month), 1, minval=1, maxval=12))
    } else {
      something_failed <- FALSE
    }
    # Birth day
    # magick::image_crop(ss, "65x45+1270+580")
    birth_day <- edit_player_read_ocr_objects$birth_day$ocr(ss, "120x40+1240+655")
    r$add_SendEvent('w')
    if (!is.na(birth_day)) {
      r$add(adjustLR(birth_day - 1))
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
  first_position <- edit_player_read_ocr_objects$position$ocr(ss, "80x45+1260+800")
  if (!is.na(first_position)) {
    if (first_position == "SP") {
      # good
    } else if (first_position == "RP") {
      r$add_SendEvent("a")
    } else {
      pos <- which(first_position_order == first_position)
      stopifnot(length(pos)==1, !is.na(pos))
      r$add(adjustLR(-pos))
    }
  } else {
    something_failed <- FALSE
  }
  
  # End page
  rm(ss)
  
  # Move to next page
  r <- run_ahk_object$new()
  r$add("SendEvent 'ssssssssssw'")
  r$run_ahk("tmp_zero_one_player")
  rm(r)
  
  # General Inf p2 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  
  # Second position
  # magick::image_crop(ss, "80x45+1260+505")
  r$add_SendEvent("www") # move to second pos
  if (!is_pitcher) {
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
  
  # Skip Throws, all C are RIGHT
  r$add_SendEvent('s')
  
  # Bats
  r$add_SendEvent("s") # move to bats
  # magick::image_crop(ss, "120x45+1240+655")
  bats <- edit_player_read_ocr_objects$throws_bats$ocr(ss, "120x45+1240+655")
  if (!is.na(bats)) {
    if (bats == 'LEFT') {
      r$add_SendEvent('d')
    }
  } else {
    something_failed <- FALSE
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
  # magick::image_crop(ss, "240x45+1180+800")
  bdt <- edit_player_read_ocr_objects$batter_ditty_type$ocr(ss, "240x45+1180+800")
  if (!is.na(bdt)) {
    r$add(adjustLRcts(which(bdt==batter_ditty_type_options), 1, minval=1, 
                      maxval=length(batter_ditty_type_options)))
  } else {
    something_failed <- FALSE
  }
  
  # End page
  
  # Move to next page, move down to height
  r$add_SendEvent('9s')
  r$run_ahk("tmp_zero_one_player")
  rm(r, ss)
  
  
  # Appearance ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  # Jersey number
  r$add_SendEvent('w')
  # magick::image_crop(ss, "80x45+1260+435")
  jersey <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+435")
  if (!is.na(jersey)) {
    r$add(adjustLRcts(jersey, 15, minval=1, 
                      maxval=length(batter_ditty_type_options)))
  } else {
    something_failed <- FALSE
  }
  
  # Face
  r$add_SendEvent('w')
  # magick::image_crop(ss, "80x45+1260+727")
  face <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
  if (!is.na(face)) {
    r$add(adjustLRcts(face, 1, minval=1, 
                      maxval=15))
  } else {
    something_failed <- FALSE
  }
  
  # Hair color
  r$add_SendEvent('w')
  # magick::image_crop(ss, "80x45+1260+727")
  hair <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
  if (!is.na(hair)) {
    r$add(adjustLRcts(hair, 1, minval=1, 
                      maxval=7))
  } else {
    something_failed <- FALSE
  }
  rm(hair)
  r$add_SendEvent('ssww')
  r$run_ahk('zero_one_player')
  rm(r, ss)
  
  # Appearance p2 ----
  ss <- screenshot_and_read("./images/tmp_zero_one_player.png")
  r <- run_ahk_object$new()
  
  # Hair Style
  r$add_SendEvent('w')
  # magick::image_crop(ss, "80x45+1260+727")
  hair <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+727")
  if (!is.na(hair)) {
    r$add(adjustLRcts(hair, 1, minval=1, 
                      maxval=10))
  } else {
    something_failed <- FALSE
  }
  
  # Facial hair
  r$add_SendEvent('w')
  # magick::image_crop(ss, "80x45+1260+800")
  facialhair <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "80x45+1260+800")
  if (!is.na(facialhair)) {
    r$add(adjustLRcts(facialhair, 1, minval=1, 
                      maxval=8))
  } else {
    something_failed <- FALSE
  }
  
  r$add_SendEvent('9sssss') # Move to next tab
  r$run_ahk('zero_one_player')
  rm(r, ss, hair, facialhair, jersey, face)
  
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
  # magick::image_crop(ss, "")
  elbowguard <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "")
  if (!is.na(elbowguard)) {
    r$add(adjustLRcts(elbowguard, 1, minval=1, 
                      maxval=))
  } else {
    something_failed <- FALSE
  }
  
  # x----
  
  # Template
  
  # 
  r$add_SendEvent('s')
  # magick::image_crop(ss, "")
   <- edit_player_read_ocr_objects$reg_cts$ocr(ss, "")
  if (!is.na()) {
    r$add(adjustLRcts(, 1, minval=1, 
                      maxval=))
  } else {
    something_failed <- FALSE
  }
  
  # End ----
  if (something_failed) {
    r$add_SendEvent("isk")
  } else {
    r$add_SendEvent("usk")
  }
  r$run_ahk("zero_one_player")
  rm(r)
  
  
}
if (F) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  zero_one_player()
}