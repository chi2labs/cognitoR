#' Cognito Shiny Module UI
#'
#' Is a Shiny UI function to be used if you want to implement Amazon Cognito in your shiny app.
#' This UI load the required JS.
#'
#' @param id character - Namespace ID
#' @import shiny
#' @rawNamespace import(shinyjs, except = runExample)
#' @author Pablo Pagnone
#' @export
cognito_ui <- function(id){
  ns <- NS(id)
  jscode <- "Shiny.addCustomMessageHandler('redirect', function(url) { window.location = url;});"
  fluidRow(
    shinyjs::useShinyjs(),
    tags$head(tags$script(jscode))
  )
}
