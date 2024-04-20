// Modules
mod backlog;
mod apod;
// Local Crates
use crate::backlog::{BacklogItem, BacklogStore, MongoBacklogStore};

// External Crates
#[macro_use]
extern crate rocket;
use log::{error, info};
use mongodb::{bson::doc, options::ClientOptions, Client};
use rocket::serde::json::{json, Json, Value};
use rocket::State;

#[get("/ping")]
fn ping() -> &'static str {
    "pong"
}

// TODO: allow user param to be passed for queries to dispatch to correct mongo db
// let db = self.client.database(&self.user);

// TODO: move these to their own file/handler crate

// TODO: pagination
#[get("/?<sort_by>&<filter_field>&<filter_value>")]
async fn list_backlog_entries(
    sort_by: Option<&str>,
    filter_field: Option<&str>,
    filter_value: Option<&str>,
    db: &State<MongoBacklogStore>,
) -> Json<Vec<BacklogItem>> {
    // if we're given both parts of a filter, use it. Otherwise pass None.
    let document_matcher = match (filter_field, filter_value) {
        (Some(field), Some(val)) => doc! { field: val }.into(),
        _ => None,
    };

    let all_entries = db.get_items(document_matcher, sort_by).await;
    match all_entries {
        Ok(entries) => Json(entries),
        Err(err) => {
            // TODO: convert this to a failed response code instead of just silently swallowing
            error!("Error occured getting entries: {:?}", err);
            Json(Vec::new())
        }
    }
}

#[post("/item", data = "<new_item>")]
async fn create_backlog_entry(new_item: Json<BacklogItem>, db: &State<MongoBacklogStore>) -> Value {
    if db.write_items(vec![new_item.into_inner()]).await {
        json!({ "status": "success" })
    } else {
        json!({ "status": "fail"})
    }
}

// delete by title and category, which should be a sufficiently unique combination
// both are required fields for a BacklogItem so all entries should have them
#[delete("/item?<title>&<category>")]
async fn remove_backlog_entry(title: &str, category: &str, db: &State<MongoBacklogStore>) -> Value {
    // NOTE: this is case-sensitive (intentionally)
    if db
        .delete_items(doc! { "title": title, "category": category })
        .await
    {
        json!({ "status": "success" })
    } else {
        json!({ "status": "fail"})
    }
}

#[get("/refresh")]
async fn refresh_apod() -> Value {
    // download file and store
    apod::download_apod();
    // TODO: need to create a DB entry here as well so I can mark as favorite and similar
    json!({"status": "success"})
}

#[post("/favorite")]
async fn mark_favorite() -> Value {
    unimplemented!();
}

#[get("/favorite?<id>")]
async fn get_favorites(id: Option<&str>) -> Value {
    // if no Id passed, return full list
    unimplemented!();
}

/* TODO Routes for:
- C&H or other comic
- mood playlist
- run/ride planner
- APOD
- xkcd
- wikipedia fun fact
- shitty quote
- random game/book/movie with high rating that you can add to backlog
- dinner options
*/

#[rocket::main]
async fn main() -> Result<(), rocket::Error> {
    env_logger::init();

    info!("Starting server...");
    // Parse a connection string into an options struct.
    // we explicitly want to panic here if we can't connect to the database, so use `.unwrap()`
    let client_options = ClientOptions::parse("mongodb://localhost:27017")
        .await
        .unwrap();
    let mongo_client = Client::with_options(client_options).unwrap();

    info!("Successfully connected to mongo instance...");

    // Mount paths by namespace
    rocket::build()
        .mount("/util", routes![ping])
        .mount(
            "/backlog",
            routes![
                list_backlog_entries,
                create_backlog_entry,
                remove_backlog_entry
            ],
        )
        .mount("/apod", routes![refresh_apod])
        .manage(
            // TODO: de-hardcode this
            // This is global application state accessible by any handler
            // through the magic of mongo, these will be created automatically if they don't already exist
            MongoBacklogStore {
                user_collection: mongo_client.database("user1").collection("Backlog"),
            },
        )
        .launch()
        .await?;

    Ok(())
}
