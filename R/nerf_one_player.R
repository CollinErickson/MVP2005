if (!exists("is_pitcher_on_edit_player_page")) {
  source('./R/is_pitcher_on_edit_player_page.R')
}
if (!exists("nerf_one_pitcher")) {
  source('./R/nerf_one_pitcher.R')
}
if (!exists("nerf_one_batter")) {
  source('./R/nerf_one_batter.R')
}



nerf_one_player <- function(add_at_end=NULL,
                            add_at_beginning=NULL) {
  # Check pitcher/hitter ----
  screenshot::screenshot(file="./images/tmp_nerf_one_player.png")
  cat("Took screenshot", "\n")
  # Wait a second for it to get the screenshot
  Sys.sleep(2)
  # Read in screenshot
  img <- magick::image_read("./images/tmp_nerf_one_player.png")
  
  is_pitcher <- is_pitcher_on_edit_player_page(img)
  
  if (is_pitcher) {
    cat("is pitcher", "\n")
    nerf_one_pitcher(add_at_end=add_at_end)
  } else {
    cat("is batter\n")
    nerf_one_batter(add_at_end=add_at_end)
  }
}
if (F) {
  cat("Switch windows now", "\n")
  Sys.sleep(2)
  nerf_one_player()
}