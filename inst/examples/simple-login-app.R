library(cognitoR)
options(shiny.port = 5000)
shinyApp(
  ui = function() {
    fluidPage(
              # Load UI logout
              logout_ui("logout"),
              # Load UI Cognito.
              cognito_ui("cognito"),
              # Output to show some content.
              uiOutput("content"))
  },
  server = function(input, output, session) {

    # Call Cognito module. ####
    cognitomod <- callModule(cognito_server, "cognito")

    # Call Logout module ####
    logoutmod <- callModule(logout_server,
                            "logout",
                            reactive(cognitomod$isLogged),
                            sprintf("You are logged in as '%s'", cognitomod$userdata$email))

    # To Click on button logout of logout module, call logout in cognito module. ####
    observeEvent(logoutmod(),{
      cognitomod$logout()
    })

    # Check if user is already logged, and show a content. ####
    observeEvent(cognitomod$isLogged, {
      if (cognitomod$isLogged) {
        # User is logged
        userdata <- cognitomod$userdata
        # Render user logged.
        output$content <- renderUI({
          p(paste("User: ", unlist(userdata$username)))
        })
      }
    })

  }
)
