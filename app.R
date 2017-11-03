require(shiny)
require(leaflet)
require(rgdal)


NPA <- readOGR("data/NPA_Shape_And_Data.shp",
               layer = "NPA_Shape_And_Data", GDAL1_integer64_policy = TRUE)

server <- function(input, output, session) {
  
  
  output$mymap <- renderLeaflet({
    leaflet(data = NPA, options = leafletOptions(crs = leafletCRS(proj4def = proj4string(NPA)))) %>%
      #addTiles() %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.75,
                  opacity = 1.0, fillOpacity = 0.5,
                  fillColor = "blue",
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  label = as.character(
                    paste0("Pop Density: ", signif(NPA@data$Populati_1/(NPA@data$ACRES), 3),
                           " Adjusted Pop Density: ", signif(NPA@data$Populati_1/(NPA@data$ACRES-NPA@data$Vacant_L_1), 3)
                    )
                  )
                  
      )
  })
}

ui <- fluidPage(
  leafletOutput("mymap")
)

shinyApp(ui = ui, server = server)
