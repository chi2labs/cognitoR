#' Cookie Shiny Module Server
#'
#'
#' This server module returns a list with methods to interact with cookie created via JS.
#' You have:
#'
#' * getCookie - Reactive function, returns the content of cookie if exist. Else return FALSE.
#' * setCookie - Sets the content for a cookie. (Required param: list())
#' * rmCookie -  Removes a cookie
#' @md
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#' @param cookie_name character - Name of cookie to create
#' @param cookie_expire numeric - Expiration timeof cookie
#' @examples
#' cookie_server(NULL,NULL,NULL)
#' @import shiny
#' @rawNamespace import(shinyjs, except = runExample)
#' @import dplyr
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom base64enc base64encode base64decode
#' @return list of reactive element and function to manage cookies
#' @author Pablo Pagnone
#' @export
cookie_server <- function(input, output, session, cookie_name = "user", cookie_expire = 0.5){

  # Return a reactive element (getCookie) and methods to remove/set cookie ####
  functions <- list(
    # IF cookie exist return the cookie data as list.
    # If cookie dont exist, else return FALSE
    # IF input$cookie was not set yet (initial state), return NULL.
    getCookie = reactive({
      js$getCookie(cookie_name)
      cookiedata <- input$cookie
      if(!is.null(cookiedata) && cookiedata != ""){
        # Decode cookie
        cookiedata <- cookiedata %>%
          base64enc::base64decode() %>%
          rawToChar() %>% jsonlite::fromJSON(cookiedata, TRUE)

      } else {
        if(is.null(cookiedata)){
          # Input is not set to init.
          cookiedata = NULL
        } else {
          cookiedata = FALSE
        }
      }
      cookiedata
    }),
    # Allow remove the cookie.
    rmCookie = function() {
      js$rmCookie(cookie_name)
    },
    # Allow to save data in cookie.
    setCookie = function(data) {
      if(is.list(data) && length(data) > 0){
        # Encode data for cookie (as is done by plumbeR package)
        encodecookie <-  data %>% jsonlite::toJSON() %>% charToRaw() %>% base64enc::base64encode()
        js$setCookie(cookie_name, encodecookie, cookie_expire)
        return(TRUE)
      }
      return(FALSE)
    }
  )
  functions
}
