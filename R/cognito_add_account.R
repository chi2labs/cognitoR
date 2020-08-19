#' Allow create an user in Cognito Pool
#'
#' This method is working with amazing package "paws" , so you need to have the required AWS secret and access key (see example).
#'
#' Also needs to have the config for cognitoR. Specially the pool Id (group_id in config),
#' where the new user is created.
#'
#' @param cognito_config - Cognito Config list
#' @param Username - Username to use in Cognito - This can be a username, email ,phone depending configuration
#' in Amazon Pool.
#' @param UserAttributes - User attributes: This can be multiples attributes, depends of configuration in Amazon Pool.
#' @param DesiredDeliveryMediums - Medium to delivert email when user is created, can be EMAIL or SMS
#' @param ... extra params to pass to method paws::admin_create_user
#' @return boolean
#' @examples
#' \dontrun{
#' Sys.setenv(
#' AWS_ACCESS_KEY_ID = '',
#' AWS_SECRET_ACCESS_KEY = '',
#' AWS_REGION = ''
#' )
#' cognito_add_account("account@mail.com",
#'                     UserAttributes = list(list(Name = "email", Value = "account@mail.com"),
#'                                           list(Name = "phone_number", Value = "+12123212312321")
#'                                      ),
#'                     DesiredDeliveryMediums = "EMAIL"
#'                     )
#' }
#' @import paws
#' @import config
#' @export
cognito_add_account <- function(cognito_config, Username, UserAttributes, DesiredDeliveryMediums, ...){

  if(!is.list(cognito_config) || is.null(cognito_config$group_id)) {
    return(FALSE)
  }

  tryCatch({
    prov <- cognitoidentityprovider()
    user_creation <- prov$admin_create_user(UserPoolId = cognito_config$group_id,
                                            Username = Username,
                                            UserAttributes = UserAttributes,
                                            DesiredDeliveryMediums = DesiredDeliveryMediums,
                                            ...)

    return(user_creation)
  },
  error = function(e){
    warning(e)
    return(FALSE)
  })

}
