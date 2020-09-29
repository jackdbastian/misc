# load required libraries
library(tidyverse)
library(rvest)

# the initial url
url <- "https://www.baseball-reference.com/teams/SFG"

# create all the addons to the url. the giants moved to san francisco in 1958
year <- 1958:2020

# create a list of the url's with the year added on and .shtml at the end
unitedata<- function(x){
  full_url <- paste0(url, "/",  x , ".shtml")
  full_url
}

finalurl <- unitedata(year)

# Defining the scraping function
BBRefScrape <- function(page){
  SB <- 
    page %>% 
      read_html() %>% 
      html_nodes("#team_batting tbody tr:nth-child(3) .right:nth-child(14)") %>% 
      html_text() 
  
  player_name <-
    page %>%
      read_html() %>%
      html_nodes("#team_batting tr:nth-child(3) a") %>%
      html_text()
  
  df <- tibble(player_name = player_name, SB = SB)
  
  df
}

# Using the scraping function to create a dataframe of SFG second baseman
SFG_2B <- tibble(year = year, map_df(finalurl, BBRefScrape))
