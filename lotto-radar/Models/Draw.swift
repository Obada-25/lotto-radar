//
//  Untitled.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

struct Draw: Codable {
    let drawIdentifier: String
    let drawDate: Date
    let drawDateUtc: Date
    let drawResult: DrawResult
    let quotas: [String: String]
    let nonMonetaryQuotas: [String: String]
    let winners: [String: Int]
    let totalStake: String
    let currency: String
}
