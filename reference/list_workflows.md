# List all workflows

List all workflows from the active workflow backend.

## Usage

``` r
list_workflows()
```

## Value

List of all RecipeWorkflow objects.

## See also

[`search_workflows`](https://metasurveyr.github.io/metasurvey.core/reference/search_workflows.md),
[`filter_workflows`](https://metasurveyr.github.io/metasurvey.core/reference/filter_workflows.md)

Other tidy-api:
[`RecipeCategory-from_list`](https://metasurveyr.github.io/metasurvey.core/reference/RecipeCategory-from_list.md),
[`RecipeCertification`](https://metasurveyr.github.io/metasurvey.core/reference/RecipeCertification.md),
[`RecipeUser`](https://metasurveyr.github.io/metasurvey.core/reference/RecipeUser.md),
[`add_category()`](https://metasurveyr.github.io/metasurvey.core/reference/add_category.md),
[`certify_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/certify_recipe.md),
[`default_categories()`](https://metasurveyr.github.io/metasurvey.core/reference/default_categories.md),
[`filter_recipes()`](https://metasurveyr.github.io/metasurvey.core/reference/filter_recipes.md),
[`filter_workflows()`](https://metasurveyr.github.io/metasurvey.core/reference/filter_workflows.md),
[`find_workflows_for_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/find_workflows_for_recipe.md),
[`list_recipes()`](https://metasurveyr.github.io/metasurvey.core/reference/list_recipes.md),
[`rank_recipes()`](https://metasurveyr.github.io/metasurvey.core/reference/rank_recipes.md),
[`rank_workflows()`](https://metasurveyr.github.io/metasurvey.core/reference/rank_workflows.md),
[`recipe_category()`](https://metasurveyr.github.io/metasurvey.core/reference/recipe_category.md),
[`recipe_certification()`](https://metasurveyr.github.io/metasurvey.core/reference/recipe_certification.md),
[`recipe_user()`](https://metasurveyr.github.io/metasurvey.core/reference/recipe_user.md),
[`remove_category()`](https://metasurveyr.github.io/metasurvey.core/reference/remove_category.md),
[`search_recipes()`](https://metasurveyr.github.io/metasurvey.core/reference/search_recipes.md),
[`search_workflows()`](https://metasurveyr.github.io/metasurvey.core/reference/search_workflows.md),
[`set_user_info()`](https://metasurveyr.github.io/metasurvey.core/reference/set_user_info.md),
[`set_version()`](https://metasurveyr.github.io/metasurvey.core/reference/set_version.md)

## Examples

``` r
set_workflow_backend("local", path = tempfile(fileext = ".json"))
all <- list_workflows()
length(all)
#> [1] 0
```
