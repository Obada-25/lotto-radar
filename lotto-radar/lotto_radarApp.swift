//
//  lotto_radarApp.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import SwiftUI

@main
struct lotto_radarApp: App {
    var body: some Scene {
        WindowGroup {
            LotteryView(
                viewModel: LotteryViewModel(networkingService: NetworkingService())
            )
        }
    }
}
