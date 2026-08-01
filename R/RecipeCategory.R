# Migrado de metasurvey-legacy/R/RecipeCategory.R
# Paquete metasurvey.core
# Origen: https://github.com/metasurveyr/metasurvey-legacy

#' @title RecipeCategory
#' @description Standardized taxonomy for classifying recipes by domain.
#' Supports hierarchical categories with parent-child relationships.
#'
#' @field name Character. Category identifier.
#' @field description Character. Human-readable description.
#' @field parent RecipeCategory or NULL. Parent category for hierarchy.
#'
#' @return An [R6][R6::R6Class] object of class `RecipeCategory`.
#'
#' @examples
#' # Use recipe_category() for the public API:
#' cat <- recipe_category(
#'   "economics", "Economic indicators"
#' )
#' sub <- recipe_category(
#'   "labor_market", "Labor market",
#'   parent = "economics"
#' )
#'
#' @family tidy-api
#' @export
RecipeCategory <- R6::R6Class(
  "RecipeCategory",
  public = list(
    name = NULL,
    description = NULL,
    parent = NULL,

    #' @description Create a new RecipeCategory
    #' @param name Character. Category identifier (non-empty string).
    #' @param description Character. Description of the category.
    #' @param parent RecipeCategory or NULL. Parent category.
    initialize = function(name, description, parent = NULL) {
      if (is.null(name) || !is.character(name) || nchar(name) == 0) {
        msvy_abort(
          "Category name must be a non-empty character string",
          class = "metasurvey_error_recipe"
        )
      }
      if (!is.null(parent) && !inherits(parent, "RecipeCategory")) {
        msvy_abort(
          "parent must be a RecipeCategory object or NULL",
          class = "metasurvey_error_recipe"
        )
      }
      self$name <- name
      self$description <- description
      self$parent <- parent
    },

    #' @description Check if this category is a subcategory of another
    #' @param ancestor_name Character. Name of the potential
    #'   ancestor category.
    #' @return Logical
    is_subcategory_of = function(ancestor_name) {
      current <- self$parent
      while (!is.null(current)) {
        if (current$name == ancestor_name) {
          return(TRUE)
        }
        current <- current$parent
      }
      FALSE
    },

    #' @description Get full hierarchical path
    #' @return Character string with slash-separated path
    get_path = function() {
      parts <- self$name
      current <- self$parent
      while (!is.null(current)) {
        parts <- c(current$name, parts)
        current <- current$parent
      }
      paste(parts, collapse = "/")
    },

    #' @description Check equality by name
    #' @param other RecipeCategory to compare with.
    #' @return Logical
    equals = function(other) {
      inherits(other, "RecipeCategory") &&
        self$name == other$name
    },

    #' @description Serialize to list for JSON
    #' @return List representation
    to_list = function() {
      lst <- list(
        name = self$name,
        description = self$description,
        parent = if (!is.null(self$parent)) {
          self$parent$to_list()
        } else {
          NULL
        }
      )
      lst
    },

    #' @description Print category
    #' @param ... Additional arguments (not used)
    print = function(...) {
      cat(cli::style_bold(self$name), "\n")
      if (nchar(self$description) > 0) {
        cat("  ", self$description, "\n")
      }
      if (!is.null(self$parent)) {
        cat("  Path:", self$get_path(), "\n")
      }
      invisible(self)
    },

    #' @description Deserialize a RecipeCategory from a list
    #' @param lst List with name, description, parent fields, or NULL
    #' @return RecipeCategory object or NULL
    from_list = function(lst) {
      # Placeholder - actual implementation added via $set() below
      msvy_abort(
        paste0(
          "This method should be called as ",
          "RecipeCategory$from_list(), not on an instance"
        ),
        class = "metasurvey_error_recipe"
      )
    }
  )
)

# Actual $from_list implementation; roxygen docs live on the placeholder
# method inside the class definition (plain comments here so roxygen's R6
# mode does not merge a second block into the class topic).
RecipeCategory$set("public", "from_list", function(lst) {
  if (is.null(lst)) {
    return(NULL)
  }
  parent <- if (!is.null(lst$parent)) {
    RecipeCategory$new(
      name = lst$parent$name,
      description = lst$parent$description %||% "",
      parent = RecipeCategory$public_methods$from_list(
        NULL, lst$parent$parent
      )
    )
  } else {
    NULL
  }
  RecipeCategory$new(
    name = lst$name,
    description = lst$description %||% "",
    parent = parent
  )
}, overwrite = TRUE)

# Make from_list callable as RecipeCategory$from_list() (class-level)
RecipeCategory$from_list <- function(lst) {
  if (is.null(lst)) {
    return(NULL)
  }
  # Handle empty data.frames from JSON simplifyVector
  if (is.data.frame(lst) && (nrow(lst) == 0 || ncol(lst) == 0)) {
    return(NULL)
  }
  # Handle empty lists from JSON (NULL serialized as {})
  if (is.list(lst) && length(lst) == 0) {
    return(NULL)
  }
  parent_obj <- NULL
  if (
    !is.null(lst$parent) &&
      !(is.data.frame(lst$parent) && (nrow(lst$parent) == 0 || ncol(lst$parent) == 0)) &&
      !(is.list(lst$parent) && length(lst$parent) == 0)
  ) {
    parent_obj <- RecipeCategory$from_list(lst$parent)
  }
  RecipeCategory$new(
    name = lst$name,
    description = lst$description %||% "",
    parent = parent_obj
  )
}

#' @title Default recipe categories
#' @description Returns a list of standard built-in
#'   categories for recipe classification.
#' @return List of RecipeCategory objects
#' @examples
#' cats <- default_categories()
#' vapply(cats, function(c) c$name, character(1))
#' @family tidy-api
#' @export
default_categories <- function() {
  list(
    RecipeCategory$new(
      "labor_market",
      "Labor market indicators (employment, unemployment, wages)"
    ),
    RecipeCategory$new(
      "income",
      "Income distribution and poverty measurement"
    ),
    RecipeCategory$new(
      "education",
      "Education attainment and enrollment"
    ),
    RecipeCategory$new(
      "health",
      "Health outcomes and access to healthcare"
    ),
    RecipeCategory$new(
      "demographics",
      "Population structure and demographic characteristics"
    ),
    RecipeCategory$new("housing", "Housing conditions and access")
  )
}
