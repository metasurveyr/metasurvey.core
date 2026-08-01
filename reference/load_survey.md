# Load survey from file and create Survey object

This function reads survey files in multiple formats and creates a
Survey object with all necessary metadata for subsequent analysis.
Supports various survey types with specific configurations for each one.

## Usage

``` r
load_survey(
  path = NULL,
  svy_type = NULL,
  svy_edition = NULL,
  svy_weight = NULL,
  svy_psu = NULL,
  svy_strata = NULL,
  ...,
  bake = FALSE,
  recipes = NULL
)
```

## Arguments

- path:

  Path to the survey file. Supports multiple formats: csv, xlsx, dta
  (Stata), sav (SPSS), rds (R). If NULL, survey arguments must be
  specified to create an empty object

- svy_type:

  Survey type as string. Supported types:

  - "ech": Encuesta Continua de Hogares (Uruguay)

  - "eph": Encuesta Permanente de Hogares (Argentina)

  - "eai": Encuesta de Actividades de Innovación (Uruguay)

  - "eaii": Encuesta de Actividades de Innovación e I+D (Uruguay)

- svy_edition:

  Survey edition as string. Supports different temporal patterns:

  - "YYYY": Year (e.g., "2023")

  - "YYYYMM" or "MMYYYY": Year-month (e.g., "202301" or "012023")

  - "YYYY-YYYY": Year range (e.g., "2020-2022")

- svy_weight:

  List with weight information specifying periodicity and weight
  variable name. Use helper function
  [`add_weight`](https://metasurveyr.github.io/metasurvey.core/reference/add_weight.md)

- svy_psu:

  Primary sampling unit (PSU) variable as string

- svy_strata:

  Stratification variable name as string (optional). Used in
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html)
  for stratified sampling designs.

- ...:

  Additional arguments passed to specific reading functions

- bake:

  Logical indicating whether recipes are processed automatically when
  loading data. Defaults to FALSE

- recipes:

  Recipe object obtained with
  [`get_recipe`](https://metasurveyr.github.io/metasurvey.core/reference/get_recipe.md).
  If bake=TRUE, these recipes are applied automatically

## Value

`Survey` object with structure:

- `data`: Survey data

- `metadata`: Information about type, edition, weights

- `steps`: History of applied transformations

- `recipes`: Available recipes

- `design`: Sample design information

## Details

The function automatically detects file format and uses the appropriate
reader. For each survey type, it applies specific configurations such as
standard variables, data types, and validations.

When `bake=TRUE` is specified, recipes are applied immediately after
loading the data, creating an analysis-ready object.

If no `path` is provided, an empty Survey object is created that can be
used to build step pipelines without initial data.

## See also

[`add_weight`](https://metasurveyr.github.io/metasurvey.core/reference/add_weight.md)
to specify weights
[`get_recipe`](https://metasurveyr.github.io/metasurvey.core/reference/get_recipe.md)
to get available recipes
[`load_survey_example`](https://metasurveyr.github.io/metasurvey.core/reference/load_survey_example.md)
to load example data
[`load_panel_survey`](https://metasurveyr.github.io/metasurvey.core/reference/load_panel_survey.md)
for panel surveys

Other survey-loading:
[`extract_time_pattern()`](https://metasurveyr.github.io/metasurvey.core/reference/extract_time_pattern.md),
[`group_dates()`](https://metasurveyr.github.io/metasurvey.core/reference/group_dates.md),
[`load_panel_survey()`](https://metasurveyr.github.io/metasurvey.core/reference/load_panel_survey.md),
[`load_survey_example()`](https://metasurveyr.github.io/metasurvey.core/reference/load_survey_example.md),
[`validate_time_pattern()`](https://metasurveyr.github.io/metasurvey.core/reference/validate_time_pattern.md)

## Examples

``` r
# Load the ECH sample bundled with the package
ech_sample <- load_survey(
  path = system.file(
    "extdata", "ech_2023_sample.csv",
    package = "metasurvey.core"
  ),
  svy_type = "ech",
  svy_edition = "2023",
  svy_weight = add_weight(annual = "W_ANO")
)
ech_sample
#> Type: ECH
#> Edition: 2023
#> Periodicity: Annual
#> Engine: data.table
#> Design: 
#>   Design: Not initialized (lazy initialization - will be created when needed)
#> 
#> Steps: None
#> Recipes: None 

if (FALSE) { # \dontrun{
# Not run: needs full local microdata files and a configured backend
ech_2023 <- load_survey(
  path = "data/ech_2023.csv",
  svy_type = "ech",
  svy_edition = "2023",
  svy_weight = add_weight(annual = "pesoano"),
  recipes = get_recipe("ech", "2023"),
  bake = TRUE
)

# Load monthly survey from STATA format
ech_january <- load_survey(
  path = "data/ech_202301.dta",
  svy_type = "ech",
  svy_edition = "202301",
  svy_weight = add_weight(monthly = "pesomes")
)
} # }
```
