# Paquete metasurvey.core
# Classed condition system: every error/warning carries a domain subclass
# plus the package-wide base class (see R/conditions.R and the
# ?metasurvey_conditions topic).

# ---- helpers ----

test_that("msvy_abort appends the metasurvey_error base class", {
  cnd <- tryCatch(
    msvy_abort("boom", class = "metasurvey_error_step"),
    error = function(e) e
  )
  expect_s3_class(cnd, "metasurvey_error_step")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("msvy_warn appends the metasurvey_warning base class", {
  cnd <- tryCatch(
    msvy_warn("careful", class = "metasurvey_warning_step"),
    warning = function(w) w
  )
  expect_s3_class(cnd, "metasurvey_warning_step")
  expect_s3_class(cnd, "metasurvey_warning")
})

test_that("msvy_abort treats braces in messages as literal text", {
  cnd <- tryCatch(
    msvy_abort(
      "deparsed code: if (x) {y} else {z}",
      class = "metasurvey_error_step"
    ),
    error = function(e) e
  )
  expect_match(
    conditionMessage(cnd),
    "if (x) {y} else {z}",
    fixed = TRUE
  )
})

test_that("stop_input signals a classed input error, message unchanged", {
  cnd <- tryCatch(
    stop_input(
      "my_fn", "my_arg", "must be a thing",
      got = "<numeric>"
    ),
    error = function(e) e
  )
  expect_s3_class(cnd, "metasurvey_input_error")
  expect_s3_class(cnd, "metasurvey_error")
  expect_identical(
    conditionMessage(cnd),
    "`my_arg` in `my_fn()` must be a thing; got <numeric>"
  )
})

# ---- representative sample of domain classes via the public API ----

test_that("input validation errors carry metasurvey_input_error", {
  cnd <- tryCatch(add_weight(annual = 3L), error = function(e) e)
  expect_s3_class(cnd, "metasurvey_input_error")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("engine errors carry metasurvey_error_engine", {
  cnd <- tryCatch(set_engine("__not_an_engine__"), error = function(e) e)
  expect_s3_class(cnd, "metasurvey_error_engine")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("survey loading errors carry metasurvey_error_io", {
  cnd <- tryCatch(load_survey(), error = function(e) e)
  expect_s3_class(cnd, "metasurvey_error_io")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("step errors carry metasurvey_error_step", {
  svy <- make_test_survey()
  cnd <- tryCatch(step_filter(svy), error = function(e) e)
  expect_s3_class(cnd, "metasurvey_error_step")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("recipe errors carry metasurvey_error_recipe", {
  cnd <- tryCatch(
    RecipeCategory$new(name = "", description = "d"),
    error = function(e) e
  )
  expect_s3_class(cnd, "metasurvey_error_recipe")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("workflow errors carry metasurvey_error_workflow", {
  cnd <- tryCatch(
    save_workflow(list(name = "fake"), tempfile()),
    error = function(e) e
  )
  expect_s3_class(cnd, "metasurvey_error_workflow")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("panel errors carry metasurvey_error_panel", {
  cnd <- tryCatch(get_implantation("not a panel"), error = function(e) e)
  expect_s3_class(cnd, "metasurvey_error_panel")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("backend errors carry metasurvey_error_backend", {
  cnd <- tryCatch(set_backend("__bogus__"), error = function(e) e)
  expect_s3_class(cnd, "metasurvey_error_backend")
  expect_s3_class(cnd, "metasurvey_error")
})

test_that("api backend without provider signals backend_unavailable", {
  old <- options(metasurvey.backend_provider = NULL)
  on.exit(options(old), add = TRUE)
  cnd <- tryCatch(
    .backend_api_call("list_recipes"),
    error = function(e) e
  )
  expect_s3_class(cnd, "metasurvey_error_backend_unavailable")
  expect_s3_class(cnd, "metasurvey_error_backend")
  expect_s3_class(cnd, "metasurvey_error")
  expect_match(conditionMessage(cnd), "metasurvey.explorer.backend")
})

test_that("step warnings carry metasurvey_warning_step", {
  svy <- make_test_survey()
  cnd <- tryCatch(
    step_remove(svy, vars = "__not_a_var__"),
    warning = function(w) w
  )
  expect_s3_class(cnd, "metasurvey_warning_step")
  expect_s3_class(cnd, "metasurvey_warning")
})
