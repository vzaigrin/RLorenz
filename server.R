library(shiny)
library(deSolve)
library(plotly)
library(htmltools)
library(htmlwidgets)
library(metricsgraphics)
library(DT)

Lorenz<-function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    dX <- s*(Y-X)
    dY <- X*(r-Z) - Y
    dZ <- X*Y - b*Z
    
    list(c(dX, dY, dZ))
  })
}

shinyServer(function(input, output) {

  parameters <- eventReactive(input$submit, {
    c(s = input$s, r = input$r, b = input$b)
  })
  state <- eventReactive(input$submit, {
    c(X = input$X, Y = input$Y, Z = input$Z)
  })
  times <- eventReactive(input$submit, {
    seq(input$t0, input$t1, by = input$ts)
  })
  
  result <- eventReactive(input$submit, {
    ode(y = state(), times = times(), func = Lorenz,
        parms = parameters(), method = input$method)
  })

 output$mainPlot <- renderPlotly({
   data <- as.data.frame(result())
   mainPlot <- plot_ly(data, x = ~X, y = ~Y, z = ~Z,
                       type = 'scatter3d', mode = 'lines')
   mainPlot$elementId <- NULL
   mainPlot
 })

 output$xPlot <- renderMetricsgraphics({
   x <- as.data.frame(result()[,c("time", "X")])
   x %>% mjs_plot(x=time, y=X) %>%
     mjs_line() %>%
     mjs_labs(x="time", y="X") -> xPlot
   xPlot$elementId <- NULL
   xPlot
 })

 output$yPlot <- renderMetricsgraphics({
   y <- as.data.frame(result()[,c("time", "Y")])
   y %>% mjs_plot(x=time, y=Y) %>%
     mjs_line() %>%
     mjs_labs(x="time", y="Y") -> yPlot
   yPlot$elementId <- NULL
   yPlot
 })

 output$zPlot <- renderMetricsgraphics({
   z <- as.data.frame(result()[,c("time", "Z")])
   z %>% mjs_plot(x=time, y=Z) %>%
     mjs_line() %>%
     mjs_labs(x="time", y="Z") -> zPlot
   zPlot$elementId <- NULL
   zPlot
 })

 output$dataTable <- renderDataTable({
   as.data.frame(result())
 })

})
