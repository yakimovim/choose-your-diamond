#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

minWeight = min(diamonds$carat)
maxWeight = max(diamonds$carat)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    getFilteredDiamonds <- reactive({
        filteredDiamonds <- diamonds
        
        if(input$selectedCut != "Any")
        {
            filteredDiamonds <- filteredDiamonds[filteredDiamonds$cut == input$selectedCut,]
        }
        
        if(input$selectedColor != "Any")
        {
            filteredDiamonds <- filteredDiamonds[filteredDiamonds$color == input$selectedColor,]
        }
        
        if(input$selectedClarity != "Any")
        {
            filteredDiamonds <- filteredDiamonds[filteredDiamonds$clarity == input$selectedClarity,]
        }
        
        filteredDiamonds
    })
    
    getModel <- reactive({
        filteredDiamonds <- getFilteredDiamonds()
        
        lm(price ~ carat + I(carat^2), data = filteredDiamonds)
    })
    
    output$cut <- renderText({
        input$selectedCut
    })
    output$color <- renderText({
        input$selectedColor
    })
    output$clarity <- renderText({
        input$selectedClarity
    })
    
    output$diamondPrice <- renderPlot({
        
        filteredDiamonds <- getFilteredDiamonds()
        
        fit <- getModel()
        fit.coefs <- coef(fit)
        
        x.fit.points <- seq(from = minWeight, to = maxWeight, length.out = 100)
        y.fit.points <- fit.coefs[1] + fit.coefs[2] * x.fit.points + fit.coefs[3] * (x.fit.points ^ 2)
        
        with(filteredDiamonds, {
            plot(x = carat, y = price, col = "blue", 
                 xlab = "Weight, carats", ylab = "Price, USD",
                 main = "Price of diamonds depending on their weight"
            )
            
            lines(x = x.fit.points, y = y.fit.points, col = "red", lty = 1, lwd = 3)
            
            abline(v = input$selectedWeight, lwd = 3)
        })
    })
    
    output$price <- renderText({
        fit <- getModel()
        
        price <- predict(fit, data.frame(carat = input$selectedWeight))
        
        paste("Approximate price of the diamond is: $", round(price, 2))
    })
    
})
