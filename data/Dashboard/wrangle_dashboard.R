## Wrangle csvs ready for dashboard
# Ben Day
# 2019/11/22

library(tidyverse)

# Venues vector
venues <- c("edogawa", "tokyo", "nerima",
            "fuchu", "tsujido", "izu",
            "tokorozawa", "mobara", "sapporo")

# Years vector
years <- c("2015", "2016", "2017", "2018", "2019")


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
                   lapply(filenames,function(i){
                     read.csv(i, header=FALSE, skip=1) %>%
                       select(V1, V2, V5, V8, V11, V13) %>%
                       mutate(venue = venues[k]) %>%
                       slice(5:nrow(.))
                   }) %>% 
                     bind_rows())
    
    # Then combine into year dataframe
    ifelse(
      exists('master'), 
      master <- rbind(master, df),
      master <- df
    )
    
  }
  
}

# Column headers
colnames(master) <- c("datetime", "temperature",
                      "rainfall", "humidity", 
                      "wind speed", "wind direction",
                      "venue")


# --------------------------------------------
# Tidy up: clear workspace and write file

wdd <- setwd("..")
write.csv(master, 
          paste0(wdd, "/", "venuedata_", years[1], "-", years[length(years)], ".csv"))
rm(list = ls())
