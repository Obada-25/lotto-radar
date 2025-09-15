//
//  NextDraw.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

struct NextDraw: Codable {
    let drawIdentifier: String
    let lottery: Lottery
    let drawDate: Date
    let drawDateUtc: Date
    let timeZone: String
    let cutofftime: Date
    let jackpot: Jackpot
}
