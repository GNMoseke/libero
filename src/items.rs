use rocket::serde::{Serialize, Deserialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
pub struct BacklogItem {
    id: Uuid,
    category: BacklogItemCategory,
    title: String,
    progress: BacklogItemProgress,
    favorite: Option<bool>,
    replay: Option<bool>,
    notes: Option<String>,
    // TODO: use custom type to allow for user-defined rating scales
    rating: Option<i32>,
    //TODO: use custom type to allow user-defined genres & easier filtering
    genre: Option<String>,
    // TODO: Enable & this should be refactored to an array of tag types eventually
    // tags: Option<Vec<String>>
}

#[derive(Serialize, Deserialize)]
pub enum BacklogItemCategory {
    Game,
    Book,
    Movie,
    Show
}

#[derive(Serialize, Deserialize)]
pub enum BacklogItemProgress {
    Backlog,
    InProgress,
    Complete,
    DNF
}