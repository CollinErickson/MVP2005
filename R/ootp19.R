# load ----
library(dplyr)
library(ggplot2)

# Read csv ----
# ootp19 <- readr::read_csv("C:\\Users\\colli\\OneDrive\\Documents\\Out of the Park Developments\\OOTP Baseball 19\\saved_games\\New Game.lg\\import_export\\mlb_rosters2.txt")
ootp19 <- readr::read_csv("./data/ootp25_mlb_rosters2.txt", skip = 0)

ootp19
ootp19$id %>% stringr::str_sub(1,2) %>% head

# Remove the team ID rows
ootp19 <- ootp19[stringr::str_sub(ootp19$id, 1, 2) != "//",]
ootp19
View(ootp19)
ootp19 %>% arrange(-Curveball)
ootp19 %>% arrange(-Slider)
ootp19$Position %>% table
ootp19$Stamina[ootp19$Position == 1] %>% hist
ootp19 %>% colnames()
ootp19 %>% arrange(-pmin(`Infield Range`, `OF Range`)) %>% relocate(`Infield Range`, `OF Range`)

# Begin MVP cols ----
# Add columns that will go into MVP. Preface them all with MVP_, this will be
# used to filter for later, and stripped
ootp19$MVP_First <- ootp19$FirstName
ootp19$MVP_Last <- ootp19$LastName
ootp19$`MVP_Birth Date` <- ootp19$DayOB
ootp19$`MVP_Birth Month` <- ootp19$MonthOB
ootp19$`MVP_Birth Year` <- ootp19$YearOB

ootp19$MVP_Throws <- c("R", "L")[ootp19$Throws]
ootp19$MVP_Bats <- c("R", "L", "S")[ootp19$Bats]

# facial_type ----
# 1: Black
# 2: Asian
# 3: Pacific islander
# 4: White
# 5: Hispanic
# MVP face
# 1-5: White
# 6-10: Intermediate
# 11-15: Black
ootp19 <- ootp19 %>% 
  mutate(MVP_Face=ifelse(
    facial_type == 1,
    sample(1:5, size=n(), replace=T),
    ifelse(
      facial_type <= 4,
      sample(6:10, size=n(), replace=T),
      sample(11:15, size=n(), replace=T)
      
    )
  )
  )

# MVP hair: pick based on race ----
# 1: black
# 2,3: blond
# 4: red
# 5: dark
# 6: black
# 7: white
ootp19 <- ootp19 %>% 
  mutate('MVP_Hair Color'=ifelse(
    facial_type == 1,
    sample(c(1,2,3,5,6), size=n(), replace=T),
    ifelse(
      facial_type <= 4,
      sample(c(1,5,6), size=n(), replace=T),
      sample(c(1,6), size=n(), replace=T)
      
    )
  )
  ) %>% 
  mutate('MVP_Body Type'=ifelse(
    
  ))

# Body type: ----
# It looks like ootp says `Weight (kg)` but is actually in LBs 
# lm(I(ootp19$`Weight (kg)`*2.204) ~ I(ootp19$`Height (cm)`/2.54))
# lm(I(ootp19$`Weight (kg)`) ~ I(ootp19$`Height (cm)`/2.54))
ootp19 <- ootp19 %>% 
  mutate(MVP_Height = round(`Height (cm)`/2.54),
         MVP_Weight = `Weight (kg)`) %>%
  mutate(
    pred_weight = 4.88*`Height (cm)`/2.54 - 166.74
  ) %>% mutate(
    "MVP_Body Type"=
      ifelse(
        `Weight (kg)` - pred_weight > 20, # Heavy for height
        "Heavy",
        ifelse(
          `Weight (kg)` - pred_weight < -20, # Light for height
          "Skinny", 
          "Athletic"
        )
      )
  )

# Positions ----
# Add Primary and Secondary position
# OOTP has 1-9. All pitchers are 1. Need to split them into RP/SP
# Changed from 2019 to 2025. No pitchers are 1. SP are 11, RP are 12/13.
ootp19$Position %>% table
ootp19 %>%
  filter( 
    Position > 10.5, 
    team_id>0
  ) %>% 
  ggplot(aes(
    Stamina,
    color=as.factor(`expected level`),
    group=as.factor(`expected level`))) +
  geom_density()
# Add positions now
ootp19 <- ootp19 %>% mutate(
  "MVP_First Position"=case_when(
    Position==11 &
      ((Stamina > 80 & `expected level`==1) |
         (Stamina > 70 & `expected level`==2) |
         (Stamina > 70 & `expected level`==3) |
         (Stamina > 65 & `expected level`==4) |
         (Stamina > 65 & `expected level`==5) |
         (Stamina > 65 & `expected level` > 5)) ~ 'SP',
    Position==12 ~ 'RP',
    Position==13 ~ 'RP',
    Position==2 ~ 'C',
    Position==3 ~ '1B',
    Position==4 ~ '2B',
    Position==5 ~ '3B',
    Position==6 ~ 'SS',
    Position==7 ~ 'LF',
    Position==8 ~ 'CF',
    Position==9 ~ 'RF',
    TRUE ~ 'ERROR'
  )
  # ) %>% select(Position, `MVP_First Position`) %>% table # to check
) %>% mutate(
  "MVP_Second Position"=case_when(
    Position==11 ~ '',
    Position==12 ~ '',
    Position==13 ~ '',
    Position==4 ~ 'SS',
    Position==5 ~ '1B',
    Position==6 ~ 'IF',
    Position==7 ~ 'OF',
    Position==8 ~ 'OF',
    Position==9 ~ 'OF',
    TRUE ~ ''
  )
  # ) %>% select(`MVP_First Position`, `MVP_Second Position`) %>% table # to check
)

# Look at some of these stat distributions
library(ggplot2)
ootp19 %>%
  filter(Position > 1.5, team_id>0) %>% 
  ggplot(aes(`Contact vL`, `Power vL`)) +
  geom_point() + facet_wrap(.~`expected level`)
ootp19 %>%
  filter(
    # Position > 1.5,
    # Position < 1.5, Slider>0 ,
    `expected level` == 1,
    team_id>0
  ) %>% 
  ggplot(aes(#`Contact vL`,
    # `Power vL`,
    # speed,
    # Velocity,
    `OF Range`, 
    # color=as.factor(`expected level`),
    # group=as.factor(`expected level`))) +
    color=as.factor(Position),
    group=as.factor(Position))) +
  geom_density()

# Maybe something like
# MLB 98%ile maps to 100
# MLB  5%ile maps to 60
# MLB 50%ile maps to 80

# Specify percentiles and where I want to map them to.
# Then 

# monreg for monotone regression: I had trouble with parameters when using OOTP data
x <- rnorm(100)
y <- x + rnorm(100)
mon1 <- monreg::monreg(x, y, hd = .5, hr = .5)
mon1
plot(mon1$t, mon1$estimation)
approxfun(mon1$t, mon1$estimation, rule = 2) %>% curve(-3,3)

# Combined defense stats
ootp19$`Combined Arm` <- with(
  ootp19,
  case_when(Position==2 ~ `Catcher Arm`,
            Position %in% c(7,8,9) ~ `OF Arm`,
            T ~ `Infield Arm`))
ootp19$`Combined Error` <- with(
  ootp19,
  case_when(Position==2 ~ CatcherAbil,
            Position  %in% c(7,8,9) ~ `OF Error`,
            T ~ `Infield Error`))
ootp19$`Combined Range` <- with(
  ootp19,
  case_when(Position==2 ~ CatcherAbil,
            Position  %in% c(7,8,9) ~ `OF Range`,
            T ~ `Infield Range`))

invert <- function(f,x, lower, upper) {
  fmin <- function(a) {(f(a) - x) ^ 2}
  optimize(f=fmin, lower=lower, upper=upper)
}
if (F) {
  invert(pnorm, .5, -10, 20)
  invert(pnorm, .975, -10, 10)
}

# statmap ----
statmap <- readr::read_csv("./data/MVP Baseball 2005 - Map OOTP to MVP - statmap - Map.csv", skip = 1)
statmap
View(statmap)
for (irow in 1:nrow(statmap)) {
  # irow <- 5
  mvpmin <- statmap$MVPmin[irow]
  mvpmax <- statmap$MVPmax[irow]
  ootpvals <- c()
  mvpvals <- c()
  weights <- c()
  # Map the OOTP stats to a processed stat (combines multiple stats)
  # Calculate mean and sd only using MLB/AAA/AA players from right position group,
  #  then normalize and add to processed stat
  ootp19$processedstat <- 0
  numrefstats <- 0 +
    as.integer(!is.na(statmap$OOTPStatName1[irow])) +
    as.integer(!is.na(statmap$OOTPStatName2[irow]) ) +
    as.integer(!is.na(statmap$OOTPStatName3[irow]) )
  if (numrefstats > 1.5) {
    for (istat in 1:3) {
      istatname <- statmap[[paste0("OOTPStatName", istat)]][irow]
      if (is.na(istatname)) {
        next
      }
      istatweight <- statmap[[paste0("OOTPWeight", istat)]][irow]
      iOOTPPitchType <- statmap$OOTPPitchType[irow]
      refvals <- ootp19 %>% 
        filter(`expected level` < 3.5, # MLB/AAA/AA
               team_id > 0,
               (statmap$StatType[irow]=="B") |
                 (statmap$StatType[irow]=="P" & Position > 10.5) |
                 (statmap$StatType[irow]=="H" & Position < 10.5) |
                 (statmap$StatType[irow]=="SP" & `MVP_First Position` == "SP") |
                 (statmap$StatType[irow]=="RP" & `MVP_First Position` == "RP")
               # is.na(iOOTPPitchType) | !!ensym(iOOTPPitchType) > 0 
        ) %>%
        {
          if (is.na(iOOTPPitchType)) {.} else{
            filter(., !!ensym(iOOTPPitchType) > 0)
          } 
        } %>% 
        .[[istatname]]
      refmean <- mean(refvals)
      refsd <- sd(refvals)
      ootp19$processedstat <- ootp19$processedstat + (ootp19[[istatname]] - refmean) / refsd
      
    }
  } else {
    istatname <- statmap[["OOTPStatName1"]][irow]
    stopifnot(!is.na(istatname))
    iweight <- if (!is.na(statmap[["OOTPWeight1"]][irow])) {
      statmap[["OOTPWeight1"]][irow]
    } else {1}
    ootp19$processedstat <- ootp19[[istatname]] * iweight
  }
  
  for (ilevel in 1:5) {
    level_quantile_map <- statmap[[paste0('Level', ilevel)]][irow]
    if (is.na(level_quantile_map)) {
      next
    }
    print(level_quantile_map)
    level_quantile_map_vals <- strsplit(level_quantile_map, ",")[[1]] %>%
      as.numeric
    stopifnot(length(level_quantile_map_vals) %% 2 == 0)
    npairs <- length(level_quantile_map_vals) / 2
    level_quantile_map_q <- level_quantile_map_vals[2*(1:npairs)-1]
    level_quantile_map_x <- level_quantile_map_vals[2*(1:npairs)]
    stopifnot(level_quantile_map_q > 0, level_quantile_map_q < 1)
    stopifnot(level_quantile_map_x >= mvpmin, level_quantile_map_x <= mvpmax)
    
    ootpstat <- ootp19 %>% 
      filter(`expected level` == ilevel, 
             team_id > 0,
             (statmap$StatType[irow]=="B") |
               (statmap$StatType[irow]=="P" & Position > 10.5) |
               (statmap$StatType[irow]=="H" & Position < 10.5) |
               (statmap$StatType[irow]=="SP" & `MVP_First Position` == "SP") |
               (statmap$StatType[irow]=="RP" & `MVP_First Position` == "RP")) %>%
               # .[[statmap$OOTPStatName1[irow]]]
               .[["processedstat"]]
             # ootpstat %>% hist
             
             ootpecdf <- ecdf(ootpstat)
             # curve(ootpecdf, min(ootpstat), max(ootpstat))
             for (ipair in 1:npairs) {
               invert_out <- invert(ootpecdf, level_quantile_map_q[ipair],
                                    min(ootpstat), max(ootpstat))
               # curve(ootpecdf, min(ootpstat), max(ootpstat))
               if (invert_out$objective > .01) {
                 browser()
                 warning(paste0("invert out objective bad", irow))
                 print(invert_out)
               }
               ootpval_ipair <- invert_out$minimum
               ootpvals <- c(ootpvals, ootpval_ipair)
               mvpvals <- c(mvpvals, level_quantile_map_x[ipair])
               weights <- c(weights, 1/ilevel) # 1 for MLB, 1/2 for AAA, 1/3 for AA, etc
               
             }
  }
  plot(ootpvals, mvpvals, cex=weights)
  
  # mon1 <- monreg::monreg(ootpvals, mvpvals, hd = 15, hr = .5)
  # mon1
  # points(mon1$t, mon1$estimation, col=2, type='l')
  # approxfun(mon1$t, mon1$estimation, rule = 2) %>% 
  #   curve(min(ootpvals), max(ootpvals))
  # cmspline <- demography::cm.spline(ootpvals, mvpvals)
  scammod <- scam::scam(mvpvals ~ s(ootpvals, bs='mpi',
                                    k=max(2,length(ootpvals) - 2)),
                        weights=weights)
  scampreds <- predict(scammod, 
                       data.frame(ootpvals=seq(min(ootpvals), 
                                               max(ootpvals), l=101))) %>% 
    as.vector %>% unname
  points(seq(min(ootpvals), max(ootpvals), l=101), scampreds, col=2, type='l')
  
  # Predict, round, and save stat
  ootp19[paste0("MVP_", statmap$MVPStatName[irow])] <- 
    predict(scammod, 
            # data.frame(ootpvals=ootp19[[statmap$OOTPStatName1[irow]]])) %>% 
            data.frame(ootpvals=ootp19$processedstat)) %>% 
    as.vector %>% unname %>% 
    pmax(mvpmin) %>% 
    pmin(mvpmax) %>% 
    {
      if (statmap$MVPIsDiscrete[irow]) {round_to_discrete(.)} else {round(.)}
    } %>% 
    { # Remove pitcher stats for batters
      if(statmap$StatType[irow]=="P" && !is.na(statmap$OOTPPitchType[irow])) {
        # browser()
        ifelse(ootp19$Position > 10.5 & ootp19[[statmap$OOTPPitchType[irow]]] >0, ., NA)
      } else if(statmap$StatType[irow]=="P") {
        ifelse(ootp19$Position < 10.5, NA, .)
      }
    }
} # End statmap loop

# plot(ootp19$`MVP_Power vs LHP`, ootp19$`MVP_Power vs RHP`)
# plot(ootp19$`Power vL`, ootp19$`Power vR`)

# Jersey number
ootp19['MVP_Jersey Number'] <- as.integer(pmin(pmax(ootp19$UniformNumber,0),99))

# Career potential
# TODO
FGdf %>% inner_join(peopledf %>% transmute(FGid=as.character(key_fangraphs),
                                           bbref_id=as.character(key_bbref)),
                    by=c(FGid="bbref_id"))

# Heatmaps
# TODO

# Add teams
ootp19_teammap <- ootp19 %>% select(team_id, `Team Name`) %>% distinct() %>%
  filter(team_id > 0) %>% mutate(isMLB=team_id<100) %>% 
  mutate(org_id=cumsum(isMLB)) %>% group_by(org_id) %>% 
  mutate("MLB Team Name" = `Team Name`[1], level_id=1:n())
ootp19 <- ootp19 %>% left_join(ootp19_teammap %>% select(-`Team Name`), by = c("team_id"))

# Assign to teams and orgs, pick which will be on roster vs left out
# TODO
ootp19 %>% 
  mutate(MVP_Overall)


# MVPdf ----
# Now prepare MVP df
MVPdf <- ootp19[,grepl("MVP_", colnames(ootp19))]
colnames(MVPdf) <- colnames(MVPdf) %>% substring(5, nchar(.))
MVPdf
View(MVPdf)

# Check some things
MVPdf$`Body Type` %>% table




