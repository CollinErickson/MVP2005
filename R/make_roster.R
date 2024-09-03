library(dplyr)

make_roster <- function(norgs=30, nlevels=4, nplayers=25) {
  kill_all_ahk()
  
  # This csv tracks which players have been created
  if (file.exists("./data/created_players.csv")) {
    created_players <- readr::read_csv("./data/created_players.csv")
  } else {
    created_players <- tibble(bbrefminors_id=character(),
                              "Birth Year"=integer(),
                              "Birth Month"=integer(),
                              "Birth Date"=integer())
  }
  # This csv tracks which teams have had all players created and added to roster
  if (file.exists("./data/created_teams.csv")) {
    created_teams <- readr::read_csv("./data/created_teams.csv")
  } else {
    created_teams <- tibble(org_id=integer(), level_id=integer())
  }
  
  # Make sure that it starts on the Create/Edit Player screen
  screenshot::screenshot(file="./images/tmp_check_create_edit_player_page.png")
  ss <- magick::image_read("./images/tmp_check_create_edit_player_page.png")
  ssorig <- magick::image_read("./images/create_edit_player_page.png")
  ss_crop <- magick::image_crop(ss, "400x100+500+350")
  ssorig_crop <- magick::image_crop(ssorig, "400x100+500+350")
  diff <- mean(abs(as.integer(ssorig_crop[[1]][1:3,,]) -
                     as.integer(ss_crop[[1]][1:3,,])))
  if (diff > 1) {
    stop("ERROR Need to start on the create/edit player menu")
  }
  
  
  # Loop over orgs
  for (i in 3:norgs) {
    cat("make_roster starting org_id", i, "\n")
    # Loop over levels
    for (j in 1:nlevels) {
      cat("make_roster starting level_id", j, "\n")
      # Check if org*level (aka team) is already done
      team_already_done <- nrow(created_teams %>%
                                  filter(org_id==i, level_id == j)
      ) > .5
      if (team_already_done) {
        next
      }
      rm(team_already_done)
      
      # Loop over players
      for (k in 1:nplayers) {
        cat("make_roster starting player", k, i, j, "\n")
        playerrow <- MVPdf %>% filter(org_id == i,
                                      level_id == j) %>%
          arrange(org_position_rank) %>% 
          .[k,]
        # Check csv to see if player was created
        player_already_created <- nrow(
          created_players %>%
            filter(bbrefminors_id == playerrow$bbrefminors_id,
                   `Birth Year` == playerrow$`Birth Year`,
                   `Birth Month` == playerrow$`Birth Month`, 
                   `Birth Date` == playerrow$`Birth Date`
                   )
        ) > .5
        if (player_already_created) {
          next
        }
        rm(player_already_created)
        
        # Make player (onto FA list)
        make_player_from_row(playerrow)
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
      } # Done with making all players
      
      # Navigate to FA page, clear team, then add them to team
      move_fa_to_roster(org_id = i, level_id = j, nplayers = nplayers)      
      
      # Write that team was created
      created_teams <- bind_rows(
        created_teams,
        tibble(org_id=i, level_id=j, created_time=(Sys.time()))
      )
      readr::write_csv(created_teams, "./data/created_teams.csv")
    } # end level
  } # end org
}
if (T) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  make_roster(5,4)
}
