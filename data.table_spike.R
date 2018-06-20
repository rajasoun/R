#!/usr/bin/env Rscript

# Packages Used
# pryr - R Internals
# data.table - Reading Big Data
# tidyverse - Tidy Data
# tictoc - Time the Execustion -


pkgs <- c("pryr", "data.table", "tidyverse","tictoc")

# Packages Used
# pkgs <- c("party","Boruta","data.table", "knitr" ,"tictoc", "tidyverse","dplyr")

# Install Packages
for (pkg in pkgs) {
  if (!(pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)

# Set Working Directory For Data
getwd()
setwd("~/Workspace/prototypes/data-science/data")
# setwd("~/workspace/data-science/data")
challenge_data <- "challengeData.tsv"
data_file <- "training_set.tsv"

# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.

tic("Using data.table Fread")
dataset <- fread(challenge_data,
                            sep = "\t",
                            header = TRUE,
                            showProgress = TRUE,
                            stringsAsFactors = TRUE
)
toc()
dim(dataset)

# Tidy the Data [Meaningfull Column Names]
names(dataset) %<>%
  toupper() %>%
  str_replace_all("IBSA_MAIN_SMALL_TRAINING_SET.", "")

# Understand The Data
colnames(dataset) # Names of teh Columns
glimpse(dataset)

# Extract Columns Names based on Name Patterns
column_names <- names(dataset)
column_names

# Get Column Number given a Column Name
column_name <- "INSTALLATION_DATE"
column_number <- which( colnames(dataset) == column_name )
column_number



# Column Names Containing DATE
column_with_id <- column_names[grep("DATE",column.names,fixed=TRUE)]
column_with_id

# Get first 2 rows of the Data Frame
ans <- dataset[1:2]
head(ans)

# Get Unique Values for each Column in the Data Frame
for (i in 1:ncol(dataset)) {
  unique_col_values <- unique(dataset[, i, with=FALSE])
  print(unique_col_values)
}


unique(dataset[ , which( colnames(dataset) == "INSTALLATION_DATE" ), with = FALSE])

ans <- dataset[RENEWED_YORN == "Y" & INSTALLATION_DATE == 6L]

