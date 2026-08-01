# Read panel survey files from different formats and create a RotativePanelSurvey object

Read panel survey files from different formats and create a
RotativePanelSurvey object

## Usage

``` r
load_panel_survey(
  path_implantation,
  path_follow_up,
  svy_type,
  svy_weight_implantation,
  svy_weight_follow_up,
  svy_strata = NULL,
  ...
)
```

## Arguments

- path_implantation:

  Survey implantation path, file can be in different formats, csv, xtsx,
  dta, sav and rds

- path_follow_up:

  Path with all the needed files with only survey valid files but also
  can be character vector with path files.

- svy_type:

  String with the survey type, supported types; "ech" (Encuensta
  Continua de Hogares, Uruguay), "eph" (Encuesta Permanente de Hogares,
  Argentina), "eai" (Encuesta de Actividades de Innovacion, Uruguay)

- svy_weight_implantation:

  List with survey implantation weights information specifing
  periodicity and the name of the weight variable. Recomended to use the
  helper function add_weight().

- svy_weight_follow_up:

  List with survey follow_up weights information specifing periodicity
  and the name of the weight variable. Recomended to use the helper
  function add_weight().

- svy_strata:

  Stratification variable name (character or NULL). Passed to
  Survey\$new(strata = ...).

- ...:

  Further arguments to be passed to load_panel_survey

## Value

RotativePanelSurvey object

## See also

Other survey-loading:
[`extract_time_pattern()`](https://metasurveyr.github.io/metasurvey.core/reference/extract_time_pattern.md),
[`group_dates()`](https://metasurveyr.github.io/metasurvey.core/reference/group_dates.md),
[`load_survey()`](https://metasurveyr.github.io/metasurvey.core/reference/load_survey.md),
[`load_survey_example()`](https://metasurveyr.github.io/metasurvey.core/reference/load_survey_example.md),
[`validate_time_pattern()`](https://metasurveyr.github.io/metasurvey.core/reference/validate_time_pattern.md)

## Examples

``` r
# Build a small panel from temporary CSV files
impl_dir <- tempfile("panel_")
follow_dir <- file.path(impl_dir, "follow_up")
dir.create(follow_dir, recursive = TRUE)
dt <- data.table::data.table(id = 1:20, income = runif(20), w = 1)
data.table::fwrite(dt, file.path(impl_dir, "ech_2023.csv"))
data.table::fwrite(dt, file.path(follow_dir, "ech_2023_01.csv"))
data.table::fwrite(dt, file.path(follow_dir, "ech_2023_02.csv"))

panel <- load_panel_survey(
  path_implantation = file.path(impl_dir, "ech_2023.csv"),
  path_follow_up = follow_dir,
  svy_type = "ech",
  svy_weight_implantation = add_weight(annual = "w"),
  svy_weight_follow_up = add_weight(monthly = "w")
)
#> Type does not match. Please provide a valid type in the survey edition or as an argument
panel
#> Type: ECH (Rotative Panel)
#> Edition: 2023
#> Periodicity: Implantation: Annual, Follow-up: Monthly
#> Engine: data.table
#> Steps: 
#> Recipes: None 
unlink(impl_dir, recursive = TRUE)

if (FALSE) { # \dontrun{
# Not run: requires the full ECH 2023 microdata and bootstrap
# replicate-weight files on disk
path_dir <- here::here("example-data", "ech", "ech_2023")
ech_2023 <- load_panel_survey(
  path_implantation = file.path(
    path_dir,
    "ECH_implantacion_2023.csv"
  ),
  path_follow_up = file.path(
    path_dir,
    "seguimiento"
  ),
  svy_type = "ECH_2023",
  svy_weight_implantation = add_weight(
    annual = "W_ANO"
  ),
  svy_weight_follow_up = add_weight(
    monthly = add_replicate(
      "W",
      replicate_path = file.path(
        path_dir,
        c(
          "Pesos replicados Bootstrap mensuales enero_junio 2023",
          "Pesos replicados Bootstrap mensuales julio_diciembre 2023"
        ),
        c(
          "Pesos replicados mensuales enero_junio 2023",
          "Pesos replicados mensuales Julio_diciembre 2023"
        )
      ),
      replicate_id = c("ID" = "ID"),
      replicate_pattern = "wr[0-9]+",
      replicate_type = "bootstrap"
    )
  )
)
} # }
```
