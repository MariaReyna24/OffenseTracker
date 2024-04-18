//
//  CloudKitService.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 4/16/24.
//

import Foundation
import CloudKit
class CloudKitService {
    
    enum CloudKitServiceError: Error {
        case recordNotInDatabase
    }
    
    let publicContainer = CKContainer(identifier: "iCloud.com.newOffenses.OffenseTracker")
    
    private lazy var database = publicContainer.publicCloudDatabase
    
    
    public func saveOff(_ offense: SingleOffense) async throws {
        let record = CKRecord(recordType: "Offenses", recordID: .init(recordName: offense.id))
        
        record["name"] = offense.name
        record["date"] = offense.date
        try await database.save(record)
    }
    public func fetchEvents() async throws -> [SingleOffense] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Offenses", predicate: predicate)
        let (matchResults, _) = try await database.records(matching: query)
        let results = matchResults.map{ matchResult in
            return matchResult.1
        }
        
        let records = results.compactMap{ result in
            try? result.get()
            
        }
        let offenses: [SingleOffense] = records.compactMap{ record in
         guard let name = record["name"] as? String,
               let date = record["date"] as? Date else {
             return SingleOffense(name: "No name", date: Date.now)
         }
            return SingleOffense(name: name, date: date)
        }
        return offenses
    }
    public func updateOffense(_ offense: SingleOffense) async throws {
        guard let fetchedRecord = try? await database.record(for: .init(recordName: offense.id)) else {
            throw CloudKitServiceError.recordNotInDatabase
        }
        let record = CKRecord(recordType: "Offenses", recordID: fetchedRecord.recordID)
        record["name"] = offense.name
        record["date"] = offense.date
        
        _ = try await database.modifyRecords(saving: [record], deleting: [])
    }
    public func delteEvent(_ offense: SingleOffense) async throws {
        guard let fetchedRecord = try? await database.record(for: .init(recordName: offense.id)) else {
            throw CloudKitServiceError.recordNotInDatabase
        }
        _ = try await database.modifyRecords(saving: [], deleting: [fetchedRecord.recordID])    }
}
