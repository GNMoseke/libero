This includes some copy-pastable curl commands for testing

# Backlog
Post a new entry:
```sh
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"Hades","progress":"Complete","category":"Game","rating":10,"favorite":true}' \
  http://localhost:8000/backlog/item
```
Get entries:
```sh
# All entries
curl http://localhost:8000/backlog

# With filter
curl "http://localhost:8000/backlog?sort_by=title&filter_field=foo&filter_value=bar"
```
Delete an entry by title/genre
```sh
curl --request DELETE "http://localhost:8000/backlog/item?title=Hades&category=Game"
```

Update an item by title/genre
```sh
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"Hades","progress":"Complete","category":"Game","rating":10,"favorite":true,"notes":"Artemis Boons OP"}' \
  http://localhost:8000/backlog/item/update
```
You can of course update an entry by deleting it and then re-adding it


# APOD
Get the picture for the day (will overwrite existing file if it exists for this date)
```sh
curl http://localhost:8000/apod/refresh
```

Mark a picture as favorite by date
```sh
curl -X POST "http://localhost:8000/apod/favorite?date=YYYY-MM-DD"
```
