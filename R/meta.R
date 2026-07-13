# Migrado de metasurvey-legacy/R/meta.R
# Paquete metasurvey.core
# Origen: https://github.com/metasurveyr/metasurvey-legacy
# NOTA: metasurvey_user_agent() (User-Agent HTTP) y el bloque de auto-config de
#       API (METASURVEY_API_URL / METASURVEY_TOKEN) del .onLoad NO están aquí:
#       viven en metasurvey.explorer.backend. El core no configura red.

#' Metadata arguments for survey objects
#' @return Character vector
#' @noRd
#' @keywords internal

metadata_args <- function() {
  c(
    "svy_type", "svy_edition", ".engine_name",
    "svy_weight", "recipes", "steps", "svy_psu", "svy_strata", "bake"
  )
}

#' @importFrom glue glue
NULL

#' Internal message helper with verbose opt-out
#'
#' Wraps \code{message()} behind the \code{metasurvey.verbose} option.
#' Set \code{options(metasurvey.verbose = FALSE)} to suppress all
#' informational messages from metasurvey.
#' @param ... Arguments passed to \code{message()}.
#' @noRd
metasurvey_msg <- function(...) {
  if (isTRUE(getOption("metasurvey.verbose", TRUE))) {
    message(...)
  }
}

.onLoad <- function(libname, pkgname) {
  default_engine()

  set_use_copy(use_copy_default())

  if (is.null(getOption("metasurvey.verbose"))) {
    options(metasurvey.verbose = TRUE)
  }
}
