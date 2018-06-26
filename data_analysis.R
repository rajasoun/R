# Packages Used
pkgs <- c("party","data.table", "Boruta","tidyverse")

# Install Packages
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)

# Datasets from Flat File
flight_data <- "dot_online_flight_data.csv"
path <- file.path("~/workspace/data-science","datasets", challenge_data) #Path To Data File

# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.
dataset <- fread(path,
                 sep = ",", #column seperator
                 header = TRUE, #first row is variable/column names - Default is False
                 showProgress = TRUE, 
                 stringsAsFactors = TRUE
)

# rows & columns
dim(original_data)

# rows & columsn without NA
dataset <- na.omit(original_data)
dim(dataset)

# Understand The Data
colnames(original_data) # Names of teh Columns

# That is a lot of rows to process so to speed thing up 
# let's restrict data to only flight between certain large airports
airports <-c('ATL','LAX', 'ORD', 'DFW', 'JFK', 'SFO', 'CLT', 'LAS', 'PHX')
flights_btw_large_airports  <- subset(original_data, DEST %in% airports & ORIGIN %in% airports)
nrow(flights_btw_large_airports)

summary(flights_btw_large_airports)
dim(flights_btw_large_airports)

# Take a Glimpse at the Data Frame
glimpse(flights_btw_large_airports)

# Tidy the Data [Meaningfull Column Names]
names(flights_btw_large_airports) %<>%
  toupper() %>%
  str_replace_all("_", ".")

glimpse(flights_btw_large_airports)

summarise(flights_btw_large_airports, correlation = cor(ORIGIN.AIRPORT.SEQ.ID, ORIGIN.AIRPORT.ID))
cor(flights_btw_large_airports[c("ORIGIN.AIRPORT.SEQ.ID", "ORIGIN.AIRPORT.ID")])
