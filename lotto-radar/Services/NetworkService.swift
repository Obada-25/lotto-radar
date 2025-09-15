//
//  BackendService.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

protocol Networking {
    func fetchData() async throws -> Result<[LotteryResponse], Error>
}

actor NetworkingService: Networking {
    func fetchData() async throws -> Result<[LotteryResponse], any Error> {
        guard let url = URL(string: Constants.baseURL) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode([LotteryResponse].self, from: data)
            return .success(decodedData)
        } catch {
            throw error
        }
    }
}
