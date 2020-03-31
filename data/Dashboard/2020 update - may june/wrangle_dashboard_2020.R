## Wrangle csvs ready for dashboard
# Ben Day
# 2019/11/22

library(tidyverse)
library(purrr)

# Venues vector
venues <- c("tsujido", "edogawa", "tokyo",
            "nerima", "fuchu", "tokorozawa",
            "sapporo", "izu", "mobara")

# Years vector
years <- c("2015", "2016", "2017", "2018", "2019")

# Data columns
metrics <- data.frame(matrix(nrow = 6, ncol = 9))
metrics[,1] <- c(1, 2, 5, 8, 11, 13)
metrics[,2] <- c(1, 16, 19, 22, 25, 27)
metrics[,3] <- c(1, 30, 33, 37, 40, 42) #
metrics[,4] <- c(1, 45, 48, 51, 54, 56)
metrics[,5] <- c(1, 59, 62, 65, 68, 70)
metrics[,6] <- c(1, 73, 76, 79, 82, 84)
metrics[,7] <- c(1, 87, 90, 94, 97, 99) #
metrics[,8] <- c(1, 102, 105, 109, 112, 114)
metrics[,9] <- c(1, 117, 120, 123, 126, 128) #


# -----------------------------------
# Wrap for loop through years vector around functions below
for (j in 1:5) {

  # Set working directory
  wdd <- paste0("C:/Users/bend/OneDrive - SportNZGroup/Documents/INTELLIGENCE/DATA PROJECTS/20181201 Environmental Report/environmental_report/data/Dashboard/2020 update - may june/", years[j])
  setwd(wdd)
  
  ## Get filenames
  filenames = list.files(wdd, "*.csv")
  
  # dataframe
  df <- data.frame(matrix(nrow = 0, ncol = 6))
  
  # Save filenames in a list and read.csvs
  for (k in 1:9) {    # 9 venues
   
    df <- rbind(df, 
                lapply(filenames, function(i) {
                  read.csv(i, header = FALSE, skip = 6) %>%
                  select(num_range("V", metrics[, k])) %>%
                  mutate_all(funs('as.character')) %>%
                  mutate(venue = venues[k]) %>%
                  #slice(5:nrow(.)) %>%
                  setNames(nm = c('datetime', 'temperature',
                      'rainfall', 'humidity',
                      'wind speed', "wind direction",
                      'venue'))
                   }) %>%
                bind_rows())

  }

  # Then combine into year dataframe
  ifelse(
    exists('master'), 
    master <- rbind(master, df),
    master <- df
  )
    
}

# --------------------------------------------
# Read in previous data (July-Sept)
wdd <- setwd("..")
wdd <- setwd("..")
prev <- read.csv("venuedata_2015-2019.csv") %>% 
  select(-X)
names(prev) <- names(master)

# Merge
combined <- rbind(prev, master)
combined[is.na(combined)] <- ""



# --------------------------------------------
# Quality assurance
# Estimate number of records
24*30*4*5*9  # 24 hours * 30 days * 4 months * 5 years * 9 venues
dups <- combined[duplicated(combined) == TRUE,]



# --------------------------------------------
# Tidy up: clear workspace and write file
wdd <- setwd("..")
write.csv(combined, 
          paste0(wdd, "/", "venuedata_combined_", years[1], "-", years[length(years)], ".csv"))
rm(list = ls())


