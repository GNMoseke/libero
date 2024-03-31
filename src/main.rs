#[macro_use] extern crate rocket;
use rocket::serde::{Serialize, json::Json};
use log::{debug, error, info};

pub mod items;
pub mod storage;

#[get("/ping")]
fn ping() -> &'static str {
    "pong"
}

// TODO: move these to their own file/handler crate
#[get("/")]
fn list_backlog_entries() -> Json<Vec<items::BacklogItem>> {
    unimplemented!()
    // Return all
    // TODO: allow pagination, sorting, type args
}

#[post("/item")]
fn create_backlog_entry() {
    unimplemented!()
    /*
    Request content needs:
        - Item type enum
        - Title
        - additional metadata per type
     */

    // TODO: store by unique ID
}

#[get("/item?<id>")]
fn get_backlog_entry(id: &str) -> Json<items::BacklogItem> {
    //debug!("raw resp: {}", raw_text);

    unimplemented!()
    /* 
    Request content needs:
        - unique ID of backlog entry
    */
}

#[delete("/item?<id>")]
fn remove_backlog_entry(id: &str) {
    unimplemented!()
    /* 
    Request content needs:
        - unique ID of backlog entry
    */
}

#[launch]
fn rocket() -> _ {
    // Mount paths by namespace
    rocket::build()
        .mount("/util", routes![ping])
        .mount("/backlog", routes![list_backlog_entries, create_backlog_entry, get_backlog_entry, remove_backlog_entry])
}
