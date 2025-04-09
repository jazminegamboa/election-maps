#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(sf)
library(maps)
library(leaflet)

county_map = st_as_sf(map(database = "county", plot = FALSE, fill = TRUE))|>
  st_transform(4326)
county_map 

county_map = inner_join(county_map, county.fips, by = join_by(ID == polyname))
county_map

data = read_csv("countypres_2000-2020.csv") |>
  mutate(prop = candidatevotes / totalvotes)


#Merging by fips 
county_map = inner_join(county_map, data, by = join_by(fips == county_fips))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("U.S. Elections Map by County"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId = "year",
                        "Select Year",
                        min = 2000,
                        max = 2020,
                        step = 4,
                        value = 2012)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           leafletOutput(outputId = "map",
                         height = 700)
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$map <- renderLeaflet({
      county_map_year = county_map |>
        filter(year == input$year) |>
        group_by(fips) |>
        slice_max(prop) |>
        mutate(prop2 = case_when(
          party == "DEMOCRAT" ~ prop,
          party == "REPUBLICAN" ~ -prop))
      
      pal = colorNumeric(
        palette = "RdBu",
        domain = county_map_year$prop2)
      
      county_map_year |>
        leaflet() |>
        addTiles() |>
        addPolygons(weight = 0.3, 
                    label = ~paste(ID, round(prop, 2)), 
                    fillColor = ~pal(prop2), 
                    fillOpacity = 0.8)
      
  
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
