//
//  LotteryViewmodel.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

final class LotteryViewModel: ObservableObject {
    // MARK: Properties
    @Published var isLoading = false
    @Published var error: Error?
    @Published var lotteries: [LotteryResponse] = []
    
    private let networkingService: Networking
    
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
            case .failure(let error):
                self.error = error
            }
        } catch {
            self.error = error
        }
    }
}
