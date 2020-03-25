context("get_url_logout_redirect")
test_that("Return the logout url when the configuration file is correct.", {
  config <- get_config()
  expect_equal(class(get_url_logout_redirect(config)), 'character')
})

test_that("Return FALSE when try to get the logout url with an incorrect configuration file", {
  config <- list()
  expect_false(get_url_logout_redirect(config))
})
