//
//  Untitled.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation

struct DrawResult: Codable {
    let numbers: [Int]
    let superNumber: Int?
    let euroNumbers: [Int]?
}
