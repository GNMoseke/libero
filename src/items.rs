use std::fmt::Display;

use rocket::serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct BacklogItem {
    id: String,
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

impl Display for BacklogItem {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}: {} {}", self.title, self.category, self.progress)
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum BacklogItemCategory {
    Game,
    Book,
    Movie,
    Show,
}

impl Display for BacklogItemCategory {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // There's probably a better way to do this with a macro
        let as_string = match self {
            Self::Game => "Game",
            Self::Book => "Book",
            Self::Movie => "Movie",
            Self::Show => "Show",
        };
        write!(f, "Type: {}", as_string)
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum BacklogItemProgress {
    Backlog,
    InProgress,
    Complete,
    DNF,
}

impl Display for BacklogItemProgress {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // There's probably a better way to do this with a macro
        let as_string = match self {
            Self::Backlog => "Baclog",
            Self::InProgress => "In Progress",
            Self::Complete => "Complete",
            Self::DNF => "DNF",
        };
        write!(f, "Progress: {}", as_string)
    }
}
