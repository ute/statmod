# Statmod-GLM  uh
#
#
# transform dataset deadflies.csv into:
# 1. a dataset with one line per dose
# 2. a data set with one line per fly 

# doing it the tidyverse way, 
# and also checking out package here that promises to find all your files by 
# constructing the right path no matter if you run from the command line, or source the R file

library(tidyr)
library(dplyr)

# adjust this to your file structure
deadflies <- read.csv("data/deadflies.csv")

# 1. the dataset with one line per dose,
df_per_dose <- deadflies %>% 
  group_by(dose) %>%
  summarize(n_dead = sum(n_dead), 
            n_total = sum(n_flies)) %>%
  ungroup() %>%
  mutate(logdose = log(dose))

write.csv(df_per_dose, "deadflies_grouped.csv", row.names = FALSE)

# 2. dataset with one row for each fly, variables: dose, is_dead
df_per_fly <- rbind(
    df_per_dose %>% mutate(is_dead = 1, count = n_dead),
    df_per_dose %>% mutate(is_dead = 0, count = n_total - n_dead)
  ) %>%
  uncount(count) %>%
  select(dose, is_dead) %>%
  mutate(logdose = log(dose))

write.csv(df_per_fly, "deadflies_individual.csv", row.names = FALSE)
