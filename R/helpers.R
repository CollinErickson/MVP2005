# opentextboxandclear <- '
#   SetKeyDelay 175, 25  ; 75ms between keys, 25ms between down/up.
# 	SendEvent "k"
# 	Sleep 1000
#     SendEvent "sskkkkk"
# 
# '
# 
# pressandreturn <- list(
#   "a" = "aaaawwkssdddd",
#   "z" = "aaaawksdddd",
#   "b" = "aaawksddd",
#   "o" = "aawwwksssdd",
#   "y" = "aaawwwdksssddd"
# )

# typeout <- function(x) {
#   y <- ""
#   for (i in 1:nchar(x)) {
#     y <- paste0(y, "\n  SendEvent \"", 
#                 pressandreturn[tolower(substr(x,i,i))], " ; \t",
#                 tolower(substr(x,i,i)), "\"")
#   }
#   y
# }
# 
# cat(typeout("azzzaa"))
# cat(typeout("boo"))

charlocation <- list(
  a=c(2,1),
  b=c(3,5),
  c=c(3,3),
  d=c(2,3),
  e=c(1,3),
  f=c(2,4),
  g=c(2,5),
  h=c(2,6),
  i=c(1,8),
  j=c(2,7),
  k=c(2,8),
  l=c(2,9),
  m=c(3,7),
  n=c(3,6),
  o=c(1,9),
  p=c(1,10),
  q=c(1,3),
  r=c(1,4),
  s=c(2,2),
  t=c(1,5),
  u=c(1,7),
  v=c(3,4),
  w=c(1,2),
  x=c(3,2),
  y=c(1,6),
  z=c(3,1)
)


typeout2 <- function(x, start='done') {
  # browser()
  stopifnot(is.character(x), length(x) == 1)
  # Clean accents "Loáisiga"
  x <- stringi::stri_trans_general(x, id = "Latin-ASCII")
  # Remove spaces, periods, commas
  x <- x %>%
    stringr::str_replace(" ", "") %>% 
    stringr::str_replace("\\.", "") %>% 
    stringr::str_replace(",", "")
  # If last 2 are Jr, remove it
  if (substring(x, nchar(x) - 1) == "Jr") {
    x <- substring(x, 1,nchar(x) - 2)
  }
  
  # # Move to z from back
  # y <- '  SendEvent "aaaaw" ; \tmove from back to z'
  # Move to z from entry point
  if (start == 'done') {
    y <- '  SendEvent "ds" ; \tmove from done to z'
    start <- 'z'
  } else {
    y <- ''
    stopifnot(nchar(start) == 1)
  }
  
  
  for (i in 1:nchar(x)) {
    if (!(tolower(substring(x, i, i))) %in% letters) {
      cat("Had to skip letter:", substring(x, i, i), "\n")
      next
    }
    # browser()
    if (i==1) {
      loc1 <- charlocation[[start]]
    } else {
      # loc1 <- charlocation[[tolower(substr(x,i-1,i-1))]]
      loc1 <- loc2
    }
    loc2 <- charlocation[[tolower(substr(x,i,i))]]
    
    capitalize_i <- (i > 1.5 && (substr(x,i,i) %in% LETTERS))
    
    # Capitalize this letter, need to turn off after
    if (capitalize_i) {
      y <- paste0(y, "\n  SendEvent \"j\" ; capitalize")
    }
    
    y <- paste0(y, "\n  SendEvent \"")
    # browser()
    # if (inherits(if (loc1[1] < loc2[1]) {}, "try-error")) {browser();1}
    # print(length(loc1[1] < loc2[1]))
    # Up
    if (loc1[1] < loc2[1]) {
      for (j in 1:(loc2[1] - loc1[1])) {
        y <- paste0(y, "s")
      }
    }
    # Down
    if (loc1[1] > loc2[1]) {
      for (j in 1:(-loc2[1] + loc1[1])) {
        y <- paste0(y, "w")
      }
    }
    # Left
    if (loc1[2] < loc2[2]) {
      for (j in 1:(loc2[2] - loc1[2])) {
        y <- paste0(y, "d")
      }
    }
    # Right
    if (loc1[2] > loc2[2]) {
      for (j in 1:(-loc2[2] + loc1[2])) {
        y <- paste0(y, "a")
      }
    }
    # Click
    y <- paste0(y, "k")
    
    y <- paste0(y, "\" ; \t",
                tolower(substr(x,i,i)))
    
    # Decapitalize
    if (capitalize_i) {
      y <- paste0(y, "\n  SendEvent \"j\" ; decapitalize")
    }
    
    # if (i == 1) {
    #   y <- paste0(y, "j ; lower case for remainder")
    # }
    
    
    
    # y <- paste0(y, "\n  SendEvent \"", 
    #             pressandreturn[tolower(substr(x,i,i))], " ; \t",
    #             tolower(substr(x,i,i)), "\"")
  } # end loop over letters
  
  # # Exit by navigating to done and clicking
  # 
  # y <- paste0(y, "\n  SendEvent \"")
  # # move to 2nd row
  # if (loc2[1]<2) {
  #   y <- paste0(y, "s")
  # }
  # if (loc2[1]>2) {
  #   y <- paste0(y, "w")
  # }
  # # Move to done
  # # print(loc2)
  # for (i in 1:(12 - loc2[2])) {
  #   
  #   y <- paste0(y, "d")
  # }
  # # Click done
  # y <- paste0(y, "k\" ; \tDone")
  
  # Exit by pressing start
  y <- paste0(y, "\n\tSendEvent \"u\" ; \tDone")
  
  y
}
if (F) {
  cat(typeout2("aaron"))
}

adjustLR <- function(x, keyright='d', keyleft='a') {
  if (x > 0) {
    paste0("  SendEvent \"", paste(rep(keyright, x), collapse=''), "\"\n")
  } else
    if (x < 0) {
      paste0("  SendEvent \"", paste(rep(keyleft, -x), collapse=''), "\"\n")
    }
}
if (F) {
  cat(adjustLR(5))
  cat(adjustLR(-3))
}
adjustLRapprox <- function(start, goal, minval, maxval,
                           keyright='d', keyleft='a', careful=TRUE) {#browser()
  diff_direct <- abs(start - goal)
  diff_around <- if (start < goal) {
    start - minval + 1 + maxval - goal
  } else {
    goal - minval + 1 + maxval - start
  }
  # diff <- abs(start - goal)
  # dist_from_edge <- ifelse(start < goal, 
  #                          maxval - goal,
  #                          goal - minval)
  dist_from_edge <- min(maxval - goal, goal - minval)
  diff <- min(diff_direct, diff_around)
  key <- case_when(
    diff_direct <= diff_around && start <= goal ~ keyright,
    diff_direct <= diff_around && start > goal  ~ keyleft,
    diff_direct >  diff_around && start <= goal ~ keyleft,
    diff_direct >  diff_around && start > goal ~ keyright,
    TRUE ~ "error")
  stopifnot(key != "error")
  
  if (!careful) {
    dist_from_edge <- 100
  }
  # If close to start or close to edge, do exact
  if (diff <= 12 || dist_from_edge < 4) {
    return(adjustLRcts(start=start, goal=goal, minval=minval, maxval=maxval))
  }
  # Do approx
  hold_length <- round((diff --3.66572375)/  0.02399106, 3)
  # key <- ifelse(goal > start, keyright, keyleft)
  paste0('
    SetKeyDelay 75, ', hold_length, '  ; Hold for X seconds to move fast than
                          ; repeated presses, should get within 1, need to be
                          ; running PCSX2 at 2x speed
    SendEvent "', key, '" ; Set movement to 0
    SetKeyDelay 75, 40  ; 75ms between keys, 25ms between down/up
  ')
}
if (F) {
  cat(adjustLRapprox(50, 5, minval=0, maxval=100))
  cat(adjustLRapprox(50, 95, minval=0, maxval=100))
  cat(adjustLRapprox(50, 45, minval=0, maxval=100))
  cat(adjustLRapprox(50, 1, minval=0, maxval=100))
  cat(adjustLRapprox(50, 1, minval=0, maxval=100, careful=F))
  cat(adjustLRapprox(54, 1, minval=0, maxval=100, careful=F))
  cat(adjustLRapprox(50, 90, minval=0, maxval=100))
  cat(adjustLRapprox(50, 70, minval=0, maxval=100))
  cat(adjustLRapprox(0, 100, minval=0, maxval=100))
  cat(adjustLRapprox(97, 0, minval=0, maxval=100, careful=F))
  cat(adjustLRapprox(90, 10, minval=0, maxval=100, careful=F))
}

# Go either way. cts means 0 to 100 scale
adjustLRcts <- function(start, goal, maxval=100, minval=0) {
  # maxval: contact/power go 0-100, speed goes 0-99
  # minval: stamina goes 0-99
  if (abs(start - goal) <= .55*(maxval-minval)) { # Simple
    adjustLR(goal - start)
  } else { # Go across 0
    if (start > .5*(minval + maxval)) {
      adjustLR(maxval-start+goal+1 - minval)
    } else {
      adjustLR(-(start+1+maxval-goal - minval))
    }
  }
}
if (F) {
  adjustLRcts(47, 47) # nothing
  adjustLRcts(47, 53) # dddddd
  adjustLRcts(53, 47) # aaaaaa
  adjustLRcts(1, 99) # aaa
  adjustLRcts(1, 99, maxval = 99) # aa
  adjustLRcts(1, 99, maxval = 99, minval=1) # a
  adjustLRcts(99, 1) # ddd
  adjustLRcts(99, 1, maxval = 99) # dd
  adjustLRcts(99, 1, maxval = 99, minval=1) # dd
}

discrete_values <- c(0,10,20,30,40,50,55,60,65,70,75,80,85,90,95,99)
adjustLRdiscrete <- function(start, goal) {
  # cat("LR discrete", start, goal, "\n")
  stopifnot(length(start) == 1,
            length(goal)==1,
            start %in% discrete_values,
            goal %in%discrete_values)
  s2 <- which(start == discrete_values)
  g2 <- which(goal == discrete_values)
  # print(c(s2,g2))
  if (abs(g2 - s2) <= 9) {
    adjustLR(g2 - s2)
  } else { # go across 0
    if (s2 >= 9) { # up 99 back to 0
      adjustLR(g2 + (16-s2))
    } else { # down to 0 back to 99
      adjustLR(-s2 + -(16-g2))
    }
  }
}
if (F) {
  cat(adjustLRdiscrete(0, 10))
  cat(adjustLRdiscrete(0, 99))
  cat(adjustLRdiscrete(95, 10))
  cat(adjustLRdiscrete(40, 50))
  cat(adjustLRdiscrete(50, 40))
  cat(adjustLRdiscrete(65, 30))
}

adjustLRnoneorcts <- function(start, goal, keyright='d', keyleft='a') {
  stopifnot(length(start) == 1, start %in% c("NONE", 1:6))
  stopifnot(length(goal) == 1, goal %in% c("NONE", 1:6))
  if (start == goal) {
    # Done
  } else if (start == "NONE") {
    paste0("  SendEvent \"", paste(rep(keyright, as.integer(goal)), collapse=''), "\"\n")
  } else if (goal == "NONE") {
    paste0("  SendEvent \"", paste(rep(keyleft, as.integer(start)), collapse=''), "\"\n")
  } else {
    adjustLR(as.integer(goal) - as.integer(start))
  }
}
if (F) {
  cat(adjustLRnoneorcts(1,2))
  cat(adjustLRnoneorcts("NONE", "NONE"))
  cat(adjustLRnoneorcts("NONE", 5))
  cat(adjustLRnoneorcts(4,"NONE"))
}

adjustLRcharlist <- function(start, goal, char_list, cts=T) {
  stopifnot(length(start) == 1, length(goal) == 1,
            start %in% char_list, goal %in% char_list)
  i1 <- which(start == char_list)
  i2 <- which(goal == char_list)
  adjustLR(i2 - i1)
}


round_to_discrete <- function(x) {
  stopifnot(is.numeric(x))
  discrete_mids <- (discrete_values[1:15] +discrete_values[2:16])/2
  out <- rep(NA, length(x))
  for (i in seq_along(discrete_mids)) {
    out[is.na(out) & !is.na(x) & x < discrete_mids[i]] <- discrete_values[i]
  }
  out[is.na(out) & !is.na(x) & x >= discrete_mids[15]] <- discrete_values[16]
  out
}
if (F) {
  round_to_discrete(0:100)
  cbind(0:100, round_to_discrete(0:100))
  plot((-2):102, round_to_discrete((-2):102))
  round_to_discrete(c(4, NA, 99.8))
}

first_position_order <- c("1B", "2B", "3B", "SS", "LF", "CF", "RF", "RP", "SP", "C")
second_position_order <- c("C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "OF",
                           "IF", "UTIL", "NONE", "RP", "SP")


# KeyboardSimulator::keybd.press("shift+ctrl+1")

pitch_order <- c("Changeup", 'Curveball', 'Knuckleball',
                 'Screwball', 'Sinker', 'Slider',
                 'Splitter', '2-Seam Fastball',
                 'Cutter', 'Circle Change', 'Forkball',
                 'Knucklecurve', 'Palmball', 'Slurve')
pitch_speed_default <- c(78,76,67,
                         79,88,86,
                         85,91,
                         89,77,81,
                         67,72,79)

# Delivery names and their probability (relative, to give variation but avoid classic)
pitcher_delivery_options <- c(
  "Style 1"=1, "Style 2"=1, "Style 3"=1, "Style 4"=1,
  "Style 5"=1, "Style 6"=1, "Style 7"=1,
  "Style 8"=1, "Style 9"=1, "Style 10"=1, "Style 11"=1,
  "Classic 1"=0, "Classic 2"=0, "Classic 3"=0,
  'K. Brown'=0, 'Foulke'=1, 'E. Gagne'=1, 'B. Gibson'=0, 'Glavine'=1, 'R. Halladay'=1, 
  'Hasegawa'=1, 'O. Hernandez'=1, 'Hoffman'=0, 'T. Hudson'=1, 'C. Hunter'=0, 
  'Ishii'=1, 'R. Johnson'=1, 'W. Johnson'=0, 'Kim'=0, 'Lowe'=1, 'Maddux'=1,
  'J. Marichal'=0, 'P. Martinez'=1, 'M. Morris'=1, 'Moyer'=1, 
  'M. Mulder'=1, 'Mussina'=1, 'Nelson'=1, 'Nomo'=0, 'Ohka'=1, 'Oswalt'=1,
  'S. Paige'=0, 'Park'=1, 'Ol. Perez'=1, 'Pettitte'=1, 'M. Prior'=1, 'M. Redman'=1, 
  'Rivera'=1, 'N. Ryan'=0, 'Schilling'=1, 'Schmidt'=1, 'T. Seaver'=1, 'J. Seo'=1,
  'Smoltz'=1, 'Wakefield'=1, 'Weber'=1, 'D. Wells'=1, 'D. Willis'=1, 'B. Zito'=1
)
stopifnot(is.numeric(pitcher_delivery_options))

# batter stance names and their probability (relative, to give variation but avoid bent)
batter_stance_options <- c(
  "Generic"=5, "Generic 2"=1, "Generic 3"=0, "Bent"=0, "Closed"=0, "Crouched"=1,
  "High"=1, "Open"=0, "Upright"=1, 
  "Classic 1"=1, "Classic 2"=0, "Classic 3"=1, "Alou"=1, "Bagwell"=1,
  "Beltre"=1, "Y. Berra"=1, 
  "B. Boone"=1, "Burnitz"=1, "R. Carew"=0, "E. Chavez"=1, "T. Cobb"=1, 
  "Counsell"=0, "Delgado"=1, 
  "Durham"=1, "Everett"=1, "Floyd"=1, "J. Franco"=1, 
  "Fullmer"=1, "Garciaparra"=1, "L. Gehrig"=1,
  "Giambi"=1, "Giles"=1, "Glaus"=1, "J. Gonzalez"=1, "L. Gonzalez"=0,
  "Green"=1, "Griffey Jr."=1, "V. Guerrero"=1, "Helton"=1, "Ichiro"=1,
  "R. Jackson"=1, "Jeter"=1,
  "A. Jones"=1, "C. Jones"=1, "Klesko"=1, "Lofton"=1, "H. Matsui"=1, "K. Matsui"=1,
  "J. Morgan"=1, "M. Ordonez"=1, "D. Ortiz"=1, "Piazza"=1, "A. Pujols"=1,
  "M. Ramirez"=1, "Renteria"=1, "A. Rodriguez"=1, "B. Ruth"=0, "Sheffield"=1,
  "Sierra"=1, "Sosa"=1, "Thomas"=1, "Thome"=1, "Vina"=1, "H. Wagner"=1,
  "Walker"=1, "B. Williams"=1)
stopifnot(is.numeric(batter_stance_options))

kill_all_ahk <- function() {
  # Kill processes
  # system("wmic process where \"commandline like '%%.ahk'\" delete")
  
  # Alternatively, kill AHK itself. 
  system('taskkill /im "AUTOHO~1.exe"')
  Sys.sleep(.2)
}

# MVP_org_order ----
# Order the teams in MVP show up (on the FA page)
MVP_org_order <- c('LAA', 'HOU', 'OAK', 'TOR', 'ATL', 'MIL', 'STL',
                   'CHC', 'TBR', 'ARI', 'LAD', 'SFG', 'CLE', 'SEA',
                   'MIA', 'NYM', 'WAS', 'BAL', 'SDP', 'PHI', 'PIT',
                   'TEX', 'BOS', 'CIN', 'COL', 'KCR', 'DET', 'MIN',
                   'CHW', 'NYY')
# MVP_org_order2 ----
# Order the teams in MVP show up (on the edit player page)
MVP_org_order2 <- c('BOS', 'CHC', 'CHW', 'CIN', 'CLE', 'COL', 'DET',
                    'MIA', 'HOU', 'KCR', 'LAD', 'MIL', 'MIN', 'NYM',
                    'NYY', 'OAK', 'PHI', 'PIT', 'SDP', 'SFG', 'SEA',
                    'STL', 'TBR', 'TEX', 'TOR', 'WAS', 'LAA', 'ARI',
                    'ATL', 'BAL')
# OOTP_team_id_order ----
# team_id for the MLB teams
OOTP_team_id_order <- c('ARI', 'ATL', 'BAL', 'BOS', 'CHW', 'CHC', 'CIN',
                        'CLE', 'COL', 'DET', 'MIA', 'HOU', 'KCR', 'LAA',
                        'LAD', 'MIL', 'MIN', 'NYY', 'NYM', 'OAK', 'PHI',
                        'PIT', 'SDP', 'SEA', 'SFG', 'STL', 'TBR', 'TEX',
                        'TOR', 'WAS')
# OOTP_MLB_team_order ----
# Order of the MLB teams from the OOTP spreadsheet
OOTP_MLB_team_order <- c('BAL', 'BOS', 'NYY', 'TBR', 'TOR',
                         'CHW', 'CLE', 'DET', 'KCR', 'MIN',
                         'LAA', 'OAK', 'SEA', 'TEX', 'HOU',
                         'ATL', 'MIA', 'NYM', 'PHI', 'WAS',
                         'CHC', 'CIN', 'MIL', 'PIT', 'STL',
                         'ARI', 'COL', 'LAD', 'SDP', 'SFG')
stopifnot(length(MVP_org_order) == 30, 
          length(OOTP_team_id_order) == 30,
          length(OOTP_MLB_team_order) == 30,
          sort(MVP_org_order) == sort(OOTP_team_id_order),
          sort(MVP_org_order) == sort(OOTP_MLB_team_order))

months <- c('JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
            'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER')
month_to_int <- function(x) {
  stopifnot(length(x) == 1, is.character(x))
  m <- which(months == toupper(x))
  stopifnot(length(m) == 1)
  m
}

press_spacebar_when_done <- function() {
  # Press spacebar when done
  on.exit(expr={
    r <- run_ahk_object$new()
    r$add("SendEvent ' ' ; spacebar to pause PCSX2")
    r$run_ahk(file_prefix="press_spacebar")
  })
}

screenshot_and_read <- function(file) {
  screenshot::screenshot(file=file)
  magick::image_read(file)
}

batter_ditty_type_options <- c(
  "COUNTRY", 'DANCE', 'HIP HOP', 'POP', 'ROCK', 'HEAVY ROCK', 'LATIN'
)
