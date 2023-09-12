# #' Get Cognito Information of user via oauth
# #'
# #' @param token string You can obtain with get_cognito_token_access()
# #' @param cognito_config list List obtained with get_cognito_config()
#' @importFrom config get
#' @importFrom httr GET add_headers
# #' @return list|FALSE - If request is success return list with info about user. If configuration of token is invalid return FALSE.
# #' @author Pablo Pagnone
get_info_user <- function(token, cognito_config) {

  if(!is.list(cognito_config) || is.null(cognito_config$base_cognito_url)) {
    return(FALSE)
  }

  tryCatch({
    request <- GET(url = paste0(cognito_config$base_cognito_url, "/oauth2/userInfo"),
                   add_headers(Authorization = paste("Bearer", token)))

    userinfo <- content(request)
    if(!is.null(userinfo$error)){
      stop(userinfo$error)
    }

    return(c(userinfo, list("access_token" = token)))
  },
  error = function(e){
    return(FALSE)
  })

}
