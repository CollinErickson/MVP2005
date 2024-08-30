library(dplyr)
if (F) {
  Sys.sleep(2); screenshot::screenshot(file="./images/edit_greinke.png")
  Sys.sleep(2); screenshot::screenshot(file="./images/edit_sweeney.png")
  Sys.sleep(2); screenshot::screenshot(file="./images/edit_lima.png")
  Sys.sleep(2); screenshot::screenshot(file="./images/edit_long.png")
  greinke <- magick::image_read("./images/edit_greinke.png")
  sweeney <- magick::image_read("./images/edit_sweeney.png")
  lima <- magick::image_read("./images/edit_lima.png")
  long <- magick::image_read("./images/edit_long.png")
  greinke
  sweeney
  lima
  long
  greinke_crop <- magick::image_crop(greinke,geometry="65x85+725+400",gravity="NorthWest",repage=TRUE)
  sweeney_crop <- magick::image_crop(sweeney,geometry="65x85+725+400",gravity="NorthWest",repage=TRUE)
  lima_crop <- magick::image_crop(lima,geometry="65x85+725+400",gravity="NorthWest",repage=TRUE)
  long_crop <- magick::image_crop(long,geometry="65x85+725+400",gravity="NorthWest",repage=TRUE)
  greinke_crop
  sweeney_crop
  lima_crop
  long_crop
  magick::image_resize(greinke_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer()
  magick::image_resize(sweeney_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer()
  magick::image_resize(lima_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer()
  magick::image_resize(long_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer()
  # Avg first 3
  magick::image_resize(greinke_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer() %>% {mean(.[1:3])}
  magick::image_resize(sweeney_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer() %>% {mean(.[1:3])}
  magick::image_resize(lima_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer() %>% {mean(.[1:3])}
  magick::image_resize(long_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer() %>% {mean(.[1:3])}
}

is_pitcher_on_edit_player_page <- function(img) {
  img_crop <- magick::image_crop(img,geometry="65x85+725+400",gravity="NorthWest",repage=TRUE)
  avg3 <- magick::image_resize(img_crop, c(1,1)) %>% .[[1]] %>% .[,1,1] %>% as.integer() %>% {mean(.[1:3])}
  
  return(avg3 < 110)
}
if (F) {
  is_pitcher_on_edit_player_page(greinke)
  is_pitcher_on_edit_player_page(sweeney)
  is_pitcher_on_edit_player_page(lima)
  is_pitcher_on_edit_player_page(long)
}