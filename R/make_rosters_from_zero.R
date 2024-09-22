'
Make rosters from zero:

Before starting: Zero all, move all editables from MLB to FA list (very few)

Loop over all orgs:

1. Dump players from team AAA/AA/A all to FA. Cannot do this for all orgs
first or the FA list will be overwhelmed.

2. Create 26 (orig 27) pitchers, 37 (orig 39) batters from roster. 
63 (orig 66) total.
(If it runs out, or
there are 30+ of either type left, then these can be updated again.)

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
if (!exists('make_player_from_row')) {
  source("./R/make_player.R")
}

is_on_manage_rosters_statistics <- function() {
  
  # Start on the top of Manage Rosters screen, highlighting the "Statistics" option
  # Make sure it starts on the right page
  # Sys.sleep(2); 
  ss <- screenshot_and_read("./images/tmp.png")
  # print(ss)
  # print(ss %>% magick::image_crop("200x150+1200+250") %>%
  #         .[[1]] %>% .[1:3,,] %>%
  #         as.integer %>% mean
  # )
  # browser()
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
    misc_param <- list()
    # browser()
    for (cn in setdiff(colnames(save_progress_df),
                       c('step', 'org', 'substep', 'subsubstep'))) {
      misc_param[[cn]] <- save_progress_df[[cn]]
    }
  } else {
    step <- 0
    org <- 1
    substep <- 0
    subsubstep <- 0
    misc_param <- list()
  }
  update_progress_file <- function(step, org, substep, subsubstep=0,
                                   misc_param=list()) {
    # browser()
    outdf <- data.frame(step=step, org=org, 
                        substep=substep,
                        subsubstep=subsubstep)
    for (cn in names(misc_param)) {
      outdf[[cn]] <- misc_param[[cn]]
    }
    readr::write_csv(x=outdf,
                     file = save_progress_file_path)
  }
  
  # This csv tracks which players have been created
  if (file.exists("./data/created_players.csv")) {
    created_players <- readr::read_csv("./data/created_players.csv")
    stopifnot(!anyDuplicated(
      created_players %>%
        select(bbrefminors_id, `Birth Year`, `Birth Month`, `Birth Date`)))
  } else {
    created_players <- tibble(bbrefminors_id=character(),
                              "Birth Year"=integer(),
                              "Birth Month"=integer(),
                              "Birth Date"=integer())
  }
  
  num_pitchers_to_create <- 26 # orig 27
  num_batters_to_create  <- 37 # orig 39
  
  
  # Pause when done
  on.exit(expr={
    cat("Running on.exit from make_rosters_from_zero", "\n")
    timestamp()
    quick_run_ahk_SendEvent(" ")
    beepr::beep(2)
  }, add=T)
  
  # Make sure on correct page
  stopifnot(is_on_manage_rosters_statistics())
  
  
  # Step 0: example step 0000 ----
  if (step <= 0.5) {
    # Do stuff
    
    # End step 0 by incrementing
    step <- 1
    subsubstep <- 0
    
    # Save progress
    update_progress_file(step = 1, org=1, substep=1)
  }
  
  # Step 1: Do one org ----
  if (step <= 1.5) {
    cat("Starting step 1 in make_rosters_from_zero: edit players", "\n")
    for (i_org in 1:30) {
      # Get to correct org
      if (org > i_org) {
        next
      }
      
      ## Substep 1: move AAA/AA/A to FA ----
      if (substep <= 1.5) {
        r <- run_ahk_object$new()
        # Enter FA option
        r$add_SendEvent("sk")
        r$add_Sleep(200)
        
        # Move to correct org
        if (i_org >= 2) {
          # r$add_SendEvent(paste0("d", 
          #                        paste0(rep("9", i_org - 1),
          #                               collapse=''),
          #                        "a"))
          r$add_SendEvent("d")
          r$add(adjustLRcts(start=23,
                            goal=which(MVP_org_order == MVP_org_order2[i_org]),
                            minval=1, maxval=30, keyleft='8', keyright='9'))
          r$add_SendEvent("a")
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
        update_progress_file(step, org, substep, subsubstep)
      }
      
      ## Substep 2: Make pitchers. They are on top of FA list, easy to find ----
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
        stopifnot(nrow(pitcherdf) >= num_pitchers_to_create)
        
        # subsubstep is which was completed
        for (ipitcher in 1:num_pitchers_to_create) {
          if (subsubstep >= ipitcher) {
            next
          }
          # Move down to editable player
          if (ipitcher > 1.5) {
            quick_run_ahk_SendEvent(paste0(rep("s", ipitcher - 1), collapse = ''))
          }
          
          # Make sure first player is pitcher
          if(
            is_pitcher_on_edit_player_page(
              screenshot_and_read("./images/tmp_delete.png"))) {
            
            playerrow <- pitcherdf[ipitcher, ]
            
            if (anyDuplicated(
              bind_rows(
                created_players %>% select(created_time),
                playerrow %>% transmute(bbref_id, bbrefminors_id, `Birth Year`,
                                        `Birth Month`, `Birth Date`,
                                        First, Last,
                                        org_id, level_id)
              )
            )) {
              print(playerrow)
              stop('Player already created, stopping')
            }
            
            # Create player
            make_player_from_row(playerrow, from_zero = TRUE)
            Sys.sleep(4.5)
            
            # Write to csv that player was created
            created_players <- bind_rows(
              created_players,
              playerrow %>% transmute(bbref_id, bbrefminors_id, `Birth Year`,
                                      `Birth Month`, `Birth Date`,
                                      First, Last,
                                      org_id, level_id,
                                      created_time=(Sys.time()))
            )
            readr::write_csv(created_players, "./data/created_players.csv")
            
            # Move up to top of list
            if (ipitcher < num_pitchers_to_create) {
              quick_run_ahk_SendEvent('07')
              Sys.sleep(5.3)
            }
            
            subsubstep <- ipitcher
            update_progress_file(step, org, substep, subsubstep)
            rm(playerrow)
          } else {
            # No pitchers left, break
            break
          }
        }; rm(ipitcher)
        rm(pitcherdf)
        
        # Move back to menu page
        quick_run_ahk_SendEvent('ii')
        
        # Done, plan for next
        substep <- 3
        # subsubstep <- Leave as subsubstep, so next step knows how many
        update_progress_file(step, org, substep, subsubstep)
        # stop('finished make pitchers')
      }
      
      ## Substep 3: Move pitchers from top of FA to AAA/AA ----
      ##  subsubstep is number of pitchers created yesterday
      if (substep <= 3.5) {
        stopifnot(is_on_manage_rosters_statistics())
        
        r <- run_ahk_object$new()
        # Enter FA option
        r$add_SendEvent("sk")
        r$add_Sleep(200)
        
        # Move to correct org
        if (i_org >= 2) {
          r$add_SendEvent("d")
          r$add(adjustLRcts(start=23,
                            goal=which(MVP_org_order == MVP_org_order2[i_org]),
                            minval=1, maxval=30, keyleft='8', keyright='9'))
          r$add_SendEvent("a")
        }
        
        # Move to AAA
        r$add_SendEvent("d0a")
        
        # Move first 25 players to AAA
        r$add_SendEvent(paste0("", 
                               paste0(rep("ksk", min(25, subsubstep)),
                                      collapse='')))
        
        if (subsubstep > 25) {
          # Move to AA
          r$add_SendEvent("d0a")
          
          # Move remaining 2 pitchers to AA
          r$add_SendEvent(paste0("", 
                                 paste0(rep("ksk", subsubstep-25),
                                        collapse='')))
        }
        
        # Move back to roster menu Statistics
        r$add_SendEvent('i')
        
        r$run_ahk("tmp_make_rosters_from_zero")
        rm(r)
        
        
        
        substep <- 4
        subsubstep <- 0
        update_progress_file(step, org, substep, subsubstep)
        cat('finished pitchers move\n')
      }
      
      ## Substep 4: Make batters ----
      ###   They are not on top of FA list, need to find start index
      if (substep < 4.5) {
        # Move to edit player page
        quick_run_ahk_SendEvent('ssssksk')
        Sys.sleep(1)
        # Move to FA list
        quick_run_ahk_SendEvent('7')
        Sys.sleep(4)
        # browser()
        
        if (subsubstep == 0) {
          # Find how many pitchers we need to skip
          numskip <- 0
          while(
            is_pitcher_on_edit_player_page(
              screenshot_and_read("./images/tmp_delete.png"))
          ) {
            numskip <- numskip + 1
            quick_run_ahk_SendEvent('s', kill_before = ifelse(numskip<=1,T,F))
          }
        } else {
          # browser()
          numskip <- misc_param$numskip
          if (is.null(numskip) || is.na(numskip) || numskip<0) {
            browser('bad numskip')
          }
        }
        # browser()
        
        batterdf <- MVPdf %>% 
          filter(org_id == which(MVP_org_order2[org] == OOTP_MLB_team_order),
                 !(`First Position` %in% c('SP', 'RP')),
                 !MakeFromCreate) %>% 
          arrange(org_position_create_rank)
        stopifnot(nrow(batterdf) >= num_batters_to_create)
        
        # subsubstep is which was completed
        for (ibatter in 1:num_batters_to_create) {
          if (subsubstep >= ibatter) {
            next
          }
          # Move down to editable player: first one is already okay
          if (ibatter > 1.5) {
            quick_run_ahk_SendEvent(paste0(rep("s", ibatter - 1 + numskip),
                                           collapse = ''))
          }
          
          # Make sure player is batter
          if (
            !is_pitcher_on_edit_player_page(
              screenshot_and_read("./images/tmp_delete.png"))) {
            
            playerrow <- batterdf[ibatter, ]
            
            if (anyDuplicated(
              bind_rows(
                created_players %>% select(created_time),
                playerrow %>% transmute(bbref_id, bbrefminors_id, `Birth Year`,
                                        `Birth Month`, `Birth Date`,
                                        First, Last,
                                        org_id, level_id)
              )
            )) {
              print(playerrow)
              stop('Player already created, stopping')
            }
            
            # Create player
            make_player_from_row(playerrow, from_zero = TRUE)
            Sys.sleep(4.5)
            
            # Write to csv that player was created
            created_players <- bind_rows(
              created_players,
              playerrow %>% transmute(bbref_id, bbrefminors_id, `Birth Year`,
                                      `Birth Month`, `Birth Date`,
                                      First, Last,
                                      org_id, level_id,
                                      created_time=(Sys.time()))
            )
            readr::write_csv(created_players, "./data/created_players.csv")
            
            # Move up to top of list
            if (ibatter < num_batters_to_create) {
              quick_run_ahk_SendEvent('07')
              Sys.sleep(5.3)
            }
            
            subsubstep <- ibatter
            update_progress_file(step, org, substep, subsubstep, 
                                 misc_param=list(numskip=numskip))
            
            rm(playerrow)
          } else {
            # On pitcher before getting through all players
            if (ibatter >= 10) {
              # Used up all editable batters, exit
              break
            } else {
              stop("not enough batters to edit, this seems like an error")
            }
          }
        }; rm(ibatter, numskip)
        
        # Move back to menu page
        quick_run_ahk_SendEvent('ii')
        
        # Done, plan for next
        substep <- 5
        # subsubstep <- Keep this so that it knows how many were created
        update_progress_file(step, org, substep, subsubstep)
        # stop('finished make batters')
      } # End substep 4
      
      ## Substep 5: Move batters from top of FA to AA/A ----
      if (substep <= 5.5) {
        stopifnot(is_on_manage_rosters_statistics())
        
        r <- run_ahk_object$new()
        # Enter FA option
        r$add_SendEvent("sk")
        r$add_Sleep(200)
        
        # Move to correct org
        if (i_org >= 2) {
          r$add_SendEvent("d")
          r$add(adjustLRcts(start=23,
                            goal=which(MVP_org_order == MVP_org_order2[i_org]),
                            minval=1, maxval=30, keyleft='8', keyright='9'))
          r$add_SendEvent("a")
        }
        
        # Move to AA
        r$add_SendEvent("d00a")
        
        # Move first XX players to AA. Some pitchers may already be there.
        r$add_SendEvent(paste0("", 
                               paste0(rep("ksk",
                                          min(num_pitchers_to_create-25,
                                              subsubstep)),
                                      collapse='')))
        
        if (subsubstep > num_pitchers_to_create - 25) {
          # Move to A
          r$add_SendEvent("d0a")
          
          # Move remaining num_batters-(num_pitchers-25) batters to A
          r$add_SendEvent(
            paste0("", 
                   paste0(rep("ksk", 
                              subsubstep-(num_pitchers_to_create-25)),
                          collapse='')))
        }
        
        # Move back to roster menu Statistics
        r$add_SendEvent('i')
        
        r$run_ahk("tmp_make_rosters_from_zero")
        rm(r)
        
        substep <- 6
        subsubstep <- 0
        update_progress_file(step, org, substep, subsubstep)
        # stop('finished batters move')
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
  
  # Step 2: Edit remaining players ----
  cat("Starting step 2 in make_rosters_from_zero: edit players", "\n")
  
  if (step <= 2.5) {
    # browser("fix s2")
    
    # Players that can be created, in order
    remainingeditplayersdf <- MVPdf %>% 
      filter(!MakeFromCreate,
             !is.na(org_id)) %>% 
      dplyr::anti_join(created_players,
                       c('bbrefminors_id', 'Birth Year', 'Birth Month', 'Birth Date')) %>% 
      arrange(org_position_create_rank)
    stopifnot(nrow(remainingeditplayersdf) >= 2)
    
    # While there is an editable player, edit them
    done <- FALSE
    while(!done) {
      cat("Step 2, doing next player", "\n")
      # Start on roster options page
      stopifnot(is_on_manage_rosters_statistics())
      
      # Move to edit player page
      quick_run_ahk_SendEvent('ssssksk')
      Sys.sleep(1)
      # Move to FA list
      quick_run_ahk_SendEvent('7')
      Sys.sleep(4)
      
      # Check if pitcher before entering
      is_pitcher <- is_pitcher_on_edit_player_page(
        screenshot_and_read("./images/tmp_delete.png"))
      
      # Enter first player
      quick_run_ahk('SendEvent "k"
                     Sleep 3000')
      
      # Check if is_editable
      is_editable <- is_editable_player()
      
      if (is_editable) {
        # browser()
        # Find next player to edit
        stopifnot(nrow(remainingeditplayersdf) >= 100)
        if (is_pitcher) {
          playerrow <- remainingeditplayersdf %>%
            filter(`First Position` %in% c('SP', 'RP')) %>%
            .[1, ]
        } else {
          playerrow <- remainingeditplayersdf %>%
            filter(!(`First Position` %in% c('SP', 'RP'))) %>%
            .[1, ]
        }
        
        # Edit player
        make_player_from_row(playerrow, from_zero = TRUE,
                             already_entered_player = TRUE)
        Sys.sleep(4.5)
        
        # Write to csv that player was created
        created_players <- bind_rows(
          created_players,
          playerrow %>% transmute(bbref_id, bbrefminors_id, `Birth Year`,
                                  `Birth Month`, `Birth Date`,
                                  First, Last,
                                  org_id, level_id,
                                  created_time=(Sys.time()))
        )
        readr::write_csv(created_players, "./data/created_players.csv")
        
        # Remove from remaining player df
        nrows_before <- nrow(remainingeditplayersdf)
        remainingeditplayersdf <- remainingeditplayersdf %>% 
          dplyr::anti_join(created_players,
                           c('bbrefminors_id', 'Birth Year', 'Birth Month', 'Birth Date'))
        stopifnot(nrow(remainingeditplayersdf) == nrows_before - 1)
        rm(nrows_before)
        
        # Move to the Free Agent tab
        r <- run_ahk_object$new()
        r$add_SendEvent('iisk')
        
        
        # Move to correct org
        r$add_SendEvent("d")
        r$add(adjustLRcts(
          start=23,
          goal=which(MVP_org_order == OOTP_MLB_team_order[playerrow$org_id]),
          minval=1, maxval=30, keyleft='8', keyright='9'))
        r$add_SendEvent("a")
        
        
        # Move to A
        r$add_SendEvent("d000a")
        
        # Move top player to that team
        r$add_SendEvent("ksk")
        
        # Return to roster stats page
        r$add_SendEvent('i')
        
        # Run it
        r$run_ahk("tmp_make_rosters_from_zero")
        rm(r)
        
        # Don't need to update progress csv since there's no pre-known count,
        #  but save anyway
        subsubstep <- subsubstep + 1
        update_progress_file(step=step, org=org, substep=substep,
                             subsubstep = subsubstep)
        
        # cleanup
        rm(playerrow)
      } else {
        done <- TRUE
        cat("All done editing players", "\n")
        # Exit player, wait for FA tab to load
        quick_run_ahk_SendEvent('isk')
        Sys.sleep(5.3)
        # Move back to menu page
        quick_run_ahk_SendEvent('ii')
      }
      
      # Cleanup
      rm(is_pitcher, is_editable)
    }; rm(done, remainingeditplayersdf)
    
    
    
    # End step 2 by incrementing
    cat("Done with step 2", "\n")
    step <- 3
    substep <- 1
    subsubstep <- 0
    # Save progress
    update_progress_file(step = 3, org=NA, substep=substep, subsubstep=subsubstep)
  }
  
  # Step 3: Create 25 players ----
  
  cat("Starting step 3 in make_rosters_from_zero: create players", "\n")
  
  if (step <= 3.5) {
    # browser("fix s3")
    
    # Players that can be created, in order
    # 1. Players specified to be created.
    # 2. Players that were missed in previous step (probably b/c there weren't
    #     enough editable players with their position type). Equalizes number
    #     of players in each org.
    # 3. Player in order of create rank.
    playerstocreatedf <- MVPdf %>% 
      filter(!is.na(org_id)) %>% 
      mutate(missed_prev_step=
               ifelse(`First Position` %in% c("SP", "RP"),
                      org_position_create_rank <= num_pitchers_to_create,
                      org_position_create_rank <= num_batters_to_create)) %>% 
      dplyr::anti_join(created_players,
                       c('bbrefminors_id', 'Birth Year',
                         'Birth Month', 'Birth Date')) %>% 
      arrange(ifelse(MakeFromCreate, 0, 1),
              ifelse(missed_prev_step, 0, 1), 
              org_position_create_rank)
    
    stopifnot(nrow(playerstocreatedf) >= 2)
    
    # Create 25 players
    # subsubstep is the number of players created
    for (i_create in 1:25) {
      if (subsubstep >= i_create) {
        next
      }
      cat("Step 3, creating next player", "\n")
      # Start on roster options page
      stopifnot(is_on_manage_rosters_statistics())
      
      # Move to create player page
      quick_run_ahk_SendEvent('sssskk')
      Sys.sleep(2)
      
      # Find next player to create
      stopifnot(nrow(playerstocreatedf) >= 2)
      playerrow <- playerstocreatedf %>%
        .[1, ]
      # browser()
      
      # Create player
      make_player_from_row(playerrow, from_zero = FALSE,
                           already_entered_player = TRUE)
      Sys.sleep(1)
      
      # Write to csv that player was created
      created_players <- bind_rows(
        created_players,
        playerrow %>% transmute(bbref_id, bbrefminors_id, `Birth Year`,
                                `Birth Month`, `Birth Date`,
                                First, Last,
                                org_id, level_id,
                                created_time=(Sys.time()))
      )
      readr::write_csv(created_players, "./data/created_players.csv")
      
      # Remove from remaining player df
      playerstocreatedf <- playerstocreatedf[-1, ]
      
      # Move to the Free Agent tab
      r <- run_ahk_object$new()
      r$add_SendEvent('isk')
      
      # Move to correct org
      r$add_SendEvent("d")
      r$add(adjustLRcts(start=23,
                        goal=which(MVP_org_order == OOTP_MLB_team_order[playerrow$org_id]),
                        minval=1, maxval=30, keyleft='8', keyright='9'))
      r$add_SendEvent("a")
      
      
      # Move to A
      r$add_SendEvent("d000a")
      
      # Move top player to that team
      r$add_SendEvent("ksk")
      
      # Return to roster stats page
      r$add_SendEvent('i')
      
      # Run it
      r$run_ahk("tmp_make_rosters_from_zero")
      rm(r)
      
      # Don't need to update progress csv since there's no pre-known count,
      #  but save anyway
      subsubstep <- subsubstep + 1
      update_progress_file(step=step, org=org, substep=substep,
                           subsubstep = subsubstep)
      
      # cleanup
      rm(playerrow)
      
    }; rm(playerstocreatedf, i_create)
    
    
    
    # End step 3 by incrementing
    cat("Done with step 3", "\n")
    step <- 4
    org <- 1
    substep <- 1
    subsubstep <- 0
    # Save progress
    update_progress_file(step = 4, org=1, substep=substep,subsubstep = subsubstep)
  }
  
  # Step 4: Optimize rosters ----
  if (step <= 4.5) {
    # Mess up rosters so that MLB needs to be optimized
    stopifnot(is_on_manage_rosters_statistics())
    quick_run_ahk_SendEvent('sssk99d')
    for (i in 1:30) {
      quick_run_ahk_SendEvent(paste0(
        'kskksk', #Send two catchers down to A
        paste(rep('s', 22), collapse=''), # Go to bottom pitcher
        paste(rep('w', 10), collapse=''), # Go up 10 to a SP
        'kskksk', #Send two SP down to A
        ifelse(i==30,
               'i', # Go back if on last org
               paste0('0', 
                      paste0(rep('w', 15), collapse='')
               ) # Go to next org, move to top
        )
      ))
    }
    
    
    # Exit roster page, click yes to all optimizations
    stopifnot(is_on_manage_rosters_statistics())
    
    quick_run_ahk_SendEvent('i')
    while (TRUE) {
      Sys.sleep(2); ss <- screenshot_and_read("./images/tmp_delete.png")
      
      need_opt <- (abs((ss %>% magick::image_crop("400x250+900+450") %>%
                          .[[1]] %>% .[1:3,,] %>%
                          as.integer %>% mean
      ) - 86.72673) < 1)
      
      rm(ss)
      if (need_opt) {
        quick_run_ahk_SendEvent("sk")
      } else {
        break
      }
    }; rm(need_opt)
    
    # End step 4 by incrementing
    step <- 5
    substep <- 1
    subsubstep <- 0
    
    # Save progress
    update_progress_file(step = step, org=NA, substep=substep, subsubstep=subsubstep)
  }
  # Done
  cat('Done with make_rosters_from_zero', "\n")
  timestamp()
}
if (F) { # Run ----
  # cat("Change window now", "\n")
  KeyboardSimulator::keybd.press("alt+tab")
  Sys.sleep(.2)
  make_rosters_from_zero()
}
