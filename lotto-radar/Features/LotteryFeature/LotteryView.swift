//
//  ContentView.swift
//  lotto-radar
//
//  Created by Obada Darkazanly on 15.09.25.
//

import SwiftUI

struct LotteryView: View {
    @ObservedObject var viewModel: LotteryViewModel
    @State private var selectedLotteryType: Lottery = .sixAus49
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !viewModel.lotteries.isEmpty {
                    pickerView
                }
                
                // Next draw header + info
                if let selectedLottery = viewModel.selectedLottery, let info = viewModel.formattedNextDrawInfo(for: selectedLottery) {
                    HStack { Text("Next draw").font(.headline); Spacer() }
                        .padding(.horizontal)
                    NextDrawView(
                        jackpotText: info.jackpotText,
                        dateText: info.dateText,
                        primaryColor: (viewModel.selectedLottery?.lottery.mainColor)!,
                        secondaryColor: (viewModel.selectedLottery?.lottery.accentColor)!
                    )
                    .padding(.horizontal)
                    .onTapGesture {
                        openURL(viewModel.selectedLottery!.lottery.websiteURL)
                    }
                }
                
                // Previous draws header + list
                if let selectedLottery = viewModel.selectedLottery {
                    HStack { Text("Previous draws").font(.headline); Spacer() }
                        .padding(.horizontal)
                    PreviousDrawsListView(draws: viewModel.previousDraws(for: selectedLottery))
                } else {
                    Spacer()
                }
                
                Spacer(minLength: 0)
            }
            .navigationTitle("Lotto Radar")
            .task {
                await viewModel.fetchData()
                if let firstLottery = viewModel.lotteries.first {
                    selectedLotteryType = firstLottery.lottery
                    viewModel.selectedLottery = firstLottery
                }
            }
            .overlay {
                if viewModel.isLoading { ProgressView() }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil), actions: {
                Button("OK", role: .cancel) { viewModel.error = nil }
            }, message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            })
        }
    }
    
    private var pickerView: some View {
        Picker("Lottery", selection: $selectedLotteryType) {
            ForEach(viewModel.lotteries, id: \.lottery) { response in
                Text(response.lottery.name.capitalized)
                    .tag(response.lottery)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .colorMultiply(.yellow)
        .onChange(of: selectedLotteryType) { _, newValue in
            viewModel.selectedLottery = viewModel.lotteries.first { $0.lottery == newValue }
        }
    }
}

#Preview {
    LotteryView(
        viewModel: LotteryViewModel(networkingService: MockNetworking())
    )
}
