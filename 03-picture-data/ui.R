# itns-03 PICTURE DATA 2020-04-17

myPanelText = "Frequency histogram of verbatim transcription data in percent,
                 for the laptop group, with N = "
myPanelText1 = " from Study 1 of Mueller and Oppenheimer (2014)"


sliderInputUI <- function(id, label="Number of bins:", min=5, max=20, value=9) {
    sliderInput(
        id,
        label = label,
        min = min,
        max = max,
        value = value
    )
}



shinyUI <- fluidPage(

    singleton(
        tags$head(tags$script(src = "message-handler.js"))
    ),

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
                 checkboxInput("ragValue",
                               label = strong("Show individual observations"), value = FALSE)
             ), # conditionalPanel Dot Plot

             conditionalPanel(
                 'input.dataset === "Histogram"',
                 sliderInputUI("bins1", "Number of bins: Histogram 1", value = 5),
                 sliderInputUI("bins2", "Number of bins: Histogram 2", value = 14),
                 hr(),
                 checkboxInput("ragValue2",
                               label = strong("Show individual observations"), value = FALSE)
             ), # conditionalPanel histogram

             conditionalPanel(
                 'input.dataset === "Data"',
                 actionButton("add", "Add Row",
                              class = "btn btn-primary",
                              width = "100px"),
                 actionButton("delete", "Delete Row",
                              class = "btn btn-primary",
                              width = "100px"),
                 hr(),
                 actionButton("reset", "Reset",
                              class = "btn btn-warning",
                              width = "100px"),
                 hr(),
                verbatimTextOutput("summary")
             ), # conditionalPanel Data

        ), # sidebarPanel

        mainPanel(width = 8,
              tabsetPanel(type = "tabs", selected = "Histogram",
                          id = 'dataset',

                  tabPanel("Data",
                           fluidRow(br(),
                                    column(5, DTOutput("myDT")),
                           ) # fluidRow
                  ), # tabPanel Data

                  tabPanel("Dot Plot",
                           plotOutput("dotPlotSimple", height = 200),
                           br(), br(),
                           plotOutput("dotPlotStacked", height = 300),
                    ), # tabPanel Dot Plot

                  tabPanel("Histogram",
                           br(),
                           plotOutput("distPlot1", height = 350),
                           br(), br(),
                           plotOutput("distPlot2", height = 350)
                    ) # tabPanel Histogram

                ) # tabsetPanel
        ) # mainPanel
    ) # sidebarLayout
) # fluidPage


