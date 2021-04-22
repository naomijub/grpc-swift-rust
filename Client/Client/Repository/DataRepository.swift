import Foundation
import GRPC
import NIO

class DataRepository {
    private let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    private let client:Notes_NoteServiceClient
    private var options = CallOptions()
    
    static let shared = DataRepository()
    init() {
        options.timeLimit = TimeLimit.timeout(TimeAmount.seconds(30))
        let channel = ClientConnection.insecure(group: group)
          .connect(host: "localhost", port: 50051)
        client = Notes_NoteServiceClient(channel: channel)
    }
        
    func list() -> Result<Array<Notes_Note>, Error> {
        var notes: Array<Notes_Note>?
        var error: Error?;
        let call = client.list(Notes_Empty(), callOptions: options)

      call.response.whenSuccess { summary in
        notes = summary.notes
      }

      call.response.whenFailure { e in
        error = e
        print("Notes_ListRoute Failed: \(e)")
      }

      call.status.whenComplete { notes in
        print("Finished Notes_ListRoute")
      }
    
      // Wait for the call to end.
      _ = try! call.status.wait()
        
        if error != nil {
            return .failure(error!)
        }
        return .success(notes!)
    }
    
    func get(id: String) -> Result<Notes_Note, Error> {
        var note: Notes_Note?;
        var error: Error?;
        var note_id = Notes_NoteRequestId.init();
        note_id.id = id
        
        let call = client.get(note_id, callOptions: options)
        
        call.response.whenSuccess { summary in
            note = summary
        }

        call.response.whenFailure { e in
            error = e
          print("Notes_ListRoute Failed: \(e)")
        }

        call.status.whenComplete { notes in
          print("Finished Notes_GetRoute")
        }
      
        // Wait for the call to end.
        _ = try! call.status.wait()
        
        if error != nil {
            return .failure(error!)
        }
        return .success(note!)
    }
    
    func addOrUpdate(note: Notes_Note, which: Options) -> Result<Notes_Note, Error> {
        var result: Notes_Note?;
        var call: UnaryCall<Notes_Note, Notes_Note>
        var error: Error?;
        
        if which == Options.Add {
            call = client.insert(note, callOptions: options)
        } else if which == Options.Update {
            call = client.update(note, callOptions: options)
        } else {
            return .failure(EventLoopError.cancelled)
            
        }
        
        
        call.response.whenSuccess { summary in
            result = summary
        }

        call.response.whenFailure { e in
            error = e
          print("Notes_ListRoute Failed: \(e)")
        }

        call.status.whenComplete { notes in
          print("Finished Notes_AddOrUpdateRoute")
        }
      
        // Wait for the call to end.
        _ = try! call.status.wait()
        
        if error != nil {
            return .failure(error!)
        }
        return .success(result!)
    }
    
    func delete(id: String) -> Result<Notes_Note, Error> {
        let result = Notes_Note.init()
        var error: Error?;
        var note_id = Notes_NoteRequestId.init();
        note_id.id = id
        
        let call = client.delete(note_id, callOptions: options)


        call.response.whenFailure { e in
            error = e
          print("Notes_ListRoute Failed: \(e)")
        }

        call.status.whenComplete { notes in
          print("Finished Notes_DeleteRoute")
        }
      
        // Wait for the call to end.
        _ = try! call.status.wait()
        
        if error != nil {
            return .failure(error!)
        }
        return .success(result)
    }
    
}
