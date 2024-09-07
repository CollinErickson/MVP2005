# run_ahk_object ----
run_ahk_object <- R6::R6Class(
  classname='run_ahk_object',
  public=list(
    
    
    
    # Initiate
    out = '
#Requires AutoHotkey v2.0

#SingleInstance Force

thread "interrupt", 2000, -1
Interrupted := 0

^+2::{
  Global Interrupted
  Interrupted := 1

}

^+1::{
  Global Interrupted
  SetKeyDelay 95, 40  ; 75ms between keys, 25ms between down/up\n',
add = function(x, interrupt=TRUE) {
  self$out <- paste0(self$out, "\n  ", x, "\n")
  if (interrupt)
    self$out <<- paste0(self$out,"  If (Interrupted > 0) {
    SoundBeep(523, 500)
    return      
  }\n")
},
add_SendEvent = function(text, rep=1) {
  stopifnot(length(text) == 1)
  if (rep > 1) {
    text <- paste0(rep(text, rep), collapse=T)
  }
  self$add(paste0(
    "SendEvent '", text, "'"
  ))
},
run_ahk = function(file_prefix, trigger=TRUE, wait=TRUE, wait_sec=240,
                   kill_before=TRUE, kill_after=FALSE) {
  textcs1=self$out
  if (length(textcs1) != 1) {
    browser('rahk l1')
  }
  stopifnot(
    is.character(textcs1), length(textcs1) == 1,
    is.character(file_prefix), length(file_prefix) == 1,
    nchar(file_prefix) > 0)
  
  done_text_file_name <- paste0("./autohotkey/", file_prefix, "_done.txt")
  
  if (file.exists(done_text_file_name)) {
    file.remove(done_text_file_name)
  }
  
  # End ahk
  # Write out file ----
  self$add(paste0('
  FileAppend("done\\n", "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/', 
                  file_prefix, 
                  '_done.txt")
  '))
  # Beep when done
  self$add("
      SoundBeep(523, 500)")
  # Close 1
  self$add("}", interrupt=FALSE)
  
  # # Return
  # out
  
  
  # Write it ----
  write(x=self$out, file=paste0("./autohotkey/", file_prefix, ".ahk"))
  
  # Kill any existing ahk ----
  if (kill_before) {
    kill_all_ahk()
  }
  
  # Execute it ----
  # system('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/beep.ahk',
  #        wait=FALSE)
  system(paste0('"C:/Program Files/AutoHotkey/UX/AutoHotkeyUX.exe" "C:/Users/colli/Documents/codeprojects/MVP2005/autohotkey/',
                file_prefix,
                '.ahk"'),
         wait=FALSE)
  
  # Wait a sec
  Sys.sleep(1)
  
  # Trigger it ----
  if (!trigger) {
    return()
  }
  KeyboardSimulator::keybd.press("shift+ctrl+1")
  trigger_time <- Sys.time()
  
  if (!wait) {
    return()
  }
  
  # Loop, check for file ----
  cat("R will now wait for ahk to run", "\n")
  ahk_done <- FALSE
  cat_progress <- progress::progress_bar$new(
    format=paste0("Waiting for ahk ", file_prefix, " :elapsed"), total=NA, clear=F, width=80
  )
  while (as.numeric(Sys.time()-trigger_time,units="secs") < wait_sec) {
    # cat('p3 wait ahk', 
    #     as.numeric(Sys.time()-trigger_time,units="secs"), "\n")
    cat_progress$tick()
    if (file.exists(done_text_file_name)) {
      ahk_done <- TRUE
      cat("\nFound ahk done!", "\n")
      file.remove(done_text_file_name)
      rm(cat_progress)
      break
    }
    Sys.sleep(.5)
  }
  if (!ahk_done) {
    stop(paste0("move_fa_to_roster ahk failed to finish in ", wait_sec, " seconds"))
  }
  
  # Kill after ----
  if (kill_after) {
    kill_all_ahk()
  }
  
  cat("Finished run_ahk", file_prefix, "\n")
  return(invisible(self))
}
  )
)
if (F) {
  ra1 <- run_ahk_object$new()
  ra1$add("SendEvent 'abcdef this is a test'")
  ra1$run_ahk(file_prefix='test run_ahk')
}
if (F) {
  run_ahk("SendEvent 'test run_ahk'", file_prefix="test run_ahk")
}

# run_ahk_object_new <- function() {
#   run_ahk_object$new()
# }
