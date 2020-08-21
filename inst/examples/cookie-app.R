#' App to test the creation/deletion of cookie.
library(cognitoR)
library(shiny)
library(shinyjs)

# Shiny APP ####
shinyApp(ui = function(){
  fluidPage(
    cookie_ui("cookietest"),
    fluidRow(
      h2("Try to create and remove cookie."),
      actionButton("create", "Create a cookie"),
      actionButton("remove", "Remove Cookie")
    ),
    br(),
    fluidRow(
      h2("Cookie content"),
      uiOutput("cookiedata"),
    )
  )
},
server = function(input, output, session) {

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

  observeEvent(input$create, {
    shinyjs::alert("Cookie has been created")
    cookiemod$setCookie(list("user" = "test"))
  },ignoreInit = TRUE)

  output$cookiedata <- renderText({

    req(with_cookie() == TRUE)
    existscookie <- cookiemod$getCookie()
    if(is.null(existscookie)){
      "Click on 'create' button to create a cookie"
    }
    if (is.list(existscookie)) {
      cnames <- names(existscookie)
      allvalues <- lapply(cnames, function(name) {
        paste(name, existscookie[[name]], sep = " = ")
      })
      paste(allvalues, collapse = "\n")
    }
  })

  observeEvent(input$remove, {
    shinyjs::alert("Cookie has been removed.")
    cookiemod$rmCookie()
  },ignoreInit = TRUE)

}
)
