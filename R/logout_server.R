#' Logout Shiny Module Server
#'
#' Receive a reactive element (isLogged), when is TRUE the logout button and information about is shown.
#'
#' @param input Shiny input
#' @param output Shiny output
#' @param session Shiny session
#' @param isLogged reactive
#' @param textlogged character
#' @import shiny
#' @rawNamespace import(shinyjs, except = runExample)
#' @return reactive (the logout button)
#' @export
logout_server <- function(input,
                          output,
                          session,
                          isLogged = reactive(FALSE),
                          textlogged = "You are logged in") {

  observeEvent(isLogged(), {
    if(isLogged()){
      shinyjs::show("logout")

    } else {
      shinyjs::hide("logout")
    }
  })

  output$who <- renderUI({
    if(isLogged()){
      textlogged
    }
  })

  reactive(input$logout)
}
