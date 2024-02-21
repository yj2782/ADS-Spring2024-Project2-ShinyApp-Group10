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
                            fluidRow(
                              column(6, 
                                     img(src = "disaster1.png", height = "100%",  style="width: 100%; height: auto; max-height: 1000px; display: block; margin-right: 10px;")  # Adjusted for responsive design
                              ),
                              column(6,
                                     h2("Disaster Dynamics Explorer: A Socio-Economic and Demographic Analysis Tool (2021-2023)", style = "color: #31708f;"),
                                     div(
                                       p("Welcome to the Shiny Application presented by Group 10. This application is designed to facilitate the exploration and understanding of the interplay between various socio-economic and demographic factors among individuals affected by disasters from 2021 to 2023.", style = "color: #3c3c3c;"),
                                       p("First, it features a stacked bar chart that allows users to select from five distinct variables for the axes—namely, income, age, education, race, and the level of awareness regarding disasters. Through interactive selection, this visualization tool demonstrates potential correlations and patterns between these factors.", style = "color: #3c3c3c;"),
                                       p("Additionally, the application incorporates a Choropleth map that utilizes FEMA's national household survey data segmented by state for the years 2021 to 2023. This map provides valuable insights into the occurrence and frequency of different types of disasters, including floods, wildfires, and earthquakes. It enables users to conduct a thorough analysis and comparison of the impacts across various regions and timelines.", style = "color: #3c3c3c;"),
                                       p("
Furthermore, the platform includes a FEMA Disaster Preparedness Summary, which is a grouped bar plot that categorizes the different levels of disaster preparedness as reported by individuals across the country. The data for 2023 is categorized based on four criteria identified in the FEMA survey: awareness, experience, efficacy, and risk preparedness.
", style = "color: #3c3c3c;"),
                                       p("Lastly, the application offers a detailed percentage estimate map for New York City, highlighting the distribution of the affected counties by disasters from 2021 to 2023. The map visualizes data collected from survey respondents queried about their personal or familial experiences with disaster impacts. Each county is delineated with a color code that corresponds to the percentage of respondents acknowledging the effects of disasters.", style = "color: #3c3c3c;"),
                                       p("
We invite you to engage with our application to gain deeper insights into the dynamics of disaster impact across different demographics and regions.", style = "color: #3c3c3c;")
                                     
                                       
                                      
            
                                     )
                              )
                            )
                          )
                 ),
                 
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
                 tabPanel("Choropleth Disasater map",
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
                 tabPanel( "FEMA Disaster Preparedness Summary", titlePanel("FEMA Disaster Preparedness Summary"),
                            
                            
                            tabPanel(
                              "Select Disaster",
                              sidebarLayout(
                                sidebarPanel(
                                  selectInput("dis", "Disaster", c("Coastal Flood", "Earthquake", 
                                                                   "Hurricane", "Radiological Emergency",
                                                                   "Riverine Flooding", "Wildfire"))
                                ),
                                mainPanel(
                                  plotOutput("prepplot"),
                                )
                              )
                            )),
                 tabPanel(  "Percentage Estimates for New York Counties ever experienced the impacts of a disaster",
                            titlePanel("Percentage Estimates for New York Counties ever experienced the impacts of a disaster"),
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
                            h2("Authors: Yiwei Jiang, Kasey Liang, Aojie Li, Danielle Solomon"),
                            p("Image:https://www.shutterstock.com/zh/image-generated/cartoon-artistic-image-all-natural-disasters-2284041723"),
                            p("Data:https://www.fema.gov/about/openfema/data-sets/national-household-survey")
                          )
                 )
  
          
)
