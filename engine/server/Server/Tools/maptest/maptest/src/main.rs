use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, StatusCode};
use hyper::server::Server;
use tokio::fs::File;
use tokio::io::AsyncReadExt;
use std::convert::Infallible;
use std::net::SocketAddr;
use mime_guess::from_path;
use std::path::{Path, PathBuf};

async fn serve_file(req: Request<Body>, base_path: PathBuf) -> Result<Response<Body>, Infallible> {
    let mut path = sanitize_path(req.uri().path(), &base_path);

    if path.is_dir() {
        path.push("index.html");
    }

    match File::open(&path).await {
        Ok(mut file) => {
            let mut contents = vec![];
            match file.read_to_end(&mut contents).await {
                Ok(_) => {
                    let mime_type = from_path(&path).first_or_octet_stream();
                    Ok(Response::builder()
                        .header("Content-Type", mime_type.as_ref())
                        .body(Body::from(contents))
                        .unwrap())
                }
                Err(_) => Ok(response_with_code(StatusCode::INTERNAL_SERVER_ERROR)),
            }
        }
        Err(_) => Ok(response_with_code(StatusCode::NOT_FOUND)),
    }
}

fn sanitize_path(uri_path: &str, base_path: &Path) -> PathBuf {
    let path = uri_path.trim_start_matches('/').replace("/", &std::path::MAIN_SEPARATOR.to_string());
    base_path.join(path)
}

fn response_with_code(status_code: StatusCode) -> Response<Body> {
    Response::builder()
        .status(status_code)
        .body(Body::from(status_code.to_string()))
        .unwrap()
}

#[tokio::main]
async fn main() {
    let addr = SocketAddr::from(([127, 0, 0, 1], 5001));
    let base_path = PathBuf::from("../");

    let make_svc = make_service_fn(move |_| {
        let base_path = base_path.clone();
        async {
            Ok::<_, Infallible>(service_fn(move |req| {
                serve_file(req, base_path.clone())
            }))
        }
    });

    let server = Server::bind(&addr).serve(make_svc);

    println!("Listening on http://{}", addr);

    if let Err(e) = server.await {
        eprintln!("server error: {}", e);
    }
}
