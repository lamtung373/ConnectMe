//
//  ActivityService.swift
//  ConnectMe
//
//  Created by Tisp on 23/5/24.
//

import Foundation
import FirebaseFirestore

struct ActivityService {
    static func addActivity(userId: String, type: String, details: [String: Any], activityFor: String) {
        var stringDetails = [String: String]()
        for (key, value) in details {
            stringDetails[key] = String(describing: value)
        }
        
        let activity = Activity(userId: userId, activityFor: activityFor, type: type, timestamp: Date(), details: stringDetails)
        
        do {
            let _ = try Firestore.firestore().collection("activities").addDocument(from: activity)
        } catch let error {
            print("Error adding activity: \(error)")
        }
    }
}
