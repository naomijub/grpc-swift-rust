use tonic::{transport::Server, Request, Response, Status};
use tokio::sync::Mutex;
use std::collections::HashMap;

mod notes;

use notes::{
    note_service_server::{NoteService, NoteServiceServer},
    Note, NoteList, NoteRequestId
};

#[derive(Default)]
pub struct NoteContext {
    context: Mutex<HashMap<String, Note>>
}

#[tonic::async_trait]
impl NoteService for NoteContext {
    async fn list(&self,_request:Request<notes::Empty>,)->Result<Response<NoteList>,Status> {
        let data = self.context.lock().await;
        let note_list = data.iter().map(|n| n.1.to_owned()).collect::<Vec<Note>>();

        if note_list.is_empty() {
            Err(Status::not_found("Empty list"))
        } else {
            Ok(Response::new(NoteList {
                notes: note_list
            }))
        }
    }

    async fn get(&self,request:Request<NoteRequestId>,)->Result<Response<Note>,Status> {
        let note_id = request.into_inner();
        let data = self.context.lock().await;

        let note = data.get(&note_id.id);

        if let Some(note) = note {
            Ok(Response::new(note.to_owned()))
        } else {
            Err(Status::not_found(note_id.id))
        }
    }

    async fn insert(&self,request:Request<Note>,)->Result<Response<Note>,Status> {
        let note = request.into_inner();
        let mut data = self.context.lock().await;

        
        if !data.contains_key(&note.id) {
            data.insert(note.id.clone(), note.clone());
            Ok(Response::new(note))
        } else {
            Err(Status::already_exists(note.id))
        }
    }

    async fn update(&self,request:Request<Note>,)->Result<Response<Note>,Status> {
        let note = request.into_inner();
        let mut data = self.context.lock().await;

        
        if data.contains_key(&note.id) {
            let previous = data.insert(note.id.clone(), note.clone());
            Ok(Response::new(previous.unwrap()))
        } else {
            Err(Status::not_found(note.id))
        }
    }

    async fn delete(&self,request:Request<NoteRequestId>,)->Result<Response<notes::Empty>,Status> {
        let note_id = request.into_inner();
        let mut data = self.context.lock().await;

        
        if data.contains_key(&note_id.id) {
            data.remove(&note_id.id);
            Ok(Response::new(notes::Empty::default()))
        } else {
            Err(Status::not_found(note_id.id))
        }
    }
}


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse().unwrap();
    let note = NoteContext::default();
    println!("Server listening on {}", addr);

    Server::builder()
        .add_service(NoteServiceServer::new(note))
        .serve(addr)
        .await?;
    Ok(())
}