library(shiny)
library(tidyverse)
library(DT)
library(cowplot)

my_theme <- theme_light() +
    theme(plot.title = element_text(size = 10, face = "bold", hjust = 0.5)) +
    theme(plot.background = element_rect(color = NA, fill = NA)) +
    theme(plot.margin = margin(1, 0, 0, 0, unit = 'cm')) +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          plot.margin = margin(12, 12, 12, 12),
          plot.title = element_text(size = 14))

df_laptop <- read_csv("Describe_Laptop.csv")
x_laptop = df_laptop$`Transcription%`
dt_laptop <- datatable(df_laptop,
                       editable = list(target = 'cell', disable = list(columns = 0))) %>%
    formatRound(columns = 'Transcription%', digits = 2)

myFillColor = "steelblue"
myColor = "black"
myBorder = "white"

myPanelText = paste("Frequency histogram of verbatim transcription data in percent,
                 for the laptop group, with N =", length(x_laptop),
                    "from Study 1 of Mueller and Oppenheimer (2014)")
