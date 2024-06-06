//
//  Offense.swift
//  OffenseTracker
//
//  Created by Maria Reyna on 2/12/24.
//

import Foundation
import CloudKit
import UserNotifications
import UIKit

struct Reaction: Identifiable {
    var id: String
    var icon: String
    var count: Int
    
    init(id: String = UUID().uuidString, icon: String = "👎", count: Int) {
        self.id = id
        self.icon = icon
        self.count = count
    }
}


struct SingleOffense: Identifiable {
    var id: String
    var name: String
    var date: Date
    
    init(id: String = UUID().uuidString, name: String, date: Date) {
        self.id = id
        self.name = name
        self.date = date
    }
    static var exampleOff = [SingleOffense(name: "Burnt my shake", date: Date.now), SingleOffense(name: "Another 1", date: Date.now)]
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
    @Published var reactions: [Reaction] = []
    
    func fetchReactions() async throws {
        
        do {
            self.reactions = try await ckService.fetchReactions()
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }

    
    func fetchOffenses() async throws {
        
        do {
            self.listOfOffenses = try await ckService.fetchEvents()
            appState = .loaded
        } catch {
            appState = .failed(error)
        }
    }
    
    func saveNewEvent(withName name: String, date: Date) async throws {
        appState = .loading
        do {
            let off = SingleOffense(name: name, date: date)
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
    
//    func endOfDayNotification(){
//        
//        let center = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//        content.title = "End of Day Recap"
//        content.body = "How many times did Miss Bauer mess up today"
//        //content.categoryIdentifier = "alarm"
//       // content.userInfo = ["customData": "fizzbuzz"]
//        content.sound = UNNotificationSound.default
//
//        var dateComponents = DateComponents()
//        dateComponents.hour = 12
//        dateComponents.minute = 00
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        center.add(request)
//
//       
//    }
    
}
