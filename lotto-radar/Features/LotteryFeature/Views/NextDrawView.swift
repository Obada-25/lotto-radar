//
//  NextDrawView.swift
//  lotto-radar
//
//  Created by Assistant on 16.09.25.
//

import SwiftUI

struct NextDrawView: View {
    let jackpotText: String?
    let dateText: String
    let primaryColor: Color
    let secondaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            if let jackpotText {
                Text(jackpotText)
                    .font(.title3).bold()
                    .foregroundStyle(primaryColor)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(secondaryColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(primaryColor, lineWidth: 4)
                    )
            }
            Text(dateText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NextDrawView(jackpotText: "€10,000,000.00", dateText: "Sep 17, 2025 at 6:25 PM", primaryColor: .black, secondaryColor: .yellow)
}


