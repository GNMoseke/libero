use log::info;
use mongodb::bson::{doc, Document};
use mongodb::options::FindOptions;
use mongodb::Collection;
use rocket::futures::StreamExt;
use serde::{Deserialize, Serialize};
use std::env;
use std::ffi::OsStr;

#[derive(Debug, Deserialize)]
pub struct Apod {
    pub copyright: Option<String>,
    pub date: String,
    pub explanation: String,
    pub title: String,
    hdurl: Option<String>,
    media_type: String,
    url: String,
}

impl Apod {
    /// Return on-disk file name
    pub fn file_name(&self) -> Result<String, String> {
        let image_url = self.image_url();
        let file_ext = std::path::Path::new(&image_url)
            .extension()
            .and_then(OsStr::to_str)
            .ok_or("Unable to parse file type")?;
        Ok("apod-".to_owned() + &self.date + "." + file_ext)
    }

    fn image_url(&self) -> String {
        // attempt hq url first, fallback if necessary
        return self.hdurl.as_ref().unwrap_or(&self.url).to_string();
    }
}

pub async fn download_apod(db: &impl ApodStore) -> Result<(), Box<dyn std::error::Error>> {
    info!("Starting Astronomy Picture of the Day download...");
    // get json response, grab high quality image URL
    let file_store_dir = env::var("APOD_PATH").unwrap_or("/tmp/".to_owned());
    let api_key = env::var("APOD_API_KEY").unwrap_or("DEMO_KEY".to_owned());
    let endpoint = "https://api.nasa.gov/planetary/apod?api_key=".to_owned() + &api_key;
    let apod = reqwest::get(endpoint).await?.json::<Apod>().await?;

    if apod.media_type == "video" {
        return Err("Video currently unsupported.".into());
    }

    let file_name = &apod.file_name()?;
    let mut file_path = std::fs::File::create(file_store_dir + file_name)?;
    let mut apod_file = std::io::Cursor::new(reqwest::get(apod.image_url()).await?.bytes().await?);
    let _ = std::io::copy(&mut apod_file, &mut file_path);
    info!("Successfully wrote APOD to {file_path:?}");

    db.write_entry(ApodEntry {
        date: apod.date,
        title: apod.title,
        copyright: apod.copyright,
        explanation: apod.explanation,
        filename: file_name.to_string(),
        favorite: false,
    })
    .await;

    Ok(())
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ApodEntry {
    pub date: String,
    pub title: String,
    pub copyright: Option<String>,
    pub explanation: String,
    pub filename: String,
    pub favorite: bool,
}
// NB: this needs to be a client to support multiple users - right now I am targeting just me
pub struct MongoApodStore {
    // each user has their own DB
    // each user has (right now) one collection with all their backlog items in it
    // I could split this on some field like type but that feels needless for something so simple
    pub user_collection: Collection<ApodEntry>,
}

pub trait ApodStore {
    fn write_entry(&self, apod: ApodEntry) -> impl std::future::Future<Output = bool> + Send;
    fn get_entry(
        &self,
        filter: impl Into<Option<Document>>,
        sort_by: Option<&str>,
    ) -> impl std::future::Future<Output = Result<Vec<ApodEntry>, mongodb::error::Error>>;
}

impl ApodStore for MongoApodStore {
    async fn write_entry(&self, apod: ApodEntry) -> bool {
        let res = self.user_collection.insert_one(apod, None).await;
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

    async fn get_entry(
        &self,
        filter: impl Into<Option<Document>>,
        sort_by: Option<&str>,
    ) -> Result<Vec<ApodEntry>, mongodb::error::Error> {
        // if a sort field is provided, use that. Otherwise deafault to category.
        let sort_option = sort_by.unwrap_or("category");
        let find_options = FindOptions::builder().sort(doc! { sort_option: 1 }).build();
        // TODO: allow pagination options to be passed here as part of findoptions
        let mut cursor = self.user_collection.find(filter, find_options).await?;
        let mut items = Vec::<ApodEntry>::new();
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
}
