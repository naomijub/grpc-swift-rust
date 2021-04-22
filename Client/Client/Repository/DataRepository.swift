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
    
}
