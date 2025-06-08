##
## EPITECH PROJECT, 2024
## ShinyDo
## File description:
## app.R
##

source("R/logic.R")
library(shiny)

ui <- fluidPage(
  titlePanel("Shinydo – My To-Do List"),
  fluidRow(
    column(12, align = "right",
      actionButton("choose_day", "Choose Day"),
      actionButton("delete_task_btn", "Delete Task")
    )
  ),
  sidebarLayout(
    sidebarPanel(
      textInput("new_task", label = "New Task", placeholder = "Type your task here..."),
      actionButton("add", "Add to selected day"),
      actionButton("clear", "Clear All")
    ),
    mainPanel(
      uiOutput("task_list")
    )
  )
)
server <- function(input, output, session) {
  days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  tasks_by_day <- reactiveValues()
  for (day in days) {
    tasks_by_day[[day]] <- character()
  }
  selected_day <- reactiveVal("Monday")
  observeEvent(input$choose_day, {
    showModal(modalDialog(
      title = "Choose a day",
      selectInput("day_select", "Select a day", choices = days, selected = selected_day()),
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cancel"),
        actionButton("confirm_day", "Confirm")
      )
    ))
  })
  observeEvent(input$confirm_day, {
    selected_day(input$day_select)
    removeModal()
  })
  observeEvent(input$add, {
    task <- input$new_task
    if (nzchar(task)) {
      day <- selected_day()
      tasks_by_day[[day]] <- c(tasks_by_day[[day]], task)
    }
  })
  observeEvent(input$clear, {
    for (day in days) {
      tasks_by_day[[day]] <- character()
    }
  })
  observeEvent(input$delete_task_btn, {
    showModal(modalDialog(
      title = "Delete a Task",
      selectInput("delete_day", "Choose a day", choices = days),
      uiOutput("task_selector"),
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cancel"),
        actionButton("confirm_delete", "Delete")
      )
    ))
  })
  output$task_selector <- renderUI({
    day <- input$delete_day
    choices <- tasks_by_day[[day]]
    if (length(choices) == 0) choices <- "No tasks"
    selectInput("task_to_delete", "Select a task to delete", choices = choices)
  })
  observeEvent(input$confirm_delete, {
    day <- input$delete_day
    task <- input$task_to_delete
    tasks_by_day[[day]] <- tasks_by_day[[day]][tasks_by_day[[day]] != task]
    removeModal()
  })
  output$task_list <- renderUI({
    if (all(sapply(days, function(d) length(tasks_by_day[[d]]) == 0))) {
      return(p("No tasks yet."))
    }
    tagList(
      lapply(days, function(day) {
        if (length(tasks_by_day[[day]]) > 0) {
          tagList(
            h4(day),
            tags$ul(
              lapply(tasks_by_day[[day]], function(task) {
                tags$li(task)
              })
            ),
            tags$hr()
          )
        }
      })
    )
  })
}
shinyApp(ui, server)
