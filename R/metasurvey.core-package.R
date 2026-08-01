# Migrado de metasurvey-legacy/R/metaSurvey-package.R
# Paquete metasurvey.core
# Origen: https://github.com/metasurveyr/metasurvey-legacy

#' @title metasurvey.core: Local Survey Processing Engine
#'
#' @description
#' The core engine of the metasurvey ecosystem: reproducible survey data
#' processing with a step-based pipeline, recipes, and workflows, built on the
#' \pkg{survey} package for complex sampling designs. This package is fully
#' local: it has no network, Shiny, or STATA dependencies. Those live in
#' companion packages (metasurvey.explorer.backend, metasurvey.explorer.frontend,
#' metasurvey.anda, metasurvey.fromstata).
#'
#' @section Key Features:
#'
#' **Survey Objects and Classes:**
#' \itemize{
#'   \item \code{\link{Survey}}: Basic survey object for cross-sectional data
#'   \item \code{\link{RotativePanelSurvey}}: Panel survey
#'     with implantation and follow-up
#'   \item \code{\link{PoolSurvey}}: Pool of multiple
#'     surveys for time series analysis
#' }
#'
#' **Steps and Workflows:**
#' \itemize{
#'   \item \code{\link{step_compute}}: Create computed variables
#'   \item \code{\link{step_recode}}: Recode variables
#'     with multiple conditions
#'   \item \code{\link{workflow}}: Execute estimation
#'     workflows with variance adjustment
#' }
#'
#' **Recipes and Reproducibility:**
#' \itemize{
#'   \item \code{\link{recipe}}: Create reusable recipe objects
#'   \item \code{\link{bake_recipes}}: Apply recipes to survey data
#'   \item \code{\link{get_recipe}}: Retrieve recipes from the configured backend
#' }
#'
#' **Data Loading and Weights:**
#' \itemize{
#'   \item \code{\link{load_survey}}: Load single survey data
#'   \item \code{\link{load_panel_survey}}: Load panel survey data
#'   \item \code{\link{add_weight}}: Add survey weights
#'   \item \code{\link{add_replicate}}: Add bootstrap/jackknife replicates
#' }
#'
#' **Quality Assessment:**
#' \itemize{
#'   \item \code{\link{evaluate_cv}}: Evaluate coefficient
#'     of variation quality
#'   \item Built-in variance estimation with multiple engines
#' }
#'
#' **Configuration and Error Handling:**
#' \itemize{
#'   \item \link{metasurvey.core-options}: Package options
#'     (engine, laziness, copy semantics, backends, verbosity)
#'   \item \link{metasurvey_conditions}: Condition classes signalled
#'     by the package, for use with \code{tryCatch()}
#' }
#'
#' @author
#' Mauro Loprete \email{mauro.loprete@@icloud.com},
#' Natalia da Silva \email{natalia.dasilva@@fcea.edu.uy},
#' Fabricio Machado \email{fabricio.mch.slv@@gmail.com}
#'
#' @references
#' Lumley, T. (2020). "survey: analysis of complex survey
#' samples". R package version 4.0.
#'
#' @seealso
#' \itemize{
#'   \item \url{https://CRAN.R-project.org/package=survey}
#'     for the survey package
#'   \item Package website:
#'     \url{https://github.com/metasurveyr/metasurvey.core}
#' }
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom data.table .BY
#' @importFrom data.table .EACHI
#' @importFrom data.table .GRP
#' @importFrom data.table .I
#' @importFrom data.table .N
#' @importFrom data.table .NGRP
#' @importFrom data.table .SD
#' @importFrom data.table :=
#' @importFrom data.table data.table
#' @importFrom lifecycle deprecated
#' @importFrom glue glue
#' @importFrom R6 R6Class
## usethis namespace: end
NULL


utils::globalVariables(c(
  "j", "se", "stat", "period", "type", "evaluate",
  # Added to silence R CMD check NOTES from NSE/data.table usage
  "variance", "value", "new_category", ".pool_k",
  "confint_lower", "confint_upper"
))

#' @importFrom stats as.formula confint
NULL

#' Options used by metasurvey.core
#'
#' All behavior toggles of metasurvey.core are controlled through R
#' [options()] under the `metasurvey.` prefix. None of them needs to be
#' set explicitly: every option has a working default.
#'
#' @section Options:
#' \describe{
#'   \item{`metasurvey.engine`}{Character. Data-processing engine used
#'     when loading surveys. Default `"data.table"` (set on load). Change
#'     it with [set_engine()]; see [show_engines()] for the available
#'     engines.}
#'   \item{`metasurvey.lazy_processing`}{Logical, default `TRUE`. When
#'     `TRUE`, `step_*()` functions record transformations without
#'     executing them until [bake_steps()] is called. Set with
#'     [set_lazy_processing()]; query with [lazy_default()].}
#'   \item{`metasurvey.use_copy`}{Logical, default `TRUE`. When `TRUE`,
#'     steps operate on a copy of the survey so the original object is
#'     never modified in place. Set with [set_use_copy()]; query with
#'     [use_copy_default()].}
#'   \item{`metasurvey.verbose`}{Logical, default `TRUE`. Gates all
#'     informational messages emitted by the package. Set it to `FALSE`
#'     to silence them; errors and warnings are not affected.}
#'   \item{`metasurvey.backend`}{A `RecipeBackend` object holding the
#'     active recipe backend. Unset by default (an in-memory local
#'     backend is used). Configure with [set_backend()]; query with
#'     [get_backend()].}
#'   \item{`metasurvey.workflow_backend`}{A `WorkflowBackend` object
#'     holding the active workflow backend. Unset by default (an
#'     in-memory local backend is used). Configure with
#'     [set_workflow_backend()]; query with [get_workflow_backend()].}
#'   \item{`metasurvey.backend_provider`}{A function `(op, args)` that
#'     implements the remote (`"api"`) backend. Default `NULL`: core has
#'     no network access, and selecting the `"api"` backend without a
#'     registered provider signals a
#'     `metasurvey_error_backend_unavailable` error (see
#'     [metasurvey_conditions]). Companion packages such as
#'     `metasurvey.explorer.backend` register the provider on load.}
#'   \item{`metasurvey.skip_recipes`}{Logical, default `FALSE`. When
#'     `TRUE`, [get_recipe()] skips every backend lookup and returns
#'     `NULL` with a warning: useful for fully offline runs.}
#' }
#'
#' @examples
#' # Silence informational messages for a session
#' old <- options(metasurvey.verbose = FALSE)
#' options(old)
#'
#' # Current engine and laziness
#' getOption("metasurvey.engine")
#' lazy_default()
#' @return No return value. This topic documents the global options
#'   recognised by metasurvey.core and their defaults.
#' @name metasurvey.core-options
NULL
