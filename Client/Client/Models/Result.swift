//
//  Result.swift
//  Client
//
//  Created by Julia Naomi Boeira on 22/04/21.
//
import GRPC
import Foundation

struct ResultNote {
    var note: Notes_Note?
    var error: Error?
    
    init(note: Notes_Note?, error: Error?) {
        self.note = note
        self.error = error
    }
    
    init() {
        self.note = nil
        self.error = nil
    }
}
