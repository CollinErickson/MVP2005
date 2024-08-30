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
    # browser()
    if (i==1) {
      loc1 <- charlocation[[start]]
    } else {
      loc1 <- charlocation[[tolower(substr(x,i-1,i-1))]]
    }
    loc2 <- charlocation[[tolower(substr(x,i,i))]]
    
    
    y <- paste0(y, "\n  SendEvent \"")
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

adjustLR <- function(x) {
  if (x > 0) {
    paste0("  SendEvent \"", paste(rep("d", x), collapse=''), "\"\n")
  } else
    if (x < 0) {
      paste0("  SendEvent \"", paste(rep("a", -x), collapse=''), "\"\n")
    }
}
if (F) {
  cat(adjustLR(5))
  cat(adjustLR(-3))
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
  cat("LR discrete", start, goal, "\n")
  stopifnot(length(start) == 1,
            length(goal)==1,
            start %in% discrete_values,
            goal %in%discrete_values)
  s2 <- which(start == discrete_values)
  g2 <- which(goal == discrete_values)
  print(c(s2,g2))
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
second_position_order <- c("C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "OF", "IF", "UTIL", "RP", "SP")


# KeyboardSimulator::keybd.press("shift+ctrl+1")

pitch_order <- c("Changeup", 'Curveball', 'Knuckleball',
                 'Screwball', 'Sinker', 'Slider',
                 'Splitter', '2-Seam Fastball',
                 'Cutter', 'Circle Change', 'Forkball',
                 'Knucklecurve', 'Palmball', 'Slurve')
