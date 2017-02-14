# Popular queries

From a specific index, extract all the popular queries.

# Usage

```bash
APPLICATION_ID=FIXME \
API_KEY=FIXME \
CONFIG='{
  "indices": ["instant_search", "instant_search_price_asc", "instant_search_price_desc"],
  "index_prefix": "instant_search_",
  "min_letters": 3,
  "min_hits": 5,
  "to_generate": { "instant_search": [["brand"], ["type"], ["category"], ["brand", "type"]] },
  "exclude": [
    "p[o0]rn",
    "killing.*people"
  ]
}' \
bundle exec ./run
```
