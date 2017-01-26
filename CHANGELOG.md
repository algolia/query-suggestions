<a name="1.2.1"></a>
## [1.2.1](https://github.com/algolia/algolia-popular-queries/compare/v1.2.0...v1.2.1) (2017-01-26)


### Bug Fixes

* **SearchString:** fix multiline regexp ([43b185f](https://github.com/algolia/algolia-popular-queries/commit/43b185f))



<a name="1.2.0"></a>
# [1.2.0](https://github.com/algolia/algolia-popular-queries/compare/v1.1.0...v1.2.0) (2016-12-22)


### Features

* **CONFIG:** indices now accepts an array ([75c447d](https://github.com/algolia/algolia-popular-queries/commit/75c447d))


### BREAKING CHANGES

* CONFIG: The old comma separated string list doesn't work anymore for the indices attribute.
  Since we're accepting JSON as an input, it indeed seems weird that we would rely on this.
  Just a new minor because no-one except us seem to use this connector right now.



<a name="1.1.0"></a>
# [1.1.0](https://github.com/algolia/algolia-popular-queries/compare/v1.0.3...v1.1.0) (2016-12-14)


### Bug Fixes

* **analytics:** startAt not start_at ([45b1825](https://github.com/algolia/algolia-popular-queries/commit/45b1825))


### Features

* **generation:** add query generation capabilities ([13282b5](https://github.com/algolia/algolia-popular-queries/commit/13282b5))



<a name="1.0.3"></a>
## [1.0.3](https://github.com/algolia/algolia-popular-queries/compare/v1.0.2...v1.0.3) (2016-12-14)


### Bug Fixes

* **config:** handle default correctly ([242046e](https://github.com/algolia/algolia-popular-queries/commit/242046e))



<a name="1.0.2"></a>
## [1.0.2](https://github.com/algolia/algolia-popular-queries/compare/v1.0.1...v1.0.2) (2016-12-14)


### Bug Fixes

* **credentials:** use .blank? instead of || ([70099ec](https://github.com/algolia/algolia-popular-queries/commit/70099ec))



<a name="1.0.1"></a>
## [1.0.1](https://github.com/algolia/algolia-popular-queries/compare/v1.0.0...v1.0.1) (2016-12-13)


### Bug Fixes

* **data:** index query (duplicate of objectID) ([d61f4ab](https://github.com/algolia/algolia-popular-queries/commit/d61f4ab))



<a name="1.0.0"></a>
# [1.0.0](https://github.com/algolia/algolia-popular-queries/compare/v0.0.8...v1.0.0) (2016-12-12)



<a name="0.0.8"></a>
## [0.0.8](https://github.com/algolia/algolia-popular-queries/compare/v0.0.7...v0.0.8) (2016-12-12)


### Features

* **tags:** allow using analytics tags ([1251877](https://github.com/algolia/algolia-popular-queries/commit/1251877))



<a name="0.0.7"></a>
## [0.0.7](https://github.com/algolia/algolia-popular-queries/compare/v0.0.6...v0.0.7) (2016-12-10)


### Bug Fixes

* **main:** exclude queries with special characters ([6643fc0](https://github.com/algolia/algolia-popular-queries/commit/6643fc0))
* **main:** use single spaces between words ([f1ebeb6](https://github.com/algolia/algolia-popular-queries/commit/f1ebeb6))



<a name="0.0.6"></a>
## [0.0.6](https://github.com/algolia/algolia-popular-queries/compare/v0.0.5...v0.0.6) (2016-12-09)


### Bug Fixes

* **config:** type cast numbers ([96e4647](https://github.com/algolia/algolia-popular-queries/commit/96e4647))



<a name="0.0.5"></a>
## [0.0.5](https://github.com/algolia/algolia-popular-queries/compare/v0.0.4...v0.0.5) (2016-12-09)


### Features

* **config:** retrieve constants from the config ([9da172a](https://github.com/algolia/algolia-popular-queries/commit/9da172a))



<a name="0.0.4"></a>
## [0.0.4](https://github.com/algolia/algolia-popular-queries/compare/v0.0.3...v0.0.4) (2016-12-09)


### Features

* **source:** allow to provide source_{app_id,api_key} ([5151d7c](https://github.com/algolia/algolia-popular-queries/commit/5151d7c))



<a name="0.0.3"></a>
## [0.0.3](https://github.com/algolia/algolia-popular-queries/compare/v0.0.2...v0.0.3) (2016-12-09)


### Bug Fixes

* **config:** retrieve env vars ([cad15af](https://github.com/algolia/algolia-popular-queries/commit/cad15af))



<a name="0.0.2"></a>
## [0.0.2](https://github.com/algolia/algolia-popular-queries/compare/v0.0.1...v0.0.2) (2016-12-09)


### Features

* **indices:** accept multiple indices as a source ([f3fc10e](https://github.com/algolia/algolia-popular-queries/commit/f3fc10e))



<a name="0.0.1"></a>
## [0.0.1](https://github.com/algolia/algolia-popular-queries/compare/2726960...v0.0.1) (2016-12-08)


### Bug Fixes

* **algoliasearch:** use latest version ([f1c79a6](https://github.com/algolia/algolia-popular-queries/commit/f1c79a6))


### Features

* **popular:** initial commit ([2726960](https://github.com/algolia/algolia-popular-queries/commit/2726960))



