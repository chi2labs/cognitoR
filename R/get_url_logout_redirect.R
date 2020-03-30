#' Get Cognito URL for Logout redirect.
#'
#' Return Url where user is redirect when is logout.
#'
#' @param cognito_config list Obtained with get_cognito_config()
#' @return character|FALSE
#' @author Pablo Pagnone
#' @export
get_url_logout_redirect <- function(cognito_config) {

  if(!is.list(cognito_config) ||
     is.null(cognito_config$base_cognito_url) ||
     is.null(cognito_config$app_client_id) ||
     is.null(cognito_config$redirect_uri_logout)) {
    return(FALSE)
  }

  aws_auth_logout <-paste0(cognito_config$base_cognito_url, "logout?",
                          "client_id=", cognito_config$app_client_id, "&",
                          "logout_uri=", cognito_config$redirect_uri_logout
  )
}
