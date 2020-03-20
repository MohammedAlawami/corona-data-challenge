#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny, warn.conflicts = TRUE)
library(tidyverse, warn.conflicts = TRUE)
library(magrittr, warn.conflicts = TRUE)
library(leaflet, warn.conflicts = TRUE)

total_confirmed <- read_csv(
    'https://covid.ourworldindata.org/data/total_cases.csv',
    col_types = paste0("D", strrep("i", 161))
)
total_deaths <- read_csv(
    'https://covid.ourworldindata.org/data/total_deaths.csv',
    col_types = paste0("D", strrep("i", 161))
)
new_confirmed <- read_csv(
    'https://covid.ourworldindata.org/data/new_cases.csv',
    col_types = paste0("D", strrep("i", 161))
)
new_deaths <- read_csv(
    'https://covid.ourworldindata.org/data/new_deaths.csv',
    col_types = paste0("D", strrep("i", 161))
    )
full_dataset <- read_csv(
    'https://covid.ourworldindata.org/data/full_data.csv',
    col_types = "Dciiii"
    )

countries <- names(total_confirmed)[-1]

m <- leaflet() %>%
    addTiles()

total_confirmed %<>% 
    gather(key = 'country',
           value = 'total_confirmed',
           -date)

total_deaths %<>% 
    gather(key = 'country',
           value = 'total_deaths',
           -date)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Coronavirus"),
    
    navbarPage(
        "Analysis",
        tabPanel(
            "Total Confirmed",
            sidebarLayout(
                sidebarPanel(
                    selectInput("confirmed_country",
                                "Country:",
                                countries,
                                selected = "World")
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                    plotOutput("total_confirmed")
                )
            )
        ),
        
        tabPanel(
            "Total Deaths",
            sidebarLayout(
                sidebarPanel(
                    selectInput("deaths_country",
                                "Country:",
                                countries,
                                selected = "World")
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                    plotOutput("total_deaths")
                )
            )
        ),
        
        tabPanel(
            "Map",
            sidebarLayout(
                sidebarPanel(
                    selectInput("deaths_country",
                                "Country:",
                                countries,
                                selected = "World")
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                    leafletOutput("map")
                )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$total_confirmed <- renderPlot({
        total_confirmed %>% 
            filter(country == input$confirmed_country) %>% 
            ggplot(aes(date, total_confirmed)) +
            geom_line() +
            ggtitle('Total Number of Confirmed Cases') + 
            ylab('Total Confirmed Cases') +
            xlab('Date')
    })
    
    output$total_deaths <- renderPlot({
        total_deaths %>% 
            filter(country == input$deaths_country) %>% 
            ggplot(aes(date, total_deaths)) +
            geom_line() +
            ggtitle('Total Number of Deaths') + 
            ylab('Total Deaths') +
            xlab('Date')
    })
    
    output$map <- renderLeaflet({
        m
    })
    
    output$total <- renderPlot({
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
