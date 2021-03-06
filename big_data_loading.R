# Packages Used
# pryr - R Internals
# data.table- Reading Big Data
# tidyverse - Tidy Data
# 
# tictoc - Time the Execustion -

pkgs <- c("pryr", "data.table",  "tidyverse","tictoc")

# Install Packages
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)


# Datasets from Flat File
sample_data <- "sampleData.tsv"
challenge_data <- "challengeData.tsv"
training_data <- "training_set.tsv"
scoring_data <- "scoring_set.tsv"

path <- file.path("~/workspace/data-science","datasets", challenge_data) #Path To Data File


# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.

tic("Using data.table Fread")
data.table.dataset <- fread(path, sep="\t", header=TRUE, stringsAsFactors = TRUE)
dim(data.table.dataset)
toc()

# Cleaning up rows & columns without NA
tic("Cleaning up rows & columns without NA")
data.table.dataset <- na.omit(data.table.dataset)
dim(data.table.dataset)
toc()

# Remove Duplicates if any
tic("Remove Duplicates if any")
data.table.dataset = distinct(data.table.dataset)
dim(data.table.dataset)
toc()


mem_used()
object_size(data.table.dataset)

# Tidy the Data [Meaningfull Column Names]
names(data.table.dataset) %<>%
  toupper() %>%
  str_replace_all("IBSA_MAIN_SMALL_TRAINING_SET.", "")

# Understand The Data
colnames(data.table.dataset) # Names of teh Columns
glimpse(data.table.dataset)

# Extract Columns Names based on Name Patterns
column.names <- names(data.table.dataset)
column.names
# Column Names Containing ID
column_with_id <- column.names[grep("ID",column.names,fixed=TRUE)]
column_with_id


# Getting Unique Values for a Column in a DataFrame
unique(data.table.dataset$RENEWED_YORN)
# Counting unique / distinct values by Columns of a Data Frame group in a data frame
data.table.dataset[, 
                   .(total = uniqueN(INNOVATION_CHALLENGE_KEY)), 
                   by = RENEWED_YORN
                  ]

# Just First Column with All rows
unique(data.table.dataset[, 2])

# Counting unique / distinct values in a data frame by Columns
n=20
factors_with_n_values = 0

for (i in 1:ncol(data.table.dataset)){
    unique_col_values <- unique(data.table.dataset[, i, with=FALSE])
    number_of_rows_in_column <- nrow((unique_col_values))
    if (number_of_rows_in_column < n) { 
      print(unique_col_values)
      factors_with_n_values <- factors_with_n_values + 1
    }
}
print(factors_with_n_values)

# Finding Correlations between Two Numeric Columns
with(data.table.dataset, cor(PRODUCT_NET_PRICE, CONTRACT_LINE_NET_USD_AMOUNT))


# Understand The Data that is Numeric & Explore Options to Apply Filter
numeric_data <- select_if(data.table.dataset, is.numeric)
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

