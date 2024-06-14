//
//  ConnectMeTextFieldModifier.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct ConnectMeTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.colorA), lineWidth: 1)
            )
            .padding(.horizontal, 24)
    }
}
