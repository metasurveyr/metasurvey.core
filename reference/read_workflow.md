# Read a RecipeWorkflow from a JSON file

Read a RecipeWorkflow from a JSON file

## Usage

``` r
read_workflow(file)
```

## Arguments

- file:

  Character file path

## Value

A RecipeWorkflow object

## See also

Other workflows:
[`RecipeWorkflow-class`](https://metasurveyr.github.io/metasurvey.core/reference/RecipeWorkflow-class.md),
[`evaluate_cv()`](https://metasurveyr.github.io/metasurvey.core/reference/evaluate_cv.md),
[`print.RecipeWorkflow()`](https://metasurveyr.github.io/metasurvey.core/reference/print.RecipeWorkflow.md),
[`publish_workflow()`](https://metasurveyr.github.io/metasurvey.core/reference/publish_workflow.md),
[`save_workflow()`](https://metasurveyr.github.io/metasurvey.core/reference/save_workflow.md),
[`workflow()`](https://metasurveyr.github.io/metasurvey.core/reference/workflow.md),
[`workflow_from_list()`](https://metasurveyr.github.io/metasurvey.core/reference/workflow_from_list.md),
[`workflow_table()`](https://metasurveyr.github.io/metasurvey.core/reference/workflow_table.md)

## Examples

``` r
wf <- RecipeWorkflow$new(
  name = "Example", description = "Test",
  survey_type = "ech", edition = "2023",
  recipe_ids = "r_001", estimation_type = "svymean"
)
f <- tempfile(fileext = ".json")
save_workflow(wf, f)
#> Workflow saved to /tmp/RtmpHVh7Yc/file1f233bd938c.json
wf2 <- read_workflow(f)
```
