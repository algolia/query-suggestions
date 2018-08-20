# Introduction

The configuration file contains everyting that Query Suggestions needs in order to function - index names, settings, excluded queries, facets, and more. 

## An example:

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

## Running the configuration file

Once you've set up the configuration file, you need to execute it with the run command.

The `run` script accepts four environment variables:
- `APPLICATION_ID`: Your [Algolia application ID][api_keys_page]
- `API_KEY`: Your [Admin API key][api_keys_page]
- `INDEX_PREFIX`: A prefix you want to use for the index name.
  If, for example, you used `prod_` here, the generated index would be called `prod_query_suggestions`. If this variable is not set, the name will default to `query_suggestions`.
- `CONFIG`: The file name of the JSON configuration file

[api_keys_page]: https://www.algolia.com/api-keys

## Global options

### Credentials

This connector can use Algolia's API on three applications.
The default credentials are passed through the environment variables described above (`APPLICATION_ID`, `API_KEY`).

However, if you want to, you can pass custom credentials for:
- the **source application**: the application where the source indices are stored, with their Analytics
- the **target application**: the application where the query suggestions index will be created

You can change those using these parameters:
- [Optional] `source_app_id` - Default: `APPLICATION_ID` environment variable
- [Optional] `source_api_key` - Default: `API_KEY` environment variable
- [Optional] `target_app_id` - Default: `APPLICATION_ID` environment variable
- [Optional] `target_api_key` - Default: `API_KEY` environment variable

### Debug

- `debug` - Default: `false`

Add a `_debug` field to every generated record to get extra information about what happened to it.

### Exclude

- `exclude` - Default: `[]`

Here, you can add a list of words and phrases that you want ignored: if any query contains a word or phrase in this list, it will be skipped.

Additionally, you can use regular expressions (regexes) to ignore any query that contains a certain set of characters:
if any part of a query matches a regex in this list, it will be skipped.

### Ignore plurals

- `ignore_plurals`

Accepts all available values for [`ignorePlurals`][ignore_plurals] in the API.  
This is used to treat singular and plural forms the same, "chat bot" = "chat bots" for instance.
We'll keep only the most popular of the two, but we combine their popularity scores.

[ignore_plurals]: https://www.algolia.com/doc/api-reference/api-parameters/ignorePlurals/

## Index options

- `indices`

This parameter contains the configuration for each of the source indices.

### Basic

- `name`

Index name.

- `replicas`: `true|false` - Default: `true`

Whether to use the analytics of the replicas indices too.

### Analytics

- `analytics_tags` - Default: `[]`
- `analytics_days` - Default: `90`
- `distinct_by_ip` - Default: false

Analytics tags can be used to restrict the analytics we use to only a subset of your users' usage.
This can be useful to distinguish between different sections of your website that both target the same index (e.g. homepage vs blog).

`distinct_by_ip` allows you to prevent a user from spamming a query and thereby making it more popular in the suggestions list. The analytics API sends us the top 10K queries, with their associated counts. This request is already expensive.
If you add distinct by IP logic there, the request will become really expensive and this is why it might timeout.

### Generating queries

- `generate` - Default: `[]`

Generate queries from facet attributes with a popularity at 0.

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

### External Sources

- `external`: Array of indices you want to use.
- [Optional] `external_source`: Accepts either `"source"` or `"target"` (See [Credentials](#credentials)).

If the external source is not specified, it uses the app passed through the environment variables.

You can use an external index to populate your index.  
This can be useful when you have an external source for analytics, for instance Google Analytics.

This index needs to contain values with this structure:

```js
{
  "query": "iphone",
  "count": "123"
}
```

Optionally, if you're using [Relevant facets](#relevant-facets) you can also provide the facet values which were used the most with a query using `topRefinements`:

```js
{
  "query": "iphone",
  "count": "123",
  "topRefinements": {
    "type": [{
      "value": "smartphones",
      "count": 20
    }, {
      "value": "electronics",
      "count": 10
    }]
  }
}
```


### Expansion

- `query_type`: `null|"prefixLast"|"prefixAll"|"prefixNone"` - Default: `null`

It transforms a query like brea into bread.

Algolia's analytics contain mostly prefixes.
To still provide relevant queries to your users, we can try to interpolate which words the user meant with those prefixes.
When null, we use [the index setting][query_type] (the different options are also desribed in this link).

[query_type]: https://www.algolia.com/doc/api-reference/api-parameters/queryType/

### Refining / Filtering

- `min_hits` - Default: `5`
- `min_letters` - Default: `4`
- `exclude` - Default: `[]`

These options gives you some control, allowing you to avoid suggesting irrelevant queries.

### Relevant facets

- `facets` - Default: `[]`

This is used to create suggestions associated to relevant categories.

Here is an example:

```json
"facets": [
  {
    "attribute": "brand",
    "amount": "3"
  }
]
```
