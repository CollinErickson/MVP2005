# Create a list of these objects. Go through them all at the end.
edit_player_read_ocr_objects <- list(
  position=read_ocr_object$new(name="position", char=T, 
                               char_list=c("SP", "RP", "C", "1B", "2B", "SS", 
                                           "3B", "LF", "CF", "RF", "IF", "OF",
                                           "UTIL", "NONE"), all_caps=T),
  birth_year=read_ocr_object$new(name="birth_year", cts=T, minval=1961, maxval=1987),
  birth_month=read_ocr_object$new(name='birth_month', char=T, char_list=months, all_caps = T),
  birth_day=read_ocr_object$new(name="birth_day", cts=T, minval=1, maxval=31),
  throws_bats=read_ocr_object$new(name="throws_bats", char=T, char_list=c("LEFT", "RIGHT"), all_caps = T),
  batter_ditty_type=read_ocr_object$new(name='batter_ditty_type', char=T, all_caps = T,
                                        char_list = batter_ditty_type_options),
  reg_cts=read_ocr_object$new('reg_cts', cts=T, minval=0, maxval=100),
  none_or_cts=read_ocr_object$new('none_or_cts', char=T,char_list = c("NONE", 1,2,3,4,5,6))
)
for (i in seq_along(edit_player_read_ocr_objects)) {
  edit_player_read_ocr_objects[[i]]$run_unique()
  edit_player_read_ocr_objects[[i]]$run_labeler()
}
