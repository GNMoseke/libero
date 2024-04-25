This is a fun toy project for a personal home dashboard server meant to both be useful and as some Rust practice. Planned features:
1. Backlog tracking for games/movies/tv shows/books and a "now playing/reading/etc" (fancy spreadsheet)
2. Automatic planning of run/cycling routes based on a training schedule each morning
3. Getting the Nasa Astronomy Picture of the Day/current xckd/wikipedia home page/etc or any other fun stuff

# Currently working on
- Backlog system v0.1.0 (I am the one millionth person to write a new thing that's basically a discount spreadsheet)
- Morning dashboard with the NASA Astronomy Picture of the Day

## Development
You'll need a mongodb instance running locally for the backlog system, the easiest way to do this is with docker:

```sh
$ docker run --name khares-mongodb -p 27017:27017 -d mongo:latest
```

^ by default the above will not persist data once the container is gone, if you need to volume mount it:

```sh
$ docker run --name khares-mongodb -v /path/on/local:/data/db -p 27017:27017 -d mongo:latest
```

## Env Config
- `APOD_API_KEY`: NASA APOD API key, can be generated [here](https://api.nasa.gov/).
- `APOD_PATH`: Path to store the APOD when downloaded. If not configured defaults to `/tmp/`. Must have a trailing slash