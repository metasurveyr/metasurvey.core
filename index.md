# metasurvey.core

**metasurvey.core** is the processing engine of the
[metasurvey](https://github.com/metasurveyr) ecosystem: reproducible
survey data processing with a lazy, step-based pipeline, built on the
[`survey`](https://cran.r-project.org/package=survey) package for
**complex sampling designs** and **recurring estimation** over time
(rotating panels, repeated cross-sections).

Everything in this package runs on your machine — your microdata never
leave your R session. Publishing recipes online, the Shiny explorer, and
STATA migration are provided by companion packages (see [the
ecosystem](#the-metasurvey-ecosystem) below).

------------------------------------------------------------------------

## Key features

- **Steps**: lazy transformation pipeline
  ([`step_compute()`](https://metasurveyr.github.io/metasurvey.core/reference/step_compute.md),
  [`step_recode()`](https://metasurveyr.github.io/metasurvey.core/reference/step_recode.md),
  [`step_rename()`](https://metasurveyr.github.io/metasurvey.core/reference/step_rename.md),
  [`step_remove()`](https://metasurveyr.github.io/metasurvey.core/reference/step_remove.md),
  [`step_join()`](https://metasurveyr.github.io/metasurvey.core/reference/step_join.md))
  executed via
  [`bake_steps()`](https://metasurveyr.github.io/metasurvey.core/reference/bake_steps.md).
- **Recipes**: portable, versioned objects that encapsulate
  harmonisation pipelines with automatic documentation (`$doc()`) and
  validation (`$validate()`).
- **Workflows**: estimation with
  [`survey::svymean`](https://rdrr.io/pkg/survey/man/surveysummary.html),
  `svytotal`, `svyratio` and `svyby` integrated into
  [`workflow()`](https://metasurveyr.github.io/metasurvey.core/reference/workflow.md),
  returning a `data.table` with value, standard error and coefficient of
  variation.
- **Rotating panels**: support for `RotativePanelSurvey` with
  implantation and follow-ups, and `PoolSurvey` for combined estimation.
- **Replicate weights**: bootstrap replicate configuration via
  [`add_replicate()`](https://metasurveyr.github.io/metasurvey.core/reference/add_replicate.md)
  for robust variance estimation with
  [`survey::svrepdesign`](https://rdrr.io/pkg/survey/man/svrepdesign.html).
- **Local registry**: publish, search and discover recipes and workflows
  in a local JSON registry. The remote registry (REST API) is provided
  by
  [`metasurvey.explorer.backend`](https://github.com/metasurveyr/metasurvey.explorer.backend)
  through an injectable backend provider.
- **Provenance and harmonisation**: track where every variable comes
  from and harmonise names and types across survey editions.

## Works with any household survey

The step pipeline and workflow system are survey-agnostic. The same
verbs process Uruguay’s ECH, Argentina’s EPH, Chile’s CASEN, Brazil’s
PNAD-C, the US CPS, Mexico’s ENIGH, or DHS data from 90+ countries.

|  | ECH | EPH | CASEN | PNAD-C | CPS | ENIGH | DHS |
|----|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Steps (compute / recode / rename / remove / join) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Weights ([`add_weight()`](https://metasurveyr.github.io/metasurvey.core/reference/add_weight.md)) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Stratified + cluster designs | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ |
| Replicate weights ([`add_replicate()`](https://metasurveyr.github.io/metasurvey.core/reference/add_replicate.md)) | ✓ | — | — | ✓ | ✓ | — | — |
| Rotating panels (`RotativePanelSurvey`) | ✓ | ✓ | — | ✓ | ✓ | — | — |
| Recipes & workflows | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

``` r

# Same pipeline, different surveys ─────────────────────────

# Argentina (eph)
eph_svy <- Survey$new(
  data = as.data.table(eph::get_microdata(2023, 3)),
  edition = "2023-T3", type = "eph", psu = NULL,
  engine = "data.table", weight = add_weight(quarterly = "PONDERA")
)

# Chile (casen)
casen_svy <- Survey$new(
  data = as.data.table(casen::descargar_casen_github(2017)),
  edition = "2017", type = "casen", psu = "varunit",
  engine = "data.table", weight = add_weight(annual = "expr")
)

# Both use the exact same verbs
process <- function(svy) {
  svy |>
    step_recode(employed, labor_status == 1 ~ 1L, .default = 0L,
                comment = "Binary employment indicator") |>
    bake_steps()
}
```

See the [international surveys
article](https://metasurveyr.github.io/metasurvey.core/articles/international-surveys.html)
for reproducible examples with all seven surveys.

## The metasurvey ecosystem

`metasurvey.core` is the foundation of a modular, tidyverse-style family
of packages. Most users should install the
[`metasurvey`](https://github.com/metasurveyr/metasurvey) meta-package,
which attaches the whole ecosystem.

| Package | Role |
|----|----|
| [`metasurvey.core`](https://github.com/metasurveyr/metasurvey.core) | **This package.** Local engine: steps, recipes, workflows, panels |
| [`metasurvey`](https://github.com/metasurveyr/metasurvey) | Meta-package: attaches the ecosystem, high-level orchestration |
| [`metasurvey.anda`](https://github.com/metasurveyr/metasurvey.anda) | Client for ANDA (National Data Archive): catalog, DDI metadata, microdata download |
| [`metasurvey.fromstata`](https://github.com/metasurveyr/metasurvey.fromstata) | STATA `.do` → recipe transpiler |
| [`metasurvey.explorer.backend`](https://github.com/metasurveyr/metasurvey.explorer.backend) | HTTP client for the recipe registry REST API |
| [`metasurvey.explorer.frontend`](https://github.com/metasurveyr/metasurvey.explorer.frontend) | Shiny app to browse and preview community recipes |
| [`metasurvey.worker`](https://github.com/metasurveyr/metasurvey.worker) | Server-side infra: plumber REST API + compute worker |

## Installation

Install the development version from GitHub:

``` r

# install.packages("pak")
pak::pak("metasurveyr/metasurvey.core")
```

## Quick example

Everything below runs offline, using the Academic Performance Index data
shipped with the `survey` package:

``` r

library(metasurvey.core)

data(api, package = "survey")

svy <- Survey$new(
  data    = data.table::as.data.table(apistrat),
  edition = "2000",
  type    = "api",
  psu     = NULL,
  engine  = "data.table",
  weight  = add_weight(annual = "pw")
)

# Lazy transformations: recorded now, executed at bake time
svy <- step_compute(svy, growth = api00 - api99, comment = "API growth")
svy <- step_recode(svy, school_level,
  stype == "E" ~ "Elementary",
  stype == "M" ~ "Middle",
  stype == "H" ~ "High",
  .default = NA_character_
)
svy <- bake_steps(svy)

# Design-based estimation with tidy output
workflow(
  list(svy),
  survey::svymean(~growth, na.rm = TRUE),
  estimation_type = "annual"
)
```

## Full example: ECH panel with bootstrap replicate weights

This example uses the rotating panel from Uruguay’s [*Encuesta Continua
de Hogares*](https://www.gub.uy/instituto-nacional-estadistica/) (ECH)
with bootstrap replicate weights. First, download the example data:

``` r

download_example_ech <- function() {
  zip_url <- "https://informe-tfg.s3.us-east-2.amazonaws.com/example-data.zip"
  dest_zip <- "example-data.zip"
  temp_dir <- tempfile("example-data")
  download.file(zip_url, destfile = dest_zip, mode = "wb")
  dir.create(temp_dir)
  unzip(dest_zip, exdir = temp_dir)
  target_dir <- "example-data"
  dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)
  file.rename(
    list.files(file.path(temp_dir, "example-data"), full.names = TRUE),
    file.path(target_dir, basename(list.files(file.path(temp_dir, "example-data"))))
  )
  unlink(dest_zip)
  unlink(temp_dir, recursive = TRUE)
}
download_example_ech()
```

With the data downloaded:

``` r

library(metasurvey.core)

path_dir <- file.path("example-data", "ech", "ech_2023")

ech_2023 <- load_panel_survey(
  path_implantation = file.path(path_dir, "ECH_implantacion_2023.csv"),
  path_follow_up = file.path(path_dir, "seguimiento"),
  svy_type = "ECH_2023",
  svy_weight_implantation = add_weight(annual = "W_ANO"),
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

# Build labour market indicators
ech_2023 <- ech_2023 |>
  step_recode("pea", POBPCOAC %in% 2:5 ~ 1, .default = 0,
              comment = "EAP", .level = "follow_up") |>
  step_recode("pet", e27 >= 14 ~ 1, .default = 0,
              comment = "WAP", .level = "follow_up") |>
  step_recode("po", POBPCOAC == 2 ~ 1, .default = 0,
              comment = "Employed", .level = "follow_up") |>
  step_recode("pd", POBPCOAC %in% 3:5 ~ 1, .default = 0,
              comment = "Unemployed", .level = "follow_up")

ech_2023_bake <- bake_steps(ech_2023)

# Quarterly rates: activity, employment and unemployment
workflow_result <- workflow(
  survey = extract_surveys(ech_2023_bake, quarterly = 1:4),
  survey::svyratio(~pea, denominator = ~pet),
  survey::svyratio(~po, denominator = ~pet),
  survey::svyratio(~pd, denominator = ~pea),
  estimation_type = "quarterly:monthly",
  rho = 0.5,
  R = 5 / 6
)

workflow_result
```

This pipeline loads a rotating panel with bootstrap replicate weights,
builds binary labour market indicators (EAP, WAP, employed, unemployed),
and estimates activity, employment and unemployment rates by quarter
with robust variance. The [ECH case
study](https://metasurveyr.github.io/metasurvey.core/articles/ech-case-study.html)
walks through the same survey step by step with the sample bundled in
the package.

## Documentation

Full documentation and articles at
[metasurveyr.github.io/metasurvey.core](https://metasurveyr.github.io/metasurvey.core/):

- [Creating and sharing
  recipes](https://metasurveyr.github.io/metasurvey.core/articles/recipes.html)
- [Estimation
  workflows](https://metasurveyr.github.io/metasurvey.core/articles/workflows-and-estimation.html)
- [Survey designs and
  validation](https://metasurveyr.github.io/metasurvey.core/articles/complex-designs.html)
- [Rotating panels and
  PoolSurvey](https://metasurveyr.github.io/metasurvey.core/articles/panel-analysis.html)
- [Inequality measures with
  convey](https://metasurveyr.github.io/metasurvey.core/articles/convey-inequality.html)

Las viñetas principales también están disponibles en español
(`recipes-es`, `workflows-and-estimation-es`, `complex-designs-es`,
`panel-analysis-es`).

## Related work

| Package | Focus | metasurvey.core adds |
|----|----|----|
| [survey](https://cran.r-project.org/package=survey) | Sampling designs and estimation | Lazy step pipeline, recipe system, rotating panels |
| [srvyr](https://cran.r-project.org/package=srvyr) | dplyr-style interface to survey | Portable recipes, workflow registry, panel support |
| [recipes](https://cran.r-project.org/package=recipes) | Feature engineering for modelling | Survey-aware steps, complex designs, community sharing |
| [targets](https://cran.r-project.org/package=targets) | General pipeline orchestration | Domain-specific steps, built-in survey semantics |

metasurvey.core is **not** a wrapper around `survey`. It adds a
reproducibility layer (steps, recipes, workflows) that is
survey-agnostic: the same pipeline processes Uruguay’s ECH, Argentina’s
EPH, Chile’s CASEN, Brazil’s PNAD-C, the US CPS, Mexico’s ENIGH, or DHS
data without survey-specific code.

## Citation

To cite metasurvey.core in publications use:

``` r

citation("metasurvey.core")
```

## Contributing

Please see
[CONTRIBUTING.md](https://github.com/metasurveyr/metasurvey.core/blob/main/CONTRIBUTING.md)
for contribution guidelines.

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/metasurveyr/metasurvey.core/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project you agree to abide by its terms.
