#
# Max Marion-Spencer
# ST 558 - Final Project
# Server file
#

library(shiny)
library(readr)
library(DT)

library(dplyr)
library(ggplot2)
library(ggcorrplot)

miami <- read_csv("C:/Users/mxmx/Documents/repos/558final/miami-housing.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
  ### Exploration Tab
    ## Numeric Summaries
    observe(output$num_sum <- renderPrint({
      if(input$exp_num == 'sum'){
        summary(miami[1:input$expRows_NI, c(input$exp_variables), drop = FALSE])
      }
      else if(input$exp_num == 'sd'){
        apply(miami[1:input$expRows_NI, c(input$exp_variables), drop = FALSE], 2, sd)
      }
      else{
        cor(miami[1:input$expRows_NI,c(input$exp_variables), drop = FALSE])
      }
    }))
    ## Graphical Summaries
    observe(output$graph_sum <- renderPlot({
      if(input$exp_graph == 'hist'){
        # histogram code
        g <- ggplot(miami[1:input$expRows_NI,c(input$hist_x), 
                                 drop = FALSE])
        g + geom_histogram(aes_string(x = input$hist_x))
      }
      else if(input$exp_graph == 'corr'){
        # corr code
        g_corr <- round(cor(miami[1:input$expRows_NI,c(input$exp_variables), drop = FALSE]),2)
        ggcorrplot(g_corr)
      }
      else{
        # scattercode
        g <- ggplot(data = miami[1:input$expRows_NI,c(input$scatter_x, input$scatter_y), 
                                 drop = FALSE])
        g + geom_point(aes_string(x = input$scatter_x, y = input$scatter_y))
      }
    }))
  ### Model Fitting Tab  
    # Test/Train Split watcher
    # Updates testRato 
    observeEvent(input$trainRatio,
                 updateSliderInput(session = session, inputId = "testRatio", value = 1-input$trainRatio))
    # Updates trainRato 
    observeEvent(input$testRatio,
                 updateSliderInput(session = session, inputId = "trainRatio", value = 1-input$testRatio))
    
  ### Data Tab
    # Dataset options
    output$data <- DT::renderDataTable(miami[1:input$rows_NI, c(input$data_variables), 
                                             drop = FALSE], 
                                       extensions = 'Buttons',
                                       options = list(scrollX = TRUE,
                                                      scrolly = TRUE,
                                                      buttons = c('csv'),
                                                      dom = 'Bfrtip'),
                                       class = "display"
                                       )
    
})
