# Data.frame

## Filter by index
mtcars[1:3, 2:3]
mtcars[1:5, ] # 1-5. row
mtcars[, 1:3] # 1-3. column

## Filter by names
colnames(mtcars)
rownames(mtcars)

mtcars["Mazda RX4", ]
mtcars[, "mpg"]
mtcars[, c("mpg", "cyl")]

## Filter by logical vector
mtcars[mtcars$cyl == 6, ]

# dplyr (tidyverse)
install.packages("dplyr")
library(dplyr)

# Main verbs
mtcars %>% # CTRL+SHIFT+M -> Pipe operator
  select(mpg, cyl) %>%  # Select columns
  filter(cyl %in% c(4, 6)) %>%  # Filter rows
  mutate(
    x = 1, 
    y = mpg + cyl
  ) %>%  # Create new columns
  group_by(cyl) %>% # Grouping
  summarise( # Aggregation
    mean_mpg = mean(mpg),
    sum = sum(mpg)
  ) %>% 
  arrange(desc(mean_mpg)) # Sorting

mutate(filter(select(mtcars, mpg, cyl), cyl %in% c(4, 6)), x = 1, y = mpg + cyl)

## Equivalent to previous code
tmp1 <- select(mtcars, mpg, cyl)
tmp2 <- filter(tmp1, cyl %in% c(4, 6))
tmp3 <- mutate(tmp2, x = 1, y = mpg + cyl)

