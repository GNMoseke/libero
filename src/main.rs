#[macro_use] extern crate rocket;

#[get("/ping")]
fn ping() -> &'static str {
    "pong"
}

#[launch]
fn rocket() -> _ {
    // Mount paths by namespace

    // Util routes
    rocket::build().mount("/util", routes![ping])
}
