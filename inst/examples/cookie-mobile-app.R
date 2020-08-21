#' Example of ShinyMobile app working with cognitoR authentication.
#' - You need to have correctly configured the config.R for CognitoR.
library(shiny)
library(shinyMobile)
library(shinyjs)
library(cognitoR)
#options(shiny.port = 5000)

ui = f7Page(
  cookie_ui("cookietest"),
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
      f7Button("create","Create cookie"),
      f7Button("remove","Remove")

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


           cookiemod <- callModule(cookie_server, "cookietest")
           with_cookie <- reactiveVal(FALSE)

           observe({

             existscookie <- cookiemod$getCookie()
             req(!is.null(existscookie))
             if(isFALSE(existscookie)){
             } else {
               with_cookie(TRUE)
             }
           })

           output$cookiecontent <- renderUI({

             req(with_cookie() == TRUE)
             existscookie <- cookiemod$getCookie()
             if (is.list(existscookie)) {
               cnames <- names(existscookie)
               allvalues <- lapply(cnames, function(name) {
                 paste(name, existscookie[[name]], sep = " = ")
               })
               content <- paste(allvalues, collapse = "\n")
               f7Block(
                 content
               )
             }

           })

           observeEvent(input$create, {
             shinyjs::alert("Cookie has been created")
             cookiemod$setCookie(list("user" = "test"))
           },ignoreInit = TRUE)

           observeEvent(input$remove, {
             shinyjs::alert("Cookie has been removed.")
             cookiemod$rmCookie()
           })

         }
)
