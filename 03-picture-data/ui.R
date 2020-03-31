# itns-03 PICTURE DATA 31.3.2020

sliderInputUI <- function(id, label="Number of bins:", min=1, max=20, value=9) {
    sliderInput(
        id,
        label = label,
        min = min,
        max = max,
        value = value
    )
}


shinyUI <- fluidPage(
    titlePanel("Picture Data"),

    sidebarLayout(
        sidebarPanel(width = 4,

                     conditionalPanel(
                         'input.dataset === "Dot Plot"',
                         helpText(myPanelText, hr()),
                         checkboxInput("ragValue", label = "Rug (1-d plot)", value = FALSE),
                         fluidRow(column(3, verbatimTextOutput("value")))
                     ), # conditionalPanel compare


                     conditionalPanel(
                         'input.dataset === "Histogram"',
                         helpText(myPanelText, hr()),
                         sliderInputUI("bins1", "Number of bins: Histogram 1"),
                         sliderInputUI("bins2", "Number of bins: Histogram 2")
                     ), # conditionalPanel histogram

                     conditionalPanel(
                         'input.dataset === "Data"',
                         helpText(myPanelText, hr()),
                         actionButton("reset", "Reset",
                                      class = "btn btn-primary"),
                         br(),br(),
                         #                verbatimTextOutput(outputId = "cellData")
                     ), # conditionalPanel Data

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
                                                column(width = 5, DTOutput("laptopTable"), offset = 0),
                                                cat(file = stderr(), "Endlich!", "\n")
                                       )
                              ) # tabPanel Table
                  ) # tabsetPanel
        ) # mainPanel
    ) # sidebarLayout
) # fluidPage


