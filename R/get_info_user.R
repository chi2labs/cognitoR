#' Get Cognito Information of user via oauth
#'
#' @param token string You can obtain with get_cognito_token_access()
#' @param cognito_config list List obtained with get_cognito_config()
#' @import config
#' @import httr
#' @return list|FALSE - If request is success return list with info about user. If configuration of token is invalid return FALSE.
#' @author Pablo Pagnone
#' @export
get_info_user <- function(token, cognito_config) {

  if(is.null(cognito_config$base_cognito_url)) {
    return(FALSE)
  }

  request <- GET(url = paste0(cognito_config$base_cognito_url, "oauth2/userInfo"),
                  add_headers(Authorization = paste("Bearer", token)))

  userinfo <- content(request)
  if(!is.null(userinfo$error)){
    return(FALSE)
  }

  return(c(userinfo, list("access_token" = token)))
}
