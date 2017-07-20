# Introduction

The `run` script accepts four environment variables:
- `APPLICATION_ID`: Your [Algolia application ID][api_keys_page]
- `API_KEY`: Your [Admin API key][api_keys_page]
- `INDEX_PREFIX`: A prefix you want to use for the index name.
  If for instance, you used `prod_` here, the generated index would be called `prod_query_suggestions`.
- `CONFIG`: A JSON object containing all configuration options

[api_keys_page]: https://www.algolia.com/api-keys

In this file, we'll describe the configuration object in `CONFIG`.  
Here is an example:

```json
{
  "external": "google_analytics_export",
  "exclude": [
    "p[o0]rn[Oo]?(graphy)?",
    "killing"
  ],
  "ignore_plurals": ["en"],
  "indices": [{
    "name": "products",
    "replicas": true,
    "generate": [
      ["brand"],
      ["type"],
      ["categories"],
      ["brand", "type"]
    ],
    "external": [
      "alternate_analytics_source_index"
    ],
    "min_letters": 4,
    "min_hits": 20,
    "facets": [
      { "attribute": "brand", "amount": 1 },
      { "attribute": "categories", "amount": 2 }
    ]
  }, {
    "name": "blog_posts"
  }]
}
```

## Global options

### Credentials

- `source_app_id`
- `source_api_key`
- `target_app_id`
- `target_api_key`

Useful if you want to use a different application for the source than for the destination.

### Exclude

- `exclude` - Default: `[]`

You can use regexes to ignore some queries.
If a query matches any regex in this list, it will simply be skipped.

### Ignore plurals

- `ignore_plurals`

Accepts all available values for [`ignorePlurals`][ignore_plurals] in the API.  
Used to deduplicate between "chat bot" and "chat bots" for instance.
We'll keep only the most popular of the two, the other one inherits from its popularity.

[ignore_plurals]: https://www.algolia.com/doc/api-reference/api-parameters/ignorePlurals/

## Index options

- `indices`

This parameter contains the configuration for each of the source indices.

### Basic

- `name`

Index name.

- `replicas`: `true|false` - Default: `true`

Whether to use analytics of the replicas indices too.

### Analytics

- `analytics_tags` - Default: `[]`
- `analytics_days` - Default: `90`
- `distinct_by_ip` - Default: false

Analytics tags can be used to restrict the analytics we use to only a subset of your users usage.
Can be useful to distinguish between different sections of your website that both target the same index (e.g. homepage vs blog).

`distinct_by_ip` allows to prevent a user spamming a query and making it come up in the suggestions list. Resource intensive, might timeout.

### Generation

- `generate` - Default: `[]`

Generate queries using facets with a popularity at 0.

_Example:_

```json
{
  "generate": [
    ["brand"],
    ["type"],
    ["brand", "type"]
  ]
}
```

Generates:
- "apple"
- "samsung"
- "smartphone"
- "tv"
- "apple smartphone"
- "samsung smartphone"
- "apple tv"
- "samsung tv"

### External

- `external`: Array of indices you want to use.
- [Optional] `external_source`: Accepts either `"source"` or `"target"` (See [Credentials](#credentials))

You can use an external index to populate your index.  
This can be useful when you have an external source for analytics, for instance Google Analytics.

### Expansion

- `query_type`: `null|"prefixLast"|"prefixAll"|"prefixNone"` - Default: `null`

Algolia analytics contain mostly prefixes.
To still provide relevant queries to your users, we can try to interpolate which words the user were meaning with those prefixes.
When null, we use [the index setting][query_type] (the different options are also desribed in this link).

[query_type]: https://www.algolia.com/doc/api-reference/api-parameters/queryType/

### Refining / Filtering

- `min_hits` - Default: `5`
- `min_letters` - Default: `4`
- `exclude` - Default: `[]`

Those options allow to avoid suggesting irrelevant queries.

### Relevant facets

- `facets` - Default: `[]`

Used to create suggestions results with associated relevant categories.

Accepts objects with those values:

```json
{
  "attribute": "brand",
  "amount": "3"
}
```
