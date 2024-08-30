suffixes <- c(0:9, letters[1:6])

for (i in suffixes) {
  download.file(
    paste0("https://raw.githubusercontent.com/chadwickbureau/register/master/data/people-",i,".csv"),
    paste0("./data/people/people-",i,".csv"))
  Sys.sleep(1)
}


playersdflist <- list()
for (i in suffixes) {
  playersdflist[[length(playersdflist)+1]] <- (
    
    readr::read_csv(paste0("./data/people/people-",i,".csv"))
  )
  playersdflist[[length(playersdflist)]]$key_npb <- as.character(
    playersdflist[[length(playersdflist)]]$key_npb
  )
}

playersdf <- bind_rows(playersdflist)

playersdf %>% filter(name_last=="Judge")

readr::write_csv(playersdf, "./data/people/people.csv")

peopledf <- readr::read_csv("./data/people/people.csv")
