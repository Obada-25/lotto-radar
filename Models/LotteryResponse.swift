//
//  LotteryResponse.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

struct LotteryResponse: Codable {
    let lottery: Lottery
    let lastDraw: Draw?
    let nextDraw: NextDraw?
    let draws: [Draw]
}
