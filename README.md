This is a fun toy project for a personal home dashboard server meant to both be useful and as some Rust practice. Planned features:
1. Backlog tracking for games/movies/tv shows/books and a "now playing/reading/etc" (fancy spreadsheet)
2. Automatic planning of run/cycling routes based on a training schedule each morning
3. Getting the Nasa Astronomy Picture of the Day/current xckd/wikipedia home page/etc or any other fun stuff

# Currently working on
- Backlog system v0.1.0 (I am the one millionth person to write a new thing that's basically a discount spreadsheet)

## Development
You'll need a mongodb instance running locally for the backlog system, the easiest way to do this is with docker:

```sh
$ docker run --name khares-mongodb -p 27017:27017 -d mongodb/mongodb-community-server:latest
```

^ by default the above will not persist data once the container is gone, if you need to volume mount it:

```sh
$ docker run --name khares-mongodb -v /path/on/local:/data/db -p 27017:27017 -d mongodb/mongodb-community-server:latest
```

## Quick CURL command reference
```sh
# post a new entry:
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"Hades","progress":"Complete","category":"Game"}' \
  http://localhost:8000/backlog/item

# get all entries
curl http://localhost:8000/backlog

# Delete an entry by title/genre
curl --request DELETE "http://localhost:8000/backlog/item?title=Hades&category=Game"
```
