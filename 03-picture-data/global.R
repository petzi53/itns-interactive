# itns-03 PICTURE DATA 2020-04-17

# my usual packages
library(shiny)
library(tidyverse)
library(DT)


# first time use packages
library(scales)
library(cowplot)
library(ggthemes)


# library(shinyjs)
# library(reactlog)
# library(gsheet)
# library(glue)
# library(itns)

# options(shiny.reactlog = TRUE)

myFillColor = "steelblue"
myBorderColor = "black"

########

df <- read_csv("Describe_Laptop.csv")
dataOrig <- df

# df <-
#   gsheet2tbl(
#  'https://docs.google.com/spreadsheets/d/1xzDqZv3jbDsUVND8wwza19rSiogDXBt6F6sVUNCZWKw/edit?usp=sharing')







