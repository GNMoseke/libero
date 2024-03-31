use crate::items::BacklogItem;
use log::{debug, error};
use mongodb::bson::{doc, Document};
use mongodb::options::FindOptions;
use mongodb::Collection;
use rocket::futures::StreamExt;

// TODO: this needs to be sendable to use generically in rocket state
/// A generic Backlog store trait to allow test mocking.
/// (or swapping the underlying store in the future if I feel like returning to the comfortable land of relational DBs)
pub trait BacklogStore {
    async fn write_items(&self, new_items: Vec<BacklogItem>) -> bool;
    async fn get_items(
        &self,
        filter: impl Into<Option<Document>>,
        sort_by: Option<&str>,
    ) -> Result<Vec<BacklogItem>, mongodb::error::Error>;
    async fn delete_items(&self) -> bool;
}

// TODO: this needs to be a client instead of a user collection to support multiple users
pub struct MongoBacklogStore {
    // each user has their own DB
    // each user has (right now) one collection with all their backlog items in it
    // I could split this on some field like type but that feels needless for something so simple
    pub user_collection: Collection<BacklogItem>,
}

impl BacklogStore for MongoBacklogStore {
    async fn write_items(&self, new_items: Vec<BacklogItem>) -> bool {
        let res = self.user_collection.insert_many(new_items, None).await;
        match res {
            Ok(insert_result) => {
                debug!("successfully inserted new items: {:?}", insert_result);
                true
            }
            Err(err) => {
                error!("Issue inserting new items to backlog: {}", err);
                false
            }
        }
    }

    async fn get_items(
        &self,
        filter: impl Into<Option<Document>>,
        sort_by: Option<&str>,
    ) -> Result<Vec<BacklogItem>, mongodb::error::Error> {
        // if a sort field is provided, use that. Otherwise deafault to category.
        let sort_option = sort_by.unwrap_or("category");
        let find_options = FindOptions::builder().sort(doc! { sort_option: 1 }).build();
        // TODO: allow pagination options to be passed here as part of findoptions
        let mut cursor = self.user_collection.find(filter, find_options).await?;
        let mut items = Vec::<BacklogItem>::new();
        while let Some(item) = cursor.next().await {
            match item {
                Ok(backlog_entry) => items.push(backlog_entry),
                Err(err) => {
                    error!("Unknown item in iteration: {}", err)
                }
            }
        }
        debug!("Items returned from mongodb: {:?}", items);
        Ok(items)
    }

    async fn delete_items(&self) -> bool {
        todo!()
    }
}
