



![](election-sc.png)


This repository contains a shiny app that visualizes the election outcomes for
the year selected in each county in the United States. A red shading indicates a 
Republican win and blue indicates a Democratic win.



## Running the app


To run the app in Rstudio, execute the following code in R:


```r
library(shiny)

# Run an app from a subdirectory in the repo

runGitHub(
  repo = "election-maps",
  username = "jazmmiine")
  
```