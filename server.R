function(input, output){
  
  regionMedalsMapRange <- reactive({ 
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

  
  
  output$table <- DT::renderDataTable({
    datatable(regionadded, rownames=FALSE, options = list(scrollX = TRUE)) %>%
      formatStyle(input$selected,
                  background='skyblue', fontWeight = 'bold')
  })  
}