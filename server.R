function(input, output){
  
  regionMedalsMapRange <- reactive({ #Reactive for Year Slider on Map
    byevent %>%
      filter(., Year >= input$slideryearsmap[1] & Year <= input$slideryearsmap[2]) %>%
      group_by(., region) %>%
      summarise(., Gold = sum(Medal == 'Gold'), 
                Silver = sum(Medal == 'Silver'),
                Bronze = sum(Medal == 'Bronze'),
                Medalists = n()) %>%
      mutate(., Breakdown = paste0(.$region, ': ', .$Gold, ' Gold, ', 
                                   .$Silver, ' Silver, ', 
                                   .$Bronze, ' Bronze'))
  })
  
  BioReactive1 <- reactive({ #Reactive for tab 1 of the biometrics
    if(input$monlybio1 == FALSE){
      regionadded %>%
        filter(., Year >= input$slideryearsbio1[1] & Year <= input$slideryearsbio1[2]) %>%
        group_by(., Sport, Sex) %>%
        summarise(., AvgWeight = mean(Weight, na.rm = TRUE), AvgHeight = mean(Height, na.rm = TRUE))
    } else regionadded %>%
      filter(., is.na(Medal) == FALSE) %>%
      filter(., Year >= input$slideryearsbio1[1] & Year <= input$slideryearsbio1[2]) %>%
      group_by(., Sport, Sex) %>%
      summarise(., AvgWeight = mean(Weight, na.rm = TRUE), AvgHeight = mean(Height, na.rm = TRUE))
    
  })
  
  BioReactive2 <- reactive({ #Reactive for tab 2 of the biometrics
    if(input$monlybio2 == FALSE){
      regionadded %>%
        filter(., Year >= input$slideryearsbio2[1] & Year <= input$slideryearsbio2[2])
    } else regionadded %>%
      filter(., is.na(Medal) == FALSE) %>%
      filter(., Year >= input$slideryearsbio2[1] & Year <= input$slideryearsbio2[2])

  })
  
  BioReactive3 <- reactive({ #Reactive for tab 3 of the biometrics
    if(input$monlybio3 == FALSE){
      regionadded %>%
        group_by(., Sport, Year, Sex) %>%
        summarise(., AvgWeight = mean(Weight, na.rm = TRUE), AvgHeight = mean(Height, na.rm = TRUE))
    } else regionadded %>%
      filter(., is.na(Medal) == FALSE) %>%
      group_by(., Sport, Year, Sex) %>%
      summarise(., AvgWeight = mean(Weight, na.rm = TRUE), AvgHeight = mean(Height, na.rm = TRUE))
    
  })
  
  output$homelist <- renderUI({
    HTML(paste("Select Map to compare medals won globally, with adjustable focus and timescale.", 
               "Select Time Series to compare medals won by nations over time",
               'Select Biometrics to see average basic physical information for athletes in a given sport, 
               and how those averages changed over time.',
               'Select Medalists to generate a profile with medals won by any decorated Olympian.',
               'Select Data to see the raw dataset used to produce this app.',
               sep="<br/><br/>"))
  })
  
  output$map = renderGvis(
    gvisGeoChart(regionMedalsMapRange(), locationvar = 'region', 
                      colorvar = 'Medalists', 
                      hovervar = 'Breakdown', 
                      options = list(width = 'auto', height = 'auto', region = input$mapregion, backgroundColor = '#81d4fa',
                                     colorAxis="{values:[1,50,500,1000],
                                   colors:[\'#E3F7E1', \'#AEF1A8\', \'#24CF15',\'#107107']}")))
  
  output$time = renderPlot(
    ggplot(regionmedalsbyyear, aes(x = Year, y =  Medalists)) + 
      geom_line(data = filter(regionmedalsbyyear, region %in% input$timecountry), aes(color = region)) +
      xlab('') + 
      ylab('Olympic Medals Won') +
      labs(color = 'Country:') +
      theme_economist() +
      scale_x_continuous(breaks=seq(1896, 2016, 4)) + 
      theme(axis.text.x = element_text(angle=45))
  )
  
  output$bioplot = renderPlotly({
    ggplot(BioReactive1(), aes(x = AvgWeight, y = AvgHeight, label = Sport)) + 
      geom_point(aes(color = Sex)) + 
      xlab('Average Weight (kg)') +
      ylab('Average Height (cm)') +
      theme_economist()
   
     })
  
  output$bioSportHeight = renderPlot(
    ggplot(subset(BioReactive2(), Sport == input$bioSport1), aes(x = Sex, y = Height)) + 
      geom_boxplot(aes(fill = Sex)) + 
      theme_economist() + 
      stat_boxplot(geom ='errorbar', width = 0.6) + 
      xlab('') +
      ylab('Height (cm)') +
      theme(axis.text.x = element_blank(),
            axis.title.y = element_text(size = 12))
    
  )
  
  output$bioSportWeight = renderPlot(
    ggplot(subset(BioReactive2(), Sport == input$bioSport1), aes(x = Sex, y = Weight)) + 
      geom_boxplot(aes(fill = Sex)) + 
      theme_economist() + 
      stat_boxplot(geom ='errorbar', width = 0.6) + 
      xlab('') +
      ylab('Weight (kg)') +
      theme(axis.text.x = element_blank(),
            axis.title.y = element_text(size = 12))
  
)
  output$bioYearWeight = renderPlot(
    ggplot(BioReactive3(), aes(x = Year, y =  AvgWeight)) + 
      geom_line(data = filter(BioReactive3(), Sport %in% input$bioSportYear), aes(color = Sex)) +
      xlab('') +
      ylab('Weight (kg)') +
      theme(axis.text.x = element_text(angle=45)) +
      theme_economist()
  )
  
  output$bioYearHeight = renderPlot(
    ggplot(BioReactive3(), aes(x = Year, y =  AvgHeight)) + 
      geom_line(data = filter(BioReactive3(), Sport %in% input$bioSportYear), aes(color = Sex)) +
      xlab('') +
      ylab('Height (cm)') +
      theme(axis.text.x = element_text(angle=45)) +
      theme_economist()
  )
  
  output$medaltable = renderTable({
    medalsonly %>%
      filter(., Name == input$athleteselect) %>%
      arrange(., Year) %>%
      select(., Olympics, Event, Medal)
  })
  
  output$profile = renderTable({
    medalsonly %>%
      filter(., Name == input$athleteselect) %>%
      arrange(., desc(Year)) %>%
      summarise(., Team = first(region), 
                Sport = first(Sport), 
                Age = first(Age), 
                'Height (cm)' = first(Height), 
                'Weight (kg)' = first(Weight))
  })
  
  output$table <- DT::renderDataTable({
    datatable(regionadded, rownames=FALSE, options = list(scrollX = TRUE)) %>%
      formatStyle(input$selected,
                  background='skyblue', fontWeight = 'bold')
  })  
}