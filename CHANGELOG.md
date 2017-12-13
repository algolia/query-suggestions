<a name="1.17.1"></a>
## [1.17.1](https://github.com/algolia/query-suggestions/compare/v1.17.0...v1.17.1) (2017-12-13)


### Bug Fixes

* **generator:** correct mishandled nested facets ([8e96c7d](https://github.com/algolia/query-suggestions/commit/8e96c7d))



<a name="1.17.0"></a>
# [1.17.0](https://github.com/algolia/query-suggestions/compare/v1.16.1...v1.17.0) (2017-12-06)


### Features

* **connector:** add user agent ([f32d0d1](https://github.com/algolia/query-suggestions/commit/f32d0d1))



<a name="1.16.1"></a>
## [1.16.1](https://github.com/algolia/query-suggestions/compare/v1.16.0...v1.16.1) (2017-11-25)


### Bug Fixes

* **unprefixer:** disable unprefixing for kanjis ([2a434d8](https://github.com/algolia/query-suggestions/commit/2a434d8))



<a name="1.16.0"></a>
# [1.16.0](https://github.com/algolia/query-suggestions/compare/v1.15.0...v1.16.0) (2017-11-03)


### Bug Fixes

* **debug:** remove the _debug field when debug is off ([b1e3b24](https://github.com/algolia/query-suggestions/commit/b1e3b24))


### Features

* **parallel:** allow to run a config with queries sent in parallel ([32912d9](https://github.com/algolia/query-suggestions/commit/32912d9))



<a name="1.15.0"></a>
# [1.15.0](https://github.com/algolia/query-suggestions/compare/v1.14.6...v1.15.0) (2017-11-03)


### Bug Fixes

* **suggestions_index:** correctly initialize the temporary index ([c86a715](https://github.com/algolia/query-suggestions/commit/c86a715))


### Features

* **connector:** add debug option to the config ([71343fd](https://github.com/algolia/query-suggestions/commit/71343fd))



<a name="1.14.6"></a>
## [1.14.6](https://github.com/algolia/query-suggestions/compare/v1.14.5...v1.14.6) (2017-10-31)


### Bug Fixes

* **unprefixer:** improve the matchedWords handling ([c1ec6ee](https://github.com/algolia/query-suggestions/commit/c1ec6ee))



<a name="1.14.5"></a>
## [1.14.5](https://github.com/algolia/query-suggestions/compare/v1.14.4...v1.14.5) (2017-10-31)


### Bug Fixes

* **unprefixer:** do not rely on matchedWords ([2323b9a](https://github.com/algolia/query-suggestions/commit/2323b9a))



<a name="1.14.4"></a>
## [1.14.4](https://github.com/algolia/query-suggestions/compare/v1.14.3...v1.14.4) (2017-09-14)


### Bug Fixes

* **config:** grab global exclude if sub list is empty ([44c91ba](https://github.com/algolia/query-suggestions/commit/44c91ba))



<a name="1.14.3"></a>
## [1.14.3](https://github.com/algolia/query-suggestions/compare/v1.14.2...v1.14.3) (2017-08-28)



<a name="1.14.2"></a>
## [1.14.2](https://github.com/algolia/query-suggestions/compare/v1.14.1...v1.14.2) (2017-08-24)


### Bug Fixes

* **SuggestionsIndex:** remove wrong attributes to retrieve ([20791ad](https://github.com/algolia/query-suggestions/commit/20791ad))



<a name="1.14.1"></a>
## [1.14.1](https://github.com/algolia/query-suggestions/compare/v1.14.0...v1.14.1) (2017-07-31)


### Bug Fixes

* **unprefixer:** add suport for hash highlighted objects ([3fd0a3a](https://github.com/algolia/query-suggestions/commit/3fd0a3a))



<a name="1.14.0"></a>
# [1.14.0](https://github.com/algolia/query-suggestions/compare/v1.13.0...v1.14.0) (2017-07-26)


### Features

* **SuggestionsIndex:** add analytics facets ([a8d8995](https://github.com/algolia/query-suggestions/commit/a8d8995))



<a name="1.13.0"></a>
# [1.13.0](https://github.com/algolia/query-suggestions/compare/v1.12.0...v1.13.0) (2017-07-20)


### Features

* **record:** add nb_hits in each primary index ([3cf5ee8](https://github.com/algolia/query-suggestions/commit/3cf5ee8))



<a name="1.12.0"></a>
# [1.12.0](https://github.com/algolia/query-suggestions/compare/v1.11.2...v1.12.0) (2017-07-20)


### Features

* **analytics:** add analytics_days ([b3d28a4](https://github.com/algolia/query-suggestions/commit/b3d28a4))
* **external:** move external to an index config ([9128535](https://github.com/algolia/query-suggestions/commit/9128535))



<a name="1.11.2"></a>
## [1.11.2](https://github.com/algolia/query-suggestions/compare/v1.11.1...v1.11.2) (2017-07-13)


### Bug Fixes

* **facets:** add facet counts to generated and external ([3074d5d](https://github.com/algolia/query-suggestions/commit/3074d5d))



<a name="1.11.1"></a>
## [1.11.1](https://github.com/algolia/query-suggestions/compare/v1.11.0...v1.11.1) (2017-07-13)


### Bug Fixes

* **facets:** one facets object per source index ([3252434](https://github.com/algolia/query-suggestions/commit/3252434))



<a name="1.11.0"></a>
# [1.11.0](https://github.com/algolia/query-suggestions/compare/v1.10.0...v1.11.0) (2017-07-12)


### Bug Fixes

* **main:** fix typo resulting in incorrect method call ([a7751f4](https://github.com/algolia/query-suggestions/commit/a7751f4))


### Features

* **facets:** add count of hits with exact query ([c370a45](https://github.com/algolia/query-suggestions/commit/c370a45))



<a name="1.10.0"></a>
# [1.10.0](https://github.com/algolia/query-suggestions/compare/v1.9.0...v1.10.0) (2017-07-12)


### Bug Fixes

* **plurals:** ensure the index is created and has no queue ([d2035eb](https://github.com/algolia/query-suggestions/commit/d2035eb))


### Features

* **external:** add the ability to import data from an external index ([5460020](https://github.com/algolia/query-suggestions/commit/5460020))



<a name="1.9.0"></a>
# [1.9.0](https://github.com/algolia/query-suggestions/compare/v1.8.0...v1.9.0) (2017-06-20)


### Features

* **renaming:** change to query suggestions ([cfd3853](https://github.com/algolia/query-suggestions/commit/cfd3853))



<a name="1.8.0"></a>
# [1.8.0](https://github.com/algolia/query-suggestions/compare/v1.7.0...v1.8.0) (2017-04-04)


### Features

* **distinct:** add distinct_by_ip index config ([c240222](https://github.com/algolia/query-suggestions/commit/c240222))



<a name="1.7.0"></a>
# [1.7.0](https://github.com/algolia/query-suggestions/compare/v1.6.1...v1.7.0) (2017-03-27)


### Features

* **unprefixer:** change prefix replacement ([b2fd3dc](https://github.com/algolia/query-suggestions/commit/b2fd3dc))



<a name="1.6.1"></a>
## [1.6.1](https://github.com/algolia/query-suggestions/compare/v1.6.0...v1.6.1) (2017-03-22)


### Bug Fixes

* **source_index:** slaves or replica setting can be empty ([cc21384](https://github.com/algolia/query-suggestions/commit/cc21384))



<a name="1.6.0"></a>
# [1.6.0](https://github.com/algolia/query-suggestions/compare/v1.5.0...v1.6.0) (2017-03-20)


### Bug Fixes

* **config:** properly handle exclude inheritance ([2b3a11a](https://github.com/algolia/query-suggestions/commit/2b3a11a))


### Features

* **ignore_plurals:** new parameter ([5c61445](https://github.com/algolia/query-suggestions/commit/5c61445))



<a name="1.5.0"></a>
# [1.5.0](https://github.com/algolia/query-suggestions/compare/v1.4.0...v1.5.0) (2017-03-15)


### Bug Fixes

* **config:** regexp warning ([ade02f6](https://github.com/algolia/query-suggestions/commit/ade02f6))
* **main:** do not hold everything in ram ([59606e8](https://github.com/algolia/query-suggestions/commit/59606e8))
* **main:** ignore if blank, not only nil ([fe1c6c1](https://github.com/algolia/query-suggestions/commit/fe1c6c1))
* **source_index:** generate and replicas should be set to their defaults ([78f24d1](https://github.com/algolia/query-suggestions/commit/78f24d1))
* **source_index:** properly handle query_type ([b3cc714](https://github.com/algolia/query-suggestions/commit/b3cc714))


### Features

* **source_index:** replicas should reuse generated from primary ([02a9a20](https://github.com/algolia/query-suggestions/commit/02a9a20))



<a name="1.4.0"></a>
# [1.4.0](https://github.com/algolia/query-suggestions/compare/v1.3.0...v1.4.0) (2017-03-15)


### Features

* **CONFIG:** prepare new format ([6eb4b15](https://github.com/algolia/query-suggestions/commit/6eb4b15))
* **prefix:** handle prefix searches too now ([622ba1b](https://github.com/algolia/query-suggestions/commit/622ba1b))
* **replicas:** use the same config for replicas ([f33eed5](https://github.com/algolia/query-suggestions/commit/f33eed5))



<a name="1.3.0"></a>
# [1.3.0](https://github.com/algolia/query-suggestions/compare/v1.2.1...v1.3.0) (2017-02-14)


### Features

* **exclude:** add exclude exclusion array w/ Regexes ([6d5ad1c](https://github.com/algolia/query-suggestions/commit/6d5ad1c))
* **search_string:** accept numbers too (iphone 7, windows 10) ([1c75caa](https://github.com/algolia/query-suggestions/commit/1c75caa))



<a name="1.2.1"></a>
## [1.2.1](https://github.com/algolia/query-suggestions/compare/v1.2.0...v1.2.1) (2017-01-26)


### Bug Fixes

* **SearchString:** fix multiline regexp ([43b185f](https://github.com/algolia/query-suggestions/commit/43b185f))



<a name="1.2.0"></a>
# [1.2.0](https://github.com/algolia/query-suggestions/compare/v1.1.0...v1.2.0) (2016-12-22)


### Features

* **CONFIG:** indices now accepts an array ([75c447d](https://github.com/algolia/query-suggestions/commit/75c447d))


### BREAKING CHANGES

* CONFIG: The old comma separated string list doesn't work anymore for the indices attribute.
  Since we're accepting JSON as an input, it indeed seems weird that we would rely on this.
  Just a new minor because no-one except us seem to use this connector right now.



<a name="1.1.0"></a>
# [1.1.0](https://github.com/algolia/query-suggestions/compare/v1.0.3...v1.1.0) (2016-12-14)


### Bug Fixes

* **analytics:** startAt not start_at ([45b1825](https://github.com/algolia/query-suggestions/commit/45b1825))


### Features

* **generation:** add query generation capabilities ([13282b5](https://github.com/algolia/query-suggestions/commit/13282b5))



<a name="1.0.3"></a>
## [1.0.3](https://github.com/algolia/query-suggestions/compare/v1.0.2...v1.0.3) (2016-12-14)


### Bug Fixes

* **config:** handle default correctly ([242046e](https://github.com/algolia/query-suggestions/commit/242046e))



<a name="1.0.2"></a>
## [1.0.2](https://github.com/algolia/query-suggestions/compare/v1.0.1...v1.0.2) (2016-12-14)


### Bug Fixes

* **credentials:** use .blank? instead of || ([70099ec](https://github.com/algolia/query-suggestions/commit/70099ec))



<a name="1.0.1"></a>
## [1.0.1](https://github.com/algolia/query-suggestions/compare/v1.0.0...v1.0.1) (2016-12-13)


### Bug Fixes

* **data:** index query (duplicate of objectID) ([d61f4ab](https://github.com/algolia/query-suggestions/commit/d61f4ab))



<a name="1.0.0"></a>
# [1.0.0](https://github.com/algolia/query-suggestions/compare/v0.0.8...v1.0.0) (2016-12-12)



<a name="0.0.8"></a>
## [0.0.8](https://github.com/algolia/query-suggestions/compare/v0.0.7...v0.0.8) (2016-12-12)


### Features

* **tags:** allow using analytics tags ([1251877](https://github.com/algolia/query-suggestions/commit/1251877))



<a name="0.0.7"></a>
## [0.0.7](https://github.com/algolia/query-suggestions/compare/v0.0.6...v0.0.7) (2016-12-10)


### Bug Fixes

* **main:** exclude queries with special characters ([6643fc0](https://github.com/algolia/query-suggestions/commit/6643fc0))
* **main:** use single spaces between words ([f1ebeb6](https://github.com/algolia/query-suggestions/commit/f1ebeb6))



<a name="0.0.6"></a>
## [0.0.6](https://github.com/algolia/query-suggestions/compare/v0.0.5...v0.0.6) (2016-12-09)


### Bug Fixes

* **config:** type cast numbers ([96e4647](https://github.com/algolia/query-suggestions/commit/96e4647))



<a name="0.0.5"></a>
## [0.0.5](https://github.com/algolia/query-suggestions/compare/v0.0.4...v0.0.5) (2016-12-09)


### Features

* **config:** retrieve constants from the config ([9da172a](https://github.com/algolia/query-suggestions/commit/9da172a))



<a name="0.0.4"></a>
## [0.0.4](https://github.com/algolia/query-suggestions/compare/v0.0.3...v0.0.4) (2016-12-09)


### Features

* **source:** allow to provide source_{app_id,api_key} ([5151d7c](https://github.com/algolia/query-suggestions/commit/5151d7c))



<a name="0.0.3"></a>
## [0.0.3](https://github.com/algolia/query-suggestions/compare/v0.0.2...v0.0.3) (2016-12-09)


### Bug Fixes

* **config:** retrieve env vars ([cad15af](https://github.com/algolia/query-suggestions/commit/cad15af))



<a name="0.0.2"></a>
## [0.0.2](https://github.com/algolia/query-suggestions/compare/v0.0.1...v0.0.2) (2016-12-09)


### Features

* **indices:** accept multiple indices as a source ([f3fc10e](https://github.com/algolia/query-suggestions/commit/f3fc10e))



<a name="0.0.1"></a>
## [0.0.1](https://github.com/algolia/query-suggestions/compare/2726960...v0.0.1) (2016-12-08)


### Bug Fixes

* **algoliasearch:** use latest version ([f1c79a6](https://github.com/algolia/query-suggestions/commit/f1c79a6))


### Features

* **popular:** initial commit ([2726960](https://github.com/algolia/query-suggestions/commit/2726960))



