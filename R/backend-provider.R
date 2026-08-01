# Paquete metasurvey.core
# Hook de proveedor de backend remoto.
#
# El core implementa el backend LOCAL (JSON en disco/memoria) de forma completa.
# El backend remoto ("api") NO vive en el core: se delega a un proveedor que el
# paquete metasurvey.explorer.backend registra vía
# options(metasurvey.backend_provider = function(op, args) { ... }).
#
# Esto mantiene el core libre de dependencias de red (httr2) y respeta la regla
# "lo local queda en core".

#' Dispatch a remote-backend operation to the registered provider
#'
#' Internal bridge used by the `"api"` branch of [RecipeBackend] and
#' [WorkflowBackend]. If no provider is registered (i.e. only metasurvey.core is
#' installed), it errors with an actionable message pointing to the backend
#' package.
#'
#' @param op Character operation name (e.g. "list_recipes", "publish_recipe").
#' @param args List of arguments to pass to the provider.
#' @return Whatever the provider returns.
#' @noRd
.backend_api_call <- function(op, args = list()) {
  provider <- getOption("metasurvey.backend_provider", default = NULL)
  if (is.null(provider) || !is.function(provider)) {
    msvy_abort(
      paste0(
        "Remote ('api') backend is not available. Install and load ",
        "'metasurvey.explorer.backend' to publish/fetch recipes and workflows ",
        "from a metasurvey API, or use a local backend with ",
        "set_backend(\"local\", path = ...)."
      ),
      class = c(
        "metasurvey_error_backend_unavailable",
        "metasurvey_error_backend"
      )
    )
  }
  provider(op, args)
}
