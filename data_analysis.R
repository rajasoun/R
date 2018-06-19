# Packages Used
pkgs <- c("party","Boruta","tidyverse")

# Install Packages
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)

# Set Working Directory For Data
setwd("~/Workspace/prototypes/data-science/data")

# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.
original_data <- read.csv2("dot_ontime_flight_data.csv", sep=",", header=TRUE, stringsAsFactors = TRUE)
#original_data <- read.table(file = 'sampleData.tsv', sep = '\t', header = TRUE, stringsAsFactors = TRUE)

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
