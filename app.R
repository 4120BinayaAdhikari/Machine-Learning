
    library(shiny)  
### Figure 1.


uiC <- fluidPage(
    
    selectInput(inputId = "rnormset", 
                label = "Choose a distribution", 
                choices = c("Standard Normal Distribution", "Normal Distribution N(10,3)")),
    
    plotOutput(outputId = "Plot3")
)


# generate 1000 random numbers from N(0,1)
z <- rnorm(1000)
#hist(z, main='')

# generate 1000 random numbers from N(10,3)
x <- rnorm(1000, mean=10, sd=3)
#hist(x, main='')


serverC <- function(input, output) {
    datasetInput <- reactive({
        switch(input$rnormset, 
               "Standard Normal Distribution" = z, 
               "Normal Distribution N(10,3)" = x)
    })
    
    output$Plot3 <- renderPlot({
        rnormset <- datasetInput()
        hist(rnormset, main='', xlab = "x")
        
    })
}

shinyApp(ui=uiC, server=serverC)


### Figure 2.




uiA <- fluidPage(
    sliderInput("sd_adjust", "Choose value of standard deviation:",
                min = 0, max = 25, value = 20,step = 0.2
    ),
    plotOutput("distPlot"),
    
)



# Server logic
serverA <- function(inputA, outputA) {
    outputA$distPlot <- renderPlot({
        
        par(mar=c(5, 4, 2, 2))
        x2 <- seq(-11, 31, by=0.01)
        y2 <- dnorm(x2, mean = 10, sd = inputA$sd_adjust) 
        
        plot(x2, y2,type="l", xlab="x", ylab="f(x)", main='')
    })
}

# Complete app with UI and server components
shinyApp(ui=uiA, server=serverA)




### Figure 3.





uiB <- fluidPage(
    
    # App title ----
    titlePanel("Assessing Normality"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Select the sample size ----
            radioButtons("dist", "Choose the sample size:",
                         c("n=30" = "n30",
                           "n=100" = "n100",
                           "n=1000" = "n1000")),
            
            
            # br() element to introduce extra vertical spacing ----
            #br(),
            
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(type = "tabs",
                        tabPanel("Plot", plotOutput("plot")),
                        tabPanel("Summary", verbatimTextOutput("summary")),
                        tabPanel("Table", tableOutput("table"))
            )
            
        )
    )
)


serverB <- function(input, output) {
    
    d <- reactive({
        
        dist <-switch(input$dist,
                      n30=30,
                      n100=100,
                      n1000=1000 )
        
    })
    
    output$plot <- renderPlot({
        
        dist <- input$dist
        
        par(mfrow=c(1,2))
        set.seed(999) # set seed for reproducibility
        sim_norm <- rnorm(d())
        hist(sim_norm, freq=FALSE, xlab='', main='')
        x <- seq(-3, 3, 0.01)
        y <- dnorm(x, mean=mean(sim_norm), sd=sd(sim_norm))
        lines(x, y, col="red", lwd=2)
        
        qqnorm(sim_norm)
        qqline(sim_norm)
        
    })
    
    
    # Generate a summary of the data ----
    
    output$summary <- renderPrint({
        
        summary(rnorm(d()))
        
    })
    
    # Generate an HTML table view of the data ----
    output$table <- renderTable({
        rnorm(d())
    })
    
}


# Complete app with UI and server components
shinyApp(ui=uiB, server=serverB)


