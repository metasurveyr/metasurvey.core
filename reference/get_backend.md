# Get recipe backend

Returns the currently configured recipe backend. Defaults to "api" if
not configured.

## Usage

``` r
get_backend()
```

## Value

RecipeBackend object

## See also

Other backends:
[`get_workflow_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/get_workflow_backend.md),
[`set_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/set_backend.md),
[`set_workflow_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/set_workflow_backend.md)

## Examples

``` r
set_backend("local", path = tempfile(fileext = ".json"))
backend <- get_backend()
backend
#> <RecipeBackend>
#>   Public:
#>     clone: function (deep = FALSE) 
#>     filter: function (survey_type = NULL, edition = NULL, category = NULL, 
#>     get: function (id) 
#>     increment_downloads: function (id) 
#>     initialize: function (type, path = NULL) 
#>     list_all: function () 
#>     load: function () 
#>     publish: function (recipe) 
#>     rank: function (n = NULL) 
#>     save: function () 
#>     search: function (query) 
#>     type: local
#>   Private:
#>     .path: /tmp/RtmpHVh7Yc/file1f2323cf4172.json
#>     .registry: RecipeRegistry, R6
```
