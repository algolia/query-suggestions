# Deprecation notice

This repository will soon be removed and should not be used to build new projects.

Algolia has introduced a new version of its Analytics service (V2) which makes this repository obsolete.
In the new Analytics service, top searches are limited to 1k results.
As a result, the number of suggestions can not exceed that number unless you are using any of the other suggestion generation strategies.

Algolia will soon provide a newly hosted version of this service along the other Analytics services.

In the meantime, if you have any question regarding this feature, please feel free to reach out to support@algolia.com mentioning that you have read this notice.

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

For a more complete description of all the configuration parameters, see [`connector/CONFIG.md`](./connector/CONFIG.md).
