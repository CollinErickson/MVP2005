# Find duplicates, remove, update the rank, rewrite MVPdf
dupes <- MVPdf$bbrefminors_id %>% duplicated
summary(dupes)

# Check that fails
stopifnot(!(MVPdf$bbrefminors_id %>% anyDuplicated))

MVPdf %>% filter(dupes) %>% pull(org_position_create_rank)

newMVPdf <- MVPdf %>% 
  filter(!dupes) %>% 
  group_by(org_id, `First Position` %in% c('SP', 'RP')) %>% 
  arrange(org_position_create_rank) %>% 
  mutate(new_org_position_create_rank=1:n()) %>% 
  ungroup
newMVPdf %>%
  select(org_position_create_rank, new_org_position_create_rank) %>% 
  group_by(org_position_create_rank, new_org_position_create_rank) %>% 
  summarize(N=n()) %>% 
  mutate(diff=org_position_create_rank - new_org_position_create_rank)

# Do the replacement
MVPdf <- MVPdf %>% 
  filter(!dupes) %>% 
  group_by(org_id, `First Position` %in% c('SP', 'RP')) %>% 
  arrange(org_position_create_rank) %>% 
  mutate(org_position_create_rank=1:n()) %>% 
  ungroup

# Write the replacement
readr::write_csv(MVPdf, "./data/MVProsters/MVProsters_2025-04-11.csv")
