# #' Get Cognito URL for authentication redirect
# #'
# #' Return Url where user is redirect if is not logged yet.
# #'
# #' @param cognito_config list Obtained with get_cognito_config()
# #' @param session Shiny session Will be used to keep the params in urls when redirection is done.
# #' @return character|FALSE
# #' @author Pablo Pagnone
get_url_auth_redirect <- function(cognito_config, session = getDefaultReactiveDomain()) {

  if(!is.list(cognito_config) ||
     is.null(cognito_config$base_cognito_url) ||
     is.null(cognito_config$oauth_flow) ||
     is.null(cognito_config$app_client_id) ||
     is.null(cognito_config$redirect_uri)) {
    return(FALSE)
  }

  # Take params from url and encode for send to Cognito as param.
  # These params will be returned in "status" param from Cognitor redirection.
  params = ""

  # params = ""
  # if(!is.null(session) && !is.null(session[["clientData"]]$url_pathname) && session[["clientData"]]$url_pathname != "") {
  #   params <- session[["clientData"]]$url_pathname
  # }

  if(!is.null(session) && session[["clientData"]]$url_search != "") {
    params <- paste0(params, utils::URLencode(session[["clientData"]]$url_search, TRUE))
  }
  if(!is.null(session) && session[["clientData"]]$url_hash != "") {
    params <- paste0(params, utils::URLencode(session[["clientData"]]$url_hash, TRUE))
  }

  aws_auth_redirect <- paste0(cognito_config$base_cognito_url,
                              "/oauth2/authorize?", "scope=openid", "&",
                              "response_type=",cognito_config$oauth_flow,"&",
                              "client_id=", cognito_config$app_client_id, "&",
                              "redirect_uri=", cognito_config$redirect_uri, "&",
                              paste0("state=", params)
  )
}
