## Wrangle csvs ready for dashboard
# Ben Day
# 2019/11/22

library(tidyverse)
library(purrr)

# Venues vector
venues <- c("edogawa", "tokyo", "nerima",
            "fuchu", "tsujido", "izu",
            "tokorozawa", "mobara", "sapporo")

# Years vector
years <- c("2015", "2016", "2017", "2018", "2019")

# Data columns
metrics <- data.frame(matrix(nrow = 6, ncol = 9))
metrics[,1] <- c(1, 2, 5, 8, 11, 13)
metrics[,2] <- c(1, 16, 19, 23, 26, 28)
metrics[,3] <- c(1, 31, 34, 37, 40, 42)
metrics[,4] <- c(1, 45, 48, 51, 54, 56)
metrics[,5] <- c(1, 59, 62, 65, 68, 70)
metrics[,6] <- c(1, 73, 76, 80, 83, 85)
metrics[,7] <- c(1, 88, 91, 94, 97, 99)
metrics[,8] <- c(1, 102, 105, 108, 111, 113)
metrics[,9] <- c(1, 116, 119, 123, 126, 128)


# -----------------------------------
# Wrap for loop through years vector around functions below
for (j in 1:5) {

  # Set working directory
  wdd <- paste0("C:/Users/bend/OneDrive - SportNZGroup/Documents/INTELLIGENCE/DATA PROJECTS/20181201 Environmental Report/environmental_report/data/Dashboard/", years[j])
  setwd(wdd)
  
  # Get filenames
  filenames = list.files(pattern="*.csv")
  
  # dataframe
  df <- data.frame(matrix(nrow = 0, ncol = 6))
  
  # Save filenames in a list and read.csvs
  for (k in 1:9) {
   
        df <- rbind(df, 
                    lapply(filenames, function(i) {   
                      
                     read.csv(i, header = FALSE, skip = 1) %>%
                       select(num_range("V", metrics[, k])) %>%
                       mutate_all(funs('as.character')) %>%
                       mutate(venue = venues[k]) %>%
                       slice(5:nrow(.)) %>%
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
# Tidy up: clear workspace and write file

wdd <- setwd("..")
wdd <- setwd("..")
write.csv(master, 
          paste0(wdd, "/", "venuedata_", years[1], "-", years[length(years)], ".csv"))
rm(list = ls())
