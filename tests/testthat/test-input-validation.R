# Migrado de metasurvey-legacy/tests/testthat/test-input-validation.R
# Paquete metasurvey.core

# Input validation layer for exported functions (issues #217 and #218)

# ---- issue #217: .level accepts only auto/implantation/follow_up ----

test_that("step_compute rejects undocumented .level values", {
  svy <- make_test_survey()
  expect_error(
    step_compute(svy, x2 = x * 2, .level = "quarter"),
    "should be one of"
  )
  expect_error(
    step_compute(svy, x2 = x * 2, .level = "month"),
    "should be one of"
  )
})

test_that("step_recode rejects undocumented .level values", {
  svy <- make_test_survey()
  expect_error(
    step_recode(svy, age_cat, age < 40 ~ "young", .level = "quarter"),
    "should be one of"
  )
})

test_that("step_filter rejects undocumented .level values", {
  svy <- make_test_survey()
  expect_error(
    step_filter(svy, age >= 18, .level = "month"),
    "should be one of"
  )
})

test_that("valid .level values still work", {
  svy <- make_test_survey()
  expect_no_error(step_compute(svy, x2 = x * 2, .level = "auto"))
  panel <- make_test_panel()
  expect_no_error(
    step_compute(panel, x2 = x * 2, .level = "implantation")
  )
})

# ---- issue #218: workflow() ----

test_that("workflow auto-wraps a single Survey", {
  svy <- make_test_survey()
  result <- workflow(
    svy,
    survey::svymean(~x),
    estimation_type = "annual"
  )
  expect_s3_class(result, "data.table")
  expect_gte(nrow(result), 1)
})

test_that("workflow rejects non-Survey svy with a clear message", {
  expect_error(
    workflow(3L, survey::svymean(~x)),
    "`svy` in `workflow\\(\\)` must be a Survey"
  )
  expect_error(
    workflow(list(), survey::svymean(~x)),
    "`svy` in `workflow\\(\\)` must be a Survey"
  )
  svy <- make_test_survey()
  expect_error(
    workflow(list(svy, "not a survey"), survey::svymean(~x)),
    "`svy` in `workflow\\(\\)` must be a Survey"
  )
})

test_that("workflow rejects literal (non-call) estimation arguments", {
  svy <- make_test_survey()
  expect_error(
    workflow(list(svy), 3L),
    "`\\.\\.\\.` in `workflow\\(\\)` must contain estimation calls"
  )
})

test_that("workflow requires at least one estimation call", {
  svy <- make_test_survey()
  expect_error(
    workflow(list(svy)),
    "`\\.\\.\\.` in `workflow\\(\\)` must contain at least one estimation call"
  )
})

# ---- issue #218: step_recode() ----

test_that("step_recode requires at least one formula", {
  svy <- make_test_survey()
  expect_error(
    step_recode(svy, 0L),
    "`\\.\\.\\.` in `step_recode\\(\\)` must contain at least one two-sided formula"
  )
})

test_that("step_recode rejects non-formula conditions", {
  svy <- make_test_survey()
  expect_error(
    step_recode(svy, age_cat, "not a formula"),
    "`\\.\\.\\.` in `step_recode\\(\\)` must contain only two-sided formulas"
  )
  expect_error(
    step_recode(svy, age_cat, ~"one sided"),
    "`\\.\\.\\.` in `step_recode\\(\\)` must contain only two-sided formulas"
  )
})

test_that("step_recode still works with valid formulas", {
  svy <- make_test_survey()
  out <- step_recode(
    svy, age_cat,
    age < 40 ~ "young",
    age >= 40 ~ "old",
    .copy = TRUE
  )
  expect_true("age_cat" %in% names(get_data(out)))
})

# ---- issue #218: step_filter() ----

test_that("step_filter rejects atomic literals at registration time", {
  svy <- make_test_survey()
  expect_error(
    step_filter(svy, 0L),
    "`\\.\\.\\.` in `step_filter\\(\\)` must be logical expressions"
  )
  expect_error(
    step_filter(svy, age >= 18, TRUE),
    "`\\.\\.\\.` in `step_filter\\(\\)` must be logical expressions"
  )
})

test_that("step_filter still works with logical expressions", {
  svy <- make_test_survey()
  out <- step_filter(svy, age >= 18, .copy = TRUE)
  out <- bake_steps(out)
  expect_true(all(get_data(out)$age >= 18))
})

# ---- issue #218: step_rename() ----

test_that("step_rename requires named pairs", {
  svy <- make_test_survey()
  expect_error(
    step_rename(svy, c(0, 0)),
    "`\\.\\.\\.` in `step_rename\\(\\)` must be named pairs"
  )
})

test_that("step_rename rejects values that are not variable names", {
  svy <- make_test_survey()
  expect_error(
    step_rename(svy, edad = c(0, 0)),
    "`\\.\\.\\.` in `step_rename\\(\\)` values must be variable names"
  )
})

test_that("step_rename still works with symbols and strings", {
  svy <- make_test_survey()
  out <- step_rename(svy, edad = age, .copy = TRUE)
  out <- bake_steps(out)
  expect_true("edad" %in% names(get_data(out)))

  svy2 <- make_test_survey()
  out2 <- step_rename(svy2, ingreso = "income", .copy = TRUE)
  out2 <- bake_steps(out2)
  expect_true("ingreso" %in% names(get_data(out2)))
})

# ---- issue #218: add_recipe() ----

test_that("add_recipe validates svy and recipe classes", {
  svy <- make_test_survey()
  expect_error(
    add_recipe(svy, 3L),
    "`recipe` in `add_recipe\\(\\)` must be a <Recipe> object"
  )
  r <- make_eco_recipe("test", "user")
  expect_error(
    add_recipe(3L, r),
    "`svy` in `add_recipe\\(\\)` must be a <Survey> object"
  )
  expect_no_error(add_recipe(svy, r))
})

# ---- issue #218: set_data() ----

test_that("set_data validates svy and data classes", {
  svy <- make_test_survey()
  expect_error(
    set_data(svy, "not a data frame"),
    "`data` in `set_data\\(\\)` must be a <data.frame> object"
  )
  expect_error(
    set_data(3L, make_test_data()),
    "`svy` in `set_data\\(\\)` must be a <Survey> object"
  )
  expect_no_error(set_data(svy, make_test_data()))
})

# ---- issue #218: add_weight() ----

test_that("add_weight validates weight specifications", {
  expect_error(
    add_weight(annual = 3L),
    "`annual` in `add_weight\\(\\)` must be a weight variable name"
  )
  expect_error(
    add_weight(monthly = c("w1", "w2")),
    "`monthly` in `add_weight\\(\\)` must be a weight variable name"
  )
  expect_error(
    add_weight(quarterly = ""),
    "`quarterly` in `add_weight\\(\\)` must be a weight variable name"
  )
  expect_identical(add_weight(annual = "w"), list(annual = "w"))
})

# ---- classed error branches flagged by patch coverage (rOpenSci prep) ----

test_that("set_use_copy and set_lazy_processing validate their input", {
  expect_error(set_use_copy("yes"), class = "metasurvey_input_error")
  expect_error(set_use_copy(c(TRUE, FALSE)), class = "metasurvey_input_error")
  expect_error(set_lazy_processing("yes"), class = "metasurvey_input_error")
  expect_error(set_lazy_processing(NULL), class = "metasurvey_input_error")
})

test_that("publish_recipe rejects non-Recipe objects", {
  expect_error(publish_recipe(42), class = "metasurvey_error_recipe")
  expect_error(publish_recipe(list()), class = "metasurvey_error_recipe")
})

test_that("recipe() requires the full metadata set", {
  expect_error(recipe(), class = "metasurvey_error_recipe")
  expect_error(recipe(name = "only-a-name"), class = "metasurvey_error_recipe")
})

test_that("validate_time_pattern needs a type in edition or argument", {
  expect_error(
    validate_time_pattern(svy_type = NULL, svy_edition = "2023"),
    class = "metasurvey_input_error"
  )
})

test_that("validate_weight_time_pattern rejects non-list patterns", {
  svy <- make_test_survey()
  expect_error(
    validate_weight_time_pattern(svy, "w"),
    class = "metasurvey_error_survey"
  )
})

test_that("step_quantile without a weight on an unweighted survey errors", {
  svy <- Survey$new(
    data = data.table::data.table(id = 1:10, x = 1:10),
    edition = "2023",
    type = "ech",
    psu = NULL,
    engine = "data.table",
    weight = NULL
  )
  expect_error(
    step_quantile(svy, xq, x, n = 2),
    class = "metasurvey_error_step"
  )
})

test_that("validate_replicate validates replicate id and pattern specs", {
  dat <- data.table::data.table(id = 1:3, w1 = 1:3, w2 = 4:6)
  f <- tempfile(fileext = ".csv")
  data.table::fwrite(data.table::data.table(id = 1:3, br1 = 1, br2 = 2), f)
  on.exit(unlink(f))
  expect_error(
    validate_replicate(dat, list(replicate_id = 42, replicate_path = f)),
    class = "metasurvey_error_survey"
  )
  expect_error(
    validate_replicate(dat, list(replicate_id = c(zz = "id"), replicate_path = f)),
    class = "metasurvey_error_survey"
  )
  expect_error(
    validate_replicate(
      dat,
      list(replicate_id = c(id = "id"), replicate_path = f, replicate_pattern = 42)
    ),
    class = "metasurvey_error_survey"
  )
  expect_error(
    validate_replicate(
      dat,
      list(replicate_id = c(id = "id"), replicate_path = f, replicate_pattern = "^nomatch")
    ),
    class = "metasurvey_error_survey"
  )
})

test_that("read_recipe falls back to raw steps with a classed warning", {
  r <- recipe(
    name = "X", user = "t",
    svy = survey_empty(type = "ech", edition = "2023"),
    description = "d"
  )
  f <- tempfile(fileext = ".json")
  on.exit(unlink(f))
  save_recipe(r, f)
  j <- jsonlite::read_json(f, simplifyVector = TRUE)
  j$steps <- "step_compute(svy, x = (("
  jsonlite::write_json(j, f, auto_unbox = TRUE)
  expect_warning(read_recipe(f), class = "metasurvey_warning_recipe")
})
