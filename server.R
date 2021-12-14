library(data.table)
library(ggcorrplot)

# Read in the knn model
model <- readRDS("knnmodel.rds")
df <- read.csv("occupancy.csv", header = TRUE)

shinyServer(function(input, output, session) {
  # Recieve the input Data
  datasetInput <- reactive({
    df <- data.frame(
      Name = c(
        "Temperature",
        "Humidity",
        "Light",
        "CO2",
        "HumidityRatio",
        "Period"
      ),
      Value = as.character(
        c(
          input$temperature,
          input$humidity,
          input$light,
          input$co2,
          input$humidityRatio,
          input$period
        )
      ),
      stringsAsFactors = FALSE
    )
    print(df)
    Occupancy <- 1
    df <- rbind(df, Occupancy)
    input <- transpose(df)
    write.table(
      input,
      "input.csv",
      sep = ",",
      quote = FALSE,
      row.names = FALSE,
      col.names = FALSE
    )
    
    #read the test data entered but the user
    test <- read.csv(paste("input", ".csv", sep = ""), header = TRUE)
    
   
    
    #make prediction using the data from the user
    test$Period <-
      factor(test$Period,
             levels = c("daytime", "eveningtime", "lateevening", "earlydaytime"))
    
    Output <-
      data.frame(Prediction = predict(model, test), round(predict(model, test, type =
                                                                    "prob"), 3))
    colnames(Output) <- c("Prediction", "Not_Occupied", "Occupied")
    print(Output)
    
    
  })
  
  
  
  output$distPlot <- renderPlot({
    x    <- df$Temperature
    x    <- na.omit(x)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(
      x,
      breaks = bins,
      col = "#75AADB",
      border = "black",
      xlab = "Temperature records",
      main = "Histogram of Temperature records"
    )
    
  })
  
  
  #plot for the pie chart
  output$piePlot <- renderPlot({
    ggplot(df, aes(x = 1, fill = Period)) +
      geom_bar(
        position = position_stack(),
        width = 1,
        color = "grey",
        size = 2
      ) +
      geom_text(aes(label = scales::percent((..count..) / sum(..count..))),
                
                stat = "count",
                position = position_stack(vjust = 0.5)) +
      
      coord_polar(theta = "y",
                  start = pi / 3,
                  clip = "off") +
      
      theme_void()
    
  })
  
  
  
  output$daytime <- renderPlot({
    #Class variables and period of time distributions
    ggplot(df, aes(factor(Period), fill = factor(Occupancy))) +
      theme_minimal() + xlab("Occupancy class values") + ylab("Count") + geom_bar()
    
  })
  
  output$corr <- renderPlot({
    #loading the ggplot library
    
    corr <- round(cor(df[, -6]), 1)
    
    #plot of the correlation of features
    ggcorrplot(corr,
               hc.order = TRUE,
               type = "lower",
               outline.col = "white")
    
  })
  
  #plot the model for knn
  output$knnplot <- renderPlot({
    
    
    if (input$submitbutton > 0) {
      plot(model)
    }
    
  })
  
  
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton > 0) {
      isolate("Prediction complete.")
    } else {
      return(
        "Server is ready for prediction, select the sensor values  and click the make prediction button"
      )
    }
  })
  
  #output of the model
  output$explain <- renderText({
    if (input$submitbutton > 0) {
      HTML(
        paste(
          "This is a simulation to classify the values of the sensor values selected on the left panel. Upon clicking the make prediction button,the prediction result on table above was obtained.",
          "The Prediction will either be 0 or 1, whereas the values for both Non_occupied and Occupied will range from 0 to 1.",
          "If Non_occupied is greater than Occupied, then the Prediction will be 0 and vice versa."
        )
      )
    }
  })
  
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton > 0) {
      isolate(datasetInput())
    }
  })
  
  # Status/Output Text Box
  output$plotcontents <- renderPrint({
    if (input$submitbutton > 0) {
      isolate("The plot for the knn model shows the different values of k")
    } else {
      return("The plot for the knn model will appear hear")
    }
  })
  
  output$keepAlive <- renderText({
    req(input$count)
    paste(" ")
  })
  
  #get the image to the user interface
    output$img <- renderUI({
      tags$img(src = "https://i.ibb.co/TbDNmBR/modd.png")
    })
  
  autoInvalidate <- reactiveTimer(10000)
  observe({
    autoInvalidate()
    cat(".")
  })
  
})
