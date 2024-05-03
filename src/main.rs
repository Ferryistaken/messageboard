use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use tokio::fs::{self, read_dir, File};
use tokio::io::AsyncReadExt;
use std::path::PathBuf;

#[get("/")]
async fn dailymessages() -> impl Responder {
    let header_path = "./log/header.txt";
    let messages_path = "./log/messages.log";
    let footer_path = "./log/footer.txt";

    let header = fs::read_to_string(header_path).await;
    let messages = fs::read_to_string(messages_path).await;
    let footer = fs::read_to_string(footer_path).await;

    if let (Ok(header), Ok(messages), Ok(footer)) = (header, messages, footer) {
        let contents = format!("{}\n{}\n{}", header, messages, footer);
        HttpResponse::Ok().body(contents)
    } else {
        HttpResponse::InternalServerError().body("Failed to load one or more files")
    }
}

#[get("/archive")]
async fn read_archive() -> impl Responder {
    let path = PathBuf::from("./log/backups/");
    let header_path = "./log/header.txt";
    let footer_path = "./log/footer.txt";

    let header_future = fs::read_to_string(header_path);
    let footer_future = fs::read_to_string(footer_path);
    let (header_result, footer_result) = tokio::join!(header_future, footer_future);

    let header = match header_result {
        Ok(content) => content,
        Err(_) => return HttpResponse::InternalServerError().body("Failed to read header"),
    };

    let footer = match footer_result {
        Ok(content) => content,
        Err(_) => return HttpResponse::InternalServerError().body("Failed to read footer"),
    };

    let mut dir = match read_dir(path).await {
        Ok(dir) => dir,
        Err(_) => return HttpResponse::InternalServerError().body("Failed to read directory"),
    };

    let mut contents = Vec::new();

    while let Ok(Some(entry)) = dir.next_entry().await {
        if let Ok(file_type) = entry.file_type().await {
            if file_type.is_file() {
                let mut file = match File::open(entry.path()).await {
                    Ok(file) => file,
                    Err(_) => continue, // Skip files that can't be opened
                };
                let mut data = String::new();
                if file.read_to_string(&mut data).await.is_ok() {
                    contents.push(data);
                }
            }
        }
    }

    let combined_contents = format!("{}\n{}\n{}", header, contents.join("\n"), footer);
    HttpResponse::Ok().body(combined_contents)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(dailymessages)
            .service(read_archive)
    })
    .bind(("0.0.0.0", 6969))?
    .run()
    .await
}
