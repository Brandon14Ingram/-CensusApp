library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")
# percent_map(counties$white, "darkgreen", "% White")


ui <- fluidPage(
    titlePanel("Census Visulization"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Create demographic maps with 
        information from the 2010 US Census."),
            
            selectInput("var", 
                        label = "Choose a variable to display",
                        choices = c("Percent White", "Percent Black",
                                    "Percent Hispanic", "Percent Asian"),
                        selected = "Percent Asian"),
            
            sliderInput("range", 
                        label = "Range of interest:",
                        min = 0, max = 100, value = c(0, 100))
        ),
        
        mainPanel(plotOutput("map"))
    )
)

# Server logic ----
server <- function(input, output) {
    output$map <- renderPlot({
        data <- switch(input$var, 
                       "Percent White" = counties$white,
                       "Percent Black" = counties$black,
                       "Percent Hispanic" = counties$hispanic,
                       "Percent Asian" = counties$asian)
        
        col <- switch(input$var,
                      "Percent White" = "darkgreen",
                      "Percent Black" = "black",
                      "Percent Hispanic" = "darkorange",
                      "Percent Asian" = "darkred")
        
        percent_map(var = data, color = col, legend.title = input$var, 
                    input$range[1], input$range[2])
    })
}

# Run app ----
shinyApp(ui, server)