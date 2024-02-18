library(shiny)
library(leaflet)
library(ggplot2)
library(shiny)
library(leaflet)
library(ggplot2)
library(shinythemes)
library(png)

ui <- navbarPage(title = "Shiny APP Group 10",
                 theme = shinytheme("flatly"), 
                 tabPanel("Home",
                          fluidPage(
                            h2("Welcome to Our Shiny App", style = "color: #31708f;"), 
                            p("Introduction place. user guide",
                              style = "color: #3c3c3c;"),
                           img(src = "Disaster.png", height = "1000px"),
                          )),
                 
                 tabPanel("Stacked Bar Chart",
                          titlePanel("Stacked Bar Chart with Year Filter"),
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("xaxis", "Choose X-axis category:",
                                          choices = NULL), 
                              selectInput("fill", "Choose Fill category:",
                                          choices = NULL), 
                              selectInput("yearChart", "Choose Year:",
                                          choices = NULL) 
                            ),
                            mainPanel(
                              plotOutput("stackedBarChart")
                            )
                          )),
                 tabPanel("Disaster Data",
                          titlePanel("Disaster Data by State"),
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("yearMap", "Select the year:", choices = c("2021", "2022", "2023")),
                              "Click a state on the map to view details."
                            ),
                            mainPanel(
                              leafletOutput("map"),
                              plotOutput("barPlot")
                            )
                          )),
                 tabPanel("FEMA Disaster Summary",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("dis", "Disaster", c("Coastal Flood", "Earthquake", 
                                                               "Hurricane", "Radiological Emergency",
                                                               "Riverine Flooding", "Wildfire"))
                            ),
                            mainPanel(
                              plotOutput("prepplot")
                            )
                          )),
                 tabPanel(  "Percentage Estimates for New York Counties ever experienced the impacts of a disaster",
                            sidebarLayout(
                              sidebarPanel(
                                selectInput("year", "Year",
                                            choices = c("2021", "2022", "2023"),
                                            selected = "2021")
                              ),
                              mainPanel(
                                plotOutput("plot")
                              )
                            ))
                 ,
                 tabPanel("Reference",
                          titlePanel("References"),
         
                          fluidPage(
                            h2("References"),
                            p("Write some findings and authors.")
                          )
                 )
  
          
)
