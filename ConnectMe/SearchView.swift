//
//  SearchView.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredUsers) { user in
                        NavigationLink(value: user) {
                            VStack{
                                NavigationLink(destination: ProfileView(user: user)) {
                                    UserCell(user: user)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Divider()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search")
            .onChange(of: searchText) { newValue in
                viewModel.filterUsers(for: newValue) // Gọi hàm filterUsers khi searchText thay đổi
            }
        }
    }
}

#Preview {
    SearchView()
}
