# itns-03 PICTURE DATA

library(shiny)
library(tidyverse)
library(DT)

df_laptop <- read_csv("Describe_Laptop.csv")
x = df_laptop$`Transcription%`

my_theme <- theme_light() +
    theme(plot.title = element_text(size = 10, face = "bold", hjust = 0.5)) +
    theme(plot.background = element_rect(color = NA, fill = NA)) +
    theme(plot.margin = margin(1, 0, 0, 0, unit = 'cm')) +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          plot.margin = margin(12, 12, 12, 12),
          plot.title = element_text(size = 14))


# Define UI for "Picture Data" app ----

ui <- fluidPage(
    titlePanel("Picture Data"),

    sidebarLayout(
        sidebarPanel(width = 4,
            conditionalPanel(
                'input.dataset === "Histogram"',
                helpText("This is help text for the histogram tab."),
                # Input: Slider for the number of bins ----
                sliderInput(inputId = "bins",
                            label = "Number of bins:",
                            min = 1,
                            max = 20,
                            value = 9
                ), # sliderinput
            ), # contionalPanel histogram

            conditionalPanel(
                'input.dataset === "Simple Dot Plot"',
                helpText("This is help text for the simple dot plot tab.")
            ), # contionalPanel simple dotplot

            conditionalPanel(
                'input.dataset === "Stacked Dot Plot"',
                helpText("This is help text for the stacked dot plot tab.")
            ), # contionalPanel stacked dotplot

            conditionalPanel(
                'input.dataset === "Summary"',
                helpText("This is help text for the summary tab.")
            ), # contionalPanel summary

            conditionalPanel(
                'input.dataset === "Table"',
                helpText("This is help text for the table tab.")
            ) # contionalPanel table

        ), #sidebarPanel

        mainPanel(width = 7,
            tabsetPanel(type = "tabs", selected = "Simple Dot Plot",
                id = 'dataset',

                tabPanel("Histogram",
                         br(),
                         plotOutput(outputId = "distPlot")
                ), # tabPanel Histogram

                tabPanel("Simple Dot Plot",
                         br(),
                         plotOutput(outputId = "simpleDotPlot")
                ), # tabPanel Dot Plot

                tabPanel("Stacked Dot Plot",
                         br(),
                         plotOutput(outputId = "stackedDotPlot")
                ), # tabPanel Stacked Dot Plot

                tabPanel("Summary",
                         fluidRow(br(),
                            column(3, verbatimTextOutput("summary"))
                         )
                ), # tabPanel Summary



                tabPanel("Table",
                         fluidRow(br(),
                             column(width = 5, DTOutput("table"), offset = 0)
                         )
                ) # tabPanel Table

            ) # tabsetPanel
        ) # mainPanel
    ) # sidebarPanel
) # fluidPage


################


# Define server logic required for "Picture Data" app ----
server <- function(input, output) {


        # Generate a histogram of the data ----
        output$distPlot <- renderPlot({


        x    <- df_laptop$`Transcription%`
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # if (input$myPanel == "distPlot") {

            hist(x, breaks = bins, col = "#75AADB", border = "white",
                 xlab = "X (Transcription in %)",
                 main = "Frequency histogram of verbatim transcription data in percent,
                 for the laptop group, with N = 31,
                 from Study 1 of Muellerand Oppenheimer (2014)"
                 ) # hist
        # } # endif

    })

    # Generate a stacked dotplot with rugs of the data ----
       output$stackedDotPlot <- renderPlot({

           ggplot(df_laptop, aes(x = df_laptop$`Transcription%`)) +
               geom_dotplot(method = "dotdensity",
                            binwidth = 1, # or 0.1 for simple dot plot
                            dotsize = 1, # or 10 for simple dot plot
                            stackratio = 1, # or 0.0 for a simple dot plot (not stacked)
                            fill = "#75AADB",
                            color = "#75AADB"
               ) +
               my_theme +
               scale_x_continuous("X (Transcription %)", breaks = seq(0, 36, 1)) +
               scale_y_continuous(NULL, breaks = NULL) +
               coord_fixed(ratio = 8, xlim = c(0,36), ylim = c(-.05, 1), expand = TRUE, clip = "on") +
               labs(title = "Stacked Dot Plot") +
               geom_rug(color = "red",
                        sides = "b",
                        length = unit(3, "mm"))
       })

       # Generate a simple dotplot with rugs of the data ----
       output$simpleDotPlot <- renderPlot({

           ggplot(df_laptop, aes(x = df_laptop$`Transcription%`)) +
               geom_dotplot(method = "dotdensity",
                            binwidth = 0.1, # or 1 for stacked dot plot
                            dotsize = 10, # or 1 for stacked dot plot
                            stackratio = 0.0, # or 1 for stacked dot plot
                            fill = "white",
                            stroke = 1.5,
                            color = "#75AADB"
               ) +
               my_theme +
               scale_x_continuous("X (Transcription %)", breaks = seq(0, 36, 1)) +
               scale_y_continuous(NULL, breaks = NULL) +
               coord_fixed(ratio = 8, # or 4 when height should be smaller
                           xlim = c(0,36),
                           ylim = c(-.05, 1), # or .012 when ratio = 4
                           expand = TRUE,
                           clip = "on") +
               labs(title = "Simple Dot Plot") +
               geom_rug(color = "red",
                        sides = "b",
                        length = unit(3, "mm"))
       })



    # Generate a summary of the data ----
    output$summary <- renderPrint({
        summary(df_laptop)
    })


    # Generate an HTML table view of the data ----
    output$table <- renderDT({
        df_laptop
    })


} # server

# Create Shiny app ----
shinyApp(ui = ui, server = server)
