//
//  PreviousDrawsListView.swift
//  lotto-radar
//
//  Created by Assistant on 16.09.25.
//

import SwiftUI

struct PreviousDrawsListView: View {
    let draws: [Draw]
    
    var body: some View {
            List(draws, id: \.drawIdentifier) { draw in
                VStack(alignment: .leading, spacing: 6) {
                    // Numbers line
                    HStack(spacing: 6) {
                        ForEach(draw.drawResult.numbers, id: \.self) { number in
                            Text("\(number)")
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color.gray.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        if let superNumber = draw.drawResult.superNumber {
                            Text("\(superNumber)")
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color.yellow.opacity(0.25))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        if let euroNumbers = draw.drawResult.euroNumbers, !euroNumbers.isEmpty {
                            ForEach(euroNumbers, id: \.self) { euroNumber in
                                Text("\(euroNumber)")
                                    .font(.subheadline)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.orange.opacity(0.25))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                    // Date line
                    Text(formatted(date: draw.drawDate))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }
            .listStyle(.plain)
    }
    
    private func formatted(date: Date) -> String {
        return Self.dateFormatter.string(from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    PreviousDrawsListView(draws: [])
}


