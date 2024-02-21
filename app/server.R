library(shiny)
library(usmap)
library(ggplot2)
library(readxl)
library(zipcodeR)
library(dplyr)
library(leaflet)
library(readr) 

server <- function(input, output, session) {
  
  
  
  
  # Load datasets for the Stacked Bar Chart app
  data <- read.csv("df_combined.csv")
  
  # Update choices for selectInput dynamically
  updateSelectInput(session, "xaxis", choices = names(data)[-1])
  updateSelectInput(session, "fill", choices = names(data)[-1])
  updateSelectInput(session, "yearChart", choices = unique(data$year), selected = max(data$year))
  
  # Server logic for Stacked Bar Chart
  output$stackedBarChart <- renderPlot({
    filteredData <- subset(data, year == input$yearChart)
    
    ggplot(filteredData, aes_string(x = input$xaxis, fill = input$fill)) +
      geom_bar(position = "stack", stat = "count") +
      labs(title = paste("Distribution of", input$fill, "within", input$xaxis, "for year", input$yearChart),
           x = input$xaxis, y = "Count") +
      theme_minimal()
  })
  
  # Load datasets for the Disaster Data app
  data2021 <- read.csv("aggregated_2021.csv")
  data2022 <- read.csv("aggregated_2022.csv")
  data2023 <- read.csv("aggregated_2023.csv")
  
  # Reactive expression for Disaster Data
  data_selected <- reactive({
    switch(input$yearMap,
           "2021" = data2021,
           "2022" = data2022,
           "2023" = data2023)
  })
  
  
  output$map <- renderLeaflet({
    leaflet(data_selected()) %>% 
      addTiles() %>%
      addCircleMarkers(lng = ~longitude, lat = ~latitude, popup = ~full_state_name, radius = 5, group = ~full_state_name)
  })

  CF <- read_csv("CF.csv")
  ERQK <- read_csv("ERQK.csv")
  HURR <- read_csv("HURR.csv")
  RADIO <- read_csv("RADIO.csv")
  RIVER <- read_csv("RIVER.csv")
  FIRE <- read_csv("FIRE.csv")
  
  
  CF$Criteria <- factor(CF$Criteria, levels = c("One", "Two", "Three", "Four"), 
                        labels = c("One", "Two", "Three", "Four"))
  ERQK$Criteria <- factor(ERQK$Criteria, levels = c("One", "Two", "Three", "Four"), 
                          labels = c("One", "Two", "Three", "Four"))
  HURR$Criteria <- factor(HURR$Criteria, levels = c("One", "Two", "Three", "Four"), 
                          labels = c("One", "Two", "Three", "Four"))
  RADIO$Criteria <- factor(RADIO$Criteria, levels = c("One", "Two", "Three", "Four"), 
                           labels = c("One", "Two", "Three", "Four"))
  RIVER$Criteria <- factor(RIVER$Criteria, levels = c("One", "Two", "Three", "Four"), 
                           labels = c("One", "Two", "Three", "Four"))
  FIRE$Criteria <- factor(FIRE$Criteria, levels = c("One", "Two", "Three", "Four"), 
                          labels = c("One", "Two", "Three", "Four"))  
  data20231 <- reactive({
    switch(input$dis,
           "Coastal Flood" = CF, 
           "Earthquake" = ERQK, 
           "Hurricane" = HURR, 
           "Radiological Emergency" = RADIO,
           "Riverine Flooding" = RIVER, 
           "Wildfire" = FIRE)
  })
  
  
  output$prepplot <- renderPlot({
    ggplot(data = data20231(), aes(x = Criteria, fill = Response)) +
      geom_bar() +
      labs(x = "Number of Preparedness Criteria Met")
    
  })
  
  

  output$plot <- renderPlot({
    if (input$year == "2021") {
      data_2021 <- read_excel("FNHS2021.xlsx",sheet = '2021 NHS General Data',skip=1)
      data_2021 = data_2021[data_2021$QNSD12_1 == 'New York',]
      data_2021 = data_2021[,c('County','GENEXP1')]
      
      result_2021 <- data_2021 %>%
        group_by(County) %>%
        summarize(Yes_Proportion = mean(GENEXP1 == "Yes"))
      
      result_2021 <- result_2021 %>%
        mutate(county = paste(County, "County"))
      
      result_2021 <- merge(result_2021, countypov, by = "county")
      
      
      plot_usmap(data = result_2021, values = "Yes_Proportion", include = c("NY"), color = "blue") + 
        scale_fill_continuous(low = "white", high = "blue", name = "Percentage Estimates", label = scales::comma) + 
        labs(title = "New York Region", subtitle = "Percentage Estimates for New York Counties ever experienced the impacts of a disaster in 2021") +
        theme(legend.position = "right")
    } else if (input$year == "2022") {
      data_2022 <- read_excel("FNHS2022.xlsx",sheet = '2022 NHS General Data',skip=1)
      data_2022 = data_2022[data_2022$QNSD12_1 == 'New York',]
      data_2022 = data_2022[,c('County','GENEXP1')]
      
      result_2022 <- data_2022 %>%
        group_by(County) %>%
        summarize(Yes_Proportion = mean(GENEXP1 == "Yes"))
      
      result_2022 <- result_2022 %>%
        mutate(county = paste(County, "County"))
      
      result_2022 <- merge(result_2022, countypov, by = "county")
      
      
      plot_usmap(data = result_2022, values = "Yes_Proportion", include = c("NY"), color = "blue") + 
        scale_fill_continuous(low = "white", high = "blue", name = "Poverty Percentage Estimates", label = scales::comma) + 
        labs(title = "New York Region", subtitle = "PPercentage Estimates for New York Counties ever experienced the impacts of a disaster in 2022") +
        theme(legend.position = "right")
    } else if (input$year == "2023") {
      data_2023 <- read_excel("FNHS2023.xlsx",sheet = 'Core Survey',skip=1)
      data_2023 = data_2023[data_2023$state == 'New York',]
      data_2023 = data_2023[,c('county','dis_exp')]
      
      result_2023 <- data_2023 %>%
        group_by(county) %>%
        summarize(Yes_Proportion = mean(dis_exp == "Yes"))
      
      result_2023 <- result_2023 %>%
        mutate(county = paste(county, "County"))
      
      result_2023 <- merge(result_2023, countypov, by = "county")
      
      
      plot_usmap(data = result_2023, values = "Yes_Proportion", include = c("NY"), color = "blue") + 
        scale_fill_continuous(low = "white", high = "blue", name = "Poverty Percentage Estimates", label = scales::comma) + 
        labs(title = "New York Region", subtitle = "Percentage Estimates for New York Counties ever experienced the impacts of a disaster in 2023") +
        theme(legend.position = "right")
    }
  })
  
  
  
  
  
  
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    stateName <- click$group
    stateData <- data_selected() %>% filter(full_state_name == stateName)
    
    if(nrow(stateData) > 0) {
      
      library(reshape2)
      stateDataLong <- melt(stateData, id.vars = "full_state_name", measure.vars = c("Flood", "Earthquake", "Wild_Fire", "Hurricane", "Radiological_Attack"), variable.name = "disaster_type", value.name = "count")
      
      output$barPlot <- renderPlot({
        ggplot(stateDataLong, aes(x = disaster_type, y = count)) +
          geom_bar(stat = "identity", fill = "steelblue") +
          theme_minimal() +
          xlab("Disaster Type") +
          ylab("Count") +
          ggtitle(paste("Disaster Data for", stateName, "in", input$yearMap)) +
          geom_text(aes(label = count), vjust = -0.3, size = 3.5)
      })
    } else {
      output$barPlot <- renderPlot({
        ggplot() +
          geom_blank() +
          ggtitle(paste("No data available for", stateName, "in", input$yearMap))
      })
    }
  })
  
  
  
}

