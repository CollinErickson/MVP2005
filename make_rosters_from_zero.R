'
Make rosters from zero:

Before starting: Zero all, move all editables from MLB to FA list (very few)

Loop over all orgs:

1. Dump players from team AAA/AA/A all to FA. Cannot do this for all orgs
first or the FA list will be overwhelmed.

2. Create 27 pitchers, 39 batters from roster. 66 total. (If it runs out, or
there are 30+ of either type left, then )

3. Move players from FA list to AAA/AA/A.

4. Move to next org.

5. With remaining editables, create next important players, may need to 
manually add to orgs.

6. Create 25 new players, add to their orgs A team.

Hard part may be tracking where it stopped, and navigating between screens.

'

if (!exists('adjustLR')) {
  source("./R/helpers.R")
}
if (!exists('MVPdf')) {
  source("./R/readcsv.R")
}
if (!exists('quick_run_ahk')) {
  source("./R/run_ahk.R")
}
if (!exists('is_pitcher_on_edit_player_page')) {
  source("./R/is_pitcher_on_edit_player_page.R")
}

is_on_manage_rosters_statistics <- function() {
  
  # Start on the top of Manage Rosters screen, highlighting the "Statistics" option
  # Make sure it starts on the right page
  # Sys.sleep(2); 
  ss <- screenshot_and_read("./images/tmp.png")
  # ss %>% magick::image_crop("200x150+1200+250") %>% .[[1]] %>% .[1:3,,] %>% as.integer %>% mean
  on_mrs <- (abs((ss %>% magick::image_crop("200x150+1200+250") %>%
                    .[[1]] %>% .[1:3,,] %>%
                    as.integer %>% mean
  ) - 65.92356) < 1)
  return(on_mrs)
}


make_rosters_from_zero <- function() {
  save_progress_file_path <- "./data/create_rosters_from_zero_progress.csv"
  if (file.exists(save_progress_file_path)) {
    save_progress_df <- readr::read_csv(save_progress_file_path)
    step <- save_progress_df$step
    org <- save_progress_df$org
    substep <- save_progress_df$substep
    subsubstep <- save_progress_df$subsubstep
  } else {
    step <- 0
    org <- 1
    substep <- 0
    subsubstep <- 0
  }
  update_progress_file <- function(step, org, substep, subsubstep=0) {
    readr::write_csv(x=data.frame(step=step, org=org, 
                                  substep=substep,
                                  subsubstep=subsubstep),
                     file = save_progress_file_path)
  }
  
  
  # Pause when done
  on.exit(expr={
    cat("Running on.exit from make_rosters_from_zero", "\n")
    timestamp()
    quick_run_ahk_SendEvent(" ")
    beepr::beep(2)
  }, add=T)
  
  # Make sure on correct page
  stopifnot(is_on_manage_rosters_statistics())
  
  
  # Step 0: example step 0000
  if (step <= 0.5) {
    # Do stuff
    
    # Save progress
    update_progress_file(step = 1, org=1, substep=1)
    
    # End step 0 by incrementing
    step <- 1
    subsubstep <- 0
  }
  
  # Step 1: Do one org ----
  if (step <= 1.5) {
    cat("Starting step 1 in make_rosters_from_zero: edit players", "\n")
    for (i_org in 1:30) {
      # Get to correct org
      if (org > i_org) {
        next
      }
      
      ### Substep 1: move AAA/AA/A to FA ----
      if (substep <= 1.5) {
        r <- run_ahk_object$new()
        # Enter FA option
        r$add_SendEvent("sk")
        r$add_Sleep(200)
        
        # Move to correct org
        if (i_org >= 2) {
          r$add_SendEvent(paste0("d", 
                                 paste0(rep("9", i_org - 1),
                                        collapse=''),
                                 "a"))
        }
        
        # Dump AAA
        r$add_SendEvent(paste0("d0", paste0(rep("kskd", 25), collapse='')))
        # Dump AA
        r$add_SendEvent(paste0("d0", paste0(rep("kskd", 25), collapse='')))
        # Dump A
        r$add_SendEvent(paste0("d0", paste0(rep("kskd", 25), collapse='')))
        
        # Move back to roster menu Statistics
        r$add_SendEvent('i')
        
        
        r$run_ahk("tmp_make_rosters_from_zero")
        rm(r)
        
        substep <- 2
        subsubstep <- 0
        update_progress_file(step, org, substep, subsubsubstep)
      }
      
      ### Substep 2: Make pitchers. They are on top of FA list, easy to find ----
      if (substep < 2.5) {
        # Move to edit player page
        quick_run_ahk_SendEvent('ssssksk')
        Sys.sleep(1)
        # Move to FA list
        quick_run_ahk_SendEvent('7')
        Sys.sleep(4)
        # browser()
        
        pitcherdf <- MVPdf %>% 
          filter(org_id == which(MVP_org_order2[org] == OOTP_MLB_team_order),
                 `First Position` %in% c('SP', 'RP'),
                 !MakeFromCreate) %>% 
          arrange(org_position_create_rank)
        stopifnot(nrow(pitcherdf) >= 27)
        
        # subsubstep is which was completed
        for (ipitcher in 1:27) {
          if (subsubstep >= ipitcher) {
            next
          }
          # Move down to editable player
          if (ipitcher > 1.5) {
            quick_run_ahk_SendEvent(paste0(rep("s", ipitcher - 1), collapse = ''))
          }
          
          # Make sure first player is pitcher
          stopifnot(
            is_pitcher_on_edit_player_page(
              screenshot_and_read("./images/tmp_delete.png")))
          
          # Create player
          make_player_from_row(pitcherdf[ipitcher, ], from_zero = TRUE)
          Sys.sleep(1.5)
          
          # Move up to top of list
          if (ipitcher < 26.5) {
            quick_run_ahk_SendEvent('07')
            Sys.sleep(5)
          }
          
          subsubstep <- ipitcher
          update_progress_file(step, org, substep, subsubstep)
        }; rm(ipitcher)
        rm(pitcherdf)
        
        # Move back to menu page
        quick_run_ahk_SendEvent('ii')
        
        # Done, plan for next
        substep <- 3
        subsubstep <- 0
        update_progress_file(step, org, substep, subsubstep)
        stop('finished make pitchers')
      }
      
      ### Substep 3: Move pitchers from top of FA to AAA/AA ----
      if (substep <= 3.5) {
        stopifnot(is_on_manage_rosters_statistics())
        
        r <- run_ahk_object$new()
        # Enter FA option
        r$add_SendEvent("sk")
        r$add_Sleep(200)
        
        # Move to correct org
        if (i_org >= 2) {
          r$add_SendEvent(paste0("d", 
                                 paste0(rep("9", i_org - 1),
                                        collapse=''),
                                 "a"))
        }
        
        # Move to AAA
        r$add_SendEvent("d0a")
        
        # Move first 25 players to AAA
        r$add_SendEvent(paste0("", paste0(rep("ksk", 25), collapse='')))
        
        # Move to AA
        r$add_SendEvent("d0a")
        
        # Move remaining 2 pitchers to AA
        r$add_SendEvent(paste0("", paste0(rep("ksk", 2), collapse='')))
        
        r$run_ahk()
        rm(r)
        
        substep <- 4
        subsubstep <- 0
        update_progress_file(step, org, substep, subsubstep)
        stop('finished pitchers move')
      }
      
      ### Substep 4: Make batters ----
      ###   They are not on top of FA list, need to find start index ----
      if (substep < 4.5) {
        # Move to edit player page
        quick_run_ahk_SendEvent('ssssksk')
        Sys.sleep(1)
        # Move to FA list
        quick_run_ahk_SendEvent('7')
        Sys.sleep(4)
        # browser()
        
        # Find how many pitchers we need to skip
        numskip <- 0
        while(
          is_pitcher_on_edit_player_page(
            screenshot_and_read("./images/tmp_delete.png"))
        ) {
          numskip <- numskip + 1
          quick_run_ahk_SendEvent('s')
        }
        browser()
        
        batterdf <- MVPdf %>% 
          filter(org_id == which(MVP_org_order2[org] == OOTP_MLB_team_order),
                 !(`First Position` %in% c('SP', 'RP')),
                 !MakeFromCreate) %>% 
          arrange(org_position_create_rank)
        stopifnot(nrow(batterdf) >= 39)
        
        # subsubstep is which was completed
        for (ibatter in 1:39) {
          if (subsubstep >= ibatter) {
            next
          }
          # Move down to editable player: first one is already okay
          if (ibatter > 1.5) {
            quick_run_ahk_SendEvent(paste0(rep("d", ibatter - 1 + numskip),
                                           collapse = ''))
          }
          # Create player
          make_player_from_row(batterdf[ibatter, ], from_zero = TRUE)
          
          # Move up to top of list
          if (ibatter < 38.5) {
            quick_run_ahk_SendEvent('07')
            Sys.sleep(4)
          }
          
          subsubstep <- ibatter
          update_progress_file(step, org, substep, subsubstep)
        }
        
        # Move back to menu page
        quick_run_ahk_SendEvent('ii')
        
        # Done, plan for next
        substep <- 5
        subsubstep <- 0
        update_progress_file(step, org, substep, subsubstep)
        stop('finished make batters')
      }; rm(ibatter, numskip)
      
      ### Substep 5: Move batters from top of FA to AA/A ----
      if (substep <= 5.5) {
        stopifnot(is_on_manage_rosters_statistics())
        
        r <- run_ahk_object$new()
        # Enter FA option
        r$add_SendEvent("sk")
        r$add_Sleep(200)
        
        # Move to correct org
        if (i_org >= 2) {
          r$add_SendEvent(paste0("d", 
                                 paste0(rep("9", i_org - 1),
                                        collapse=''),
                                 "a"))
        }
        
        # Move to AA
        r$add_SendEvent("d00a")
        
        # Move first 23 players to AA
        r$add_SendEvent(paste0("", paste0(rep("ksk", 23), collapse='')))
        
        # Move to A
        r$add_SendEvent("d0a")
        
        # Move remaining 39-23=16 batters to A
        r$add_SendEvent(paste0("", paste0(rep("ksk", 16), collapse='')))
        
        r$run_ahk()
        rm(r)
        
        substep <- 6
        subsubstep <- 0
        update_progress_file(step, org, substep, subsubstep)
        stop('finished batters move')
      }
      
      # Increment org
      org <- org + 1
      substep <- 1
      update_progress_file(1, i_org+1, 1)
    }; rm(i_org); # End i_org
    
    # Increment step
    step <- 2
    org <- 1
    substep <- 1
    subsubstep <- 0
    update_progress_file(step, org, substep)
  } # End step 1
  
  stop('before step 2')
  # Step 2: Edit remaining players ----
  cat("Starting step 2 in make_rosters_from_zero: edit players", "\n")
  
  # Step 3: Create 25 players ----
  
  # Done
  cat('Done with make_rosters_from_zero', "\n")
  timestamp()
}
if (F) {
  cat("Change window now", "\n")
  Sys.sleep(2)
  make_rosters_from_zero()
}