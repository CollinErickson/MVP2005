library(dplyr)

# if (!exists("nerf_one_player")) {
#   source('./R/nerf_one_player.R')
# }

if (!exists('is_editable_player')) {
  source("./R/is_editable_player.R")
}
if (!exists("adjustLR")) {
  source("./R/helpers.R")
}
if (!exists('is_pitcher_on_edit_player_page')) {
  source("./R/is_pitcher_on_edit_player_page.R")
}



boost_editable_one_player <- function(add_at_end) {
  
  
  # Check pitcher/hitter ----
  screenshot::screenshot(file="./images/tmp_boost_editable_one_player.png")
  cat("Took screenshot", "\n")
  # Wait a second for it to get the screenshot
  Sys.sleep(.2)
  # Read in screenshot
  img <- magick::image_read("./images/tmp_boost_editable_one_player.png")
  
  is_pitcher <- is_pitcher_on_edit_player_page(img)
  
  r <- run_ahk_object$new()
  r$add("SendEvent 'k' ; enter player")
  r$add("Sleep 3000 ; wait for player to load")
  r$run_ahk("boost_editable_player")
  rm(r)
  # Sys.sleep(.25)
  
  is_editable <- is_editable_player()
  
  
  r <- run_ahk_object$new()
  
  if (is_editable) {
    if (is_pitcher) {
      cat("is pitcher", "\n")
      # nerf_one_pitcher(add_at_end=add_at_end)
      r$add("SendEvent '8s' ; move to stamina")
      r$add(adjustLRapprox(1,35,1,99))
    } else {
      cat("is batter\n")
      # nerf_one_batter(add_at_end=add_at_end)
      r$add("SendEvent '999s' ; move to contact v R")
      r$add(adjustLRapprox(0,80,0,100))
    }
  }
  # Sometimes it didn't finish usk, add sleep in between
  # r$add("SendEvent 'usk' ; save player")
  r$add("SendEvent 'u' ; save player")
  r$add("Sleep 100 ; wait")
  r$add("SendEvent 's' ; save player")
  r$add("Sleep 100 ; wait")
  r$add("SendEvent 'k' ; save player")
  r$add("Sleep 100 ; wait")
  r$add(add_at_end)
  
  r$run_ahk("boost_editable_player")
  
  # rm(add_at_end)
  rm(r)
}


# Nerf rosters for multiple orgs and teams

boost_editable_rosters <- function(norgs=1, nlevels=4, nplayers=25,
                                   start_index_first=1,
                                   nlevelsfirst=nlevels) {
  cat("Starting boost_editable_rosters", "\n")
  stopifnot(norgs <= 60, nplayers <= 25, nlevels <= 4,
            norgs >= 1, nplayers >= 1, nlevels >= 1,
            # nplayersfirst <= 25, nplayersfirst >= 1,
            nlevelsfirst>=0, nlevelsfirst <= 4, start_index_first>=1)
  
  # Beep when function exists
  on.exit(expr={beepr::beep(2)}, add=T)
  
  # Need to reset to top rated player after nerfing one player
  # Flip to next org and back (don't flip by level, A will flip to FA, v slow)
  add_at_end0 <- '
    Sleep 3000 ; Wait for roster page to load
    SendEvent "98" ; Reset to top of this roster
  '
  for (i in 1:norgs) {
    for (j in (nlevels - nlevelsfirst + 1):nlevels) {
      # Num players to nerf on this team
      # kmax <- (min(nplayers, nplayersfirst+10000*(i+j-2)))
      # for (k in 1:kmax) {
      kmax <- 25
      for (k in max(1, start_index_first + -10000*(i+j-2)):25) {
        cat("boost_editable_rosters for", i, j, k, ", saving screenshot\n")
        # print(c(i,j,k))
        # Get screenshot
        screenshot::screenshot(
          file=paste0(
            "./images/boost_editable_team_start/", 
            as.character(Sys.time()) %>% stringr::str_replace_all("\\.","_") %>%
              stringr::str_replace_all(":","_") %>% 
              stringr::str_replace_all(" ","_"), ".png"))
        # stop()
        
        # On last player on team, move to next level in org,
        #  unless on last level in org, then reset to first one
        if (k == kmax) {
          if (j >= nlevels) {
            # If on A, flip back to MLB, then flip to next org
            add_at_end <- paste0(
              add_at_end0,
              '
             SendEvent "',paste0(rep(7,nlevels-1), collapse=''),'"
             SendEvent "9"
            '
            )
          } else {
            # If on MLB/AAA/AA, flip to lower level
            add_at_end <- paste0(
              add_at_end0,
              '
             SendEvent "0"
            '
            )
          }
        } else {
          # Move down to next unchecked player
          add_at_end <- paste0(
            add_at_end0, "
            SendEvent '",
            paste0(rep("s", k), collapse=''),
            "' ; move down to next unchecked player")
          
        }
        
        # After very last one, press space to pause PCSX2
        if (k==kmax && j==nlevels && i==norgs)  {
          add_at_end <- paste0(
            add_at_end0,
            '
             SendEvent " " ; \tpause PCSX2 when done
            '
          )
        }
        
        
        boost_editable_one_player(add_at_end=add_at_end)
        rm(add_at_end)
      }
    }
  }
  cat("Finished boost_editable_rosters", "\n")
}
if (T) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  boost_editable_rosters(norgs=18,
                         nlevels=4, nlevelsfirst=4,
                         nplayers=25, start_index_first=1)
}





# Nerf the Free Agent list

boost_editable_free_agents <- function(nplayers=25, startindex=1) {
  cat("Starting boost_editable_free_agents", "\n")
  stopifnot(nplayers >= 1, nplayers <= 500)
  
  # Beep when function exists
  on.exit(expr={beepr::beep(2)}, add=T)
  
  # Need to reset to top rated player after nerfing one player
  # Flip to next org and back (don't flip by level, A will flip to FA, v slow)
  add_at_end0 <- '
    Sleep 8000 ; Wait for FA page to load
    SendEvent "07" ; Reset to top of FA list
    Sleep 4000 ; Wait for FA page to load
  '
  for (i in 1:nplayers) {
    cat("boost_editable_rosters for player", i, ", saving screenshot\n")
    # print(c(i,j,k))
    # Get screenshot
    screenshot::screenshot(
      file=paste0(
        "./images/boost_editable_team_start/", 
        as.character(Sys.time()) %>% stringr::str_replace_all("\\.","_") %>%
          stringr::str_replace_all(":","_") %>% 
          stringr::str_replace_all(" ","_"), ".png"))
    if (i == nplayers) {
      add_at_end <- NULL
    } else {
      add_at_end <- paste0(add_at_end0, paste0(
        "
                           SendEvent '", rep('s', startindex + i - 1), "'
                           ", collapse=''))
    }
    
    # After very last one, press space to pause PCSX2
    if (i == nplayers)  {
      add_at_end <- paste0(
        add_at_end0,
        '
             SendEvent " " ; \tpause PCSX2 when done
            '
      )
    }
    
    boost_editable_one_player(add_at_end=add_at_end)
    rm(add_at_end)
    
  }
  cat("Finished nerf_free_agents", as.character(Sys.time()), "\n")
}
if (F) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  boost_editable_free_agents(nplayers = 400, startindex = 15)
}
