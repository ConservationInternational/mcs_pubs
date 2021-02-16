library(tidyverse)
library(data.table)

d <- read_csv('MCS_publications_author_order.csv')
head(d)
d$Authorship_Type[d$Authorship_Type == 'First'] <- 'Senior'
d$Authorship_Type[d$Authorship_Type == 'Second'] <- 'Senior'
d$Authorship_Type[d$Authorship_Type == 'Other'] <- 'Contributing'
d %>%
    select(Matched_Author, Year, Authorship_Type) %>%
    group_by(Matched_Author, Year, Count=Authorship_Type) %>%
    summarise(Value=n()) -> d
d %>% full_join(
                group_by(d, Matched_Author, Year) %>%
                summarise(Value=sum(Value),
                          Count='Total')
                ) %>%
    arrange(Matched_Author, Year, Count) %>%
    filter(Year >= 2016)  -> d
dcast(setDT(d), Matched_Author ~ Year + Count, value.var = c('Value')) -> d
write_csv(d, 'MCS_publication_by_year_by_author_wide.csv', na='')
