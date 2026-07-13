# metasurvey.core: Local Survey Processing Engine

The core engine of the metasurvey ecosystem: reproducible survey data
processing with a step-based pipeline, recipes, and workflows, built on
the survey package for complex sampling designs. This package is fully
local: it has no network, Shiny, or STATA dependencies. Those live in
companion packages (metasurvey.explorer.backend,
metasurvey.explorer.frontend, metasurvey.anda, metasurvey.fromstata).

## Key Features

**Survey Objects and Classes:**

- [`Survey`](https://metasurveyr.github.io/metasurvey.core/reference/Survey.md):
  Basic survey object for cross-sectional data

- [`RotativePanelSurvey`](https://metasurveyr.github.io/metasurvey.core/reference/RotativePanelSurvey.md):
  Panel survey with implantation and follow-up

- [`PoolSurvey`](https://metasurveyr.github.io/metasurvey.core/reference/PoolSurvey.md):
  Pool of multiple surveys for time series analysis

**Steps and Workflows:**

- [`step_compute`](https://metasurveyr.github.io/metasurvey.core/reference/step_compute.md):
  Create computed variables

- [`step_recode`](https://metasurveyr.github.io/metasurvey.core/reference/step_recode.md):
  Recode variables with multiple conditions

- [`workflow`](https://metasurveyr.github.io/metasurvey.core/reference/workflow.md):
  Execute estimation workflows with variance adjustment

**Recipes and Reproducibility:**

- [`recipe`](https://metasurveyr.github.io/metasurvey.core/reference/recipe.md):
  Create reusable recipe objects

- [`bake_recipes`](https://metasurveyr.github.io/metasurvey.core/reference/bake_recipes.md):
  Apply recipes to survey data

- [`get_recipe`](https://metasurveyr.github.io/metasurvey.core/reference/get_recipe.md):
  Retrieve recipes from the configured backend

**Data Loading and Weights:**

- [`load_survey`](https://metasurveyr.github.io/metasurvey.core/reference/load_survey.md):
  Load single survey data

- [`load_panel_survey`](https://metasurveyr.github.io/metasurvey.core/reference/load_panel_survey.md):
  Load panel survey data

- [`add_weight`](https://metasurveyr.github.io/metasurvey.core/reference/add_weight.md):
  Add survey weights

- [`add_replicate`](https://metasurveyr.github.io/metasurvey.core/reference/add_replicate.md):
  Add bootstrap/jackknife replicates

**Quality Assessment:**

- [`evaluate_cv`](https://metasurveyr.github.io/metasurvey.core/reference/evaluate_cv.md):
  Evaluate coefficient of variation quality

- Built-in variance estimation with multiple engines

## References

Lumley, T. (2020). "survey: analysis of complex survey samples". R
package version 4.0.

## See also

- <https://CRAN.R-project.org/package=survey> for the survey package

- Package website: <https://github.com/metasurveyr/metasurvey.core>

## Author

Mauro Loprete <mauro.loprete@icloud.com>, Natalia da Silva
<natalia.dasilva@fcea.edu.uy>, Fabricio Machado
<fabricio.mch.slv@gmail.com>
