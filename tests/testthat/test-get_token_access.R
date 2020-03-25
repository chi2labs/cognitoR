context("get_token_access")
test_that("To try to get token with incorrect code return false", {
  code <- "incorrect-code"
  config <- get_config()
  expect_false(get_token_access(code, config))
})
