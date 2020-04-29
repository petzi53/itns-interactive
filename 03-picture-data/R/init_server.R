# itns-03 PICTURE DATA 2020-04-24
# init_server.R

# dataset and initalizing app variables
# collection of server side text strings
# functions without reactive values
#### myDotPlotSimple
#### myDotPlotStacked
#### sliderValue
#### rugPlot
#### dataModal
#### decialplaces (not used at the moment)


#####################     included dataset      ###############

## dataset converted: so that no extra file load is necessary
## originated from df <- read_csv("Describe_Laptop.csv")
## produced with df <- dput(df)
df <- structure(list(`Transcription%` =
     c(13.7, 21.1, 15.2, 30.4, 12.8, 9.6, 9.3, 17.7,
       15.4, 8.7, 12.8, 10.6, 5.1, 16.7, 17.7, 8.7,
       26.4, 18, 19, 16.9, 18.8, 8.5, 1.2, 11.5,
       21.4, 10.3, 9, 12.8, 12, 34.7, 4.1)),
    class = c("spec_tbl_df", "tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -31L),
    spec = structure(list(cols = list(`Transcription%` =
           structure(list(), class = c("collector_double", "collector"))),
           default = structure(list(),
           class = c("collector_guess", "collector")), skip = 1),
           class = "col_spec"))

dataOriginal <- df

###################  Some Parameters  #####################

# color values for plots
myFillColor = "steelblue"
myBorderColor = "black"

# slidervalues for start & between changing plot display
slider1 = 14
slider2 = 15

######## A collection of server side text strings ##############


msgHelpTitle = "How to use 'Picture Data'"

msgHelpText =
    div(style = "text-align: left",
        HTML(
            "
        <ul>
        <li><strong>Change values: </strong>Double click on a cell to edit the value. Only numeric values are allowed. You can't edit the ID column.</li>
        <li><strong>Delete values: </strong>Select one or more rows, then click 'Delete value'.</li>
        <li><strong>Add values: </strong>Click 'Add value' and enter in the dialog the new value. The new entry it will be added as last record to your database.</li>
        <li><strong>Update: </strong>Click 'Update' to apply all your changes to the plots and to reorder the IDs.</li>
        <li><strong>Reset: </strong>Click 'Reset' to return to the original dataset. All your changes will be lost.</li>
        </ul><hr>
        <h3>Some ideas for experiments</h3>
        <ol><li><strong>Both plot types: </strong>Change, add, delete data and see what happens.</li>
        <li><strong>Dot plot: </strong>
            <ul><li>Add several similar values. Which representation is better readable?</li>
            <li>Add an an extreme data point which is relatively far from other data (outlier) . What happens with the size of the individual data points. Why?</li>
            <li>Check the box 'Individual observations' to add a 1-d plot called rug. It is an alternative representation of a simple dot plot. Do you like it more or less? Why?</li></ul>
            <li><strong>Histogram: </strong>
            <ul><li>Experiment with different slider values. Even some minor differences of the number of bins can lead to big differences in the shape of the graph. Why? And what can you do to avoid misleading conclusions? </ul></li>
            <ul><li>Add different values exactly at the bin boundaries and see what happens. Are they (always?) included on the left or right bin? If there is irregularity behaviour, explain it.</ul></li>
            <ul><li>Add the rug plot by checking 'Indiviual observations'. Are they helpful to understand better the shape of the graph in relation to the bin numbers. Explain.</ul></li>
            </li></ul>
        <hr>
        The exercise follows Chapter 3 of <em>Cumming, G., & Calin-Jageman, R. (2017). Introduction to the New Statistics: Estimation, Open Science, and Beyond. Routledge</em>, pp.45-50.<br/><br>

        Data are from <em>Mueller, P. A., & Oppenheimer, D. M. (2014). The Pen Is Mightier Than the Keyboard: Advantages of Longhand Over Laptop Note Taking. Psychological Science, 25(6), 1159–1168. https://doi.org/10.1177/0956797614524581</>."
        )
    )

#########  Functions without reactive Values  ###############

#################### dot plot ####################

myDotPlotSimple <- function(){
    p <- geom_dotplot(method = "dotdensity",
                      binwidth = 0.1,
                      dotsize = 10,
                      stackratio = 0,
                      fill = myFillColor,
                      color = myBorderColor)
}

myDotPlotStacked <- function(){
    p <- geom_dotplot(method = "dotdensity",
                      binwidth = 1,
                      dotsize = 1,
                      stackratio = 1,
                      fill = myFillColor,
                      color = myBorderColor)
}

###################### general #####################

sliderValue <- function(id, label="Number of bins:", min=5, max=20, value=9) {
    sliderInput(
        id,
        label = label,
        min = min,
        max = max,
        value = value
    )
}


rugPlot <- geom_rug(color = "red",
                    sides = "b",
                    length = unit(5, "mm"))

# Return the UI for a modal dialog
dataModal <- function(recordID) {
    modalDialog(
        numericInput("newValue", "New value:",
                     value = NULL,
                     width = '100px'
        ),
        span('(The new value will be added
             at the end of the dataset as record ID ',
             strong(recordID), ')', .noWS = "before"),
        footer = tagList(
            modalButton("Cancel"),
            actionButton("ok", "OK")
        ),
        size = 's'
    )
}


# calculate number of decimal places
# see: https://stackoverflow.com/a/55738816/7322615
# return maximal number of decimal places in a vector:
# max(sapply(vec, decimalplaces))
decimalplaces <- function(x) {
    if ((x %% 1) != 0) {
        nchar(strsplit(sub('0+$', '', as.character(x)), ".", fixed = TRUE)[[1]][[2]])
    } else {
        return(0)
    }
}

