# #' Get Cognito config from .yml
# #'
# #' Return all required configuration from file .yml to connect with Amazon Cognito instance.
#' @importFrom config get
#' @importFrom rlang .data
# #' @return list|FALSE
# #' @author Pablo Pagnone
get_config <- function() {

  # Get configuration for Cognito Service.
  tryCatch({
    .data$result <- config::get()$cognito

    validate_config(.data$result)

    .data$result
  },
  error = function(e) {
    return(FALSE)
  })

}

validate_config <- function(config) {
    config_names <- names(unlist(config))
    required_names <- c("group_name",
                        "group_id",
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
    return(TRUE)
}
