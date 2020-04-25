# itns-03 PICTURE DATA 2020-04-20

myPanelText = glue::glue("Frequency histogram of verbatim transcription data in percent,
                   for the laptop group, with N = ", {nrow(df)},
                   " from Study 1 of Mueller and Oppenheimer (2014)")

showObs = "Individual observations"

shinyFeedback::snackbar("valueNotChanged",
                        "Only numbers allowed",
                        style = "background-color: orange; color: white;")


shinyUI <- fluidPage(

    shinyjs::useShinyjs(),
    shinyFeedback::useShinyFeedback(),
    singleton(
        tags$head(tags$script(src = "message-handler.js"))
    ),

    fluidRow(
        column(2,
           wellPanel(
               HTML("<center><h2>Picture Data</h2></center>"),
               HTML("<center><h4>(Control Panel)</h4></center>"),
               hr(),
#               verbatimTextOutput("info"),
               shinyFeedback::snackbar("sucessfullyAdded",
                        "Value added successfully at the end of the dataset.",
                        style = "text-align: center;
                        background-color: green; color: white;"),
               shinyFeedback::snackbar("notAdded",
                        "No value added.",
                        style = "text-align: center;
                        background-color: orange; color: white;"),
               div(style = "text-align: center",
                   "Show data as: ", br(),
               actionButton("plotBtn", "Histogram", # but plot dot displayed
                            class = "btn btn-success",
                            width = "100px"),
               hr(),
               ), # end of button div

               div(style = "text-align: center",
                   "Actual sample size =",
                   textOutput("N", inline = TRUE)
               ), # end of sample size text
               verbatimTextOutput("summary"),
               br(),
               actionButton("add", "Add Value",
                            class = "btn btn-primary",
                            width = "100px"),
               shinyjs::disabled(actionButton("delete", "Delete Value",
                                              class = "btn btn-primary",
                                              width = "100px")),
               br(),br(),
               shinyjs::disabled(actionButton("update", "Update",
                                              class = "btn btn-primary",
                                              width = "100px")),
               shinyjs::disabled(actionButton("reset", "Reset",
                                              class = "btn btn-warning",
                                              width = "100px")),
               shinyFeedback::snackbar("resetMessage",
                                        "Data sucessfully reset.",
                                        style = "text-align: center;
                                       background-color: green; color: white;"),
               hr(),
               checkboxInput("ragValue",
                             label = strong(showObs), value = FALSE),

               #### conditional UI: Histogram sliders
               uiOutput("plotUISliders")

           ),
        ),
        column(2,
           wellPanel(
               HTML("<center><h2>Dataset</h2></center>"),
               hr(),
               DT::DTOutput("myDT"),
           ),
        ),
        column(8,
               uiOutput("plotUIHeader"),
               uiOutput("showUIPlot"),
        ),
    )
) # fluidPage


