#' Cookie Shiny Module UI
#'
#' This UI module load the required js methods to create/remove/get cookie in browser.
#'
#' @param id character
#' @examples
#' cookie_ui("cookie")
#' @rawNamespace import(shinyjs, except = runExample)
#' @rawNamespace import(shinyjs, except = runExample)
#' @return a Shiny UI
#' @export
cookie_ui <-function(id){

  ns <- shiny::NS(id)
  # JS from module (Jquery library js.cookie.js) ####
  addResourcePath("cognitoR", system.file("", package = "cognitoR"))
  # Define JS functions to cookies manage ####
  jsCode <- paste0('shinyjs.getCookie = function(params) {
                        //console.log("Returning cookie");
                        cookiename = "user";
                        if(typeof params[0] === "string"){
                          cookiename = params[0];
                        }
                        var my_cookie = Cookies.get(cookiename);
                        if(my_cookie == undefined) {
                          my_cookie = "";
                        }
                        Shiny.onInputChange("',ns("cookie"),'", my_cookie);
                      }
                      shinyjs.setCookie = function(params) {
                        //console.log("Set cookie");
                        cookiename = "user";
                        if(typeof params[0] === "string"){
                          cookiename = params[0];
                        }
                        cookiecontent = "";
                        if(typeof params[1] === "string"){
                          cookiecontent = params[1];
                        }
                        cookietime = 0.5;
                        if(typeof params[2] === "number"){
                          cookietime = params[2];
                        }
                        Cookies.set(cookiename, cookiecontent, {expires: cookietime});
                        Shiny.onInputChange("',ns("cookie"),'", params[1]);
                      }
                      shinyjs.rmCookie = function(params) {
                        //console.log("Removing cookie");
                        cookiename = "user";
                        if(typeof params[0] === "string"){
                          cookiename = params[0];
                        }
                        Cookies.remove(cookiename);
                        Shiny.onInputChange("',ns("cookie"),'", "");
                      }')
  fluidPage(
    shinyjs::useShinyjs(),
    tags$head(tags$script(src="cognitoR/js/jscookie/js.cookie.js")),
    extendShinyjs(text = jsCode, functions = c("getCookie", "setCookie", "rmCookie"))
  )
}
