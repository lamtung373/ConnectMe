//
//  ActivityViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 23/5/24.
//

import Foundation
import Firebase

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    
    init() {
        fetchActivities()
    }
    
    func fetchActivities() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("activities")
            .whereField("activityFor", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching activities: \(error.localizedDescription)")
                    return
                }
                
                self.activities = snapshot?.documents.compactMap { document -> Activity? in
                    try? document.data(as: Activity.self)
                }.sorted(by: { $0.timestamp > $1.timestamp }) ?? []
            }
    }
}
