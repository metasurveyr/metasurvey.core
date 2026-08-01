# Condition classes signalled by metasurvey.core

All errors and warnings signalled by metasurvey.core are classed
conditions: they carry a domain-specific subclass plus the package-wide
base class (`"metasurvey_error"` or `"metasurvey_warning"`), so you can
handle them with
[`tryCatch()`](https://rdrr.io/r/base/conditions.html)/[`withCallingHandlers()`](https://rdrr.io/r/base/conditions.html)
without matching message text.

## Value

No return value. This topic documents the condition classes signalled by
metasurvey.core; catch them with
[`tryCatch()`](https://rdrr.io/r/base/conditions.html) or
[`withCallingHandlers()`](https://rdrr.io/r/base/conditions.html) as
shown in the examples.

## Error classes

Every error carries `"metasurvey_error"` plus one of:

- `metasurvey_input_error`:

  An argument of an exported function failed input validation (wrong
  type, wrong class, missing value).

- `metasurvey_error_step`:

  A step could not be created or baked (unknown step type, missing
  variables, failed
  [`step_validate()`](https://metasurveyr.github.io/metasurvey.core/reference/step_validate.md)
  checks with `.action = "stop"`).

- `metasurvey_error_recipe`:

  A recipe is invalid or cannot be applied (missing metadata, unmet
  variable dependencies, dependency cycles).

- `metasurvey_error_workflow`:

  A workflow object or a
  [`workflow()`](https://metasurveyr.github.io/metasurvey.core/reference/workflow.md)
  estimation is invalid.

- `metasurvey_error_panel`:

  A rotating-panel operation failed (inconsistent waves, invalid
  extraction).

- `metasurvey_error_survey`:

  A survey-level operation failed (design construction, weight or
  replicate specification).

- `metasurvey_error_engine`:

  The requested processing engine is not supported or not installed.

- `metasurvey_error_io`:

  A file could not be loaded (unsupported format, missing reader
  package, failed download).

- `metasurvey_error_backend`:

  A recipe/workflow backend operation failed.

- `metasurvey_error_backend_unavailable`:

  The `"api"` backend was selected but no provider is registered (also
  carries `metasurvey_error_backend`). Install a provider package such
  as `metasurvey.explorer.backend`.

## Warning classes

Every warning carries `"metasurvey_warning"` plus one of
`metasurvey_warning_step`, `metasurvey_warning_recipe`,
`metasurvey_warning_workflow`, `metasurvey_warning_panel`,
`metasurvey_warning_survey`, `metasurvey_warning_engine` or
`metasurvey_warning_backend`, following the same domains as the error
classes.

## Examples

``` r
# Catch any metasurvey error by its base class
tryCatch(
  set_engine("not-an-engine"),
  metasurvey_error = function(e) message("caught: ", conditionMessage(e))
)
#> caught: Engine 'not-an-engine' is not supported. Available: data.table,
#> tidyverse, dplyr

# Or target a specific domain
tryCatch(
  set_engine("not-an-engine"),
  metasurvey_error_engine = function(e) "engine problem"
)
#> [1] "engine problem"
```
