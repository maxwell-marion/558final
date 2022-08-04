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
library(caret)

miami <- read_csv("C:/Users/mxmx/Documents/repos/558final/miami-housing.csv")

miami_model <- read_csv("C:/Users/mxmx/Documents/repos/558final/miami-housing.csv", 
                 col_types = cols(avno60plus = col_factor(levels = c("0", "1")), 
                   month_sold = col_factor(levels = c("1","2", "3", "4", "5", "6", "7", "8",
                                                      "9", "10", "11", "12")),
                   structure_quality = col_factor(levels = c("1","2", "3", "4", "5"))))

var_list <- c("LATITUDE",
              "LONGITUDE",
              "PARCELNO",
              "SALE_PRC",
              "LND_SQFOOT",
              "TOT_LVG_AREA",
              "SPEC_FEAT_VAL",
              "age",
              "structure_quality",
              "avno60plus",
              "month_sold",
              "CNTR_DIST",
              "SUBCNTR_DI",
              "OCEAN_DIST",
              "WATER_DIST",
              "RAIL_DIST",
              "HWY_DIST")

model_list <- c("TOT_LVG_AREA",
              "SPEC_FEAT_VAL",
              "age",
              "structure_quality",
              "avno60plus",
              "month_sold",
              "CNTR_DIST",
              "SUBCNTR_DI",
              "OCEAN_DIST",
              "WATER_DIST",
              "RAIL_DIST",
              "HWY_DIST")


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
    
    
    # Watches button and fits all models
    observeEvent(input$fitbutton, {
      
      # Training/Test split
      set.seed(1)
      train <- sample(1:nrow(miami_model),size=nrow(miami_model)*input$trainRatio)
      test <- setdiff(1:nrow(miami_model),train)
      miamiTrain <- miami_model[train, ]
      miamiTest <- miami_model[test, ]
      
      ### MLR Fit
      
      # Builds formula based on selected variables
      mlr_form <- as.formula(paste0('SALE_PRC', "~", paste0(input$mlr_preds, collapse = " + ")))
      
      # Fits Model w/ CV
      fit.mlr <- caret::train(mlr_form,
                      data = miamiTrain,
                      method = "lm",
                      preProcess = c("center", "scale"),
                      trControl = trainControl(method = "cv", number = 5))
    
      # Outputs summary for MLR Model
      output$mlr_sum <- renderPrint(
        summary(fit.mlr)
      )
      
      ### Boosted Tree Fit
      
      # Builds formula based on selected variables
      bt_form <- as.formula(paste0('SALE_PRC', "~", paste0(input$btree_preds, collapse = " + ")))
      
      # Converts input for nTrees into a better format
      if(input$btree_num == '1'){
        bt_num <- c(10,25,50)
      }
      else if(input$btree_num == '2'){
        bt_num <- c(25,50,100)
      }
      else{
        bt_num <- c(50,100,150)
      }
      
      # Fits Model w/ CV
      fit.boost <- train(bt_form,
                         data = miamiTrain,
                         method = "gbm",
                         preProcess = c("center", "scale"),
                         trControl = trainControl(method = "cv", number = 5),
                         tuneGrid = expand.grid(n.trees = bt_num,
                                                interaction.depth = input$btree_depth, 
                                                shrinkage = input$btree_shrinkage, 
                                                n.minobsinnode = input$btree_minobs),
                         verbose = FALSE)

      # Outputs summary for Boosted Tree Model
      output$bt_sum <- renderPrint(
        summary(fit.boost)
      )
      
      
      ### Random Forest Fit
      
      # Builds formula based on selected variables
      rf_form <- as.formula(paste0('SALE_PRC', "~", paste0(input$rf_preds, collapse = " + ")))
      
      # Fits Model w/ CV
      fit.rf <- train(rf_form,
                      method = "rf",
                      preProcess = c("center","scale"),
                      trControl = trainControl(method = "cv", number = 5),
                      tuneGrid = data.frame(mtry = input$rf_mtry),
                      data = miamiTrain)
      
      # Outputs summary for Random Forest Model
      output$rf_sum <- renderPrint(
        summary(fit.rf)
      )
      
      # Comparing everything on the test set
      mlr_testing <- round(postResample(predict(fit.mlr, newdata = miamiTest), obs = miamiTest$SALE_PRC),3)
      bt_testing <- round(postResample(predict(fit.boost, newdata = miamiTest), obs = miamiTest$SALE_PRC),3)
      rf_testing <- round(postResample(predict(fit.rf, newdata = miamiTest), obs = miamiTest$SALE_PRC),3)
      
      # Building dataframe
      h4("Comparing Our Models")
      compare <- data.frame(mlr_testing, bt_testing , rf_testing)
      colnames(compare) <- c("Multiple Linear Regression","Boosted Tree Model","Random Forest Model")
      
      output$compare <- renderTable(
        print(compare)
      )
    })
  
  ### Prediction Tab
    # Morphing all of our NI's into a dataframe
    
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
