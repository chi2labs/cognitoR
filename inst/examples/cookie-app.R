#' App to test the creation/deletion of cookie.
library(cognitoR)

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

  cookiemod <- callModule(cookie_server, "cookietest", cookie_name = "user", cookie_expire = 0.1)

  observeEvent(input$create, {
    shinyjs::alert("Cookie has been created")
    cookiemod$setCookie(list("user" = "test"))
  },ignoreInit = TRUE)

  output$cookiedata <- renderText({
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
