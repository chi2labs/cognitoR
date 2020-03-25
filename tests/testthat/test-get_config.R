context("get_config")
test_that("Will be get a list", {
  expect_equal(class(get_config()), 'list')
})
