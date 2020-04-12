# Generate histograms with different bins ----
plotHist <-  function(newBins){
    bins <- seq(min(data()[[1]]), max(data()[[1]]), length.out = newBins + 1)

    hist(data()[[1]], breaks = bins, col = "steelblue", border = myBorder,
         xlab = "X (Transcription in %)",
         main = "Histogram 2"
    )
}

observeEvent(input$bins1, {
    output$distPlot1 <-  renderPlot({plotHist(input$bins1)})
})
observeEvent(input$bins2, {
    output$distPlot2 <-  renderPlot({plotHist(input$bins2)})
})
