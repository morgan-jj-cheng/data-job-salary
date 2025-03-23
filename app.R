#if(!require(plotly)){install.packages(c("plotly"))}

library(tidyverse)
library(dplyr)
library(DT)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(ggplot2)
library(plotly)
library(bs4Dash)
library(maps)
library(countrycode)
library(viridis)
library(scales)


load("data/data_jobs_salary.RData")


type_exp <- unique(df$experience_level)
type_size <- unique(df$company_size)
type_country <- unique(df$company_country)
type_job_cat <- unique(df$job_category)
type_job_title <- unique(df$job_title)
type_job_type <- unique(df$job_type)


################################## this is UI ##################################

# FULL PAGE
ui <- dashboardPage(           
  # Header zone
  dashboardHeader(title = "Salaries of Data-Related Jobs"),
  
  # Sidebar zone
  dashboardSidebar(
    width = "310px",
    sidebarMenu(
      sliderInput("year",
                  h5("Year"),
                  min = 2020,
                  max = 2024,                      
                  value = c(2020, 2024),
                  step = 1,
                  sep = ""
      ),
      
      checkboxGroupInput("experience_level",
                         h5("Experience Level"),
                         #choices = type_exp,
                         choices = c("Entry", "Mid", "Senior", "Executive"),
                         selected = type_exp
      ),
      
      conditionalPanel(
        condition = "input.main_tab == 'Detail Data'",
        checkboxGroupInput("job_type",
                           h5("Employment Type"),
                           choices = type_job_type,
                           selected = type_job_type
        ),
        
        checkboxGroupInput("company_size",
                           h5("Company Size"),
                           choices = type_size,
                           selected = type_size
        )
      ),
      
      pickerInput("company_country",
                  h5("Country"),
                  choices = sort(type_country),
                  selected = type_country,
                  multiple = TRUE, 
                  options = pickerOptions(`actions-box` = TRUE, 
                                          `size` = 8),
                  choicesOpt = list(style = rep("color: black", 200))
                  
      ),
      
      pickerInput("job_category",
                  h5("Job Category"),
                  choices = type_job_cat,
                  selected = type_job_cat, 
                  multiple = TRUE, 
                  options = pickerOptions(`actions-box` = TRUE, 
                                          `size` = 6, 
                                          `plugins` = list("remove_button")),
                  choicesOpt = list(style = rep("color: black", 12))
      )
    )
  ),
  
  ################################ this is Body ################################
  
  # Body zone
  dashboardBody(
    tags$head(
      tags$style(HTML("
          body.dark-mode .dataTables_wrapper {
            color: white !important;  #form word
          }
          body.dark-mode table.dataTable tbody td {
            color: white !important;  #form content
          }
      ")),
      
    tags$head(tags$style(HTML("
      .value-box .value { 
        font-size: 28px !important;
        font-weight: bold !important;
      }
      .value-box .subtitle { 
        font-size: 18px !important;
      }
    ")))
      
      
    ),
    skin = "dark",
    tabBox(
      id = "main_tab",
      width = 12,
      #height = "400px",
      
      # tab1
      tabPanel("Salary Analysis",
               fluidRow(
                 column(3, valueBoxOutput("median_entry", width = "auto")),
                 column(3, valueBoxOutput("median_mid", width = "auto")),
                 column(3, valueBoxOutput("median_senior", width = "auto")), 
                 column(3, valueBoxOutput("median_executive", width = "auto"))
               ),
               
               div(style = "margin-top: 30px;"),
               plotOutput("plt1"),
               
               div(style = "margin-top: 20px;"),
               plotOutput("plt2", height = "600px")
      ),
      
      # tab2
      tabPanel("Country Analysis",
               fluidRow(
                 column(4, valueBoxOutput("global_avg_salary", width = "auto")),
                 column(4, valueBoxOutput("highest_salary_country", width = "auto")),
                 column(4, valueBoxOutput("lowest_salary_country", width = "auto"))
               ),
               div(style = "margin-top: 20px;"),
               
               # world map
               plotlyOutput("plt3", height = "550px"),
               div(style = "margin-top: 30px;"),
               
               # year vs $ line chart
               fluidRow(
                 column(7,
                        box(
                          title = "Median Salary Trend by Continent & Global",
                          width = 12, 
                          collapsible = TRUE, 
                          collapse = TRUE,
                          plotOutput("plt4")
                        )
                 ),
                 column(5,
                        box(
                          title = "Country Statistics", 
                          width = 12, 
                          collapsible = T, 
                          collapse = T,
                          tabsetPanel(
                            id = "selected_year", 
                            tabPanel("2020", DT::dataTableOutput("table_2020")),
                            tabPanel("2021", DT::dataTableOutput("table_2021")),
                            tabPanel("2022", DT::dataTableOutput("table_2022")),
                            tabPanel("2023", DT::dataTableOutput("table_2023")),
                            tabPanel("2024", DT::dataTableOutput("table_2024"))
                          )
                        )
                 )
               )
      ),
      
      # tab3
      tabPanel("Detail Data",
               fluidRow(
                 column(12, DT::dataTableOutput("table1"))
               )
               
      )
    )
  )
)


################################ this is server ################################

# Server
server <- function(input, output){
  
  ################### tab1: salary analysis ###################
  
  # tab1, card1
  output$median_entry <- renderValueBox({
    df_entry <- df %>%
      filter(experience_level == "Entry", 
             year >= input$year[1], 
             year <= input$year[2], 
             experience_level %in% input$experience_level) %>%
      summarise(median_salary = median(salary_usd, na.rm = TRUE))
    
    valueBox(HTML(paste0('<span style="font-size: 30px; font-weight: bold;"">', 
                         formatC(df_entry$median_salary, '</span>'))), 
             #format = "f", big.mark = ",", digits = 0),
             subtitle = "Entry Level Median Salary", color = "danger", icon = icon("dollar-sign"))
  })
  
  # tab1, card2
  output$median_mid <- renderValueBox({
    df_mid <- df %>%
      filter(experience_level == "Mid", 
             year >= input$year[1], 
             year <= input$year[2], 
             experience_level %in% input$experience_level) %>%
      summarise(median_salary = median(salary_usd, na.rm = TRUE))
    
    valueBox(HTML(paste0('<span style="font-size: 30px; font-weight: bold;"">', 
                         formatC(df_mid$median_salary, '</span>'))), 
             #format = "f", big.mark = ",", digits = 0),
             subtitle = "Mid Level Median Salary", color = "olive", icon = icon("dollar-sign"))
  })
  
  # tab1, card3
  output$median_senior <- renderValueBox({
    df_senior <- df %>%
      filter(experience_level == "Senior",
             year >= input$year[1], 
             year <= input$year[2], 
             experience_level %in% input$experience_level) %>%
      summarise(median_salary = median(salary_usd, na.rm = TRUE))
    
    valueBox(HTML(paste0('<span style="font-size: 30px; font-weight: bold;"">', 
                         formatC(df_senior$median_salary, '</span>'))), 
             #format = "f", big.mark = ",", digits = 0),
             subtitle = "Senior Level Median Salary", color = "info", icon = icon("dollar-sign"))
  })
  
  # tab1, card4
  output$median_executive <- renderValueBox({
    df_executive <- df %>%
      filter(experience_level == "Executive", 
             year >= input$year[1], 
             year <= input$year[2], 
             experience_level %in% input$experience_level) %>%
      summarise(median_salary = median(salary_usd, na.rm = TRUE))
    
    valueBox(HTML(paste0('<span style="font-size: 30px; font-weight: bold;"">', 
                         formatC(df_executive$median_salary, '</span>'))), 
             #format = "f", big.mark = ",", digits = 0),
             subtitle = "CXO Level Median Salary", color = "purple", icon = icon("dollar-sign"))
  })
  
  # tab1, plt1: salary vs exp, density
  react_data_tab1 <- reactive({
    df %>%
      filter(
        experience_level %in% input$experience_level, 
        job_category %in% input$job_category, 
        year >= input$year[1], 
        year <= input$year[2]
      )
  })
  
  output$plt1 <- renderPlot({
    react_data_tab1() %>%
      mutate(experience_level = factor(experience_level, levels = c("Entry", "Mid", "Senior", "Executive"))) %>%
      ggplot(aes(x = salary_usd, fill = experience_level, color = experience_level)) + 
      geom_density(alpha = 0.35) + 
      scale_x_continuous(labels = scales::comma) +
      scale_y_continuous(labels = scales::percent_format(scale = 10000000)) +
      labs(
        title = "Salary Distribution by Experience Level",
        x = "Salary (in USD)",
        y = "Density"
      ) + 
      theme_light() + 
      theme(
        axis.title = element_text(size=18, face="bold"),  #x, ylabel
        axis.text = element_text(size=14),  #x, y tick
        strip.text = element_text(size=16, color="black"),  #facet
        legend.title = element_text(size=14),  #legend title
        legend.text = element_text(size=12),  #legend content
        plot.title = element_text(size=18, hjust=0.5, face="bold")  #title
      )
  })
  
  # tab1, plt2: huge boxplot
  output$plt2 <- renderPlot({
    react_data_tab1() %>%
      mutate(experience_level = factor(experience_level, levels = c("Entry", "Mid", "Senior", "Executive"))) %>%
      ggplot(aes(x = salary_usd, y = job_category, fill = experience_level)) +
      geom_boxplot(alpha = 0.5) + 
      facet_wrap(~ experience_level) + 
      scale_x_continuous(labels = scales::comma) +
      labs(
        title = "Salary Distribution by Experience Level",
        x = "Experience Level",
        y = "Salary (USD)"
      ) +
      theme_minimal() +
      theme(
        #axis.title = element_text(size = 14, face = "bold"),
        axis.title = element_blank(),
        axis.text = element_text(size = 12),
        plot.title = element_text(size = 16, hjust = 0.5, face = "bold")
      )
  })
  
  ################### tab2: country analysis ###################
  # tab2, card1
  output$global_avg_salary <- renderValueBox({
    df <- df %>%
      filter(
        year >= input$year[1], 
        year <= input$year[2]
      )
    
    valueBox(HTML(paste0('<span style="font-size: 30px; font-weight: bold;"">', 
                         formatC(median(df$salary_usd, na.rm = TRUE), '</span>'))), 
             subtitle = "Global Median Salary (USD)", color = "primary", icon = icon("dollar-sign"))
  })
  
  # tab2, card2
  output$highest_salary_country <- renderValueBox({
    top_country <- df %>%
      filter(
        year >= input$year[1], 
        year <= input$year[2]
      ) %>%
      group_by(company_country) %>%
      summarise(median_salary = median(salary_usd, na.rm = TRUE)) %>%
      arrange(desc(median_salary)) %>%
      slice(1)
    valueBox(HTML(paste0('<span style="font-size: 30px; font-weight: bold;"">', 
                         top_country$company_country, '</span>')), 
             #format = "f", big.mark = ",", digits = 0),
             subtitle = "Highest Median Salary", color = "olive", icon = icon("dollar-sign"))
  })
  
  # tab2, card3
  output$lowest_salary_country <- renderValueBox({
    bottom_country <- df %>%
      filter(
        year >= input$year[1], 
        year <= input$year[2]
      ) %>%
      group_by(company_country) %>%
      summarise(median_salary = median(salary_usd, na.rm = TRUE)) %>%
      arrange(median_salary) %>%
      slice(1)
    valueBox(HTML(paste0('<span style="font-size: 30px; font-weight: bold;"">', 
                         bottom_country$company_country, '</span>')), 
             #format = "f", big.mark = ",", digits = 0),
             subtitle = "Lowest Median Salary", color = "danger", icon = icon("dollar-sign"))
  })
  
  # tab2, plt3: world map
  react_data_tab2 <- reactive({
    df %>%
      filter(
        company_country %in% input$company_country,
        year >= input$year[1], 
        year <= input$year[2]
      )
  })
  
  output$plt3 <- renderPlotly({
    world_map <- map_data("world") %>%
      filter(lat >= -55)
    
    # calculate median
    df_map <- react_data_tab2() %>%
      group_by(company_country) %>%
      summarise(median_salary = median(salary_usd, na.rm = TRUE)) %>%   #drop NA
      arrange(desc(median_salary))
    
    # unify convert country name in world_map
    world_map$region <- countrycode(world_map$region, origin = "country.name", destination = "country.name")
    # join location data and salary data
    df_map_salary <- left_join(world_map, df_map, by = c("region" = "company_country"))
    
    # plot
    p <- ggplot() +
      geom_polygon(data = df_map_salary,
                   aes(x = long, y = lat,
                       group = group, fill = median_salary, 
                       text = paste(region, "\nMedian Salary: $", format(median_salary, scientific = FALSE))
                   ), 
                   color = "white", size = 0.2) +
      scale_fill_viridis_c(option = "magma", na.value = "gray90", labels = comma) +  
      theme_minimal() +
      theme(
        legend.key.size = unit(0.4, "cm"),  
        legend.text = element_text(size = 8),  
        legend.title = element_text(size = 9, face = "bold"), 
        axis.title.x = element_blank(), 
        axis.title.y = element_blank()
      ) +
      labs(title = "Median Salary Distribution", 
           fill = "USD") +
      theme(
        plot.title = element_text(size=14, hjust=0.5, face="bold")
      )
    
    ggplotly(p, tooltip = "text", dynamicTicks = TRUE) %>%
      layout(height = 550)
  })
  
  
  # tab2, plt4: year vs median salary, line chart
  react_data_tab3 <- reactive({
    df %>%
      filter(
        year >= input$year[1], 
        year <= input$year[2]
      )
  })
  
  output$plt4 <- renderPlot({  
    # continental median
    continent_median <- react_data_tab3() %>%
      group_by(year, continent) %>%
      summarize(median_salary = median(salary_usd)) 
    
    # global median
    global_median <- react_data_tab1() %>%
      group_by(year) %>%
      summarize(median_salary = median(salary_usd)) %>%
      mutate(continent = "Global")
    
    # combine all median
    final_data <- bind_rows(continent_median, global_median)
    
    # plot
    continent_levels <- c("Africa", "Americas", "Asia", "Europe", "Oceania", "Global")
    
    # customize color, line, linetype
    continent_line <- setNames(c(rep(0.8, 5), 1.5), continent_levels)
    continent_linetype <- setNames(c("dashed", "longdash", "twodash", "dotdash", "dotted", "solid"), continent_levels)
    
    # plot
    ggplot(final_data, aes(x = year, y = median_salary, color = continent)) +
      geom_line(aes(size = continent, linetype = continent)) +
      #geom_point(aes(shape = continent), size = 4) +
      scale_color_manual(values = c("Africa" = "skyblue", "Americas" = "darkgreen", 
                                    "Asia" = "orange", "Europe" = "purple", 
                                    "Oceania" = "black", "Global" = "red")) +
      scale_size_manual(values = continent_line) +
      scale_linetype_manual(values = continent_linetype) +
      scale_y_continuous(labels = scales::comma) +
      labs(
        #title = "Median Salary Trend by Continent & Global",
        x = "Year",
        y = "Median Salary (USD)") +
      theme_minimal() +
      theme(
        axis.title = element_text(size=12, face="bold"),
        axis.text = element_text(size=12),
        legend.title = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(size=10),
        legend.key.width = unit(1.5, "cm")
      )
  })
  
  # tab2: table
  react_data_tab4 <- reactive({
    df
  })
  
  # continent median
  final_data <- reactive({
    # continent median
    continent_median <- react_data_tab4() %>%
      group_by(year, continent) %>%
      summarize(median_salary = median(salary_usd)) 
    
    # global median
    global_median <- react_data_tab4() %>%
      group_by(year) %>%
      summarize(median_salary = median(salary_usd)) %>%
      mutate(continent = "Global")
    
    # combine all median
    bind_rows(continent_median, global_median) %>%
      arrange(year)
  })
  
  # tab2: tabset outputs
  output$table_2020 <- DT::renderDataTable({
    final_data() %>% 
      filter(year == 2020) %>% 
      arrange(desc(median_salary)) %>%
      datatable(options = list(dom = 't'))
  })
  
  output$table_2021 <- DT::renderDataTable({
    final_data() %>% 
      filter(year == 2021) %>%
      arrange(desc(median_salary)) %>%
      datatable(options = list(dom = 't'))
  })
  
  output$table_2022 <- DT::renderDataTable({
    final_data() %>% 
      filter(year == 2022) %>% 
      arrange(desc(median_salary)) %>%
      datatable(options = list(dom = 't'))
  })
  
  output$table_2023 <- DT::renderDataTable({
    final_data() %>% 
      filter(year == 2023) %>% 
      arrange(desc(median_salary)) %>%
      datatable(options = list(dom = 't'))
  })
  
  output$table_2024 <- DT::renderDataTable({
    final_data() %>% 
      filter(year == 2024) %>% 
      arrange(desc(median_salary)) %>%
      datatable(options = list(dom = 't'))
  })
  
  
  
  
  ################### tab3: detailed analysis ###################
  # tab3: table
  react_data_tab5 <- reactive({
    df %>%
      filter(year >= input$year[1], 
             year <= input$year[2],
             experience_level %in% input$experience_level,
             job_type %in% input$job_type,
             company_size %in% input$company_size, 
             company_country %in% input$company_country,
             job_category %in% input$job_category
      )
  })
  
  output$table1 <- DT::renderDataTable({
    datatable(react_data_tab5(), 
              options = list(
                scrollX = TRUE,
                autoWidth = TRUE
              ))
  })
}


################################# Run App Here #################################
# Run the app ----
shinyApp(ui = ui, server = server)  # Aggregates the app.