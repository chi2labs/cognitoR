library(cognitoR)
ui <- function(request) {
  fluidPage(
    # Load UI Cognito.
    cognito_ui("cognito"),
    uiOutput("slide")
  )
}

server <- function(input, output, session) {

  # Call Cognito module. ####
  cognitomod <- callModule(cognito_server, "cognito")

  observeEvent(cognitomod$isLogged, {
    if (cognitomod$isLogged) {

      output$slide <- renderUI({
        fluidRow(
          sliderInput("n", "Number of observations", 1, nrow(faithful), 100),
          bookmarkButton()
        )

      })

    }
  })

}

enableBookmarking(store = "url")
shinyApp(ui, server)
