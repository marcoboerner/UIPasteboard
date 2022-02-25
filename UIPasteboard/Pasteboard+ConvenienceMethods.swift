//
//  Pasteboard+ConvenienceMethods.swift
//  UIPasteboard
//
//  Created by Marco Boerner on 25.02.22.
//

import Foundation
import DataDetection

/*
Use the following methods to actually search for the required data in the pasteboard and ad more methods as required.
 Use tests to determine the doNotStopAt values as it might be necessary to be less strict and also allow other DetectableValues.
 For example searchPhoneNumbers() will also allow .probableWebSearch and .shipmentTrackingNumbers since the phone numbers might also be considered those.
 However this does not mean by allowing other DetectableValues will not widen the search.
 For example a phone number included somewhere in a larger string that is also a web search will still not get detected as UIPasteboard evaluates each DetectableValues separately.
 */

extension Pasteboard {

    @available(iOS 15, *)
    static func searchNumbers(strict: Bool = true) async throws -> Double? {

        let doNotStopAt = strict ? [.phoneNumbers, .probableWebSearch] : DetectableValues.allCases

        let values = try await searchStrings(for: [.number], doNotStopAt: doNotStopAt)

        guard let value = values?.first, case let .number(numbers) = value else {
            return nil
        }

        return numbers
    }

    @available(iOS 15, *)
    static func searchEmail(strict: Bool = true) async throws -> [DDMatchEmailAddress] {
        let doNotStopAt = strict ? [DetectableValues.probableWebSearch] : DetectableValues.allCases

        let values = try await searchStrings(for: [.emailAddresses], doNotStopAt: doNotStopAt)

        guard let value = values?.first, case let .emailAddresses(addresses) = value else {
            return []
        }

        return addresses
    }

    @available(iOS 15, *)
    static func searchPhoneNumbers() async throws -> [DDMatchPhoneNumber] {

        let values = try await searchStrings(for: .phoneNumbers, doNotStopAt: .probableWebSearch, .shipmentTrackingNumbers)

        guard let value = values?.first, case let .phoneNumbers(numbers) = value else {
            return []
        }

        return numbers
    }

    @available(iOS 15, *)
    static func searchMoneyAmounts() async throws -> [DDMatchMoneyAmount] {

        let values = try await searchStrings(for: .moneyAmounts, doNotStopAt: .number)

        guard let value = values?.first, case let .moneyAmounts(amounts) = value else {
            return []
        }

        return amounts
    }

}

