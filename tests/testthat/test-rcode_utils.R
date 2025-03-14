testthat::test_that("With no teal.load_nest_code option set get_rcode_str_install returns default string", {
  withr::with_options(
    list(teal.load_nest_code = NULL),
    testthat::expect_equal(get_rcode_str_install(), "# Add any code to install/load your NEST environment here\n")
  )
})


testthat::test_that("With teal.load_nest_code option set to character get_rcode_str_install returns option value", {
  withr::with_options(
    list(teal.load_nest_code = "code_here()"),
    testthat::expect_equal(get_rcode_str_install(), "code_here()")
  )


  withr::with_options(
    list(teal.load_nest_code = c("code_here()", "and_here()")),
    testthat::expect_equal(get_rcode_str_install(), c("code_here()", "and_here()"))
  )
})


testthat::test_that("With teal.load_nest_code option is not character get_rcode_str_install (silently) returns
          default string", {
  withr::with_options(
    list(teal.load_nest_code = TRUE),
    testthat::expect_equal(get_rcode_str_install(), "# Add any code to install/load your NEST environment here\n")
  )


  withr::with_options(
    list(teal.load_nest_code = list(x = "boo")),
    testthat::expect_equal(get_rcode_str_install(), "# Add any code to install/load your NEST environment here\n")
  )
})


testthat::test_that("get_rcode_libraries returns current session packages", {
  testthat::expect_true(
    setequal(
      strsplit(gsub("library\\(|\\)", "", get_rcode_libraries()), "\n")[[1]],
      vapply(sessionInfo()$otherPkgs, FUN = `[[`, index = "Package", FUN.VALUE = character(1), USE.NAMES = FALSE)
    )
  )
})

testthat::test_that("get_datasets_code returns code only for specified datanames", {
  datasets <- teal.slice::init_filtered_data(
    teal.data::teal_data(
      teal.data::dataset("IRIS", x = iris, code = "IRIS <- iris"),
      teal.data::dataset("MTCARS", x = mtcars, code = "MTCARS <- mtcars")
    )
  )

  hashes <- calculate_hashes(datasets$datanames(), datasets)
  testthat::expect_true(
    !grepl(
      "mtcars",
      paste(get_datasets_code(datasets = datasets, dataname = "IRIS", hashes = hashes), collapse = "\n"),
      ignore.case = TRUE
    ) &&
      grepl(
        "iris",
        paste(get_datasets_code(datasets = datasets, dataname = "IRIS", hashes = hashes), collapse = "\n"),
        ignore.case = TRUE
      )
  )
})
