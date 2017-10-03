library(shiny)
library(shinydashboard)
library(plotly)
library(metricsgraphics)
library(DT)

dashboardPage(
  dashboardHeader(title = "Lorenz system"),

  dashboardSidebar(
    h4("Parameters"),
    numericInput("s", label = "s", value = 10, step = 0.01),
    numericInput("r", label = "r", value = 28, step = 0.01),
    numericInput("b", label = "b", value = 8/3, step = 0.01),
    hr(),
    h4("Initial values"),
    numericInput("X", label = "X0", value = 1, step = 0.01),
    numericInput("Y", label = "Y0", value = 1, step = 0.01),
    numericInput("Z", label = "Z0", value = 1, step = 0.01),
    hr(),
    h4("Time range"),
    numericInput("t0", label = "Start", value = 0),
    numericInput("t1", label = "Stop", value = 100),
    numericInput("ts", label = "Step", value = 0.01, step = 0.01),
    hr(),
    selectInput("method", label = "Method",
                choices = list("lsoda" = "lsoda", "lsode" = "lsode", 
                               "lsodes" = "lsodes", "lsodar" = "lsodar",
                               "vode" = "vode", "daspk" = "daspk",
                               "euler" = "euler", "rk4" = "rk4",
                               "ode23" = "ode23", "ode45" = "ode45",
                               "radau" = "radau", "bdf" = "bdf",
                               "bdf_d" = "bdf_d", "adams" = "adams",
                               "impAdams" = "impAdams",
                               "impAdams_d" = "impAdams_d"),
                selected = "lsoda"),
    hr(),
    actionButton("submit", "Submit")
  ),

  dashboardBody(
    fluidRow(
      box(title = "Description", status = "info", width = 12, solidHeader = TRUE, withMathJax(),
          HTML("The model is a system of three ordinary differential equations
               now known as the Lorenz equations:
               $$\\begin{cases}
                   \\dot{x} = s \\cdot (y - x)\\\\
                   \\dot{y} = x \\cdot (r - z) - y\\\\
                   \\dot{z} = x \\cdot y - b \\cdot z
                 \\end{cases}$$
               <P>Enter parameters, initial values, time range and select computation method for ODE")
         )
    ),
    fluidRow(
      box(title = "Result", status = "success", width = 12, height = 600, solidHeader = TRUE,
        tabBox(width = 12, height = 500,
          tabPanel("3D", plotlyOutput("mainPlot")),
          tabPanel("X Plot", metricsgraphicsOutput("xPlot")),
          tabPanel("Y Plot", metricsgraphicsOutput("yPlot")),
          tabPanel("Z Plot", metricsgraphicsOutput("zPlot")),
          tabPanel("Data Table", dataTableOutput("dataTable"))
        )
      )
    )
  )
)
