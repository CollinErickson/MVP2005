# Clear rosters for one org
# Use this to move all players from a roster to the Free Agent list

clear_rosters <- function(norgs=1, nlevels=4) {
  
  # Beep when function exists
  on.exit(expr={
    cat("Running on.exit from clear_rosters", "\n")
    timestamp()
    quick_run_ahk_SendEvent(" ")
    beepr::beep(2)
  }, add=T)
  
  # Start right after clicking the FA tab. Should be in left column.
  # Loop over orgs
  for (h in 1:norgs) {
    # Loop over teams in org
    for (i in 1:nlevels) {
      # Loop over players, 25 max
      r <- run_ahk_object$new()
      for (j in 1:25) {
        # Click right (move to team), x (release), down (move to yes), x (confirm)
        r$add('
            SendEvent "dksk"
            Sleep 450')
      }
      r$run_ahk("tmp_clear_rosters2")
      rm(r)
      
      # Move to next team in org
      quick_run_ahk('
          SendEvent "0" ; next team
            Sleep 300')
    }
    # Move to next org (move right, R1, move left)
    quick_run_ahk('
        SendEvent "d9a" ; next org
          Sleep 300')
  }
  
  cat("Done with clear_rosters", "\n")
  timestamp()
}

if (F) {
  cat("Change windows now", "\n")
  Sys.sleep(2)
  clear_rosters(norgs=30, nlevels=4)
}