# itns-03 PICTURE DATA 2020-04-17

myPanelText = "Frequency histogram of verbatim transcription data in percent,
                 for the laptop group, with N = "
myPanelText1 = " from Study 1 of Mueller and Oppenheimer (2014)"

showObs = "Individual observations (rug 1-d plot)"


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
        sidebarPanel(width = 3,
             helpText(myPanelText,
                      textOutput("N", inline = TRUE),
                      myPanelText1,
                      hr(),
                      ), # helpText
             verbatimTextOutput("summary"),
             hr(),
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

             conditionalPanel(
                 'input.dataset === "Dot Plot"',
                 checkboxInput("ragValue",
                               label = strong(showObs), value = FALSE)
             ), # conditionalPanel Dot Plot

             conditionalPanel(
                 'input.dataset === "Histogram"',
                 checkboxInput("ragValue2",
                               label = strong(showObs), value = FALSE),
                 hr(),
                 sliderInputUI("bins1", "Number of bins: Histogram 1", value = 5),
                 sliderInputUI("bins2", "Number of bins: Histogram 2", value = 14),
                 hr(),
             ), # conditionalPanel histogram

        ), # sidebarPanel

        mainPanel(width = 9,
              tabsetPanel(type = "tabs", selected = "Histogram",
                          id = 'dataset',

                  tabPanel("Dot Plot",
                           fluidRow(br(),
                                column(3, DTOutput("dotPlotDT")),
                                column(9,
                                       br(),
                                       plotOutput("dotPlotSimple", height = 200),
                                       br(), br(),
                                       plotOutput("dotPlotStacked", height = 300),
                                ), # column 9
                          ), # fluidRow
                    ), # tabPanel Dot Plot

                  tabPanel("Histogram",
                           fluidRow(br(),
                                column(3, DTOutput("histPlotDT")),
                                column(9,
                                       br(),
                                       plotOutput("distPlot1", height = 350),
                                       br(), br(),
                                       plotOutput("distPlot2", height = 350),
                                ), # column 9
                           ), # fluidRow
                    ) # tabPanel Histogram

                ) # tabsetPanel
        ) # mainPanel
    ) # sidebarLayout
) # fluidPage


