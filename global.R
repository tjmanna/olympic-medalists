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
regionadded <- mutate(regionadded, Olympics = paste(regionadded$City, regionadded$Year)) # Olympic Games String
regionadded$region <- replace(regionadded$region, regionadded$region == 'USA', 'United States' ) #These required for geochart to recognize region column
regionadded$region <- replace(regionadded$region, regionadded$region == 'UK', 'United Kingdom' )
medalsonly <- filter(regionadded, is.na(regionadded$Medal) == FALSE) #medal winning rows only
medalsonly <- replace_na(medalsonly, list(region = 'Singapore')) #some Singapore region columns weren't generated
byathlete <- medalsonly
byevent <- medalsonly %>%
  select(., Games, Year, Season, City, Sport, Event, Medal, region, Olympics) %>%
  distinct(.) #creates unique medal winning rows to compare regions (in cases of team wins having multiple medalists, etc)

regionmedals <- byevent %>% #creating individual medal counts
  group_by(., region) %>%
  summarise(., Gold = sum(Medal == 'Gold'), 
            Silver = sum(Medal == 'Silver'),
            Bronze = sum(Medal == 'Bronze'),
            Medalists = n())
regionmedals <- regionmedals %>%
  mutate(., Breakdown = paste0(regionmedals$region, ': ', #creating hover text for geochart
                               regionmedals$Gold, ' Gold, ', 
                               regionmedals$Silver, ' Silver, ', 
                               regionmedals$Bronze, ' Bronze'))


regionmedalsbyyear <- byevent %>% #for the year slider
  group_by(., region, Year) %>%
  summarise(., Gold = sum(Medal == 'Gold'), 
            Silver = sum(Medal == 'Silver'),
            Bronze = sum(Medal == 'Bronze'),
            Medalists = n())



