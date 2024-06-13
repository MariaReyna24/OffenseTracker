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
        record["dislike"] = offense.dislike
        
        try await database.save(record)
    }
    
    public func fetchOffenses() async throws -> [SingleOffense] {
        
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
                  let dislike = record["dislike"] as? Int else {
                return SingleOffense(name: "N/A", date: Date.now, dislike: 0)
            }
            return SingleOffense(id: "\(record.recordID.recordName)", name: name, date: date, dislike: dislike)
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
    
//    public func localDislikeToCloud(_ offense: SingleOffense, localDis: Int) async throws {
//        guard let fetchedRecord = try? await database.record(for: .init(recordName: offense.id)) else {
//            throw CloudKitServiceError.recordNotInDatabase
//        }
//        var local = localDis
//        fetchedRecord["dislike"] = local
//        _ = try await database.modifyRecords(saving: [fetchedRecord], deleting: [])
//    }
    
   public func incrementDislikes(_ offense: SingleOffense) async throws {
        guard let fetchedRecord = try? await database.record(for: .init(recordName: offense.id)) else {
            throw CloudKitServiceError.recordNotInDatabase
        }
        fetchedRecord["dislike"] = (offense.dislike) + 1
        _ = try await database.modifyRecords(saving: [fetchedRecord], deleting: [])
        
    }
    
}

