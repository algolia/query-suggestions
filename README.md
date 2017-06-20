# Query suggestions

Using Algolia indices and their analytics, generate a new query suggestion index.

# Quick Start

```bash
CONFIG='{
  "app_id": "A1B2C3D4",
  "api_key": "a1b2c3d4e5f6a1b2c3d4e5f6",

  "indices": [{
    "name": "products"
  }, {
    "name": "articles"
  }]
}' \
bundle exec ./run
```

For a more thorough example, click [here](#detailed-example).

# Options

## Global variables

- `index_prefix`: The generated index will be called `${index_prefix}query_suggestions`

### Credentials

You can either specify a single application ID and api key:
- `app_id <string>`: Algolia application ID
- `api_key <string>`: Algolia Admin API Key  
   _Or an API key with the permissions described in `source_api_key` and `target_api_key` below._


Or different credentials for the sources and the destination indices:
- For the source, you'll need to specify:
  * `source_app_id <string>`
  * `source_api_key <string>`: It needs the _Search_, _Analytics_ and _GetSettings_ ACLs on the source indices

- For the destination, you'll need to specify:
  * `target_app_id <string>`
  * `target_api_key <string>`: It needs the _Write_ ACL on the destination index

## Index variables

Mandatory:
- `name <string>`: Name of the index to use as a source  

The other index variables are both definable at the root of the `CONFIG` object, which will set the default value, and at the index level which will override the default value.

Source parameters:
- `replicas <boolean>`: Use the analytics on the replica indices too  
  Default: `true`
- `analytics_tags <array of strings>`: Restrict on specific analytics tags, which can be specified at query time
  Default: `[]`
- `generate <array of arrays of strings>`: Use facet values to generate queries  
  Example: "apple" and "apple smartphones" with `[["brand"], ["brand", "type"]]`  
  Default: `[]`
- `query_type <string>`: Accepts `prefixNone`, `prefixLast` and `prefixNone`  
  Default: the [`queryType` setting](https://www.algolia.com/doc/api-client/ruby/parameters/#querytype) value in the index settings (which itself defaults to `prefixLast`)

Restriction parameters:
- `min_letters <number>`: Too small queries will often be useless for your users  
  Default: 4
- `min_hits <number>`: Amount of associated hits with typo tolerance and prefix matching disabled, used to discard irrelevant queries  
  Default: 5 - Rule of thumb for big indices: Amount of records / 10000 .
- `exclude <array of strings>`: Array of regular expressions that you don't want to match any of your suggestions  
  Default: []

# Detailed example

Here is an example using all the options described above.

```bash
CONFIG='{
  "source_app_id": "A1B2C3D4",
  "source_api_key": "a1b2c3d4e5f6a1b2c3d4e5f6",
  "target_app_id": "4D3C2B1A",
  "target_api_key": "6f5e4d3c2b1a6f5e4d3c2b1a",
  "index_prefix": "prod_",

  "min_letters": 3,
  "min_hits": 5,
  "query_type": "prefixNone",

  "exclude": [
    "p[o0]rn[o0]?(graphy)?"
  ],

  "indices": [{
    "name": "products",

    "analytics_tags": ["autocomplete", "search_page"],
    "replicas": true,
    "to_generate": [
      ["brand"],
      ["type"],
      ["category"],
      ["brand", "type"]
    ],

    "min_letters": 8,
    "min_hits": 20,
    "query_type": "prefixLast",

    "exclude": [
      "CompetitorBrand"
    ]
  }, {
    "name": "articles",

    "replicas": false
  }]
}' \
bundle exec ./run
```
