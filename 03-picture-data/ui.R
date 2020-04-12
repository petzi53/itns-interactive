# itns-03 PICTURE DATA 2020-04-02

myPanelText = "Frequency histogram of verbatim transcription data in percent,
                 for the laptop group, with N = "
myPanelText1 = " from Study 1 of Mueller and Oppenheimer (2014)"


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
             helpText(myPanelText,
                      textOutput("N", inline = TRUE),
                      myPanelText1,
                      hr()
                      ),

             conditionalPanel(
                 'input.dataset === "Dot Plot"',
                 checkboxInput("ragValue", label = "Rug (1-d plot)", value = FALSE),
                 fluidRow(column(3, verbatimTextOutput("value")))
             ), # conditionalPanel compare


             conditionalPanel(
                 'input.dataset === "Histogram"',
                 sliderInputUI("bins1", "Number of bins: Histogram 1"),
                 sliderInputUI("bins2", "Number of bins: Histogram 2")
             ), # conditionalPanel histogram

             conditionalPanel(
                 'input.dataset === "Data"',
                 actionButton("reset", "Reset",
                              class = "btn btn-primary",
                              width = "100px"),
                 actionButton("add", "Add Row",
                              class = "btn btn-primary",
                              width = "100px"),
                 br(),br()
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
                                    column(5, DTOutput("myDT")),
                          ) # fluidRow
                        ) # tabPanel Data
                  ) # tabsetPanel
        ) # mainPanel
    ) # sidebarLayout
) # fluidPage


