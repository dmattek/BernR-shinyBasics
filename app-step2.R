#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui = fluidPage(
    
    # Application title
    titlePanel("Gaussian distribution"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "nSampleSize", 
                        label = "Sample size", 
                        choices = c("hundred" = 100,
                                    "thousand" = 10e3,
                                    "ten thousand" = 10e4,
                                    "hundred thousand" = 10e5,
                                    "million" = 10e6)),
            sliderInput("nBins",
                        "Number of histogram bins",
                        min = 1,
                        max = 50,
                        value = 30)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
)




# Define server logic required to draw a histogram
server = function(input, output) {
    
    # Function to generate N Gaussian numbers
    # N specified in UI by input$nSampleSize
    giveMeNGaussianNumbers = reactive({
        cat("We are in giveMeNGaussianNumbers function.\n")
        
        locNsampleSize = as.numeric(input$nSampleSize)
        
        # Artificial delay for illustration purposes
        # Waits several seconds, depending on the exponent of locNsampleSize
        Sys.sleep(log10(locNsampleSize))
        
        return(rnorm(locNsampleSize))
    })
    
    output$distPlot = renderPlot({
        cat("We are in distPlot function.\n")
        
        # get N gaussian-distributed numbers; N determined in UI    
        locVecNum  = giveMeNGaussianNumbers()

        # generate bins based on input$bins from ui.R
        locVecBins = seq(min(locVecNum), 
                         max(locVecNum), 
                         length.out = input$nBins + 1)
        
        # draw the histogram with the specified number of bins
        hist(locVecNum, 
             breaks = locVecBins, 
             col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
