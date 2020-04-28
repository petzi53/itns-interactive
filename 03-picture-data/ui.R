# itns-03 PICTURE DATA 2020-04-28

#### Textstrings for messages and UI

showObs = "Individual observations"

###########


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
               shinyFeedback::snackbar("sucessfullyAdded",
                        "Value added successfully at the end of the dataset.",
                        style = "text-align: center;
                        background-color: green; color: white;"),
               shinyFeedback::snackbar("notAdded",
                        "No value added.",
                        style = "text-align: center;
                        background-color: orange; color: white;"),
               shinyWidgets::radioGroupButtons(
                            inputId = "plotBtn",
                            choices = c("Histogram",
                                        "Dot Plot"),
                            selected = "Histogram",
                            status = "success",
                            checkIcon = list(
                                yes = icon("check-square"),
                                no = icon("square-o")
                            ),
                            justified = TRUE
                        ),
               br(),
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
               div(
               h2("Dataset"),
                   actionBttn(
                       inputId = "msgHelp",
                       label = NULL,
                       style = "material-circle",
                       color = "success",
                       icon = icon("question")
                   ),
                   style = "text-align: center",
               ),
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


