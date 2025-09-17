//
//  ContentView.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import SwiftUI

struct LotteryView: View {
    @ObservedObject var viewModel: LotteryViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !viewModel.lotteries.isEmpty {
                    pickerView
                } else if viewModel.error == nil {
                    Text("No lotteries available")
                        .foregroundStyle(.secondary)
                }
                
                // Next draw header + info
                if let selectedLottery = viewModel.selectedLottery, let info = viewModel.formattedNextDrawInfo(for: selectedLottery) {
                    HStack {
                        Text("Next draw").font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    NextDrawView(
                        jackpotText: info.jackpotText,
                        dateText: info.dateText,
                        primaryColor: viewModel.selectedLottery?.lottery.mainColor ?? .primary,
                        secondaryColor: viewModel.selectedLottery?.lottery.accentColor ?? .secondary
                    )
                    .padding(.horizontal)
                    .onTapGesture { if let url = viewModel.selectedLottery?.lottery.websiteURL { openURL(url) } }
                }
                
                // Previous draws header + list
                if let selectedLottery = viewModel.selectedLottery {
                    HStack {
                        Text("Previous draws").font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    PreviousDrawsListView(draws: viewModel.previousDraws(for: selectedLottery))
                } else {
                    Spacer()
                }
                
                Spacer(minLength: 0)
            }
            .navigationTitle("Lotto Radar")
            .task { await viewModel.fetchData() }
            .overlay { if viewModel.isLoading && viewModel.lotteries.isEmpty { ProgressView() } }
            .alert("Error", isPresented: .constant(viewModel.error != nil), actions: {
                Button("OK", role: .cancel) { viewModel.error = nil }
            }, message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            })
        }
    }
    
    private var pickerView: some View {
        Picker("Lottery", selection: Binding(
            get: { viewModel.selectedLotteryType ?? viewModel.lotteries.first?.lottery ?? .sixAus49 },
            set: { newType in viewModel.selectedLotteryType = newType }
        )) {
            ForEach(viewModel.lotteries, id: \.lottery) { lotteryResponse in
                Text(lotteryResponse.lottery.name.capitalized)
                    .tag(lotteryResponse.lottery)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .colorMultiply(.yellow)
    }
}

#Preview {
    LotteryView(
        viewModel: LotteryViewModel(networkingService: MockNetworking())
    )
}
