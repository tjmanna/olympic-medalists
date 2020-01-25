library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(dplyr)
library(googleVis)
library(tidyr)
library(ggthemes)
library(plotly)

MapChoice <- list('Global' = 'world', 
                  'North America' = '021',
                  'South America' = '005',
                  'Central America' = '013',
                  'Caribbean' = '029',
                  'Europe' = '150', 
                  'Africa' = '002', 
                  'Asia' = '142',
                  'Oceania' = '009')

rawdata <- read.csv('athlete_events.csv', stringsAsFactors = FALSE)
regionkey <- read.csv('noc_regions.csv', stringsAsFactors = FALSE)
regionadded <-left_join(rawdata, regionkey, by = 'NOC')
regionadded <- mutate(regionadded, Olympics = paste(regionadded$City, regionadded$Year))
regionadded$region <- replace(regionadded$region, regionadded$region == 'USA', 'United States' )
regionadded$region <- replace(regionadded$region, regionadded$region == 'UK', 'United Kingdom' )
medalsonly <- filter(regionadded, is.na(regionadded$Medal) == FALSE)
medalsonly <- replace_na(medalsonly, list(region = 'Singapore'))
byathlete <- medalsonly
byevent <- medalsonly %>%
  select(., Games, Year, Season, City, Sport, Event, Medal, region, Olympics) %>%
  distinct(.)

regionmedals <- byevent %>%
  group_by(., region) %>%
  summarise(., Gold = sum(Medal == 'Gold'), 
            Silver = sum(Medal == 'Silver'),
            Bronze = sum(Medal == 'Bronze'),
            Medalists = n())
regionmedals <- regionmedals %>%
  mutate(., Breakdown = paste0(regionmedals$region, ': ', 
                               regionmedals$Gold, ' Gold, ', 
                               regionmedals$Silver, ' Silver, ', 
                               regionmedals$Bronze, ' Bronze'))


regionmedalsbyyear <- byevent %>%
  group_by(., region, Year) %>%
  summarise(., Gold = sum(Medal == 'Gold'), 
            Silver = sum(Medal == 'Silver'),
            Bronze = sum(Medal == 'Bronze'),
            Medalists = n())

biobysportsex <- byathlete %>%
  group_by(., Sport, Sex) %>%
  summarise(., AvgWeight = mean(Weight, na.rm = TRUE), AvgHeight = mean(Height, na.rm = TRUE))

