# Migración: metasurvey.core

Este paquete es el **motor local** extraído del monolito `metasurvey`
(renombrado a
[`metasurvey-legacy`](https://github.com/metasurveyr/metasurvey-legacy))
como parte de la modularización sugerida por la revisión de rOpenSci.
Ver `RFC-MODULARIZACION.md` en el repo legacy.

Responsabilidad: procesamiento reproducible de encuestas 100% local. Sin
red, sin Shiny, sin STATA. Solo `data.table`, `R6`, `survey` (+
helpers).

## Origen → destino

Todos los archivos vienen de `metasurvey-legacy/R/` salvo indicación.

| Archivo aquí | Origen | Nota |
|----|----|----|
| `survey.R`, `PanelSurvey.R`, `Step.R`, `steps.R` | idem | motor, sin cambios |
| `workflow.R`, `workflow_table.R` | idem | estimación |
| `Recipes.R` | idem | **C1**: [`get_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/get_recipe.md) usaba `api_list_recipes()`; ahora usa `get_backend()$filter()` (funciona local por default) |
| `RecipeWorkflow.R`, `RecipeCategory.R`, `RecipeCertification.R`, `RecipeUser.R` | idem | objetos recipe |
| `recipe_tidy_api.R`, `workflow_tidy_api.R` | idem | tidy API de búsqueda/filtrado LOCAL (delegan en [`get_backend()`](https://metasurveyr.github.io/metasurvey.core/reference/get_backend.md)) |
| `RecipeRegistry.R`, `WorkflowRegistry.R` | idem | catálogos LOCALES (JSON) — quedan en core por la regla “lo local queda en core” |
| `RecipeAPI.R` (clase `RecipeBackend`) | idem | rama `"api"` refactorizada a hook `.backend_api_call()` |
| `WorkflowBackend.R` (clase `WorkflowBackend`) | idem | rama `"api"` refactorizada a hook `.backend_api_call()` |
| `backend-provider.R` | **nuevo** | hook `.backend_api_call()` que delega el backend remoto al provider inyectado |
| `load_survey.R`, `harmonize.R`, `provenance.R` | idem | carga/armonización local |
| `set_engine.R`, `checks.R` | idem | motor/validaciones |
| `meta.R` | idem | **sin** `metasurvey_user_agent()` ni el bloque de auto-config de API del `.onLoad` (van a explorer.backend) |
| `utils.R` | idem | **sin** `resolve_weight_spec()` (→ metasurvey.anda) ni `reproduce_workflow()` (→ metapaquete) |
| `metasurvey.core-package.R` | `metaSurvey-package.R` | doc de paquete adaptada |

## Cortes resueltos (ver RFC §3)

- **C1** —
  [`get_recipe()`](https://metasurveyr.github.io/metasurvey.core/reference/get_recipe.md):
  `api_list_recipes()` → `get_backend()$filter()`. Queda en core y
  funciona con backend local.
- **Backend remoto** — las clases `RecipeBackend`/`WorkflowBackend`
  mantienen la rama `"api"`, pero en vez de llamar `api_*` directo
  delegan en `.backend_api_call(op, args)`. Sin provider registrado da
  error accionable; `metasurvey.explorer.backend` registra el provider
  vía `options(metasurvey.backend_provider = ...)`.
- **utils.R** — `resolve_weight_spec` y `reproduce_workflow` (que
  llamaban `anda_download_microdata`) NO están aquí.
- **meta.R** — el `.onLoad` de core solo hace
  [`default_engine()`](https://metasurveyr.github.io/metasurvey.core/reference/default_engine.md),
  [`set_use_copy()`](https://metasurveyr.github.io/metasurvey.core/reference/set_use_copy.md),
  `verbose`. La auto-config de API se va.

## Tests

32 archivos de test + `helper-survey.R` migrados. Referencias
`metasurvey:::` → `metasurvey.core:::` y `package = "metasurvey"` →
`"metasurvey.core"`. Los tests de `explore_recipes()` (→
explorer.frontend) y `resolve_weight_spec()` (→ anda) se removieron
(comentario apuntando a su nuevo hogar).

Resultado: **1540 pass, 0 fail, 0 error** (8 skips `on CRAN`, 5 warnings
de deprecación preexistentes `use_copy`).

## Dependencia

Ninguna (es la base). Los demás paquetes del ecosistema declaran
`metasurvey.core` en `Imports` + `Remotes: metasurveyr/metasurvey.core`.
