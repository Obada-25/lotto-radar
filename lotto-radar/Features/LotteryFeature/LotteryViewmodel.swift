//
//  LotteryViewmodel.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

@MainActor
final class LotteryViewModel: ObservableObject {
    // MARK: Properties
    @Published var isLoading = false
    @Published var error: Error?
    @Published var lotteries: [LotteryResponse] = []
    @Published var selectedLottery: LotteryResponse?
    @Published var selectedLotteryType: Lottery? {
        didSet {
            guard let selectedLotteryType else { return }
            if let match = lotteries.first(where: { $0.lottery == selectedLotteryType }) {
                selectedLottery = match
            }
        }
    }
    
    private let networkingService: Networking
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    private lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    // MARK: Initializer
    init (networkingService: Networking) {
        self.networkingService = networkingService
    }
    
    // MARK: Methods
    func fetchData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await networkingService.fetchData()
            switch result {
            case .success(let lotteries):
                self.lotteries = lotteries
                self.selectedLotteryType = lotteries.first?.lottery
            case .failure(let error):
                self.error = error
            }
        } catch {
            self.error = error
        }
    }

    // MARK: Formatting / Derived Data
    func previousDraws(for response: LotteryResponse) -> [Draw] {
        let list = (response.lastDraw.map { [$0] } ?? []) + response.draws
        return list.sorted { $0.drawDate > $1.drawDate }
    }
    
    func formattedNextDrawInfo(for response: LotteryResponse) -> (jackpotText: String?, dateText: String)? {
        guard let next = response.nextDraw else { return nil }
        let currency = next.jackpot.currency
        let topJackpot = next.jackpot.jackpots["WC_1"]
        let jackpotText: String?
        if let amountString = topJackpot, let amount = Double(amountString) {
            currencyFormatter.currencyCode = currency
            jackpotText = currencyFormatter.string(from: NSNumber(value: amount))
        } else {
            jackpotText = nil
        }
        let dateText = formatDate(next.drawDate)
        return (jackpotText, dateText)
    }
    
    func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
