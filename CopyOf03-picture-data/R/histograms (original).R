# Generate histograms with different bins ----
# plotHist <-  function(newBins, x, title){
#     bins <- seq(min(data()[[1]]), max(data()[[1]]), length.out = newBins + 1)
#
#     hist(data()[[1]], breaks = bins, col = myFillColor, border = myBorder,
#          xlab = x,
#          main = title
#     )
# }
#
# observeEvent(input$bins1, {
#     output$distPlot1 <-
#     renderPlot({plotHist(input$bins1,
#                          "X (Transcription in %)",
#                          "Histogram 1")})
# })
#
# observeEvent(input$bins2, {
#     output$distPlot2 <-
#         renderPlot({plotHist(input$bins2,
#                           "X (Transcription in %)",
#                           "Histogram 2")})
# })


output$distPlot1 <- renderPlot({
    bins <- seq(min(data()[[1]]), max(data()[[1]]), length.out = input$bins1 + 1)
    print(bins)
    ggplot(data(), aes(`Transcription%`)) +
        geom_histogram(bins = input$bins1, fill = myFillColor, color = myBorder) +
        theme_clean()
})

output$distPlot2 <- renderPlot({
    bins <- seq(min(data()[[1]]), max(data()[[1]]), length.out = input$bins2 + 1)
    print(bins)
    ggplot(data(), aes(`Transcription%`)) +
        geom_histogram(bins = input$bins2, fill = myFillColor, color = myBorder) +
        theme_clean()
})
