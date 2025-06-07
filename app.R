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
  sidebarLayout(
    sidebarPanel(
      textInput("new_task", label = "New Task", placeholder = "Type your task here..."),
      actionButton("add", "Add"),
      actionButton("clear", "Clear List")
    ),
    mainPanel(
      uiOutput("task_list")
    )
  )
)
server <- function(input, output, session) {
  # Server logic will be added here
}

shinyApp(ui, server)
