library(shiny)
library(tidyverse)

df_laptop <- read_csv("Describe_Laptop.csv")
laptop <- deframe(df_laptop) # covert tibble to vector

# Define UI for Picture Data app ----

ui <- fluidPage(
    # App title ----
    titlePanel("Picture Data"),

    # Sidebar layout with input and output definitions ----
    sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(

            # Input: Slider for the number of observations to generate ----
            sliderInput(inputId = "bins",
                        label = "Number of bins:",
                        min = 1,
                        max = 20,
                        value = 9)
        ), # sidebarPanel

        # Main panel for displaying outputs ----
        mainPanel(

            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(type = "pills",
                        tabPanel("Histogram", plotOutput(outputId = "distPlot")),
                        tabPanel("Dot Plot", plotOutput(outputId = "dotplot")),
                        tabPanel("Summary", verbatimTextOutput("summary")),
                        tabPanel("Table", tableOutput("table"))
            )
        )
    )
)

################


# Define server logic required to draw a histogram ----
server <- function(input, output) {

    # Histogram of the Old Faithful Geyser Data ----
    # with requested number of bins
    # This expression that generates a histogram is wrapped in a call
    # to renderPlot to indicate that:
    #
    # 1. It is "reactive" and therefore should be automatically
    #    re-executed when inputs (input$bins) change
    # 2. Its output type is a plot
    output$distPlot <- renderPlot({

        x    <- df_laptop$`Transcription%`
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        hist(x, breaks = bins, col = "#75AADB", border = "white",
             xlab = "X (Transcription in %)",
             main = "Frequency histogram of verbatim transcription data in percent,
             for the laptop group, with N = 31,
             from Study 1 of Muellerand Oppenheimer (2014)")

    })

    # Generate a dotplot of the data ----
       output$dotplot <- renderPlot({

           x    <- df_laptop$`Transcription%`
#          bins <- seq(min(x), max(x), length.out = input$bins + 1)

           ggplot(df_laptop, aes(x)) + geom_dotplot(binwidth = 1) + geom_rug()
           # hist(x, breaks = bins, col = "#75AADB", border = "white",
           #      xlab = "X (Transcription in %)",
           #      main = "Frequency histogram")

       })


    # Generate a summary of the data ----
    output$summary <- renderPrint({
        summary(df_laptop)
    })


    # Generate an HTML table view of the data ----
    output$table <- renderTable({
        df_laptop
    })


}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
