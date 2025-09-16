//
//  TestHelpers.swift
//  lotto-radarTests
//
//  Centralized test helpers for building models and parsing dates.
//

import Foundation
@testable import lotto_radar

// MARK: - ISO8601 Date Parsing

private let iso8601WithoutFractional: ISO8601DateFormatter = {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTimeZone]
    return isoFormatter
}()

private let iso8601WithFractional: ISO8601DateFormatter = {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withColonSeparatorInTimeZone]
    return isoFormatter
}()

private let posixFallbackFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    return dateFormatter
}()

func parseISO8601Date(_ dateString: String) -> Date {
    if let parsedDate = iso8601WithoutFractional.date(from: dateString) { return parsedDate }
    if let parsedDate = iso8601WithFractional.date(from: dateString) { return parsedDate }
    if let parsedDate = posixFallbackFormatter.date(from: dateString) { return parsedDate }
    return Date()
}

// MARK: - Builders

func makeTestDraw(
    id: String,
    lottery: Lottery,
    drawDate: String,
    numbers: [Int],
    superNumber: Int? = nil,
    euroNumbers: [Int]? = nil,
    currency: String = "EUR"
) -> Draw {
    return Draw(
        drawIdentifier: id,
        drawDate: parseISO8601Date(drawDate),
        drawDateUtc: parseISO8601Date(drawDate),
        drawResult: DrawResult(numbers: numbers, superNumber: superNumber, euroNumbers: euroNumbers),
        quotas: [:],
        nonMonetaryQuotas: [:],
        winners: [:],
        totalStake: "0.00",
        currency: currency
    )
}

func makeTestNextDraw(
    id: String,
    lottery: Lottery,
    drawDate: String,
    currency: String = "EUR",
    jackpotWC1: String = "10000000.00"
) -> NextDraw {
    return NextDraw(
        drawIdentifier: id,
        drawDate: parseISO8601Date(drawDate),
        drawDateUtc: parseISO8601Date(drawDate),
        timeZone: "Europe/Berlin",
        cutofftime: parseISO8601Date(drawDate),
        jackpot: Jackpot(
            drawIdentifier: id,
            drawDate: parseISO8601Date(drawDate),
            currency: currency,
            jackpots: ["WC_1": jackpotWC1],
            jackpotSupported: true
        )
    )
}

func makeTestResponse(
    lottery: Lottery,
    last: Draw?,
    next: NextDraw?,
    draws: [Draw]
) -> LotteryResponse {
    return LotteryResponse(lottery: lottery, lastDraw: last, nextDraw: next, draws: draws)
}


