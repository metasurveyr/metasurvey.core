# Paquete metasurvey.core
# Classed condition helpers (rOpenSci review): every error/warning signalled
# by metasurvey.core carries a domain subclass plus a package-wide base class
# ("metasurvey_error" / "metasurvey_warning") so callers can catch conditions
# by class instead of matching message text.

#' Escape cli/glue braces in a message
#'
#' `msvy_abort()` / `msvy_warn()` treat their message as literal text:
#' any `{` or `}` (e.g. in deparsed expressions) is escaped so cli's
#' glue interpolation never applies.
#' @noRd
escape_braces <- function(x) {
  out <- gsub("{", "{{", gsub("}", "}}", x, fixed = TRUE), fixed = TRUE)
  names(out) <- names(x)
  out
}

#' Signal a classed metasurvey error
#'
#' Wraps [cli::cli_abort()] so the condition carries `class` plus the base
#' class `"metasurvey_error"`. The message is treated as literal text
#' (braces are escaped, no glue interpolation): build it with `sprintf()`
#' or `paste0()` before calling. A character vector gives cli bullets,
#' with names as bullet types (`"i"`, `"x"`, `"*"`, ...).
#'
#' @param message Character vector passed to [cli::cli_abort()].
#' @param class Character. Condition subclass(es); `"metasurvey_error"`
#'   is always appended. See [metasurvey_conditions].
#' @param ... Additional fields stored on the condition object.
#' @param call Environment of the user-facing function, reported in the
#'   error header. Defaults to the caller of `msvy_abort()`.
#' @noRd
msvy_abort <- function(message, class, ..., call = parent.frame()) {
  cli::cli_abort(
    escape_braces(message),
    class = c(class, "metasurvey_error"),
    call = call,
    ...
  )
}

#' Signal a classed metasurvey warning
#'
#' Wraps [cli::cli_warn()] so the condition carries `class` plus the base
#' class `"metasurvey_warning"`. Message handling is identical to
#' `msvy_abort()` (literal text, braces escaped).
#'
#' @param message Character vector passed to [cli::cli_warn()].
#' @param class Character. Condition subclass(es); `"metasurvey_warning"`
#'   is always appended. See [metasurvey_conditions].
#' @param ... Additional fields stored on the condition object.
#' @noRd
msvy_warn <- function(message, class, ...) {
  cli::cli_warn(
    escape_braces(message),
    class = c(class, "metasurvey_warning"),
    ...
  )
}

#' Condition classes signalled by metasurvey.core
#'
#' All errors and warnings signalled by metasurvey.core are classed
#' conditions: they carry a domain-specific subclass plus the package-wide
#' base class (`"metasurvey_error"` or `"metasurvey_warning"`), so you can
#' handle them with `tryCatch()`/`withCallingHandlers()` without matching
#' message text.
#'
#' @section Error classes:
#' Every error carries `"metasurvey_error"` plus one of:
#' \describe{
#'   \item{`metasurvey_input_error`}{An argument of an exported function
#'     failed input validation (wrong type, wrong class, missing value).}
#'   \item{`metasurvey_error_step`}{A step could not be created or baked
#'     (unknown step type, missing variables, failed `step_validate()`
#'     checks with `.action = "stop"`).}
#'   \item{`metasurvey_error_recipe`}{A recipe is invalid or cannot be
#'     applied (missing metadata, unmet variable dependencies, dependency
#'     cycles).}
#'   \item{`metasurvey_error_workflow`}{A workflow object or a
#'     `workflow()` estimation is invalid.}
#'   \item{`metasurvey_error_panel`}{A rotating-panel operation failed
#'     (inconsistent waves, invalid extraction).}
#'   \item{`metasurvey_error_survey`}{A survey-level operation failed
#'     (design construction, weight or replicate specification).}
#'   \item{`metasurvey_error_engine`}{The requested processing engine is
#'     not supported or not installed.}
#'   \item{`metasurvey_error_io`}{A file could not be loaded (unsupported
#'     format, missing reader package, failed download).}
#'   \item{`metasurvey_error_backend`}{A recipe/workflow backend operation
#'     failed.}
#'   \item{`metasurvey_error_backend_unavailable`}{The `"api"` backend was
#'     selected but no provider is registered (also carries
#'     `metasurvey_error_backend`). Install a provider package such as
#'     `metasurvey.explorer.backend`.}
#' }
#'
#' @section Warning classes:
#' Every warning carries `"metasurvey_warning"` plus one of
#' `metasurvey_warning_step`, `metasurvey_warning_recipe`,
#' `metasurvey_warning_workflow`, `metasurvey_warning_panel`,
#' `metasurvey_warning_survey`, `metasurvey_warning_engine` or
#' `metasurvey_warning_backend`, following the same domains as the error
#' classes.
#'
#' @examples
#' # Catch any metasurvey error by its base class
#' tryCatch(
#'   set_engine("not-an-engine"),
#'   metasurvey_error = function(e) message("caught: ", conditionMessage(e))
#' )
#'
#' # Or target a specific domain
#' tryCatch(
#'   set_engine("not-an-engine"),
#'   metasurvey_error_engine = function(e) "engine problem"
#' )
#' @return No return value. This topic documents the condition classes
#'   signalled by metasurvey.core; catch them with [tryCatch()] or
#'   [withCallingHandlers()] as shown in the examples.
#' @name metasurvey_conditions
NULL
