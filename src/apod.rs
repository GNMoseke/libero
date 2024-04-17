use image;
use serde::Deserialize;
use std::env;

#[derive(Debug, Deserialize)]
struct APOD {
    copyright: Option<String>,
    date: String,
    explanation: String,
    hdurl: Option<String>,
    media_type: String,
    service_version: String,
    title: String,
    url: String
}

fn download_apod() {
    info!("Starting Astronomy Picture of the Day download...");
    // get json response, grab high quality image URL
    let api_key = env::var("API_KEY").unwrap_or("DEMO_KEY".to_owned());
    let endpoint = "https://api.nasa.gov/planetary/apod?api_key=".to_owned() + &api_key;
    let api_resp = attohttpc::get(endpoint)
        .send()
        .expect("Could not retrieve the APOD");
    let raw_text = api_resp
        .text()
        .expect("Could not convert the respoinse to text")
        .to_owned();
    debug!("raw resp: {}", raw_text);
    let apod: APOD = serde_json::from_str(raw_text.as_str())
        .expect("Failed to parse Json object from API response");

    // Not a massive fan of magic string here, but it's on a well defined API spec so I'm more OK with it
    if apod.media_type == "video" {
        error!("Video currently unsupported.");
        return;
    }

    // attempt hq url first, fallback if necessary
    let image_url = apod.hdurl.unwrap_or_else(|| apod.url);

    debug!("HQ image URL: {}", image_url);

    // Would like to avoid panicking here, instead log errors
    // TODO: improve this match statement, I'm sure there's a cleaner way to do this
    let image_byte_vec;
    match attohttpc::get(image_url).send() {
        Ok(resp) => match resp.bytes() {
            Ok(bytes) => {
                image_byte_vec = bytes;
                let image = image::load_from_memory(&image_byte_vec).unwrap();
                image.save("test.png").unwrap();
            }
            Err(byte_err) => error!("Failed to create image byte vector with error {}", byte_err),
        },
        Err(resp_err) => error!("Failed to retrieve image with error {}", resp_err),
    }
}
