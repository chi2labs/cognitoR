#' Cognito Shiny Module Server
#'
#' A shiny server function to implement Cognito Authentication in your shiny app.
#'
#' @param input - Shiny input
#' @param output - Shiny Output
#' @param session - Shiny Session
#' @import shiny
#' @rawNamespace import(shinyjs, except = runExample)
#' @import httr
#' @return reactiveValues (isLogged and userdata) and a callback function to do logout in Cognito.
#' @author Pablo Pagnone
#' @export
cognito_server <- function(input, output, session){

  # Define params for Cognito Login ####
  cognito_config <- get_config()
  if(!is.list(cognito_config)) {
    stop("Your configuration for Cognito Service is not correct.")
  }

  # Reactive values that return this module. ####
  return <- reactiveValues(isLogged = FALSE,
                           userdata = FALSE,
                           # Logout callback.
                           logout = function(){
                             session$sendCustomMessage("redirect", get_url_logout_redirect(cognito_config))
                           })

  observe({

    if(!return$isLogged) {

      # We have support for "authorization code grant" (via code) and "Implicit grant" (via token).
      if(cognito_config$oauth_flow == "code"){
        query <- parseQueryString(session$clientData$url_search)
      }
      if(cognito_config$oauth_flow == "token"){
        query <- parseQueryString(session$clientData$url_hash)
      }

      if(!is.null(query$code) || !is.null(query$`#access_token`)){

        # Recovery params url from Cognito redirection and remove token/code params.
        if(!is.null(query$state) && query$state != ""){
          query_params <- query$state
        } else {
          query_params <- "?"
        }
        session$updateQueryString(query_params, "push")

        token = query$`#access_token`
        if(!is.null(query$code)){
          # Get token with code.
          tokens <- get_token_access(query$code, cognito_config)
          token <- if(is.list(tokens)) tokens$access_token else NULL
        }

        if(!is.null(token)) {

          # Get userdata from Amazon and save in cookie.
          userdata <- get_info_user(token, cognito_config)
          return$isLogged <- TRUE
          return$userdata <- userdata

        } else {

          # User without access, something is happen with token.
          aws_auth_redirect <- get_url_auth_redirect(cognito_config)
          session$sendCustomMessage("redirect", aws_auth_redirect)
        }

      } else {

        aws_auth_redirect <- get_url_auth_redirect(cognito_config)
        session$sendCustomMessage("redirect", aws_auth_redirect)
      }
    }
  },priority = 100000)

  return
}
