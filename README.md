# Tutorial scripts with R/Shiny basics

This project accompanies [BernR Meetup](https://www.meetup.com/Bern-R/events/sffhtqyznbsb/): *Shiny from basics to awesome in 26 minutes*, Monday, October 14, 2019.

The tutorial uses following packages:

  - `shiny` for building [interactive](https://shiny.rstudio.com) apps 
  - `magrittr` to provide a [pipe](https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html) operator
  - `shinycssloaders` to provide [loader](https://github.com/andrewsali/shinycssloaders) animations (spinners)
  - `shinyBS` to provide [popups and alerts](https://ebailey78.github.io/shinyBS)


The tutorial covers a basic shiny app with enhancements:

  - `app-step1.R` implements a basic app to plot a histogram of Gaussian-distributed numbers with adjustable number of bins
  - `app-step2.R` adds a selection field to choose the sample size from a predefined list
  - `app-step3.R` adds a *debounce* function to slow down the reactive slider
  - `app-step4.R` adds a loader animation (a spinner) from `shinycssloaders` package
  - `app-step5.R` adds alert popups from `shinyBS` package
  - `app-step6.R` adds help popups and tooltips from `shinyBS` package
  
Apps can be launched:
  
  - from within RStudio by clicking *Run App* button in the upper right corner of the editor window
  - from command line by executing `R -e "shiny::runApp('app-step1.R', port = 6969)"` and then pointing your browser to [http://127.0.0.1:6969](http://127.0.0.1:6969). The value of the `port` parameter can be changed to suit your needs.