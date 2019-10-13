#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(magrittr) # provides %>% operator
library(shinycssloaders) # provides a spinner
library(shinyBS) # adds alert messages

# Define UI for application that draws a histogram
ui = fluidPage(
  
  # Some html elements with links and actionLink from shiny package.
  # The behavior of the actionLink is defined by shinyBS::addPopover 
  # in the server section.
  tagList(
    h3(
      a("Gaussian distribution", 
        href = "https://en.wikipedia.org/wiki/Normal_distribution",
        title="External link")
    ),
    p(actionLink("learnMore", "Learn more"), 
      " about the app."),
    br()
  ),
  
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
      
      # create an anchor to display warnings (shinyBS library)
      shinyBS::bsAlert("alertAnchorLargeSample"),
      
      sliderInput("nBins",
                  "Number of histogram bins",
                  min = 1,
                  max = 50,
                  value = 30),
      
      # create an anchor for a tooltip
      shinyBS::bsTooltip("nBins", 
                         "Choose the number of bins for the histogram", 
                         placement = "top", 
                         trigger = "hover", 
                         options = NULL)
    ),
    
    # Show a plot of the generated distribution
    # Added a spinner from shinycssloader to show 
    # progress of a lengthy operation.
    mainPanel(
      shinycssloaders::withSpinner(plotOutput("distPlot"))
    )
  )
)

# Define server logic required to draw a histogram
server = function(input, output, session) {
  
  # Function to generate N Gaussian numbers
  # N specified in UI by input$nSampleSize
  giveMeNGaussianNumbers = reactive({
    cat("We are in giveMeNGaussianNumbers function.\n")
    
    locNsampleSize = as.numeric(input$nSampleSize)
    
    # Use shinyBS library to generate some warnings if sample size is large
    if (locNsampleSize >= 10e5) {
      shinyBS::closeAlert(session, 
                          alertId = "alertSampleAbove10e3")
      
      shinyBS::createAlert(session, 
                           anchorId = 'alertAnchorLargeSample',
                           alertId = 'alertSampleAbove10e5',
                           title = "Warning",
                           style = "danger",
                           content = "Large sample size. This will take a while..."
      )
    }
    else if (locNsampleSize >= 10e3) {
      shinyBS::closeAlert(session, 
                          alertId = "alertSampleAbove10e5")
      
      shinyBS::createAlert(session, 
                           anchorId = 'alertAnchorLargeSample',
                           alertId = 'alertSampleAbove10e3',
                           title = "Warning",
                           style = "warning",
                           content = "Moderate sample size. Should not take long...")
    } else {
      shinyBS::closeAlert(session, 
                          alertId = "alertSampleAbove10e3")
      shinyBS::closeAlert(session, 
                          alertId = "alertSampleAbove10e5")
    }
    
    # Artificial delay for illustration purposes
    # Waits several seconds, depending on the exponent of locNsampleSize
    Sys.sleep(log10(locNsampleSize))
    
    return(rnorm(locNsampleSize))
  })
  
  # A simple function just to return the value of input$nBins field.
  # Parsing through debounce function allows to delay the effect of the slider.
  # Here we delay by 1000 miliseconds = 1s.
  # The %>% operator is provided by magrittr library.
  giveMeNbins = reactive({
    cat("We are in giveMeNbins function.\n")
    
    locNbins = input$nBins
    
    return(locNbins)
  }) %>% debounce(millis = 1000)
  
  output$distPlot = renderPlot({
    cat("We are in distPlot function.\n")
    
    # get N gaussian-distributed numbers; N determined in UI    
    locVecNum  = giveMeNGaussianNumbers()
    
    # generate bins based on input$bins from ui.R
    locVecBins = seq(min(locVecNum), 
                     max(locVecNum), 
                     length.out = giveMeNbins() + 1)
    
    # draw the histogram with the specified number of bins
    hist(locVecNum, 
         breaks = locVecBins, 
         col = 'darkgray', border = 'white')
  })
  
  # Implements the behavior of the actionLink defined in UI
  shinyBS::addPopover(session, 
                      "learnMore",
                      title = "Help about the app",
                      content = "This app plots a histogram of numbers drawn from a Gaussian (Normal) distribution.",
                      trigger = "click")
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
