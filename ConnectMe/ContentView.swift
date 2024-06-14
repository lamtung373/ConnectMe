//
//  ContentView.swift
//  ConnectMe
//
//  Created by Tisp on 05/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            Group {
                if viewModel.userSession != nil {
                    ConnectMeTabView()
                } else {
                    LoginView()
                }
            }
        } else {
            VStack{
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.isActive = true
                    
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
