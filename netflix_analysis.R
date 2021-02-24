# Install and load required packages

# Read data
## Base R
#read.csv("data/netflix_titles.csv", encoding = "UTF-8")

## readr
#install.packages("tidyverse")
#install.packages("lubridate")
#install.packages("readr")
#install.packages("ggplot2")
# library(readr) # Read from csv, txt, etc.
# library(ggplot2) # Charts/Plots
# library(tidyr)
# library(stringr) # Regex: Regular expressions

library(tidyverse) # readr, dplyr, tidyr, ggplot2
library(lubridate) # Date functions

netflix_titles <- read_csv("data/netflix_titles.csv")

# Count by type ---------------------------------
tbl <- netflix_titles %>% 
  group_by(type) %>% 
  count()

ggplot(tbl, aes(x = type, y = n)) +
  geom_col()

# Split cast ------------------------------------
strsplit(netflix_titles$cast, split = ", ")
netflix_cast <- netflix_titles %>% 
  select(show_id, cast) %>% 
  mutate(cast = strsplit(cast, split = ", ")) %>% 
  unnest(cols = "cast")
  
# Convert "date_added" to date type -------------
#?strptime
lubridate::mdy(netflix_titles$date_added)
readr::parse_date(netflix_titles$date_added, format = "%B %d, %Y")

netflix_titles <- netflix_titles %>% 
  mutate(date_added = readr::parse_date(date_added, format = "%B %d, %Y"))

## Why use dates?
today() - netflix_titles$date_added
year(netflix_titles$date_added)
month(netflix_titles$date_added)
day(netflix_titles$date_added)

## Year - Month
tbl <- netflix_titles %>% 
  transmute( # Keeps only these cols
    year = as.factor(year(date_added)),
    month = as.factor(month(date_added))
  ) %>% 
  filter(!is.na(month), !is.na(year)) %>% 
  group_by(year, month) %>% 
  count() %>% 
  complete(year, month, fill = list(n = 0))

ggplot(tbl, aes(x = year, y = month, fill = n)) +
  geom_tile(color = "white") +
  scale_fill_distiller(palette = "Oranges", direction = 1) +
  theme_minimal()

# Split duration into movie_length and no_of_seasons --------
netflix_titles <- netflix_titles %>% 
  mutate(
    no_of_seasons = as.numeric(str_extract(string = duration, pattern = "[0-9]+(?= Season)")),
    movie_length = as.numeric(str_extract(string = duration, pattern = "[0-9]+(?= min)")),
  )

mean(netflix_titles$movie_length, na.rm = TRUE)