# Get recipe from repository or API

This function retrieves data transformation recipes from the metasurvey
repository or API, based on specific criteria such as survey type,
edition, and topic. It is the primary way to access predefined and
community-validated recipes.

## Usage

``` r
get_recipe(
  svy_type = NULL,
  svy_edition = NULL,
  topic = NULL,
  allowMultiple = TRUE
)
```

## Arguments

- svy_type:

  String specifying the survey type. Examples: "ech", "eaii", "eai",
  "eph"

- svy_edition:

  String specifying the survey edition. Supported formats: "YYYY",
  "YYYYMM", "YYYY-YYYY"

- topic:

  String specifying the recipe topic. Examples: "labor_market",
  "poverty", "income", "demographics"

- allowMultiple:

  Logical indicating whether multiple recipes are allowed. If FALSE and
  multiple matches exist, returns the most recent one

## Value

`Recipe` object or list of `Recipe` objects according to the specified
criteria and the value of `allowMultiple`

## Details

This function is essential for:

- Accessing official recipes: Get validated and maintained recipes by
  specialized teams

- Reproducibility: Ensure different users apply the same standard
  transformations

- Automation: Integrate recipes into automatic pipelines

- Collaboration: Share methodologies between teams and organizations

- Versioning: Access different recipe versions according to edition

The function queries the metasurvey API to retrieve recipes. **Internet
connection is required**. If the API is unavailable or you need to work
offline:

**Working Offline:**

- Don't call `get_recipe()` - work directly with steps

- Set `options(metasurvey.skip_recipes = TRUE)` to disable API calls

- Load recipes from local files using
  [`read_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/read_recipe.md)

- Create custom recipes with
  [`recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/recipe.md)

Search criteria are combined with AND operator, so all specified
criteria must match for a recipe to be returned.

## See also

[`recipe`](https://metasurveyr.github.io/metasurvey.core/reference/recipe.md)
to create custom recipes
[`save_recipe`](https://metasurveyr.github.io/metasurvey.core/reference/save_recipe.md)
to save recipes locally
[`read_recipe`](https://metasurveyr.github.io/metasurvey.core/reference/read_recipe.md)
to read recipes from file
[`publish_recipe`](https://metasurveyr.github.io/metasurvey.core/reference/publish_recipe.md)
to publish recipes to the repository
[`load_survey`](https://metasurveyr.github.io/metasurvey.core/reference/load_survey.md)
where recipes are used

Other recipes:
[`Recipe-class`](https://metasurveyr.github.io/metasurvey.core/reference/Recipe-class.md),
[`add_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/add_recipe.md),
[`bake_recipes()`](https://metasurveyr.github.io/metasurvey.core/reference/bake_recipes.md),
[`harmonize()`](https://metasurveyr.github.io/metasurvey.core/reference/harmonize.md),
[`print.Recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/print.Recipe.md),
[`publish_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/publish_recipe.md),
[`read_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/read_recipe.md),
[`recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/recipe.md),
[`save_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/save_recipe.md),
[`steps_to_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/steps_to_recipe.md)

## Examples

``` r
# Query a local backend (works offline)
old <- set_backend("local", path = tempfile(fileext = ".json"))

r <- Recipe$new(
  name = "labor_market", edition = "2023", survey_type = "ech",
  default_engine = "data.table", depends_on = list(),
  user = "demo", description = "Example recipe",
  steps = list("step_compute(., active = e27 >= 14)"),
  id = "r_demo"
)
publish_recipe(r)

# Get recipes for ECH 2023
ech_recipes <- get_recipe(svy_type = "ech", svy_edition = "2023")
#> Found 1 recipes

# Get a single recipe
one_recipe <- get_recipe(
  svy_type = "ech", svy_edition = "2023",
  allowMultiple = FALSE
)
#> Found 1 recipes

# Restore previous backend
options(metasurvey.backend = old)
```
