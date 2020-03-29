# itns-03 PICTURE DATA 28.3.2020

library(shiny)
library(tidyverse)
library(DT)
library(cowplot)

df_laptop <- read_csv("Describe_Laptop.csv")
# df_laptop <- rownames_to_column(df_laptop, "#")
# df_laptop$`#` <- as.integer(df_laptop$`#`)
# df_laptop <- remove_rownames(df_laptop)
x_laptop = df_laptop$`Transcription%`
N = length(x_laptop)
myFillColor = "steelblue"
myColor = "black"
myBorder = "white"
myPanelText = paste("Frequency histogram of verbatim transcription data in percent,
                 for the laptop group, with N =", N,
                 "from Study 1 of Mueller and Oppenheimer (2014)")

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
                 'input.dataset === "Dot Plot"',
                 helpText(myPanelText, hr()),
                 checkboxInput("ragValue", label = "Rug (1-d plot)", value = FALSE),
                 fluidRow(column(3, verbatimTextOutput("value")))
             ), # contionalPanel compare


            conditionalPanel(
                'input.dataset === "Histogram"',
                helpText(myPanelText, hr()),
                # Input: Slider for the number of bins ----
                sliderInput(inputId = "bins1",
                            label = "Number of bins: Histogram 1",
                            min = 1,
                            max = 20,
                            value = 9
                ), # sliderinput first histogram top

                sliderInput(inputId = "bins2",
                            label = "Number of bins: Histogram 2",
                            min = 1,
                            max = 20,
                            value = 9
                ) # sliderinput second histogram
            ), # contionalPanel histogram

            conditionalPanel(
                'input.dataset === "Data"',
                helpText(myPanelText, hr())
            ), # contionalPanel table

            verbatimTextOutput("summary")
        ), # sidebarPanel

        mainPanel(width = 8,
            tabsetPanel(type = "tabs", selected = "Data",
                id = 'dataset',

                tabPanel("Dot Plot",
                         br(),
                         plotOutput(outputId = "twoDotPlots")
                ), # tabPanel Dot Plot

                tabPanel("Histogram",
                         br(),
                         plotOutput(outputId = "distPlot1"),
                         plotOutput(outputId = "distPlot2")
                ), # tabPanel Histogram

                tabPanel("Data",
                         fluidRow(br(),
                             column(width = 5, dataTableOutput("table"), offset = 0)
                         )
                ) # tabPanel Table
           ) # tabsetPanel
        ) # mainPanel
    ) # sidebarLayout
) # fluidPage


################


# Define server logic required for "Picture Data" app ----
server <- function(input, output) {


        # Generate a histogram of the data ----
        output$distPlot1 <- renderPlot({

        bins1 <- seq(min(x_laptop), max(x_laptop), length.out = input$bins1 + 1)

        hist(x_laptop, breaks = bins1, col = "steelblue", border = myBorder,
             xlab = "X (Transcription in %)",
             main = "Histogram 1"
             ) # hist
        }) # distPlot1

        # Generate the second histogram of the data ----
        output$distPlot2 <- renderPlot({

            bins2 <- seq(min(x_laptop), max(x_laptop), length.out = input$bins2 + 1)

            hist(x_laptop, breaks = bins2, col = "steelblue", border = myBorder,
                 xlab = "X (Transcription in %)",
                 main = "Histogram 2"
            ) # hist
        }) # distPlot2

################### Generate dotplots #####################

        # factor out the same parts for both variants
        myDotPlot <-
            ggplot(df_laptop, aes(x = `Transcription%`)) +
            my_theme +
            scale_x_continuous("X (Transcription %)", breaks = seq(0, N, 1)) +
            scale_y_continuous(NULL, breaks = NULL)

        rugPlot <- geom_rug(color = "red",
                            sides = "b",
                            length = unit(3, "mm"))


        # Generate a simple dotplot with rugs of the data ----
        simpleDotPlot <-
            myDotPlot +
            labs(title = "Simple Dot Plot") +
            geom_dotplot(method = "dotdensity",
                 binwidth = 0.1, # or 1 for stacked dot plot
                 dotsize = 10, # or 1 for stacked dot plot
                 stackratio = 0, # or or 1 for stacked dot plot
                 fill = myFillColor,
                 color = myColor
            )


        # Generate a stacked dotplot with rugs of the data ----
        stackedDotPlot <-
            myDotPlot +
            labs(title = "Stacked Dot Plot") +
            geom_dotplot(method = "dotdensity",
                 binwidth = 1, # or 0.1 for simple dot plot
                 dotsize = 1, # or 10 for simple dot plot
                 stackratio = 1, # or 0.0 for a simple dot plot (not stacked)
                 fill = myFillColor,
                 color = myColor
            )

        re_stackedDotPlot <- reactive({
            if (input$ragValue) { stackedDotPlot + rugPlot }
            else {stackedDotPlot + NULL}
        })

        re_simpleDotPlot <- reactive({
            if (input$ragValue) { simpleDotPlot + rugPlot }
            else {simpleDotPlot + NULL}
        })


        # put the two dotplots vartically together
        # using package `cowplot`
        re_plots <- reactive({
            plots <- list(re_simpleDotPlot(), re_stackedDotPlot())
            grobs <- lapply(plots, as_grob)
            plot_widths <- lapply(grobs, function(x) {x$widths})

            # Aligning the left an right margins of all plots
            aligned_widths <- align_margin(plot_widths, "first")
            aligned_widths <- align_margin(aligned_widths, "last")

            # Setting the dimensions of plots to the aligned dimensions
            for (i in seq_along(plots)) {
                grobs[[i]]$widths <- aligned_widths[[i]]
            }

            # Draw aligned plots
            plot_grid(plotlist = grobs, ncol = 1)
        })

        output$twoDotPlots <- renderPlot({
            re_plots()
        })



    # Generate a summary of the data ----
    output$summary <- renderPrint({
        summary(df_laptop)
    })


    # Generate an HTML table view of the data ----
    output$table <- renderDataTable({
        df_laptop
    })





} # server

# Create Shiny app ----
shinyApp(ui = ui, server = server)
