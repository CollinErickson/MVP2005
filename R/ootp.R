# load ----
library(dplyr)
library(ggplot2)

if (!exists('round_to_discrete')) {
  source("./r/helpers.R")
}

# Read csv ----
# ootpdf <- readr::read_csv("C:\\Users\\colli\\OneDrive\\Documents\\Out of the Park Developments\\OOTP Baseball 19\\saved_games\\New Game.lg\\import_export\\mlb_rosters2.txt")
ootpdf <- readr::read_csv("./data/OOTP/ootp25_mlb_rosters2_20240829.txt", skip = 0)

ootpdf
ootpdf$id %>% stringr::str_sub(1,2) %>% head

# Remove the team ID rows
ootpdf <- ootpdf[stringr::str_sub(ootpdf$id, 1, 2) != "//",]
ootpdf
# View(ootpdf)
ootpdf %>% arrange(-Curveball)
ootpdf %>% arrange(-Slider)
ootpdf$Position %>% table
# ootpdf$Stamina[ootpdf$Position == 1] %>% hist
ootpdf %>% colnames()
ootpdf %>% arrange(-pmin(`Infield Range`, `OF Range`)) %>% relocate(`Infield Range`, `OF Range`)

# Begin MVP cols ----
# Add columns that will go into MVP. Preface them all with MVP_, this will be
# used to filter for later, and stripped
ootpdf$MVP_First <- ootpdf$FirstName
ootpdf$MVP_Last <- ootpdf$LastName
ootpdf$`MVP_Birth Date` <- ootpdf$DayOB
ootpdf$`MVP_Birth Month` <- ootpdf$MonthOB
ootpdf$`MVP_Birth Year` <- ootpdf$YearOB

ootpdf$MVP_Throws <- c("R", "L")[ootpdf$Throws]
ootpdf$MVP_Bats <- c("R", "L", "S")[ootpdf$Bats]

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
ootpdf <- ootpdf %>% 
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
ootpdf <- ootpdf %>% 
  mutate('MVP_Hair Color'=ifelse(
    facial_type == 1,
    sample(c(1,2,3,5,6), size=n(), replace=T),
    ifelse(
      facial_type <= 4,
      sample(c(1,5,6), size=n(), replace=T),
      sample(c(1,6), size=n(), replace=T)
      
    )
  )
  )

# Body type: ----
# It looks like ootp says `Weight (kg)` but is actually in LBs 
# lm(I(ootpdf$`Weight (kg)`*2.204) ~ I(ootpdf$`Height (cm)`/2.54))
# lm(I(ootpdf$`Weight (kg)`) ~ I(ootpdf$`Height (cm)`/2.54))
ootpdf <- ootpdf %>% 
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
# Then OOTP added 0, which appears to be 2-way players. I'll make them all RP.
ootpdf$Position[ootpdf$Position == 0] <- 12
# Change Ohtani to be SP. 
ootpdf$Position[ootpdf$LastName=="Ohtani" & ootpdf$FirstName=='Shohei'] <- 11

ootpdf$Position %>% table
# ootpdf %>%
#   filter( 
#     Position < 1.5, 
#     team_id>0
#   ) %>% 
#   ggplot(aes(
#     Stamina,
#     color=as.factor(`expected level`),
#     group=as.factor(`expected level`))) +
#   geom_density()
# Add positions now
ootpdf <- ootpdf %>% mutate(
  "MVP_First Position"=case_when(
    Position==11 ~ 'SP', # &
    # ((Stamina > 80 & `expected level`==1) |
    #    (Stamina > 70 & `expected level`==2) |
    #    (Stamina > 70 & `expected level`==3) |
    #    (Stamina > 65 & `expected level`==4) |
    #    (Stamina > 65 & `expected level`==5) |
    #    (Stamina > 65 & `expected level` > 5)) ~ 'SP',
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
    Position==10 ~ '1B',
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

# Add orgs ----
ootpdf_MLB_teammap <- ootpdf %>% filter(`League Name` == "Major League Baseball") %>%
  select(team_id, `Team Name`, `League Name`) %>%
  distinct %>% 
  mutate(org_id=team_id)
stopifnot(nrow(ootpdf_MLB_teammap) == 30)

# stop('xxx fix teammap')
ootpdf_teammap <- ootpdf %>% select(team_id, `Team Name`, `League Name`) %>% 
  distinct() %>%
  filter(team_id > 0) %>% mutate(isMLB=`League Name` == 'Major League Baseball') %>% 
  mutate(org_id=cumsum(isMLB)) %>% group_by(org_id) %>% 
  mutate("MLB Team Name" = `Team Name`[1], level_id=1:n())

ootpdf <- ootpdf %>%
  left_join(ootpdf_teammap %>% select(-team_id, -`League Name`),
            by = c("Team Name"), 
            suffix = c('', '_teammap'))

# Stats ----
# Look at some of these stat distributions
library(ggplot2)
# ootpdf %>%
#   filter(Position > 1.5, team_id>0) %>% 
#   ggplot(aes(`Contact vL`, `Power vL`)) +
#   geom_point() + facet_wrap(.~`expected level`)
# ootpdf %>%
#   filter(
#     # Position > 1.5,
#     # Position < 1.5, Slider>0 ,
#     `expected level` == 1,
#     team_id>0
#   ) %>% 
#   ggplot(aes(#`Contact vL`,
#     # `Power vL`,
#     # speed,
#     # Velocity,
#     `OF Range`, 
#     # color=as.factor(`expected level`),
#     # group=as.factor(`expected level`))) +
#     color=as.factor(Position),
#     group=as.factor(Position))) +
#   geom_density()

# Maybe something like
# MLB 98%ile maps to 100
# MLB  5%ile maps to 60
# MLB 50%ile maps to 80

# Specify percentiles and where I want to map them to.
# Then 
if (F) {
  # monreg for monotone regression: I had trouble with parameters when using OOTP data
  x <- rnorm(100)
  y <- x + rnorm(100)
  mon1 <- monreg::monreg(x, y, hd = .5, hr = .5)
  mon1
  plot(mon1$t, mon1$estimation)
  approxfun(mon1$t, mon1$estimation, rule = 2) %>% curve(-3,3)
}

# Combined defense stats
ootpdf$`Combined Arm` <- with(
  ootpdf,
  case_when(Position==2 ~ `Catcher Arm`,
            Position %in% c(7,8,9) ~ `OF Arm`,
            T ~ `Infield Arm`))
ootpdf$`Combined Error` <- with(
  ootpdf,
  case_when(Position==2 ~ CatcherAbil,
            Position %in% c(7,8,9) ~ `OF Error`,
            T ~ `Infield Error`))
ootpdf$`Combined Range` <- with(
  ootpdf,
  case_when(Position==2 ~ CatcherAbil,
            Position %in% c(7,8,9) ~ `OF Range`,
            T ~ `Infield Range`))

invert <- function(f,x, lower, upper) {
  fmin <- function(a) {(f(a) - x) ^ 2}
  optimize(f=fmin, lower=lower, upper=upper, tol=1e-8)
}
if (F) {
  invert(pnorm, .5, -10, 20)
  invert(pnorm, .975, -10, 10)
}
invert_ecdf <- function(ecdf, y, from, to, n=20) {
  left <- from
  right <- to
  yleft <- ecdf(left)
  yright <- ecdf(right)
  # print(c(y, yleft))
  stopifnot(left <= right, yleft <= yright, y>=yleft, y<= yright)
  for (i in 1:n) {
    # print(c(left, right, yleft, yright))
    mid <- .5*(left + right)
    ymid <- ecdf(mid)
    if (ymid < y) {
      left <- mid
      yleft <- ymid
    } else {
      right <- mid
      yright <- ymid
      
    }
    # print(c(y, yleft))
    stopifnot(left <= right, yleft <= yright, y>=yleft, y<= yright)
  }
  list(minimum=.5*(left + right),
       objective=abs(y - .5*(yleft + yright)) ^ 2)
}



# statmap ----
statmap <- readr::read_csv("./data/MVP Baseball 2005 - Map OOTP to MVP - statmap - Map.csv", skip = 1)
statmap
# View(statmap)
for (irow in 1:nrow(statmap)) {
  cat("Starting statmap row irow=", irow, statmap$MVPStatName[irow], "\n")
  # Skip knuckleball now, gives error
  if (grepl("Knuckle", statmap$MVPStatName[irow])) {
    next
  }
  # irow <- 5
  mvpmin <- statmap$MVPmin[irow]
  mvpmax <- statmap$MVPmax[irow]
  ootpvals <- c()
  mvpvals <- c()
  weights <- c()
  # Map the OOTP stats to a processed stat (combines multiple stats)
  # Calculate mean and sd only using MLB/AAA/AA players from right position group,
  #  then normalize and add to processed stat
  ootpdf$processedstat <- 0
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
      refvals <- ootpdf %>% 
        filter(level_id < 3.5, # MLB/AAA/AA
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
      ootpdf$processedstat <- ootpdf$processedstat + (ootpdf[[istatname]] - refmean) / refsd
      
    }
  } else {
    istatname <- statmap[["OOTPStatName1"]][irow]
    stopifnot(!is.na(istatname))
    iweight <- if (!is.na(statmap[["OOTPWeight1"]][irow])) {
      statmap[["OOTPWeight1"]][irow]
    } else {1}
    ootpdf$processedstat <- ootpdf[[istatname]] * iweight
  }
  
  for (ilevel in 1:5) {
    level_quantile_map <- statmap[[paste0('Level', ilevel)]][irow]
    if (is.na(level_quantile_map)) {
      next
    }
    # print(level_quantile_map)
    level_quantile_map_vals <- strsplit(level_quantile_map, ",")[[1]] %>%
      as.numeric
    stopifnot(length(level_quantile_map_vals) %% 2 == 0)
    npairs <- length(level_quantile_map_vals) / 2
    level_quantile_map_q <- level_quantile_map_vals[2*(1:npairs)-1]
    level_quantile_map_x <- level_quantile_map_vals[2*(1:npairs)]
    stopifnot(level_quantile_map_q > 0, level_quantile_map_q < 1)
    stopifnot(level_quantile_map_x >= mvpmin, level_quantile_map_x <= mvpmax)
    
    ootpstat <- ootpdf %>% 
      filter(level_id == ilevel, 
             team_id > 0,
             (statmap$StatType[irow]=="B") |
               (statmap$StatType[irow]=="P" & Position > 10.5) |
               (statmap$StatType[irow]=="H" & Position < 10.5) |
               (statmap$StatType[irow]=="SP" & `MVP_First Position` == "SP") |
               (statmap$StatType[irow]=="RP" & `MVP_First Position` == "RP")) %>%
      # .[[statmap$OOTPStatName1[irow]]]
      .[["processedstat"]]
    # ootpstat %>% hist
    stopifnot(!all(is.na(ootpstat)))
    ootpecdf <- ecdf(ootpstat)
    # curve(ootpecdf, min(ootpstat), max(ootpstat))
    for (ipair in 1:npairs) {
      # invert_out <- invert(ootpecdf, level_quantile_map_q[ipair],
      #                      min(ootpstat), max(ootpstat))
      invert_out <- invert_ecdf(ootpecdf, level_quantile_map_q[ipair],
                                min(ootpstat)-.0001, max(ootpstat))
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
  for (iscam in 1:3) {
    try_scammod <- try({
      scammod <- scam::scam(mvpvals ~ s(ootpvals, bs='mpi',
                                        k=max(2,length(ootpvals) - 2 - (iscam-1))),
                            weights=weights)
    }, silent = T)
    if (!inherits(try_scammod, "try-error")) {
      break
    }
    if (iscam == 3) {
      stop("3 bad scams")
    }
  }
  scampreds <- predict(scammod, 
                       data.frame(ootpvals=seq(min(ootpvals), 
                                               max(ootpvals), l=101))) %>% 
    as.vector %>% unname
  points(seq(min(ootpvals), max(ootpvals), l=101), scampreds, col=2, type='l')
  
  noise <- if (is.na(statmap$Noise[irow])) {0} else {statmap$Noise[irow]}
  # Predict, round, and save stat
  ootpdf[paste0("MVP_", statmap$MVPStatName[irow])] <- 
    predict(scammod, 
            # data.frame(ootpvals=ootpdf[[statmap$OOTPStatName1[irow]]])) %>% 
            data.frame(ootpvals=ootpdf$processedstat)) %>% 
    as.vector %>% unname %>%
    {. + rnorm(length(.), 0, noise)} %>% 
    pmax(mvpmin) %>% 
    pmin(mvpmax) %>% 
    {
      if (statmap$MVPIsDiscrete[irow]) {round_to_discrete(.)} else {round(.)}
    } %>% 
    { # Remove pitcher stats for batters
      if(statmap$StatType[irow]=="P" && !is.na(statmap$OOTPPitchType[irow])) {
        # browser()
        ifelse(ootpdf$Position > 10.5 &
                 ootpdf[[statmap$OOTPPitchType[irow]]] > 0,
               ., NA)
      } else if(statmap$StatType[irow]=="P") {
        ifelse(ootpdf$Position < 10.5, NA, .)
      } else {
        .
      }
    }
} # End statmap loop

# plot(ootpdf$`MVP_Power vs LHP`, ootpdf$`MVP_Power vs RHP`)
# plot(ootpdf$`Power vL`, ootpdf$`Power vR`)

# Jersey number
ootpdf['MVP_Jersey Number'] <- as.integer(pmin(pmax(ootpdf$UniformNumber,0),99))

# Prospect ranking ----
# TODO
# if (!exists("FGdf")) {
#   source("./R/FGprospects.R")
# }
if (!exists('MLB_prospectsdf')) {
  MLB_prospectsdf <- readr::read_csv(file='./data/MLBprospects.csv')
}

if (!exists("peopledf")) {
  peopledf <- readr::read_csv("./data/people/people.csv")
}
# Very few FG IDs. Switch over to MLB prospect rankings
# FGdf %>% inner_join(peopledf %>% transmute(FGid=as.character(key_fangraphs),
#                                            bbref_id=as.character(key_bbref)),
#                     by=c(FGid="FGid"))
# Join to peopledf to get bbrefminors_id
MLB_prospectsdf2 <- MLB_prospectsdf %>%
  transmute(MLB_URL=URL, MLB_prospect_rank=rank, MLBID=as.character(MLBID)) %>% 
  inner_join(peopledf %>% transmute(MLBID=as.character(key_mlbam),
                                    bbref_id=as.character(key_bbref),
                                    bbrefminors_id=as.character(key_bbref_minors)),
             by=c(MLBID="MLBID")) #%>% pull(bbrefminors_id) %>% is.na %>% table
MLB_prospectsdf2
# Join that to ootpdf
# ootpdf %>% left_join(MLB_prospectsdf2 %>% select(-bbref_id), by='bbrefminors_id') %>% 
#   relocate(MLB_prospect_rank) %>% 
#   arrange(MLB_prospect_rank)
#
ootpdf <- ootpdf %>% 
  left_join(MLB_prospectsdf2 %>%
              select(-bbref_id), by='bbrefminors_id', suffix = c("","_MLBP"))

# Heatmaps
# TODO


# MVP OverallEst
ootpdf <- ootpdf %>% 
  mutate(MVP_Stamina=coalesce(`MVP_Stamina SP`, `MVP_Stamina RP`)) %>% 
  select(-`MVP_Stamina SP`, -`MVP_Stamina RP`) %>% 
  mutate(MVP_OverallEst=case_when(
    Position < 10.5 ~ (`MVP_Contact vs LHP`+`MVP_Contact vs RHP` +
                         `MVP_Power vs LHP`+`MVP_Power vs RHP` +
                         MVP_Speed)/5,
    Position > 10.5 ~ (ifelse(Position<11.5,MVP_Stamina, pmin(99,MVP_Stamina*100/60)) + `MVP_Fastball Control` + `MVP_Fastball Velocity` +
                         pmax(`MVP_Slider Control`, `MVP_Splitter Control`,
                              `MVP_Curveball Control`, `MVP_Sinker Control`,
                              `MVP_Changeup Control`, 0, na.rm=T) +
                         pmax(`MVP_Slider Movement`, `MVP_Splitter Movement`,
                              `MVP_Curveball Movement`, `MVP_Sinker Movement`,
                              `MVP_Changeup Movement`, 0, na.rm=T)) / 5,
    TRUE ~ NA
  ))# %>% arrange(-MVP_OverallEst) %>% 
# relocate(MVP_OverallEst, LastName, FirstName,
#          `MVP_Contact vs LHP`, `MVP_Contact vs RHP`,
#          `MVP_Power vs LHP`, `MVP_Power vs RHP`,
#          MVP_Speed, MVP_Stamina)

# Pick which to include ----
# Assign to teams and orgs, pick which will be on roster vs left out
# Keep all players at MLB or AAA, all players on top 30 prospects at least 18 yo
# TODO
ootpdf <- ootpdf %>% 
  group_by(org_id, IsPitcher=Position>10.5) %>% 
  arrange(MLB_prospect_rank, ifelse(level_id < 2.5, 0, 1), -MVP_OverallEst) %>% 
  mutate(MVP_include = 1:n() <= 50) %>% 
  arrange(ifelse(MVP_include,0,1), -MVP_OverallEst) %>% 
  mutate(MVP_org_position_rank=1:n()) %>% 
  ungroup
if (F) {
  ootpdf %>% group_by(org_id) %>% summarize(n(), sum(MVP_include)) %>% print(n=100)
  ootpdf %>%  filter(org_id==3, !IsPitcher) %>%
    relocate(MVP_OverallEst, MLB_prospect_rank, MVP_include, 
             MVP_org_position_rank, FirstName, LastName) %>% View
}
stopifnot(
  ootpdf %>% filter(team_id>0, MVP_include) %>% group_by(org_id) %>% 
    count %>% pull(n) == rep(100,30)
)
# Assign to teams ----
ootpdf <- ootpdf %>% 
  mutate(MVP_level_id = case_when(
    is.na(org_id) ~ NA, # Free agents
    MVP_org_position_rank <= 12 ~ 1,
    MVP_org_position_rank == 13 & !IsPitcher ~ 1,
    MVP_org_position_rank <= 25 ~ 2,
    MVP_org_position_rank <= 37 ~ 3,
    MVP_org_position_rank == 38 & !IsPitcher ~ 3,
    MVP_org_position_rank <= 50 ~ 4,
    T ~ NA # Not in top 100 of org
  ))
# ootpdf %>% with(table(MVP_level_id, useNA='always'))
stopifnot(ootpdf %>% filter(!is.na(MVP_level_id)) %>%
            group_by(MVP_org_id, MVP_level_id) %>%
            count %>% pull(n) %>% {.==25})


# Career potential ----
ootpdf <- ootpdf %>% mutate(MLB_prospect_rank2=coalesce(MLB_prospect_rank, 100)) %>% 
  mutate('MVP_Career Potential'=case_when(
    MLB_prospect_rank2 <=3  ~ 5,
    MLB_prospect_rank2 <=9  ~ 4,
    MLB_prospect_rank2 <=18 ~ 3,
    MLB_prospect_rank2 <=30 ~ 2,
    MVP_org_position_rank <=  2 ~ 5, # Twice as many (pitchers and batters)
    MVP_org_position_rank <=  5 ~ 4,
    MVP_org_position_rank <= 10 ~ 3,
    MVP_org_position_rank <= 20 ~ 2,
    TRUE ~ 1
  ))

ootpdf$MVP_org_id <- ootpdf$org_id

# Pitcher delivery ----
ootpdf$`MVP_Pitcher Delivery` <- ifelse(
  ootpdf$IsPitcher,
  sample(names(pitcher_delivery_options), nrow(ootpdf), T, pitcher_delivery_options),
  NA
)

# Batter stance ----
ootpdf$`MVP_Batter Stance` <- sample(
  names(batter_stance_options), nrow(ootpdf), T, batter_stance_options)

# Check number of pitches for pitchers. They need at least 2.
ootpdf <- ootpdf %>% 
  mutate(Npitches_ootp=(`Fastball (scale: 0-5)`>0) +
           (Changeup > 0) +
           (Curveball > 0) +
           (Knuckleball > 0) +
           (Screwball > 0) +
           (Sinker > 0) +
           (Slider > 0) +
           (Splitter > 0) +
           # No 2-seam
           (Cutter > 0) +
           (Circlechange > 0) +
           (Forkball > 0) + 
           (Knucklecurve > 0)
         # No palmball
         # Slurve
  ) %>% 
  mutate(Npitches_MVP= 0 + 
           as.integer(!is.na(`MVP_Fastball Control`)) +
           as.integer(!is.na(`MVP_Changeup Control`)) +
           as.integer(!is.na(`MVP_Curveball Control`)) +
           # !is.na() + No knuckleball
           # !is.na() + No Screwball
           as.integer(!is.na(`MVP_Sinker Control`)) +
           as.integer(!is.na(`MVP_Slider Control`)) +
           as.integer(!is.na(`MVP_Splitter Control`)) +
           # !is.na(MVP2s) + # No 2-seam
           as.integer(!is.na(`MVP_Cutter Control`)) +
           as.integer(!is.na(`MVP_Circle Change Control`))
         # !is.na(MVPfork) + # No forkball
         # !is.na(MVPkncur) + # No knucklecurve
         # !is.na(MVPpalm) + # No palmball
         # !is.na(MVPslu) + # No slurve
  )
ootpdf %>% 
  filter(IsPitcher) %>% with(table(Npitches_MVP, Npitches_ootp))
# Pitches with 1 MVP pitch (fastball), also get average changeup
ootpdf$`MVP_Changeup Control`[ootpdf$Npitches_MVP == 1] <- 50
ootpdf$`MVP_Changeup Movement`[ootpdf$Npitches_MVP == 1] <- 50
ootpdf$`MVP_Changeup Velocity`[ootpdf$Npitches_MVP == 1] <- 76
ootpdf$Npitches_MVP[ootpdf$Npitches_MVP == 1] <- 2

# MVPdf ----
# Now prepare MVP df
MVPdf <- ootpdf[,grepl("MVP_", colnames(ootpdf))]
colnames(MVPdf) <- colnames(MVPdf) %>% substring(5, nchar(.))
MVPdf
# View(MVPdf)

# Check some things
MVPdf$`Body Type` %>% table


# Write csv ----
if (F) {
  readr::write_csv(MVPdf, 
                   paste0("./data/MVProsters/MVProsters_", Sys.Date(), ".csv"))
}
