context("get_url_auth_redirect")
test_that("Return the auth url when the configuration file is correct.", {
  config <- get_config()
  expect_equal(class(get_url_auth_redirect(config)), 'character')
})

test_that("Return FALSE when try to get the auth url with an incorrect configuration file", {
  config <- list()
  expect_false(get_url_auth_redirect(config))
})
