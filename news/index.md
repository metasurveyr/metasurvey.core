# Changelog

## metasurvey.core 0.3.0

- Version aligned with the `metasurvey` meta-package (0.3.0).
- Added five English vignettes (recipes, workflows and estimation,
  complex designs, panel analysis, convey inequality) and Spanish
  translations of the four core ones.
- Added pkgdown site configuration with a bilingual article index.
- Added rOpenSci submission files: `README.md`, `CONTRIBUTING.md`,
  `CODE_OF_CONDUCT.md`, `LICENSE.md`, and `codemeta.json`.

## metasurvey.core 0.1.0

- Initial release. Extracted from the `metasurvey` monolith (now
  [`metasurvey-legacy`](https://github.com/metasurveyr/metasurvey-legacy))
  as part of the modularization suggested by the rOpenSci review. See
  `MIGRATION.md`.
- Contains the local processing engine: `Survey`/`RotativePanelSurvey`/
  `PoolSurvey`, the step pipeline, recipes, workflows, and a local
  (JSON-backed) recipe/workflow backend. No network, Shiny, or STATA
  dependencies.
- The remote (`"api"`) backend is provided via an injectable hook
  (`options(metasurvey.backend_provider = ...)`), registered by
  `metasurvey.explorer.backend`.
