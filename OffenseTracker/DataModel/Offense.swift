//
//  Offense.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//
//OH MY GOD JSUT ADD THE COUNT I DONT NEED TO MAKE AN ARRAY OF EMOJIS I CAN JUST LABEL THE BUTTON I JUST NEED TO SAVE THE COUNT
import Foundation
import CloudKit
import UserNotifications
import UIKit

struct SingleOffense: Identifiable {
    var id: String
    var name: String
    var date: Date
    var dislike: Int
   
    
    init(id: String = UUID().uuidString, name: String, date: Date, dislike: Int) {
        self.id = id
        self.name = name
        self.date = date
        self.dislike = dislike
     
    }
//    static var exampleOff = [SingleOffense(name: "Burnt my shake", date: Date.now), SingleOffense(name: "Another 1", date: Date.now)]
}

@MainActor
class Offenses: ObservableObject{
    
    enum AppState {
        case loading, loaded, failed(Error)
    }
    private let ckService = CloudKitService()
    
    @Published var appState: AppState = .loaded
    @Published var listOfOffenses: [SingleOffense] = []
    @Published var addedImage = false
    
    func dislikeIncrement(_ offense: SingleOffense) async throws {
        try await ckService.incrementDislikes(offense)
        
    }
    func fetchOffenses() async throws {
        
        do {
            self.listOfOffenses = try await ckService.fetchOffenses()
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }
    
    func saveNewEvent(withName name: String, date: Date, dislike: Int) async throws {
        appState = .loading
        do {
            let off = SingleOffense(name: name, date: date, dislike: dislike)
            try await ckService.saveOff(off)
            listOfOffenses.append(off)
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }
    
    func delete(_ offToRemove: SingleOffense) async throws {
        appState = .loading
        do {
            try await ckService.delteEvent(offToRemove)
            listOfOffenses = listOfOffenses.filter { storedOff in
                return storedOff.id != offToRemove.id
            }
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }
    
    func update(_ updateOff: SingleOffense) async throws {
        appState = .loading
        do {
            try await ckService.updateOffense(updateOff)
            var updatedOffs = listOfOffenses.filter { storedOff in
                return storedOff.id != updateOff.id
            }
            updatedOffs.append(updateOff)
            self.listOfOffenses = updatedOffs
            appState = .loaded
            
        } catch {
            appState = .failed(error)
        }
    }
    func requestNotifPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notfication permisstions success")
                DispatchQueue.main.async{
                    UIApplication.shared.registerForRemoteNotifications()
                    self.subscribeNotification()
                }
                
            } else {
                print("Notification permission failed")
                
            }
        }
        
        
    }
    
    func subscribeNotification() {
        let container = CKContainer(identifier: "iCloud.newOffenses")
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: "Offenses", predicate: predicate, subscriptionID: "Offenses_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "Kiana messed up"
        notification.alertBody = "Come see what she did"
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        container.publicCloudDatabase.save(subscription) { returnedSub, returnedError in
            if let error = returnedError {
                print("It failed: \(error.localizedDescription)")
            } else {
                print("Successfully subscribed to notfications!")
            }
        }
    }
    
    
    
}
