use log::{debug, error, info};
use mongodb::Collection;
use mongodb::{Client, options::ClientOptions};
use mongodb::bson::{doc, Document};
use crate::items::BacklogItem;


/// A generic Backlog store trait to allow test mocking.
/// (or swapping the underlying store in the future if I feel like returning to the comfortable land of relational DBs)
trait BacklogStore {
    async fn write_items(&self, new_items: Vec<BacklogItem>) -> bool;
    async fn get_items(&self) -> BacklogItem;
    async fn delete_items(&self) -> bool;
}

struct MongoBacklogStore {
    client: Client,
    // each user has (right now) one collection with all their backlog items in it
    // I could split this on some field like type but that feels needless for something so simple
    user_collection: Collection<BacklogItem>,
    // each user has their own DB
    db: mongodb::Database
}

impl BacklogStore for MongoBacklogStore {
    async fn write_items(&self, new_items: Vec<BacklogItem>) -> bool {
        let res = self.user_collection.insert_many(new_items, None).await;
        match res {
            Ok(insert_result) => {
                debug!("successfully inserted new items: {:?}", insert_result);
                true
            },
            Err(err) => {
                error!("Issue inserting new items to backlog: {}", err);
                return false;
            }
        }
    }

    async fn get_items(&self) -> BacklogItem {
        todo!()
    }

    async fn delete_items(&self) -> bool {
        todo!()
    }
}