//
//  CreateConnectMeView.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    
    @StateObject var viewModel = CreatePostViewModel()
    
    @State private var caption = ""
    @State private var showImagePicker = false
    @State private var isPosting = false
    
    @Environment(\.dismiss) var dismiss
    
    private var user: User? {
        return UserService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    CircularProfilelmageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.username ?? "")
                            .fontWeight(.semibold)
                        
                        TextField("Start a post...", text: $caption, axis: .vertical)
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !caption.isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        let imageViews = viewModel.images.map { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 300)
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                        
                        ForEach(0..<imageViews.count, id: \.self) { index in
                            imageViews[index]
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.colorA)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isPosting {
                        ProgressView()
                    } else {
                        Button("Post") {
                            isPosting = true
                            Task {
                                try await viewModel.uploadFeed(caption: caption)
                                dismiss()
                                isPosting = false
                            }
                        }
                        .opacity(caption.isEmpty ? 0.5 : 1.0)
                        .disabled(caption.isEmpty)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.colorA)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title2)
                            .foregroundColor(.colorA)
                    }
                    .disabled(isPosting)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(images: $viewModel.selectedImages)
            }
            .onChange(of: viewModel.selectedImages) { newImages in
                viewModel.images = newImages.map { Image(uiImage: $0) }
            }
        }
    }
}

#Preview {
    CreatePostView()
}
