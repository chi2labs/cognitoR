context("get_info_user")
test_that("Incorrect token will return FALSE", {
  token <- "incorrect-token"
  config <- get_config()
  expect_false(get_info_user(token, config))
})
