# Immediately after entering edit player page
# Real players can't be edited, made up ones can.
is_editable_player <- function() {
  screenshot::screenshot(file="./images/tmp_is_editable_player.png")
  ss <- magick::image_read("./images/tmp_is_editable_player.png")
  ss_crop <- magick::image_crop(ss, "250x45+685+930")
  ss_crop
  
  # browser()
  
  # Load save images to compare to
  p_true <- magick::image_read("./images/is_editable_player_true.png")
  
  # If current page isn't edit player page, give error
  edit_player_diff <- mean(abs(
    as.integer(magick::image_crop(ss, "300x100+420+130")[[1]][1:3,,]) - 
    as.integer(magick::image_crop(p_true, "300x100+420+130")[[1]][1:3,,])
  ))
  if (edit_player_diff > 1) {
    stop("Error in is_editable_player: Not on edit player screen")
  }
  
  # 
  diff_true <- mean(abs(
    as.integer(magick::image_crop(ss, "50x220+1120+570")[[1]][1:3,,]) - 
      as.integer(magick::image_crop(p_true, "50x220+1120+570")[[1]][1:3,,])
  ))
  if (diff_true < 1) {
    return(TRUE)
  }
  
  # Now make sure it matches false (shouldn't not happen)
  p_false <- magick::image_read("./images/is_editable_player_false.png")
  diff_false <- mean(abs(
    as.integer(magick::image_crop(ss, "50x220+1120+570")[[1]][1:3,,]) - 
      as.integer(magick::image_crop(p_false, "50x220+1120+570")[[1]][1:3,,])
  ))
  if (diff_false < 1) {
    return(FALSE)
  }
  stop("Error in is_editable_player, this shouldn't happen")
}
if (F) {
  cat("Switch window now", "\n")
  Sys.sleep(2)
  cat("is_editable_player:", is_editable_player(), "\n")
}
if (F) {
  # Use this to create the saved images
  Sys.sleep(2); screenshot::screenshot(file="./images/tmp_is_editable_player.png")
  ss <- magick::image_read("./images/tmp_is_editable_player.png")
  ss_crop <- magick::image_crop(ss, "250x45+685+930")
  ss_crop
  magick::image_write(ss, "./images/is_editable_player_true.png")
}