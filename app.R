# Load Shiny App
library(shiny)
library(fullcalendar)
library(shinythemes)

# Define target reunion date
reunion_date <- as.Date("2025-06-13")


# -----------------------
# UI Layout
# -----------------------

ui <- fluidPage(
  # theme = shinytheme("lumen"),
  # App title at the top
  titlePanel("Countdown to Reunion"),
  # Main layout: sidebar + main content
  sidebarLayout(
    # Sidebar with inputs for countdown and event entry
    sidebarPanel(
      
      h3("Countdown Setup"),  # Small section title
      # Input for reunion date
      dateInput("date", "Select Reunion Date:", value = reunion_date),
      # Button to update countdown
      actionButton("update", "Update Countdown"),  
      tags$hr(),  # Horizontal line separator
      
      # Event input section
      h3("Add Relationship Event"),  # Section title
      textInput("event_name", "Event Name"),  # Input for event name
      # Allow selecting a start and end date for the event
      dateRangeInput("event_dates", "Event Date Range", 
                     start = Sys.Date(), 
                     end = Sys.Date() + 1), 
      checkboxInput("recurring", "Recurring yearly?", FALSE),  # Checkbox for recurring events
      actionButton("add_event", "Add Event"),  # Button to add the event
      tags$hr(),
      
      # Event deletion option
      h3("Delete Event"),
      # Dropdown for choosing event title to delete
      uiOutput("event_selector"),
      # Button to trigger deletion
      actionButton("delete_event", "Delete Selected Event")
      ),
      
    
    # Main panel displays countdown and event table
    mainPanel(
      # Countdown output in large, styled text
      tags$h1(
        textOutput("countdown"),  # Placeholder for countdown message
        style = "font-size: 48px; color: #D81B60; text-align: center;"),  # Styling for the text
      tags$hr(),  # Separator
      
      tags$h2(
        textOutput("live_timer"),
        style = "text-align: center; color: #00796B;"
      ),
      
      # Calendear event table
      h3("Visual Relationship Calendar"),
      fullcalendarOutput("calendar")  # Calendar display area
    )
  )
)
    

# -----------------------
# Server Logic
# -----------------------

server <- function(input, output, session) {
  
  # Reactive variable to store current selected reunion date
  current_date <- reactiveVal(Sys.Date())
  
  # When the update button is clicked, set current_date to user input
  observeEvent(input$update, {
    current_date(input$date)
  })
  
  # Output dynamic countdown message
  output$countdown <- renderText({
    # Calculate difference between target date and today
    days <- as.integer(current_date() - Sys.Date())
    
    # Display appropriate message based on countdown
    if (days > 0) {
      paste(days, "days until we're together again!")
    } else if (days == 0) {
      "Today is the day! TIME TO MEET PPP"
    } else {
      paste("🕰️ It's been", abs(days), "days since your reunion.")
    }
  })
  
  # Live timer countdown with seconds
  output$live_timer <- renderText({
    invalidateLater(1000, session)  # ⏱️ Refresh this every 1 second
    
    # Target reunion time (we assume midnight of selected date)
    target <- as.POSIXct(current_date())  # Midnight of selected day
    
    # Current time
    now <- Sys.time()
    
    # Time difference
    time_left <- difftime(target, now, units = "secs")
    
    # If the target date is in the past
    if (time_left <= 0) return("🎉 We're reunited!")
    
    # Break down the seconds
    seconds <- as.numeric(time_left)
    days <- floor(seconds / 86400)
    hours <- floor((seconds %% 86400) / 3600)
    minutes <- floor((seconds %% 3600) / 60)
    secs <- floor(seconds %% 60)
    
    # Return formatted string
    sprintf("⏳ %d days, %02d hours, %02d minutes, %02d seconds",
            days, hours, minutes, secs)
  })
  
  # Initialize reactive table of events as an empty data frame
  events <- reactiveVal(data.frame(
    title = character(),       # Event name
    start = as.Date(character()),  # Event start date
    end   = as.Date(character()),
    stringsAsFactors = FALSE
  ))
  
  # Handle event creation when 'Add Event' is clicked
  observeEvent(input$add_event, {
    # Make sure the date range is valid and not NULL
    if (is.null(input$event_dates) || length(input$event_dates) < 2) {
      showNotification("Please select a valid date range for the event.", type = "error")
      return(NULL)
    }
    
    # Create new event with both start and end dates
    new_event <- data.frame(
      title = input$event_name,
      start = input$event_dates[1],  # Start of range
      end   = input$event_dates[2],  # End of range
      stringsAsFactors = FALSE
    )
    
    # Combine with existing events
    updated <- rbind(events(), new_event)
    events(updated)  # Update reactive event list
  })
    
  # Dynamically generate a dropdown of event names
  output$event_selector <- renderUI({
    if (nrow(events()) == 0) {
      return(tags$em("No events available to delete."))
    }
    
    selectInput("event_to_delete", "Select an event to delete:",
                choices = events()$title)
  })
  
  # Handle event deletion
  observeEvent(input$delete_event, {
    if (is.null(input$event_to_delete)) {
      showNotification("Please select an event to delete.", type = "error")
      return(NULL)
    }
    
    # Filter out the selected event from the list
    updated <- events()[events()$title != input$event_to_delete, ]
    events(updated)  # Update reactive event list
  })
  
  # Render the fullcalendar using reactive events
  output$calendar <- renderFullcalendar({
    fullcalendar(events())  # Pass event data to calendar
  })
}

# -----------------------
# Run the Shiny App
# -----------------------
shinyApp(ui, server)