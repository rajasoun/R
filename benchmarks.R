# Packages Used
# pryr - R Internals
# data.table, sqldf, ff - Reading Big Data
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

# Datasets from Flat File
sample_data <- "sampleData.tsv"
challenge_data <- "challengeData.tsv"
training_data <- "training_set.tsv"
scoring_data <- "scoring_set.tsv"
flight_data <- "dot_ontime_flight_data.csv"

path <- file.path("~/workspace/data-science",
                  "datasets", 
                  flight_data) #Path To Data File



# Load Data Load the data into a data frame with columns and rows
# We specify the file path, separator, whether the CSV/tsv file's 1st row is clumn names,
# and how to treat strings.

tic("Using data.table Fread")
data.table.dataset <- fread(path,
                            sep = ",",
                            header = TRUE,
                            showProgress = TRUE,
                            stringsAsFactors = TRUE
)
toc()
dim(data.table.dataset)


tic()
csv2_data <- read.csv2(path,
                       sep = ",",
                       header = TRUE
                       )
toc()
dim(csv2_data)


tic()
sqldf_csv_data <- read.csv.sql(path,
                               sep = ",")
toc()
dim(sqldf_csv_data)


tic()
ff_csv_data <- read.table.ffdf(file = path,
                             sep = ",",
                             header = TRUE,
                             fill = TRUE,
                             quote = ""
                             )
toc()
dim(ff_csv_data)


## Package Selection Decisioon Record ###
# data.table Selected for Reading Very Big CSV/TSV Files based on Above Benchmarks - 20th Jun2 108 - Raja
