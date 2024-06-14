//
//  ActivityView.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct ActivityView: View {
    
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
                    List(viewModel.activities) { activity in
                        VStack(alignment: .leading) {
//                            HStack {
//                                let user = try await UserService.fetchUser(withUid: activity.userId)
//                                CircularProfilelmageView(user: user, size: .small)
//                            }
                            Text(activity.type.capitalized)
                                .font(.headline)
                            
                            if let description = activity.details["description"] {
                                Text(description)
                                    .font(.subheadline)
                            }
                            
                            Text(activity.timestamp, style: .relative)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                    .navigationTitle("Activity")
                    .refreshable {
                        viewModel.fetchActivities()
                    }
                }
    }
}

#Preview {
    ActivityView()
}
