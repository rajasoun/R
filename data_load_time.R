# Packages Used
# pryr - R Internals
# data.table- Reading Big Data
# tidyverse - Tidy Data
# 
# tictoc - Time the Execustion -

pkgs <- c("pryr", "data.table",  "tidyverse","tictoc")


# Packages Used
# pkgs <- c("party","Boruta","data.table", "knitr" ,"tictoc", "tidyverse","dplyr")

# Install Packages
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)

# Set Working Directory For Data
setwd("~/Workspace/prototypes/data-science/data")
challenge_data <- "challengeData.tsv"
data_file <- "training_set.tsv"

# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.
# original_data <- read.csv2("challengeData.tsv", sep="\t", header=TRUE, stringsAsFactors = TRUE)
# original_data <- read.table(file = 'sampleData.tsv', sep = '\t', header = TRUE, stringsAsFactors = TRUE)
# system.time(read.csv2("challengeData.tsv", sep="\t", header=TRUE, stringsAsFactors = TRUE))

# install.packages("data.table")
# library(data.table)
# system.time(fread("challengeData.tsv", sep="\t", header=TRUE, stringsAsFactors = TRUE)) 
# 
# install.packages("bigmemory")
# library(bigmemory)
# system.time(read.big.matrix("challengeData.tsv", sep="\t", header=TRUE, stringsAsFactors = TRUE))
# 
# install.packages("sqldf")
# library(sqldf)
# system.time(read.csv.sql("challengeData.tsv", sep="\t", header=TRUE, stringsAsFactors = TRUE))
# 
# install.packages("ff")
# library(ff)
# system.time(read.csv.ffdf(file = "challengeData.tsv", header = T, stringsAsFactors = TRUE))

tic("Using data.table Fread")
data.table.dataset <- fread(challenge_data, sep="\t", header=TRUE, stringsAsFactors = TRUE)
data.table.dataset_time <- toc()
dim(data.table.dataset)

# Remove Duplicates if any
distinct_data = distinct(data.table.dataset)

# rows & columns
dim(data.table.dataset)
dim(distinct_data)

# rows & columsn without NA
distinct_dataset <- na.omit(distinct_data)
dim(distinct_dataset)

# Understand The Data
colnames(distinct_dataset) # Names of the Columns
glimpse(distinct_dataset)

# Tidy the Data [Meaningfull Column Names]
names(distinct_dataset) %<>%
  toupper() %>%
  str_replace_all("IBSA_MAIN_SMALL_TRAINING_SET.", "")

colnames(distinct_dataset) # Names of the Columns
glimpse(distinct_dataset)

# Understand The Data that is Numeric & Explore Options to Apply Filter
numeric_data <- select_if(distinct_dataset, is.numeric)
colnames(numeric_data) # Names of the Columns
glimpse(numeric_data)
dim(numeric_data)

numeric_dataset <- tbl_df(numeric_data)
glimpse(numeric_dataset)

# Identify the Mean of Contract Price to apply Filter
contract_price_summary <- summarise_at(distinct_dataset, vars(CONTRACT_LINE_NET_USD_AMOUNT), funs(n(), mean, max, sd))
productt_price_summary <- summarise_at(distinct_dataset, vars(PRODUCT_NET_PRICE), funs(n(),min, max, median, sd))
contract_price_summary
productt_price_summary


# That is a lot of rows to process so to speed thing up 
# let's restrict data to contract line greater than  100 M
large_contracts <- filter(distinct_dataset, CONTRACT_LINE_NET_USD_AMOUNT > 125)
dim(large_contracts)

# OR

# That is a lot of rows to process so to speed thing up 
# let's restrict data to contract line greater than  100 M
contract_amt <-c(125)
large_contracts  <- subset(distinct_dataset, CONTRACT_LINE_NET_USD_AMOUNT > contract_amt )
dim(large_contracts)

# Identify the Mean of Contract Price to apply Filter
contract_price_summary <- summarise_at(large_contracts, vars(CONTRACT_LINE_NET_USD_AMOUNT), funs(n(), mean, sd))
productt_price_summary <- summarise_at(large_contracts, vars(PRODUCT_NET_PRICE), funs(n(), mean, sd))
contract_price_summary
productt_price_summary

#Inspecting and Cleaning Data
glimpse(distinct_dataset)

# Columns to Eliminate
# Correlated Columns, Not Used, No Values, Duplicates, 

# Check Presence of Column Values with NA and Remove it 
na_count <-sapply(distinct_dataset, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count

# Example: Column is Removed from the DataFrame by setting its Data to Null
temp_data <- distinct_dataset
temp_data$SERVICE_PARTNER_INSTALLED_BASE_PARTNER_RENEWAL_RATE <- NULL
temp_data
dim(temp_data)

# Let's Check the values using corrilation function, cor().  
# Closer to 1 =>  more correlate
# Correlation is Applicable to Numeric Columns Only 
colnames(numeric_data)
summarise(distinct_dataset, correlation = cor(SALES_HIERARCHY_LEVEL, SERVICE_SALES_NODE_BASE_SALES_HIERARCHY_LEVEL))

