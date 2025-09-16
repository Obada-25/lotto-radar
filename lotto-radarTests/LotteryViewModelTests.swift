//
//  LotteryViewModelTests.swift
//  lotto-radarTests
//
//  Created by Assistant on 16.09.25.
//

import Foundation
import Testing
@testable import lotto_radar

// MARK: - Mocks

struct MockNetworkingSuccess: Networking {
    let responses: [LotteryResponse]
    func fetchData() async throws -> Result<[LotteryResponse], any Error> {
        return .success(responses)
    }
}

struct MockNetworkingFailure: Networking {
    struct DummyError: Error {}
    func fetchData() async throws -> Result<[LotteryResponse], any Error> {
        return .failure(DummyError())
    }
}

// MARK: - Tests

@MainActor
struct LotteryViewModelTests {
    
    @Test func testFetchDataSuccess_setsLotteriesAndSelected() async {
        let last = makeTestDraw(id: "2025-09-12", lottery: .eurojackpot, drawDate: "2025-09-12T18:00:00Z", numbers: [1,2,3,4,5])
        let next = makeTestNextDraw(id: "2025-09-16", lottery: .eurojackpot, drawDate: "2025-09-16T18:00:00Z", currency: "EUR", jackpotWC1: "116000000.00")
        let resp1 = makeTestResponse(lottery: .eurojackpot, last: last, next: next, draws: [])
        let resp2 = makeTestResponse(lottery: .sixAus49, last: nil, next: nil, draws: [])
        let vm = LotteryViewModel(networkingService: MockNetworkingSuccess(responses: [resp1, resp2]))
        await vm.fetchData()
        #expect(vm.lotteries.count == 2)
        #expect(vm.selectedLottery?.lottery == .eurojackpot)
        #expect(vm.error == nil)
    }
    
    @Test func testFetchDataFailure_setsError() async {
        let vm = LotteryViewModel(networkingService: MockNetworkingFailure())
        await vm.fetchData()
        #expect(vm.lotteries.isEmpty)
        #expect(vm.selectedLottery == nil)
        #expect(vm.error != nil)
    }
    
    @Test func testPreviousDraws_combinesAndSortsDescending() async {
        let last = makeTestDraw(id: "A", lottery: .sixAus49, drawDate: "2025-09-13T17:25:00Z", numbers: [2,8,15,23,25,43])
        let earlier = makeTestDraw(id: "B", lottery: .sixAus49, drawDate: "2025-09-10T17:25:00Z", numbers: [1,2,3,4,5,6])
        let resp = makeTestResponse(lottery: .sixAus49, last: last, next: nil, draws: [earlier])
        let vm = LotteryViewModel(networkingService: MockNetworkingSuccess(responses: [resp]))
        await vm.fetchData()
        let sorted = vm.previousDraws(for: resp)
        #expect(sorted.count == 2)
        #expect(sorted.first?.drawIdentifier == "A")
        #expect(sorted.last?.drawIdentifier == "B")
    }
    
    @Test func testFormattedNextDrawInfo_currencyAndDate() async {
        let next = makeTestNextDraw(id: "N1", lottery: .sixAus49, drawDate: "2025-09-17T16:25:00Z", currency: "EUR", jackpotWC1: "10000000.00")
        let resp = makeTestResponse(lottery: .sixAus49, last: nil, next: next, draws: [])
        let vm = LotteryViewModel(networkingService: MockNetworkingSuccess(responses: [resp]))
        await vm.fetchData()
        let info = vm.formattedNextDrawInfo(for: resp)
        #expect(info != nil)
        #expect(info?.jackpotText?.isEmpty == false)
        #expect(info?.dateText.isEmpty == false)
    }
    
    @Test func testFormatDate_outputsNonEmpty() async {
        let vm = LotteryViewModel(networkingService: MockNetworkingSuccess(responses: []))
        let date = parseISO8601Date("2025-09-16T18:00:00Z")
        let formatted = vm.formatDate(date)
        #expect(!formatted.isEmpty)
    }
}


