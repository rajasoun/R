# Packages Used
# pryr - R Internals
# data.table- Reading Big Data
# tidyverse - Tidy Data
# knitr - cacahing 
# tictoc - Time the Execustion -

pkgs <- c("pryr", "data.table",  "tidyverse", "knitr" ,"tictoc", "psych")

# Install Packages
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)

# Turn on the cache for increased performance.
opts_chunk$set(tidy=TRUE, tidy.opts=list(blank=FALSE, width.cutoff=80), cache=TRUE)

# Set Working Directory For Data
setwd("~/Workspace/prototypes/data-science/data")
challenge_data <- "challengeData.tsv"
data_file <- "training_set.tsv"

# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.

tic("Using data.table Fread")
data.table.dataset <- fread(data_file, sep="\t", header=TRUE, stringsAsFactors = TRUE)
data.table.dataset_time <- toc()
dim(data.table.dataset)

mem_used()
object_size(data.table.dataset)

# rows & columsn without NA
data.table.dataset <- na.omit(data.table.dataset)
dim(dataset)

# Remove Duplicates if any
distinct_data = distinct(dataset)
dim(distinct_data)

# Tidy the Data [Meaningfull Column Names]
names(distinct_data) %<>%
  toupper() %>%
  str_replace_all("IBSA_MAIN_TRAINING_SET.", "")

# Understand The Data
colnames(distinct_data) # Names of teh Columns
glimpse(distinct_data)

# Understand The Data that is Numeric & Explore Options to Apply Filter
numeric_data <- select_if(distinct_data, is.numeric)
colnames(numeric_data) # Names of the Columns
glimpse(numeric_data)
dim(numeric_data)

numeric_dataset <- tbl_df(numeric_data)
glimpse(numeric_dataset)

# Identify the Mean of Contract Price to apply Filter
contract_price_summary <- summarise_at(numeric_data, vars(CONTRACT_LINE_NET_USD_AMOUNT), funs(n(), mean, sd))
productt_price_summary <- summarise_at(numeric_data, vars(PRODUCT_NET_PRICE), funs(n(),mean, sd))
contract_price_summary
productt_price_summary

# That is a lot of rows to process so to speed thing up 
# let's restrict data to contract line greater than  100 M
contract_amt <-c(127)
large_contracts  <- subset(distinct_data, CONTRACT_LINE_NET_USD_AMOUNT > contract_amt & PRODUCT_NET_PRICE > 806)
nrow(large_contracts)

#large_contracts_grouping <- group_by(distinct_data, COUNTRY, CUSTOMER_NAME)
#summary(large_contracts_grouping)

#Inspecting and Cleaning Data
head(distinct_data,10)

# Check Presence of Column Values with NA and Remove it 
na_count <-sapply(distinct_data, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count

# Example: Column is Removed from the DataFrame by setting its Data to Null
temp_data <- distinct_data
temp_data$SERVICE_PARTNER_INSTALLED_BASE_PARTNER_RENEWAL_RATE <- NULL
temp_data
dim(temp_data)

# Columns to Eliminate
# Correlated Columns, Not Used, No Values, Duplicates, 

# Let's Check the values using corrilation function, cor().  
# Closer to 1 =>  more correlate
# Correlation is Applicable to Numeric Columns Only 
colnames(distinct_data)
summarise(distinct_data, correlation = cor(SALES_HIERARCHY_LEVEL, SERVICE_SALES_NODE_BASE_SALES_HIERARCHY_LEVEL))
head(distinct_data,5)

