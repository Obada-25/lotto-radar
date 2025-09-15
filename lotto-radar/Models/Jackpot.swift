//
//  Jackpot.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

struct Jackpot: Codable {
    let drawIdentifier: String
    let lottery: Lottery
    let drawDate: Date
    let currency: String
    let jackpots: [String: String]
    let jackpotSupported: Bool
}
