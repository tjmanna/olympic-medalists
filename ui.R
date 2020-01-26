
dashboardPage(
  dashboardHeader(title = 'Olympic Medalists'),
  dashboardSidebar(
    sidebarUserPanel('Olympics',
                     image = 'https://upload.wikimedia.org/wikipedia/en/b/b1/Olympic_Rings.svg'),
    sidebarMenu(
      menuItem('Home', tabName = 'home', icon = icon('list')),
      menuItem('Map', tabName = 'map', icon = icon('map')),
      menuItem('Time Series', tabName = 'time', icon = icon('calendar-alt')),
      menuItem('Biometrics', tabName = 'bio', icon = icon('heartbeat')),
      menuItem('Medalists', tabName = 'athlete', icon = icon('swimmer')),
      menuItem('Data', tabName= 'data', icon = icon('database')),
      menuItem('Contact', tabName = 'info', icon = icon('mail'))
    )
    
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = 'home',
              fluidRow(box(h1('120 Years of Olympic History'), status = 'primary')),
              fluidRow(box(htmlOutput('homelist'))),
              fluidRow(box(h4('All credit and thanks goes to user rgriffin on kaggle.com for scraping this data.')))
        
   ),
      
      tabItem(tabName = 'map',
              fluidRow(h2('Overall Olympic Medals by Country, By Year')
                       ),
              fluidRow(box(htmlOutput('map'), width = 1000)
              ),
              fluidRow(box(sliderInput("slideryearsmap", label = h3("Range of Years"), min = 1896, 
                                       max = 2016, value = c(1896, 2016), step = 4, sep = '')),
                       box(selectInput('mapregion', 'Select Regional Focus', MapChoice)))
  ),
  tabItem(tabName = 'time',
          fluidRow(h2('Time Series of Olympic Medals by Country')),
          fluidRow(box(selectInput('timecountry', 'Choose Countries to Examine', unique(regionadded$region), multiple=TRUE, selectize=TRUE))),
          fluidRow(box(plotOutput('time'), width = 1000))
    
  ),
  tabItem(tabName = 'bio',
          fluidRow(h2('Biometrics of Olympic Competitors')),
          fluidRow(tabBox(title = 'Select Biometrics Analysis',
            tabPanel('Overall by Sport', h3('Hover over any point to see sport:'), plotlyOutput('bioplot'), 
                     checkboxInput('monlybio1', label = 'Medalists Only', value = FALSE),
                     sliderInput('slideryearsbio1', label = h4('Range of Years'), min = 1896,
                                 max = 2016, value = c(1896, 2016), step = 4, sep = '')
                     ),
            tabPanel('Individual Sport', 
                     selectInput('bioSport1', 'Choose Sport to Examine', unique(regionadded$Sport), selectize = TRUE),
                     box(plotOutput('bioSportHeight')),
                     box(plotOutput('bioSportWeight')),
                     checkboxInput('monlybio2', label = 'Medalists Only', value = FALSE),
                     sliderInput('slideryearsbio2', label = h4('Range of Years'), min = 1896,
                                 max = 2016, value = c(1896, 2016), step = 4, sep = '')
              
            ),
            tabPanel('Sport by Year',
                     selectInput('bioSportYear', 'Choose Sport(s) to Examine', unique(regionadded$Sport), selectize = TRUE),
                     box(plotOutput('bioYearHeight')),
                     box(plotOutput('bioYearWeight')),
                     checkboxInput('monlybio3', label = 'Medalists Only', value = FALSE)
              
            ),width = 1000))
          
    
  ),
  
  tabItem(tabName = 'athlete',
          fluidRow(h2('Search for a Medalist for Profile and Medal Wins')),
          fluidRow(box(selectInput('athleteselect', 'Choose Medalist to Examine', unique(byathlete$Name), 
                                   selectize =TRUE)), 
                   box(tableOutput('profile'), width = 500)),
          tableOutput('medaltable')

          
          
          
),
  
  tabItem(tabName = 'data',
          fluidRow((box(DT::dataTableOutput('table'),
                        width = 12))),
  
),

  tabItem(tabName = 'info',
        fluidRow('Tommy Manna'),
        fluidRow('tommyjmanna@gmail.com'),
        fluidRow(helpText( a('GitHub', href='https://github.com/tjmanna/', target = '_blank'))),
        fluidRow(helpText( a('LinkedIn', href='https://www.linkedin.com/in/tommy-manna-692323190/', target = '_blank')))
        
        )


)))