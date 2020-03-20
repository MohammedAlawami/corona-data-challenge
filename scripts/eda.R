library(tidyverse)
library(magrittr)
library(leaflet)

total_confirmed <- read_csv('https://covid.ourworldindata.org/data/total_cases.csv')
total_deaths <- read_csv('https://covid.ourworldindata.org/data/total_deaths.csv')
new_confirmed <- read_csv('https://covid.ourworldindata.org/data/new_cases.csv')
new_deaths <- read_csv('https://covid.ourworldindata.org/data/new_deaths.csv')
full_dataset <- read_csv('https://covid.ourworldindata.org/data/full_data.csv')

total_confirmed %<>% 
  gather(key = 'country',
         value = 'total_confirmed',
         -date)

total_confirmed %>% 
  filter(country == 'World') %>% 
  ggplot(aes(date, total_confirmed)) +
  geom_line()
