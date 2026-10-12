# Migrado de metasurvey-legacy/tests/testthat/test-load-survey-advanced.R
# Paquete metasurvey.core

# Additional tests for load_survey to increase coverage

test_that("load_survey error when no path and no survey args", {
  expect_error(
    load_survey(),
    class = "metasurvey_error_io"
  )
})

test_that("load_survey with bake=TRUE applies recipes", {
  df <- data.table::data.table(
    id = 1:10,
    x = 1:10,
    w = 1
  )

  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  data.table::fwrite(df, tmp)

  svy_empty <- make_test_survey()

  rec <- recipe(
    name = "test recipe",
    user = "tester",
    svy = svy_empty,
    description = "Test recipe with step"
  )

  s <- load_survey(
    path = tmp,
    svy_type = "ech",
    svy_edition = "2023",
    svy_weight = add_weight(annual = "w"),
    recipes = rec,
    bake = TRUE
  )

  expect_s3_class(s, "Survey")
})

test_that("load_survey handles different survey types", {
  df <- data.table::data.table(id = 1:10, w = 1)
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  data.table::fwrite(df, tmp)

  types <- c("ech", "eph", "eai", "eaii")

  for (type in types) {
    s <- load_survey(
      path = tmp,
      svy_type = type,
      svy_edition = "2023",
      svy_weight = add_weight(annual = "w")
    )

    expect_equal(s$type, type)
  }
})

test_that("load_survey handles RDS files", {
  df <- data.table::data.table(id = 1:10, val = rnorm(10), w = 1)
  tmp <- tempfile(fileext = ".rds")
  on.exit(unlink(tmp), add = TRUE)
  saveRDS(df, tmp)
  result <- read_file(tmp)
  expect_true(data.table::is.data.table(result) || is.data.frame(result))
  expect_true("id" %in% names(result))
})

test_that("load_survey handles XLSX files", {
  skip_if_not_installed("openxlsx")
  df <- data.frame(id = 1:10, val = rnorm(10), w = 1)
  tmp <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp), add = TRUE)
  openxlsx::write.xlsx(df, tmp)
  result <- read_file(tmp)
  expect_s3_class(result, "data.frame")
  expect_true("id" %in% names(result))
})

test_that("load_survey handles DTA files", {
  skip_if_not_installed("foreign")
  df <- data.frame(x1 = 1:10, x2 = rnorm(10))
  tmp <- tempfile(fileext = ".dta")
  on.exit(unlink(tmp), add = TRUE)
  foreign::write.dta(df, tmp)
  result <- read_file(tmp, .args = list(file = tmp))
  expect_s3_class(result, "data.frame")
  expect_true("x1" %in% names(result))
})

test_that("load_survey handles SAV files", {
  skip_if_not_installed("foreign")
  skip_if_not_installed("haven")
  df <- data.frame(x1 = 1:10, x2 = rnorm(10))
  tmp <- tempfile(fileext = ".sav")
  on.exit(unlink(tmp), add = TRUE)
  haven::write_sav(df, tmp)
  # foreign::read.spss needs to.data.frame=TRUE for proper data.frame output
  result <- read_file(tmp, .args = list(file = tmp, to.data.frame = TRUE))
  expect_s3_class(result, "data.frame")
  expect_identical(nrow(result), 10L)
})

test_that("read_file handles unsupported extension", {
  tmp <- tempfile(fileext = ".xyz")
  writeLines("test", tmp)
  on.exit(unlink(tmp), add = TRUE)

  expect_error(
    read_file(tmp),
    class = "metasurvey_error_io"
  )
})

test_that("validate_recipe returns FALSE for mismatched type", {
  result <- validate_recipe(
    svy_type = "ech",
    svy_edition = "2023",
    recipe_svy_edition = "2023",
    recipe_svy_type = "eph"
  )

  expect_false(result)
})

test_that("validate_recipe returns FALSE for mismatched edition", {
  result <- validate_recipe(
    svy_type = "ech",
    svy_edition = "2023",
    recipe_svy_edition = "2022",
    recipe_svy_type = "ech"
  )

  expect_false(result)
})

test_that("validate_recipe returns TRUE for matching type and edition", {
  result <- validate_recipe(
    svy_type = "ech",
    svy_edition = "2023",
    recipe_svy_edition = "2023",
    recipe_svy_type = "ech"
  )

  expect_true(result)
})
