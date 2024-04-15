//
//  CloudKitService.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 4/15/24.
//

import CloudKit
import Foundation

class CloudKitService {
    
    enum CloudKitServiceError: Error {
        case recordNotInDatabase
    }
    
    private let container = CKContainer(identifier: "iCloud.OffensesContainer")
    
    private lazy var database = container.publicCloudDatabase
    
    public func saveOffense(_ offense: Offenses) async throws {
        let identifer = offense.persistentModelID.storeIdentifier!
       
        let record = CKRecord(recordType: "Offense", recordID: .init(recordName: identifer))
        
        record["name"] = offense.name
        record["date"] = offense.date
        
        try await database.save(record)
    }
    
    public func fetchEvents() async throws -> [Offenses] {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Offense", predicate: predicate)
        
        let (matchResults, _) = try await database.records(matching: query)
        
        let results = matchResults.map{ matchResult in
            return matchResult.1
        }
        
        let records = results.compactMap { result in
            try? result.get()
        }
        let offenses: [Offenses] = records.compactMap{ record in
            guard let name = record["name"] as? String,
                  let date = record["date"] as? Date else {
                return nil
            }
            return Offenses(name: name, date: date)
        }
       return offenses
    }
    
}
