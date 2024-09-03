library(dplyr)

if (!exists("nerf_one_player")) {
  source('./R/nerf_one_player.R')
}



# Nerf rosters for multiple orgs and teams

nerf_rosters <- function(norgs=1, nlevels=4, nplayersfirst=25, nplayers=25,
                         nlevelsfirst=nlevels) {
  cat("Starting nerf_rosters", "\n")
  stopifnot(norgs <= 60, nplayers <= 25, nlevels <= 4,
            norgs >= 1, nplayers >= 1, nlevels >= 1,
            nplayersfirst <= 25, nplayersfirst >= 1,
            nlevelsfirst>=0, nlevelsfirst <= 4)
  
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
      kmax <- (min(nplayers, nplayersfirst+10000*(i+j-2)))
      for (k in 1:kmax) {
        cat("nerf_rosters for", i, j, k, ", saving screenshot\n")
        # print(c(i,j,k))
        # Get screenshot
        screenshot::screenshot(
          file=paste0(
            "./images/nerf_team_start/", 
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
          add_at_end <- add_at_end0
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
        
        nerf_one_player(add_at_end=add_at_end)
        rm(add_at_end)
      }
    }
  }
  cat("Finished nerf_rosters", "\n")
}
if (T) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  nerf_rosters(norgs=1,
               nlevels=1, nlevelsfirst=1,
               nplayers=25, nplayersfirst=25)
}





# Nerf the Free Agent list

nerf_free_agents <- function(nplayers=25) {
  cat("Starting nerf_free_agents", "\n")
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
    cat("nerf_rosters for player", i, ", saving screenshot\n")
    # print(c(i,j,k))
    # Get screenshot
    screenshot::screenshot(
      file=paste0(
        "./images/nerf_team_start/", 
        as.character(Sys.time()) %>% stringr::str_replace_all("\\.","_") %>%
          stringr::str_replace_all(":","_") %>% 
          stringr::str_replace_all(" ","_"), ".png"))
    if (i == 1.5) {
      add_at_end <- NULL
    } else {
      add_at_end <- add_at_end0
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
    
    nerf_one_player(add_at_end=add_at_end)
    rm(add_at_end)
    
    
  }
  cat("Finished nerf_free_agents", as.character(Sys.time()), "\n")
}
if (F) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  nerf_free_agents(nplayers = 400)
}
