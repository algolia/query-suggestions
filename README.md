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
