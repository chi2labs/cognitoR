#' Example of ShinyMobile app working with cognitoR authentication.
#' - You need to have correctly configured the config.R for CognitoR.
library(shiny)
library(shinyMobile)
library(cognitoR)
options(shiny.port = 5000)

ui = f7Page(
  cognito_ui("cognito"),
  title = "Chi-square Mobile Demo",
  init = f7Init(skin = "aurora", theme = "light"),
  f7TabLayout(
    navbar = f7Navbar(
      title = "Example shinymobile with cognitoR package",
      hairline = TRUE,
      shadow = TRUE,
      bigger = FALSE,
      left_panel = TRUE,
      right_panel = FALSE
    ),
    panels =  f7Panel(
      title = "Sidebar",
      side = "left",
      theme = "light",
      f7PanelMenu(
        id = "menu"
      ),
      f7Button("logout","Logout")

    ),
    f7Tabs(
      f7Tab(tabName = "tab1",
            uiOutput("cookiecontent"),
            active = TRUE),
      f7Tab(tabName = "tab2",
            div("testing"))
    ),

  )

)

# Shiny APP ####
shinyApp(ui = ui, server = function(input, output, session) {


  cognitomod <- callModule(cognito_server, "cognito")
  logged <- reactiveVal(FALSE)

  observe({
    extLogged <- cognitomod$isLogged
    if(isTRUE(extLogged)){
      logged(TRUE)
    }
  })

  output$cookiecontent <- renderUI({

    req(logged() == TRUE)
    userdata <- cognitomod$userdata
    if (is.list(userdata)) {
      cnames <- names(userdata)
      allvalues <- lapply(cnames, function(name) {
        paste(name, userdata[[name]], sep = " = ")
      })
      content <- paste(allvalues, collapse = "\n")
      f7Block(
        content
      )
    }

  })

  observeEvent(input$logout, {
    shinyjs::alert("Logout in cognito")
    cognitomod$logout()
  })

}
)
