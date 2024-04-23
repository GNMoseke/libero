use log::info;
use serde::Deserialize;
use std::env;
use std::ffi::OsStr;

#[derive(Debug, Deserialize)]
struct Apod {
    copyright: Option<String>,
    date: String,
    explanation: String,
    hdurl: Option<String>,
    media_type: String,
    service_version: String,
    title: String,
    url: String,
}

impl Apod {
    /// Return on-disk file name
    fn file_name(&self) -> Result<String, String> {
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
pub async fn download_apod() -> Result<(), Box<dyn std::error::Error>> {
    info!("Starting Astronomy Picture of the Day download...");
    // get json response, grab high quality image URL
    let file_store_dir = env::var("APOD_PATH").unwrap_or("/tmp/".to_owned());
    let api_key = env::var("APOD_API_KEY").unwrap_or("DEMO_KEY".to_owned());
    let endpoint = "https://api.nasa.gov/planetary/apod?api_key=".to_owned() + &api_key;
    let apod = reqwest::get(endpoint).await?.json::<Apod>().await?;

    if apod.media_type == "video" {
        return Err("Video currently unsupported.".into());
    }

    let mut file_path = std::fs::File::create(file_store_dir + &apod.file_name()?)?;
    let mut apod_file = std::io::Cursor::new(reqwest::get(apod.image_url()).await?.bytes().await?);
    let _ = std::io::copy(&mut apod_file, &mut file_path);
    info!("Successfully wrote APOD to {file_path:?}");
    Ok(())
}
