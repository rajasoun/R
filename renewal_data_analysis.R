#!/usr/bin/env Rscript

# Clean Up Environment 
rm(list=ls())

# Packages Used
# pryr - R Internals
# data.table - Reading Big Data
# tidyverse - Tidy Data
# tictoc - Time the Execustion -

# OS Dependencies for tidyverse
# sudo apt-get install libcurl4-openssl-dev libxml2-dev

pkgs <- c("pryr", "data.table", "tidyverse","tictoc")
# pkgs <- c("party","Boruta","data.table", "knitr" ,"tictoc", "tidyverse","dplyr")

# Install Packages
for (pkg in pkgs) {
  if (!(pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)


# Datasets from Flat File
sample_data <- "sampleData.tsv"
challenge_data <- "challengeData.tsv"
training_data <- "training_set.tsv"
scoring_data <- "scoring_set.tsv"

path <- file.path("~/workspace/data-science",
                  "datasets", 
                  challenge_data) #Path To Data File

# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.

tic("Using data.table Fread")
dataset <- fread(path,
                      sep = "\t", #column seperator
                      header = TRUE, #first row is variable/column names - Default is False
                      showProgress = TRUE, 
                      stringsAsFactors = TRUE,
                      fill = TRUE #Fill with blank fields for rows with unequal length
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
column_with_id <- column_names[grep("DATE",column_names,fixed=TRUE)]
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

