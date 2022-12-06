#   _____ _             _   _                        _ _   _       _____        _        
#  / ____| |           | | (_)                      (_| | | |     |  __ \      | |       
# | (___ | |_ __ _ _ __| |_ _ _ __   __ _  __      ___| |_| |__   | |  | | __ _| |_ __ _ 
#  \___ \| __/ _` | '__| __| | '_ \ / _` | \ \ /\ / | | __| '_ \  | |  | |/ _` | __/ _` |
#  ____) | || (_| | |  | |_| | | | | (_| |  \ V  V /| | |_| | | | | |__| | (_| | || (_| |
# |_____/ \__\__,_|_|   \__|_|_| |_|\__, |   \_/\_/ |_|\__|_| |_| |_____/ \__,_|\__\__,_|
#                                    __/ |                                               
#                                   |___/                                                
#
# Based on: https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Topic: Downloading, reading, and inspecting the data
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Lets download some data (make sure the data folder exists)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#load the tidyverse library
library(tidyverse)

# now we will read this "csv" into an R object called "surveys"
surveys <- read_csv("data_raw/portal_data_joined.csv")


# and take a look at it
head(surveys)
tail(surveys)
view(surveys)
     
# BTW, we assumed our data was comma separated, however this might not
# always be the case. So we may been to tell read.csv more about our file.



# So what kind of an R object is "surveys" ?
class(surveys)
# it is a data.frame


# ok - so what are dataframes ?
#grids made up of multiple column of information

str(surveys)

# --------------------
# Exercise/Challenge
# --------------------
#
# What is the class of the object surveys?
class(surveys)

# Answer:


# How many rows and how many columns are in this survey ?
#
# Answer: 34,786 rows x 13 columns


# Bonus functions 
names(surveys)
summary(surveys)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Topic: Sub-setting
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#data_frame[row, column]
# first element in the first column of the data frame (as a vector)
surveys[1, 1]

# first element in the 6th column (as a vector)
surveys[1, 6]

# first column of the data frame (as a vector)
surveys[, 1]

# first column of the data frame (as a data frame)
surveys$record_id

# first row (as a data frame)
surveys[1:10, ]

# first three elements in the 7th column (as a vector)
surveys[1:3, 7]

# the 3rd row of the data frame (as a data.frame)
surveys[3, ]

# equivalent to head(metadata)


# looking at the 1:6 more closely
1:6

# we also use other objects to specify the range
surveys[c(2, 4, 6),]

# We can omit (leave out) columns using '-'
surveys[, -1]


# --------------------
# Exercise/Challenge
# --------------------
#Using slicing, see if you can produce the same result as:
#
#   head(surveys)
#
# i.e., print just first 6 rows of the surveys dataframe
#
# Solution:
surveys[- (7:nrow(surveys)),]
surveys[1:6, ]

# column "names" can be used in place of the column numbers and $ operator to isolate
surveys["month"]
date1 <- surveys[c("month", "year")]

surveys[["spcies_id"]]
surveys$species_id           # $ is a quick way to look at vector and check your data 


# --------------------
# Exercise/Challenge
# --------------------

#Bonus functions:

# What's the average weight of survey animals
#
# Answer:
mean(surveys$weight)     # it doesn't work when there are 'NA' values
surveys$weight
mean(surveys$weight, na.rm=TRUE)

# Are there more Birds than Rodents ?
#
#
# Answer:
table(surveys$taxa)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Topic: Factors (for categorical data) ## convert to factors so R can 
# treat them as 'numbers' and group them properly.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

summary(surveys$sex)

#Turning characters into levels
surveys$sex <- factor(surveys$sex)
summary(surveys$sex)


# factors that have an order
temperature <-factor( c("hot", "cold", "hot", "warm"))
temperature
levels(temperature)  

# if you want to set the order you have to tell it
temperature <- factor(temperature, level=c("cold", "warm", "hot"))
levels(temperature)
nlevels(temperature)

# --------------------
# Exercise/Challenge
# --------------------
#   1. Change the columns taxa and genus in the surveys data frame into a factor.
#   2. Using the functions you learned before, can you find out…
#        a. How many rabbits were observed? 75
#        b. How many different genera are in the genus column? 26

summary(surveys$taxa)
surveys$taxa <- factor(surveys$taxa)
summary(surveys$taxa)

summary(surveys$genus)
surveys$genus <- factor(surveys$genus)
summary(surveys$genus)

nlevels(surveys$genus)

# Converting factors

year <- factor (c(1990, 1983, 1977, 1998, 1990))

# can be tricky if the levels are numbers
as.numeric(year)
as.character(year)
as.numeric(as.character(year))   #grouping them in a way that treats them like levels

# so does our survey data have any factors

# Renaming factors
summary(surveys)

plot(surveys$sex)
summary(surveys)

sex <- surveys$sex
sex <- addNA(sex)

levels(sex)
head(sex)

levels(sex)[3] <- "undetermined"  
levels(sex)[1] <- "female" 
levels(sex)[2] <- "male" 
levels(sex)
plot(sex)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Topic:  Dealing with Dates
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# R has a whole library for dealing with dates ...
library(lubridate)

my_date <- ymd ("2015-01-01")
str(my_date)
class(my_date)

# R can concatenated things together using paste()

my_date_2 <- ymd(paste("2015", "01", "26", sep="-"))


# 'sep' indicates the character to use to separate each component


# paste() also works for entire columns


# let's save the dates in a new column of our dataframe surveys$date 
surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep="-"))



# and ask summary() to summarise 
summary(surveys)


# but what about the "Warning: 129 failed to parse"

missing_date <- surveys[is.na(surveys$date), c("year", "month", "day")]
head(missing_date, 10)
