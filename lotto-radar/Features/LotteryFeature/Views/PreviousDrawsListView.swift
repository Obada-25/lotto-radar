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
            VStack(alignment: .leading, spacing: 8) {
                Text(formatted(date: draw.drawDate))
                    .font(.subheadline)
                Text(formatted(totalStake: Double(draw.totalStake) ?? 0))
                    .font(.subheadline).bold()
                    .foregroundStyle(draw.lottery.mainColor)
                    .padding(.all, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(draw.lottery.accentColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(draw.lottery.mainColor, lineWidth: 2)
                    )

                NumbersRowView(drawResult: draw.drawResult)
            }
            .padding(.vertical, 6)
        }
        .listStyle(.plain)
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private func formatted(date: Date) -> String {
        return Self.dateFormatter.string(from: date)
    }
    
    private func formatted(totalStake: Double) -> String {
        return Self.currencyFormatter.string(from: NSNumber(value: totalStake)) ?? ""
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }()
}

private struct NumbersRowView: View {
    let drawResult: DrawResult
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(drawResult.numbers, id: \.self) { number in
                Text("\(number)")
                    .font(.subheadline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            if let superNumber = drawResult.superNumber {
                Text("\(superNumber)")
                    .font(.subheadline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.yellow.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            if let euroNumbers = drawResult.euroNumbers, !euroNumbers.isEmpty {
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
    }
}

#Preview {
    PreviousDrawsListView(draws: [])
}
