# Options used by metasurvey.core

All behavior toggles of metasurvey.core are controlled through R
[`options()`](https://rdrr.io/r/base/options.html) under the
`metasurvey.` prefix. None of them needs to be set explicitly: every
option has a working default.

## Value

No return value. This topic documents the global options recognised by
metasurvey.core and their defaults.

## Options

- `metasurvey.engine`:

  Character. Data-processing engine used when loading surveys. Default
  `"data.table"` (set on load). Change it with
  [`set_engine()`](https://metasurveyr.github.io/metasurvey.core/reference/set_engine.md);
  see
  [`show_engines()`](https://metasurveyr.github.io/metasurvey.core/reference/show_engines.md)
  for the available engines.

- `metasurvey.lazy_processing`:

  Logical, default `TRUE`. When `TRUE`, `step_*()` functions record
  transformations without executing them until
  [`bake_steps()`](https://metasurveyr.github.io/metasurvey.core/reference/bake_steps.md)
  is called. Set with
  [`set_lazy_processing()`](https://metasurveyr.github.io/metasurvey.core/reference/set_lazy_processing.md);
  query with
  [`lazy_default()`](https://metasurveyr.github.io/metasurvey.core/reference/lazy_default.md).

- `metasurvey.use_copy`:

  Logical, default `TRUE`. When `TRUE`, steps operate on a copy of the
  survey so the original object is never modified in place. Set with
  [`set_use_copy()`](https://metasurveyr.github.io/metasurvey.core/reference/set_use_copy.md);
  query with
  [`use_copy_default()`](https://metasurveyr.github.io/metasurvey.core/reference/use_copy_default.md).

- `metasurvey.verbose`:

  Logical, default `TRUE`. Gates all informational messages emitted by
  the package. Set it to `FALSE` to silence them; errors and warnings
  are not affected.

- `metasurvey.backend`:

  A `RecipeBackend` object holding the active recipe backend. Unset by
  default (an in-memory local backend is used). Configure with
  [`set_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/set_backend.md);
  query with
  [`get_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/get_backend.md).

- `metasurvey.workflow_backend`:

  A `WorkflowBackend` object holding the active workflow backend. Unset
  by default (an in-memory local backend is used). Configure with
  [`set_workflow_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/set_workflow_backend.md);
  query with
  [`get_workflow_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/get_workflow_backend.md).

- `metasurvey.backend_provider`:

  A function `(op, args)` that implements the remote (`"api"`) backend.
  Default `NULL`: core has no network access, and selecting the `"api"`
  backend without a registered provider signals a
  `metasurvey_error_backend_unavailable` error (see
  [metasurvey_conditions](https://metasurveyr.github.io/metasurvey.core/reference/metasurvey_conditions.md)).
  Companion packages such as `metasurvey.explorer.backend` register the
  provider on load.

- `metasurvey.skip_recipes`:

  Logical, default `FALSE`. When `TRUE`,
  [`get_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/get_recipe.md)
  skips every backend lookup and returns `NULL` with a warning: useful
  for fully offline runs.

## Examples

``` r
# Silence informational messages for a session
old <- options(metasurvey.verbose = FALSE)
options(old)

# Current engine and laziness
getOption("metasurvey.engine")
#> [1] "data.table"
lazy_default()
#> [1] TRUE
```
