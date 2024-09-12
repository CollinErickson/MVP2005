library(dplyr)

if (!exists("zero_one_player")) {
  source('./R/zero_one_player.R')
}


# Rosters ----
# zero rosters for multiple orgs and teams

zero_rosters <- function(norgs=1, nlevels=4, nplayers=25) {
  cat("Starting zero_rosters", "\n")
  start_time <- Sys.time()
  stopifnot(norgs >= 1, norgs <= 60,
            nlevels >= 1, nlevels <= 4,
            nplayers >= 1, nplayers <= 25)
  
  # Beep when function exists
  on.exit(expr={
    cat("Running on.exit from zero_rosters", "\n")
    timestamp()
    quick_run_ahk_SendEvent(" ")
    beepr::beep(2)
  }, add=T)
  # stop()
  
  for (i in 1:norgs) {
    for (j in 1:nlevels) {
      
      nfails <- 0
      j_done <- FALSE
      
      for (k in 1:nplayers) {
        if (j_done) {
          next
        }
        cat("zero_rosters for", i, j, k, ", saving screenshot\n")
        # print(c(i,j,k))
        # Get screenshot
        screenshot::screenshot(
          file=paste0(
            "./images/zero_team_start/", 
            as.character(Sys.time()) %>% stringr::str_replace_all("\\.","_") %>%
              stringr::str_replace_all(":","_") %>% 
              stringr::str_replace_all(" ","_"), ".png"))
        
        
        zero_out <- zero_one_player()
        
        stopifnot(zero_out %in% c("success", "failure", "already_done"))
        
        if (zero_out == 'failure') {
          nfails <- nfails + 1
        }
        
        # If end of roster, move to next team or org
        if (k >= nplayers || zero_out == "already_done") {
          if (j >= nlevels) { # Reset level, then next org
            quick_run_ahk_SendEvent(
              paste0(paste0(rep("7", nlevels-1), collapse=''),
                     "9"))
          } else { # Next level
            quick_run_ahk_SendEvent("0")
          }
          j_done <- TRUE
          nfails <- 0
        } else {
          # Next player: reset current team
          # quick_run_ahk_SendEvent("98")
          quick_run_ahk("SetKeyDelay 175, 40 ; slower 
                         SendEvent '98'")
          # Move down past failed players
          if (nfails > 0.5) {
            quick_run_ahk_SendEvent(paste0(rep("s", nfails), collapse=''))
          }
        }
      }
    }
  }
  # Pause PCSX2 at end (done above using on.exit)
  # quick_run_ahk_SendEvent(" ")
  
  cat("Finished zero_rosters", Sys.time(), "\n")
  cat("Ran for", round(diff(c(start_time, Sys.time()), units='sec')/60,1), "mins\n")
}
if (F) { ## Test ----
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  zero_rosters(norgs=30, nlevels=4, nplayers=25)
}




# FA ----
# zero the Free Agent list

zero_free_agents <- function(nplayers=25, nskip=0) {
  cat("Starting zero_free_agents", "\n")
  start_time <- Sys.time()
  stopifnot(nplayers >= 1, nplayers <= 500)
  
  # Beep when function exists
  on.exit(expr={
    cat("Running on.exit from zero_free_agents", "\n")
    timestamp()
    quick_run_ahk_SendEvent(" ")
    beepr::beep(2)
  }, add=T)
  
  
  for (i in 1:nplayers) {
    cat("zero_rosters for player", i, ", saving screenshot\n")
    # print(c(i,j,k))
    # Get screenshot
    screenshot::screenshot(
      file=paste0(
        "./images/zero_team_start/", 
        as.character(Sys.time()) %>% stringr::str_replace_all("\\.","_") %>%
          stringr::str_replace_all(":","_") %>% 
          stringr::str_replace_all(" ","_"), ".png"))
    
    
    
    zero_out <- zero_one_player()
    
    stopifnot(zero_out %in% c("success", "failure", "already_done"))
    
    if (zero_out == 'failure') {
      nfails <- nfails + 1
    }
    
    # Need to reset to top rated player after zeroing one player.
    # FA page is slow to load.
    quick_run_ahk_SendEvent(
      '
    Sleep 6000 ; Wait for FA page to load
    SendEvent "07" ; Reset to top of FA list
    Sleep 4000 ; Wait for FA page to load
  '
    )
    
    # Move down past failed players
    if (nfails > 0.5) {
      quick_run_ahk_SendEvent(paste0(rep("s", nfails), collapse=''))
    }
    

    
  }
  cat("Finished zero_free_agents", as.character(Sys.time()), "\n")
  cat("Ran for", diff(c(start_time, Sys.time()), units='sec'), "\n")
}
if (F) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  zero_free_agents(nplayers = 400)
}
