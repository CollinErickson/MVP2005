# Find the pixel location boundaries for the game.
# Not the PCSX2 window, but the game within that. Ignore the black on the sides.
# Use AutoHotkey Dash -> Window Spy to get these
# My HP Pavilion, full screen
game_pixel_top <- 77
game_pixel_left <- 317
game_pixel_bottom <- 1625
game_pixel_right <- 1059

map_pixel_to_proportion <- function(pixel) {
  # pixel = c(left, down) from top corner, in pixels
  stopifnot(length(pixel) == 2, is.numeric(pixel), pixel >= 0)
  c(
    (pixel[1] - game_pixel_left) / (game_pixel_right - game_pixel_left),
    (pixel[2] - game_pixel_top) / (game_pixel_bottom - game_pixel_top)
  )
}
if (F) {
  map_pixel_to_proportion(c(317, 77))
  map_pixel_to_proportion(c(1059, 1625))
  map_pixel_to_proportion(c(317, 1625))
  map_pixel_to_proportion(c(1059, 77))
  map_pixel_to_proportion(c(900, 300))
}
map_proportion_to_pixel <- function(proportion) {
  # proportion = c(left, down) from top corner, in proportion
  stopifnot(length(proportion) == 2, is.numeric(proportion), 
            proportion >= 0, proportion <= 1)
  c(
    game_pixel_left + proportion[1] * (game_pixel_right - game_pixel_left),
    game_pixel_top + proportion[2] * (game_pixel_bottom - game_pixel_top)
    )
}
if (F) {
  map_proportion_to_pixel(c(0,0))
  map_proportion_to_pixel(c(0,1))
  map_proportion_to_pixel(c(1,0))
  map_proportion_to_pixel(c(1,1))
}