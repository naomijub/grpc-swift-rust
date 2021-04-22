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
        
    func list() -> Array<Notes_Note> {
        var notes: Array<Notes_Note> = []
        let call = client.list(Notes_Empty(), callOptions: options)

      call.response.whenSuccess { summary in
        notes = summary.notes
      }

      call.response.whenFailure { error in
        print("Notes_ListRoute Failed: \(error)")
      }

      call.status.whenComplete { notes in
        print("Finished Notes_ListRoute")
      }
    
      // Wait for the call to end.
      _ = try! call.status.wait()
        
        return notes
    }
    
    func get(id: String) -> ResultNote {
        var note = ResultNote.init()
        var note_id = Notes_NoteRequestId.init();
        note_id.id = id
        
        let call = client.get(note_id, callOptions: options)
        
        call.response.whenSuccess { summary in
            note.note = summary
        }

        call.response.whenFailure { error in
            note.error = error
          print("Notes_ListRoute Failed: \(error)")
        }

        call.status.whenComplete { notes in
          print("Finished Notes_GetRoute")
        }
      
        // Wait for the call to end.
        _ = try! call.status.wait()
        
        return note
    }
    
    func addOrUpdate(note: Notes_Note, which: Options) -> ResultNote {
        var result = ResultNote.init();
        var call: UnaryCall<Notes_Note, Notes_Note>
        
        if which == Options.Add {
            call = client.insert(note, callOptions: options)
        } else if which == Options.Update {
            call = client.update(note, callOptions: options)
        } else {
            result.error = EventLoopError.cancelled
            return result
        }
        
        
        call.response.whenSuccess { summary in
            result.note = summary
        }

        call.response.whenFailure { error in
            result.error = error
          print("Notes_ListRoute Failed: \(error)")
        }

        call.status.whenComplete { notes in
          print("Finished Notes_AddOrUpdateRoute")
        }
      
        // Wait for the call to end.
        _ = try! call.status.wait()
        
        return result
    }
    
    func delete(id: String) -> ResultNote {
        var result = ResultNote.init()
        var note_id = Notes_NoteRequestId.init();
        note_id.id = id
        
        let call = client.delete(note_id, callOptions: options)


        call.response.whenFailure { error in
            result.error = error
          print("Notes_ListRoute Failed: \(error)")
        }

        call.status.whenComplete { notes in
          print("Finished Notes_DeleteRoute")
        }
      
        // Wait for the call to end.
        _ = try! call.status.wait()
        
        return result
    }
    
}
