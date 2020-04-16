# itns-03 PICTURE DATA 2020-04-13

# my usual packages
library(shiny)
library(tidyverse)
library(DT)

# my new packages
library(scales)
library(ggthemes)
library(cowplot)

# library(shinyjs)
# library(reactlog)
# library(gsheet)
# library(glue)
# library(itns)

# options(shiny.reactlog = TRUE)

myFillColor = "steelblue"
myBorderColor = "black"
myBorder = "white"

# my_theme <- theme_light() +
#     theme(plot.title = element_text(size = 10, face = "bold", hjust = 0.5)) +
#     theme(plot.background = element_rect(color = NA, fill = NA)) +
#     theme(plot.margin = margin(1, 0, 0, 0, unit = 'cm')) +
#     theme(panel.grid.major.x = element_blank(),
#           panel.grid.minor.x = element_blank(),
#           plot.margin = margin(12, 12, 12, 12),
#           plot.title = element_text(size = 14))
#
# userMessage <- function(msg, title = NULL,
#                         footer = modalButton("Dismiss"),
#                         size = c("m", "s", "l"),
#                         easyClose = TRUE,
#                         fade = TRUE) {
#     showModal(modalDialog(
#         msg,
#         title = title,
#         footer = footer,
#         size = size,
#         easyClose = easyClose,
#         fade = fade)
#     )
# }

########

df <- read_csv("Describe_Laptop.csv")
dataOrig <- df

# df <-
#   gsheet2tbl(
#  'https://docs.google.com/spreadsheets/d/1xzDqZv3jbDsUVND8wwza19rSiogDXBt6F6sVUNCZWKw/edit?usp=sharing')







