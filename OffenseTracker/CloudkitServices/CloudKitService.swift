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
    
    private let container = CKContainer(identifier: "iCloud.newOffenses")
    
    private lazy var database = container.publicCloudDatabase
    
    
    public func saveOff(_ offense: SingleOffense) async throws {
        let record = CKRecord(recordType: "Offenses", recordID: .init(recordName: offense.id))
        
        record["name"] = offense.name
        record["date"] = offense.date
        record["emojis"] = offense.emojis
        record["count"] = offense.count
        
        try await database.save(record)
    }
    
    public func fetchEvents() async throws -> [SingleOffense] {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Offenses", predicate: predicate)
        
        let sortDes = [NSSortDescriptor(key: "date", ascending: false)]
        
        query.sortDescriptors = sortDes
        
        
        let (matchResults, _) = try await database.records(matching: query)
        let results = matchResults.map { matchResult in
            return matchResult.1
        }
        
        let records = results.compactMap { result in
            try? result.get()
            
        }
        let offenses: [SingleOffense] = records.compactMap { record in
            guard let name = record["name"] as? String,
                  let date = record["date"] as? Date,
                  let emojis = record["emojis"] as? [String],
                  let count = record["count"] as? Int else {
                return SingleOffense(name: "No name", date: Date.now, emojis: ["none"], count: 0)
            }
            return SingleOffense(id: "\(record.recordID.recordName)", name: name, date: date, emojis: emojis, count: count)
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
        print("Offense id: \(offense.id)")
        
        guard let fetchedRecord = try? await database.record(for: .init(recordName: offense.id)) else {
            throw CloudKitServiceError.recordNotInDatabase
        }
        _ = try await database.modifyRecords(saving: [], deleting: [fetchedRecord.recordID])
    }
    
    
}

