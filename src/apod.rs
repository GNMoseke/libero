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

    // attempt hq url first, fallback if necessary
    let image_url = apod.hdurl.unwrap_or(apod.url);
    let file_ext = std::path::Path::new(&image_url)
        .extension()
        .and_then(OsStr::to_str)
        .ok_or("Unable to parse file type")?;
    let mut file_path = std::fs::File::create(file_store_dir + "apod-" + &apod.date + file_ext)?;
    let apod_file = reqwest::get(image_url).await?.text().await?;
    let _ = std::io::copy(&mut apod_file.as_bytes(), &mut file_path);
    info!("Successfully wrote APOD to {file_path:?}");
    Ok(())
}
