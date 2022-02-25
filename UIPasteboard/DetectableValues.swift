//
//  DetectableValues.swift
//  UIPasteboard
//
//  Created by Marco Boerner on 25.02.22.
//

import Foundation
import DataDetection
import UIKit

enum DetectableValues: Hashable {

    case calendarEvents([DDMatchCalendarEvent])
    case emailAddresses([DDMatchEmailAddress])
    case flightNumbers([DDMatchFlightNumber])
    case links([DDMatchLink])
    case moneyAmounts([DDMatchMoneyAmount])
    case number(Double?)
    case phoneNumbers([DDMatchPhoneNumber])
    case postalAddresses([DDMatchPostalAddress])
    case probableWebSearch(String)
    case probableWebURL(String)
    case shipmentTrackingNumbers([DDMatchShipmentTrackingNumber])
}

extension DetectableValues: CaseIterable {
    static var allCases: [DetectableValues] {[
        .calendarEvents,
        .emailAddresses,
        .flightNumbers,
        .links,
        .moneyAmounts,
        .number,
        .phoneNumbers,
        .postalAddresses,
        .probableWebSearch,
        .probableWebURL,
        .shipmentTrackingNumbers
    ]}
}

extension DetectableValues {
    static var calendarEvents: Self {
        get { return self.calendarEvents([]) }
    }
    static var emailAddresses: Self {
        get { return self.emailAddresses([]) }
    }
    static var flightNumbers: Self {
        get { return self.flightNumbers([]) }
    }
    static var links: Self {
        get { return self.links([]) }
    }
    static var moneyAmounts: Self {
        get { return self.moneyAmounts([]) }
    }
    static var number: Self {
        get { return self.number(nil) }
    }
    static var phoneNumbers: Self {
        get { return self.phoneNumbers([]) }
    }
    static var postalAddresses: Self {
        get { return self.postalAddresses([]) }
    }
    static var probableWebSearch: Self {
        get { return self.probableWebSearch("") }
    }
    static var probableWebURL: Self {
        get { return self.probableWebURL("") }
    }
    static var shipmentTrackingNumbers: Self {
        get { return self.shipmentTrackingNumbers([]) }
    }
}

extension DetectableValues: RawRepresentable {

    typealias RawValue = PartialKeyPath<UIPasteboard.DetectedValues>

    var rawValue: RawValue {
        switch self {
        case .calendarEvents:
            return \UIPasteboard.DetectedValues.calendarEvents
        case .emailAddresses:
            return \UIPasteboard.DetectedValues.emailAddresses
        case .flightNumbers:
            return \UIPasteboard.DetectedValues.flightNumbers
        case .links:
            return \UIPasteboard.DetectedValues.links
        case .moneyAmounts:
            return \UIPasteboard.DetectedValues.moneyAmounts
        case .number:
            return \UIPasteboard.DetectedValues.number
        case .phoneNumbers:
            return \UIPasteboard.DetectedValues.phoneNumbers
        case .postalAddresses:
            return \UIPasteboard.DetectedValues.postalAddresses
        case .probableWebSearch:
            return \UIPasteboard.DetectedValues.probableWebSearch
        case .probableWebURL:
            return \UIPasteboard.DetectedValues.probableWebURL
        case .shipmentTrackingNumbers:
            return \UIPasteboard.DetectedValues.shipmentTrackingNumbers
        }
    }

    init?(rawValue: RawValue) {
        switch rawValue {
        case \UIPasteboard.DetectedValues.calendarEvents:
            self = .calendarEvents
        case \UIPasteboard.DetectedValues.emailAddresses:
            self = .emailAddresses
        case \UIPasteboard.DetectedValues.flightNumbers:
            self = .flightNumbers
        case \UIPasteboard.DetectedValues.links:
            self = .links
        case \UIPasteboard.DetectedValues.moneyAmounts:
            self = .moneyAmounts
        case \UIPasteboard.DetectedValues.number:
            self = .number
        case \UIPasteboard.DetectedValues.phoneNumbers:
            self = .phoneNumbers
        case \UIPasteboard.DetectedValues.postalAddresses:
            self = .postalAddresses
        case \UIPasteboard.DetectedValues.probableWebSearch:
            self = .probableWebSearch
        case \UIPasteboard.DetectedValues.probableWebURL:
            self = .probableWebURL
        case \UIPasteboard.DetectedValues.shipmentTrackingNumbers:
            self = .shipmentTrackingNumbers
        default:
            fatalError()
        }
    }
}
