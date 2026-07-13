# Bake recipes

Bake recipes

## Usage

``` r
bake_recipes(svy)
```

## Arguments

- svy:

  Survey object

## Value

Survey object with all recipes applied

## See also

Other recipes:
[`Recipe-class`](https://metasurveyr.github.io/metasurvey.core/reference/Recipe-class.md),
[`add_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/add_recipe.md),
[`get_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/get_recipe.md),
[`harmonize()`](https://metasurveyr.github.io/metasurvey.core/reference/harmonize.md),
[`print.Recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/print.Recipe.md),
[`publish_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/publish_recipe.md),
[`read_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/read_recipe.md),
[`recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/recipe.md),
[`save_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/save_recipe.md),
[`steps_to_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/steps_to_recipe.md)

## Examples

``` r
# \donttest{
dt <- data.table::data.table(id = 1:20, x = rnorm(20), w = runif(20, 0.5, 2))
svy <- Survey$new(
  data = dt, edition = "2023", type = "demo",
  psu = NULL, engine = "data.table",
  weight = add_weight(annual = "w")
)
r <- recipe(
  name = "Demo", user = "test", svy = svy,
  description = "Demo recipe"
)
svy <- add_recipe(svy, r)
processed <- bake_recipes(svy)
# }
```
