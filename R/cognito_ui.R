#' Cognito UI
#' Offer a authentication with Amazon Cognito
#' This UI load the required JS.
#'
#' @param id character - Namespace ID
#' @param logout_btn character - Text for Logout Button
#' @param logout_btn_class character - Class for logout button
#' @import shiny
#' @rawNamespace import(shinyjs, except = runExample)
#' @export
cognito_ui <- function(id, logout_btn = "Log out", logout_btn_class = "btn-danger btn-cognito-logout"){
  ns <- NS(id)
  jscode <- "Shiny.addCustomMessageHandler('redirect', function(url) { window.location = url;});"
  fluidRow(
    shinyjs::useShinyjs(),
    tags$head(tags$script(jscode))
  )
}
