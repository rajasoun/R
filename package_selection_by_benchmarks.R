# Packages Used
# pryr - R Internals
# data.table, bigmemory, sqldf, ff - Reading Big Data
# tidyverse - Tidy Data
# tictoc - Time the Execustion -


pkgs <- c("pryr", "data.table", "bigmemory", "sqldf", "ff", "tidyverse","tictoc")

# Packages Used
# pkgs <- c("party","Boruta","data.table", "knitr" ,"tictoc", "tidyverse","dplyr")

# Install Packages
for (pkg in pkgs) {
  if (!(pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Load Packages
lapply(pkgs, library, character.only = TRUE)

# Set Working Directory For Data
# setwd("~/Workspace/prototypes/data-science/data")
getwd()
setwd("~/workspace/data-science/data")
challenge_data <- "sampleData.tsv"
data_file <- "training_set.tsv"

# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.

tic("Using data.table Fread")
data.table.dataset <- fread(challenge_data,
                            sep = "\t",
                            header = TRUE,
                            showProgress = TRUE,
                            stringsAsFactors = TRUE
)
toc()
dim(data.table.dataset)


tic()
csv2_data <- read.csv2(challenge_data,
                       sep = "\t",
                       header = TRUE
                       )
toc()
dim(csv2_data)


tic()
big_memory <- read.big.matrix(challenge_data,
                              sep = "\t",
                              header = TRUE
                              )
toc()
dim(big_memory)

tic()
sqldf_csv_data <- read.csv.sql(challenge_data,
                               sep = "\t")
toc()
dim(sqldf_csv_data)


tic()
ff_csv_data <- read.table.ffdf(file = challenge_data,
                             sep = "\t",
                             header = TRUE,
                             fill = TRUE
                             )
toc()
dim(ff_csv_data)


## Package Selection Decisioon Record ###
# data.table Selected for Reading Very Big CSV/TSV Files based on Above Benchmarks - 20th Jun2 108 - Raja
