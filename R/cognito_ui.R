#' Cognito Shiny Module UI
#'
#' A Shiny UI function to be used to implement Amazon Cognito in your shiny app.
#' This UI loads the required JS.
#'
#' @param id character - Namespace ID
#' @examples
#' cognito_ui("demo")
#' @return A Shiny UI
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
