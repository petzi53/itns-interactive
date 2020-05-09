# itns-03 PICTURE DATA 2020-04-28

#### Textstrings for messages and UI text elements
showObs = "Individual observations (1-d plot)"
showUpdateMsg = "To see your changes click 'Update'."


shinyUI <- fluidPage(

    waiter::use_waiter(),
    waiter::waiter_show_on_load(spin_whirly()),
    shinyjs::useShinyjs(),
    shinyFeedback::useShinyFeedback(),

    fluidRow(
        column(3,
           wellPanel(
               HTML("<center><h2>Picture Data</h2></center>"),
               HTML("<center><h4>(Control Panel)</h4></center>"),
               hr(),
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
                   textOutput("N", inline = TRUE),
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
               shinyjs::hidden(p(style = "color: red", id = "updateString",
                        showUpdateMsg)
                      ), # end hidden
               ), # end of center div
               hr(),
               shinyWidgets::awesomeCheckbox(
                   inputId = "rugValue",
                   label = strong(showObs),
                   value = FALSE,
                   status = "primary",
                   width = NULL
               ),
               shinyWidgets::awesomeCheckboxGroup(
                   inputId = "location", label = "Measures of Location",
                   choices = c("Mean", "Median", "Mode"),
                   inline = TRUE
               ),
               shinyWidgets::awesomeCheckboxGroup(
                   inputId = "spread", label = "Measures of Spread",
                   choices = c("Z Scores", "Quartiles", "Percentiles"),
                   inline = TRUE
               ),

               #### conditional UI: Histogram sliders
               uiOutput("plotUISliders")
           ),
        ),
        column(2,
           wellPanel(
               div(
               h2("Dataset"),
                   shinyWidgets::actionBttn(
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
        column(7,
               uiOutput("plotUIHeader"),
               uiOutput("showUIPlot"),
        ),
        waiter_hide_on_render("distPlot2"),
    )
) # fluidPage


