//
//  Lottery.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import Foundation
import SwiftUI

enum Lottery: String, Codable {
    case sixAus49 = "6aus49"
    case eurojackpot = "eurojackpot"
    
    var name: String {
        return rawValue
    }
    
    var accentColor: Color {
        switch self {
        case .sixAus49:
            return .yellow
        case .eurojackpot:
            return .black
        }
    }
    
    var mainColor: Color {
        switch self {
        case .sixAus49:
            return .red
        case .eurojackpot:
            return .yellow
        }
    }
    
    var websiteURL: URL {
        switch self {
        case .sixAus49:
            return URL(string: "https://www.lotto.de")!
        case .eurojackpot:
            return URL(string: "https://www.eurojackpot.com/")!
        }
    }
}
