#' Cognito Shiny Module Server
#'
#' A shiny server function to implement Cognito Authentication in your shiny app.
#'
#' @param input - Shiny input
#' @param output - Shiny Output
#' @param session - Shiny Session
#' @param with_cookie - Create a own cookie when is authenticated in Cognito.
#' @param cookiename - name for cookie
#' @param cookie_expire - Expiration time for cookie
#' @import shiny
#' @rawNamespace import(shinyjs, except = runExample)
#' @import httr
#' @importFrom utils URLdecode
#' @return reactiveValues (isLogged and userdata) and a callback function to do logout in Cognito.
#' @author Pablo Pagnone
#' @export
cognito_server <- function(input, output, session, with_cookie = FALSE, cookiename = "cognitor", cookie_expire = 7){

  # Define params for Cognito Login ####
  cognito_config <- get_config()
  if(!is.list(cognito_config)) {
    stop("Your configuration for Cognito Service is not correct.")
  }

  if(with_cookie) {
    # Cookie support enabled.
    cookiemod <- callModule(cookie_server, "cookiemod", cookie_name = cookiename, cookie_expire = cookie_expire)
  }

  # Reactive values that return this module. ####
  return <- reactiveValues(isLogged = FALSE,
                           userdata = FALSE,
                           # Logout callback.
                           logout = function(){
                             if(with_cookie){
                               # Remove cookie
                               cookiemod$rmCookie()
                             }
                             session$sendCustomMessage("redirect", get_url_logout_redirect(cognito_config))
                           })

  observeEvent(return$isLogged, {
    if(return$isLogged == TRUE) {
      # Is logged, hide the cognitor loader.
      runjs("document.getElementById('cognitor_loader').style.display = 'none';")
    }
  })

  observe({

    if(with_cookie) {
      existscookie <- cookiemod$getCookie()
      req(!is.null(existscookie))
      if(!isFALSE(existscookie)){
        return$isLogged <- TRUE
        return$userdata <- existscookie
      }
    }

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
          query_params <- URLdecode(query$state)
        } else {
          query_params <- "?"
        }
        if(!is.null(session$clientData$url_hash)){
          # Keep the url_hash
          query_params <- paste0(query_params, session$clientData$url_hash)
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

          if(with_cookie) {
            # Create cookie
            userdata$access_token <- NULL # Not save token in cookie.
            cookiemod$setCookie(userdata)
          }

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
  }, priority = 100000)

  return
}
