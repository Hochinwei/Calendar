# README


# Countdown to Reunion - simple Shiny Calendar App

## Overview

Being an international student, I wanted a way to easily see when is the next time I will physically see my lover. I coded this simple interactice Shiny web app to practice developing a Shiny app that I can use visually track, manage, and celebrate important relationship events leading up to our ultimate day of reunion.

I added simple features so that we could plan long-distance meet-ups and milestone celebrations to easily use as a reminder of the small wins we can celebrate. You can also fork this repo for your personal use, or just to understand how it works

------------------------------------------------------------------------

## Features

### 🔢 Live Countdown Timer

-   Tracks the number of days until a reunion date of your choice.
-   Displays a real-time second-by-second countdown for extra excitement.
-   Adapts dynamically based on whether the date is upcoming, current, or past.

### 📝 Add Custom Events

-   Add personalized relationship events (e.g., anniversaries, video calls, shared memories).
-   Specify a date range and optionally mark the event as annually recurring.
-   All events are visually displayed on a calendar view using `fullcalendar`.

### 🗑️ Manage Events

-   Delete individual events using a dropdown selector.
-   All changes instantly update the full calendar display.

### 📅 Full Calendar View

-   Integrated `fullcalendar` widget shows all relationship events.
-   Responsive and interactive layout for viewing your timeline visually.

------------------------------------------------------------------------

## How to Use

1.  **Set Your Reunion Date:**
    -   Use the date picker in the sidebar to choose your target date.
    -   Click “Update Countdown” to activate the countdown.
2.  **Add Events:**
    -   Enter an event name and choose a date range.
    -   Tick the “Recurring yearly?” box if applicable.
    -   Click “Add Event” to save.
3.  **Delete Events:**
    -   Select an event title from the dropdown.
    -   Click “Delete Selected Event” to remove it.
4.  **View and Interact:**
    -   The main panel shows the countdown and visual calendar.
    -   Enjoy a real-time emotional dashboard as the reunion date approaches.

------------------------------------------------------------------------

## Tech Stack

-   **Frontend:** Shiny UI with `shinythemes` and `fullcalendar`
-   **Backend:** Reactive `R` server logic using `reactiveVal` and observers
-   **Libraries:** `shiny`, `fullcalendar`, `shinythemes`

------------------------------------------------------------------------

## Running the App

To run this app locally, make sure you have R and the necessary packages installed:

``` r
# Install packages if needed
install.packages(c("shiny", "fullcalendar", "shinythemes"))

# Run the app
shiny::runApp("path/to/your/app/folder")
```
