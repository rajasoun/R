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
# setwd("~/Workspace/prototypes/data-science/data")
getwd()
setwd("~/workspace/data-science/data")
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

# get first 2 rows of the Data Frame
ans <- dataset[1:2]
head(ans)

ans <- dataset[,ibsa_main_small_training_set.instance_status]
ans

for (i in 1:ncol(dataset)) {
  unique_col_values <- unique(dataset[, i, with=FALSE])
  print(unique_col_values)
}
