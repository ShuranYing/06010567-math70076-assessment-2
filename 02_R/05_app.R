# app.R
library(shiny)
library(tidyverse)
library(plotly)
library(here)
library(readr)
library(ggplot2)
library(fmsb)

# Load dataset
df <- read_csv(here("01_data", "clean", "merged_clean.csv"))

# UI
ui <- fluidPage(
  titlePanel("Global Education and Fertility Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select Country:",
                  choices = unique(df$country),
                  selected = "China"),
      sliderInput("map_year", "Select Year for GeoMap, Radar & Summary:",
                  min = 2000, max = 2023, value = 2023, step = 1, sep = ""),
      checkboxInput("show_prediction", "Show Linear Trend on Plot", value = TRUE),
      hr(),
      numericInput("sim_edu", "Education (% upper secondary)", value = 50, min = 0, max = 100),
      numericInput("sim_contra", "Contraceptive prevalence (%)", value = 60, min = 0, max = 100),
      numericInput("sim_gii", "Gender Inequality Index", value = 0.3, min = 0, max = 1),
      numericInput("sim_prf", "Parliamentary Seats (% female)", value = 25, min = 0, max = 100),
      hr(),
      h4("Forecast for 2024–2026"),
      actionButton("forecast_btn", "Run Forecast"),
      verbatimTextOutput("forecast_result")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Scatter Plot", plotlyOutput("trendPlot")),
        tabPanel("GeoMap", plotlyOutput("mapPlot")),
        tabPanel("Radar Profile", plotlyOutput("radarPlot")),
        tabPanel("Summary", tableOutput("summaryStats"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  data_filtered <- reactive({
    df %>% filter(country == input$country)
  })
  
  output$trendPlot <- renderPlotly({
    p <- ggplot(data_filtered(), aes(x = edu_upper, y = fertility)) +
      geom_point(color = "#2c3e50") +
      labs(x = "Female Upper Secondary (%)", y = "Fertility Rate",
           title = paste("Fertility vs. Education in", input$country)) +
      theme_minimal()
    
    if (input$show_prediction) {
      p <- p + geom_smooth(method = "lm", se = FALSE, color = "red")
    }
    ggplotly(p)
  })
  
  output$mapPlot <- renderPlotly({
    map_data <- df %>%
      filter(year == input$map_year, !is.na(edu_upper)) %>%
      group_by(iso3c) %>%
      summarise(edu_upper = mean(edu_upper, na.rm = TRUE),
                country = first(country))
    
    plot_geo(map_data) %>%
      add_trace(
        z = ~edu_upper, color = ~edu_upper, colors = "Blues",
        text = ~country, locations = ~iso3c, locationmode = 'ISO-3'
      ) %>%
      colorbar(title = "Education (%)") %>%
      layout(title = paste("Female Upper Secondary Education in", input$map_year))
  })
  
  output$summaryStats <- renderTable({
    df %>%
      filter(country == input$country, year == input$map_year) %>%
      summarise(
        `Fertility Rate` = mean(fertility, na.rm = TRUE),
        `Upper Secondary Education (%)` = mean(edu_upper, na.rm = TRUE),
        `Gender Inequality Index` = gii,
        `Expected Years of Schooling` = eys_f,
        `Maternal Mortality Ratio` = mmr,
        `Female Parliamentary Seats (%)` = pr_f
      )
  })
  
  observeEvent(input$forecast_btn, {
    model_all <- lm(fertility ~ year + income * edu_upper + contraceptive + gii + pr_f, data = df)
    selected_row <- df %>% filter(country == input$country, year == max(year)) %>% slice(1)
    if (nrow(selected_row) == 0) {
      output$forecast_result <- renderText("No baseline data for this country.")
      return()
    }
    
    new_forecast <- tibble(
      year = 2024:2026,
      income = selected_row$income,
      edu_upper = input$sim_edu,
      contraceptive = input$sim_contra,
      gii = input$sim_gii,
      pr_f = input$sim_prf
    )
    forecasted <- predict(model_all, newdata = new_forecast)
    output$forecast_result <- renderText({
      paste0("Forecasted fertility:
",
             "2024: ", round(forecasted[1], 2), "
",
"2025: ", round(forecasted[2], 2), "
",
"2026: ", round(forecasted[3], 2))
    })
  })
  
  output$radarPlot <- renderPlotly({
    country_data <- df %>%
      filter(country == input$country, year == input$map_year) %>%
      select(gii, pr_f, mmr, eys_f) %>%
      mutate(across(everything(), ~ replace_na(., 0)))
    
    radar_df <- rbind(rep(100, 4), rep(0, 4), as.numeric(country_data))
    colnames(radar_df) <- c("GII", "PR_F", "MMR", "EYS_F")
    radar_df <- as.data.frame(radar_df)
    
    plot_ly(
      type = 'scatterpolar',
      r = unlist(radar_df[3,]),
      theta = colnames(radar_df),
      fill = 'toself'
    ) %>%
      layout(
        polar = list(radialaxis = list(visible = TRUE, range = c(0, 100))),
        showlegend = FALSE,
        title = paste("Socio-Health Radar for", input$country, "in", input$map_year)
      )
  })
}

# Run app
shinyApp(ui = ui, server = server)
