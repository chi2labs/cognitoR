#' Logout UI
#' Return a UI with a logout button and information about user logged.
#' By default is hidden and is show with reactive element from logoutServer
#'
#' @param id character
#' @param textbutton character
#' @param classbutton character
#' @import shiny
#' @rawNamespace import(shinyjs, except = runExample)
#' @return Shiny UI
#' @export
logout_ui <- function(id, textbutton = "Log out", classbutton = "btn-logout btn-danger") {
  ns <- NS(id)
  fluidRow(
    uiOutput(ns("who"),inline = TRUE),
    shinyjs::hidden(
      actionButton(ns("logout"),
                   textbutton,
                   class = classbutton,
                   style = "color: white;")
    ),
    style = "margin:8px 0; float:right; display:inline; width:100%; text-align:right; font-size:12px",
    class = "user-logged",
  )
}
