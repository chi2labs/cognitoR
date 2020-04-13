# #' Get Cognito config from .yml
# #'
# #' Return all required configuration from file .yml to connect with Amazon Cognito instance.
# #' @import config
# #' @return list|FALSE
# #' @author Pablo Pagnone
get_config <- function() {

  # Get configuration for Cognito Service.
  tryCatch({
    result <- config::get()$cognito
    config_names <- names(unlist(result))
    required_names <- c("group_name",
                        "oauth_flow",
                        "base_cognito_url",
                        "app_client_id",
                        "redirect_uri",
                        "redirect_uri_logout",
                        "app_client_secret")

    missing_args <- setdiff(required_names, config_names)

    if(length(missing_args) > 0 || isFALSE(result$oauth_flow %in% c("code", "token"))) {
      stop("Missing params in config")
    }
    result
  },
  error = function(e) {
    return(FALSE)
  })

}
