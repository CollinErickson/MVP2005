library(dplyr)

# MVPdf <- readr::read_csv("./data/MVP 2005 Baseball - 2024 Player ratings test - Players2024.csv")
# MVPdf <- readr::read_csv("./data/MVProsters/MVProsters_2024-09-17.csv")
csv_date <- '2026-03-17'
MVPdf <- readr::read_csv(paste0("./data/MVProsters/MVProsters_", csv_date,".csv"))
MVPdf

# df <- MVPdf %>% filter(First=='Chris', Last=='Sale')
# df <- MVPdf %>% filter(First=='Gerrit', Last=='Cole')

# Need to fix: I allowed DH as primary again, but that doesn't work in game
MVPdf <- MVPdf %>%
  mutate(`First Position`=ifelse(`First Position`=='DH',
                                 ifelse(First=='Ohtani', 'RF', '1B'),
                                 `First Position`))

