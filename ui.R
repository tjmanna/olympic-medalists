
dashboardPage(
  dashboardHeader(title = 'Olympic Medalists'),
  dashboardSidebar(
    sidebarUserPanel('Olympics',
                     image = 'https://upload.wikimedia.org/wikipedia/en/b/b1/Olympic_Rings.svg'),
    sidebarMenu(
      menuItem('Map', tabName = 'map', icon=icon('map')),
      menuItem('Time Series', tabName = 'time', icon = icon('calendar-alt')),
      menuItem('Sports', tabName = 'sports', icon = icon('futbol')),
      menuItem('Biometrics', tabName = 'bio', icon = icon('heartbeat')),
      menuItem('Data', tabName= 'data', icon = icon('database'))
    ),
    ' Tommy Manna 2020'
  ),
  dashboardBody(
    tabItems(
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
          fluidRow(box('plot goes here')),
          fluidRow(box(sliderInput('slideryearsbio', label = h4('Range of Years'), min = 1896,
                                   max = 2016, value = c(1896, 2016), step = 4, sep = ''), 
                       checkboxInput('monlypoint', label = 'Medalists Only', value = FALSE)),
                   )
    
  ),
  tabItem(tabName = 'data',
          fluidRow((box(DT::dataTableOutput('table'),
                        width = 12))))
)))