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

miami <- read_csv("C:/Users/mxmx/Documents/repos/558final/miami-housing.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
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
    #observe(g <- ggplot(miami[1:input$expRows_NI,input$hist_x]))
    observe(output$graph_sum <- renderPlot({
      if(input$exp_graph == 'hist'){
        # histogram code
        #g <- ggplot(data = miami[1:input$expRows_NI,c(input$hist_x), 
                                 #drop = FALSE])
        #g + geom_histogram(aes(x = input$hist_x))
      }
      else if(input$exp_graph == 'bar'){
        # bar code
        #g <- ggplot(miami[1:input$expRows_NI,input$bar_x])
        #g + geom_bar()
      }
      else if(input$exp_graph == 'corr'){
        # corr code
        #g_corr <- round(cor(miami[1:input$expRows_NI,input$hist_x]),2)
        #g <-
      }
      else{
        # scattercode
        #g <- ggplot(data = miami[1:input$expRows_NI,c(input$scatter_x, input$scatter_y), 
                                 #drop = FALSE])
        #g + geom_point(aes(x = input$scatter_x, y = input$scatter_y))
      }
    }))

    ### Data Tab
    # Show entire dataset
    # Subset data (rows and columns)
    # Save the data as a file (.csv or other)
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
