use std::fmt::Display;

use rocket::serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct BacklogItem {
    pub category: BacklogItemCategory,
    pub title: String,
    pub progress: BacklogItemProgress,
    pub favorite: Option<bool>,
    pub replay: Option<bool>,
    pub notes: Option<String>,
    // TODO: use custom type to allow for user-defined rating scales
    pub rating: Option<i32>,
    //TODO: use custom type to allow user-defined genres & easier filtering
    pub genre: Option<String>,
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
        write!(f, "{}", as_string)
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum BacklogItemProgress {
    Backlog,
    InProgress,
    Complete,
    Dnf,
}

impl Display for BacklogItemProgress {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // There's probably a better way to do this with a macro
        let as_string = match self {
            Self::Backlog => "Backlog",
            Self::InProgress => "In Progress",
            Self::Complete => "Complete",
            Self::Dnf => "DNF",
        };
        write!(f, "{}", as_string)
    }
}
