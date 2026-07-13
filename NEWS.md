# metasurvey.core 0.3.0

Initial release of the local processing engine of the `metasurvey`
ecosystem, extracted from the original monolith (archived as
[`metasurvey-legacy`](https://github.com/metasurveyr/metasurvey-legacy))
following the modularization suggested during the rOpenSci review. The
version number is aligned with the `metasurvey` meta-package.

* Core engine: `Survey`, `RotativePanelSurvey` and `PoolSurvey` R6 classes,
  the lazy step pipeline (`step_compute()`, `step_recode()`,
  `step_rename()`, `step_remove()`, `step_join()`, `step_filter()`,
  `bake_steps()`), recipes with automatic documentation and validation,
  and estimation workflows built on the `survey` package (means, totals,
  ratios and domain estimation with CV-based quality labels).
* Rotating panels with implantation and follow-up waves, pooled
  estimation, and bootstrap replicate weights via `add_replicate()`.
* Local (JSON-backed) recipe and workflow registries. The remote (`"api"`)
  backend is provided through an injectable hook
  (`options(metasurvey.backend_provider = ...)`), registered by the
  companion package `metasurvey.explorer.backend`; core itself has no
  network, Shiny, or STATA dependencies.
* 13 bilingual vignettes (English and Spanish), including an ECH case
  study that runs offline on a bundled microdata sample and reproducible
  examples for seven international household surveys.
* rOpenSci-ready packaging: README, CONTRIBUTING, Code of Conduct,
  GPL-3 license files, `codemeta.json`, pkgdown site, and CI (R CMD check,
  pkgcheck, coverage, pre-commit).
