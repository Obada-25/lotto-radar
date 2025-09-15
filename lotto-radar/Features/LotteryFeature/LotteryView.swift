//
//  ContentView.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import SwiftUI

struct LotteryView: View {
    var viewModel: LotteryViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    LotteryView(
        viewModel: LotteryViewModel(networkingService: MockNetworking())
    )
}
