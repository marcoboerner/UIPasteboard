//
//  Pasteboard.swift
//  UIPasteboard
//
//  Created by Marco Boerner on 09.02.22.
//

import Foundation
import UIKit
import DataDetection

class Pasteboard {

    private init() {}

    /**
     Searches the pasteboard for specific patterns in strings

     - Parameter valuesToDetect: Detect only this patterns
     - Parameter valuesToIgnore: Patterns to ignore when searching. Default is none. See Notes.
     - Returns: Returns an array containing the detected patterns with associated values. Nil if no pattern has been detected or a non ignored pattern has been detected

     # Notes: #
     1. If no valuesToIgnore have been passed into the method, all other patterns might cause the method to return nil. This is not always desired, for example the email pattern might also be recognized as a web search pattern. In this case it's recommended to add it to the valuesToIgnore list.

     # Example #
     ```
     Task {
        do {
            guard let results = try await Pasteboard
                    .searchStrings(for: .emailAddresses, .number, doNotStopAt: .probableWebSearch) else { return }

            results.forEach {
                switch $0 {
                case .number(let number):
                    guard let number = number else { break }
                    print(number)
                case .emailAddresses(let emails):
                    guard let emailString = emails.first?.emailAddress else { break }
                    print(emailString)
                default:
                    break
                }
            }
        } catch {
            print(error)
        }
     }
     ```
     */
    @available(iOS 15, *)
    static func searchStrings(for valuesToDetect: DetectableValues..., doNotStopAt valuesToIgnore: DetectableValues...) async throws -> [DetectableValues]? {
        try await searchStrings(for: valuesToDetect, doNotStopAt: valuesToIgnore)
    }

    internal static func searchStrings(for valuesToDetect: [DetectableValues], doNotStopAt valuesToIgnore: [DetectableValues]) async throws -> [DetectableValues]? {

        // If the pasteboard contains anything other than a string (image, file, etc.) returning nil.
        guard UIPasteboard.general.hasStrings else { return nil }

        // Creating a set of values which will cause the method to return nil if found
        let valuesNotToDetect = Set(DetectableValues.allCases)
            .symmetricDifference(Set(valuesToDetect + valuesToIgnore))
        
        // Mapping the list of DetectableValues to a set of PartialKeyPath<UIPasteboard.DetectedValues>
        let keyPathsNotToDetected = valuesNotToDetect.map { $0.rawValue }

        // Checking the pasteboard for any non desired patterns and returning nil if found.
        guard try await UIPasteboard.general.detectedPatterns(for: Set(keyPathsNotToDetected)).isEmpty else { return nil }

        // Mapping the list of DetectableValues to a set of PartialKeyPath<UIPasteboard.DetectedValues>
        let keyPathsToDetect = valuesToDetect.map { $0.rawValue }

        // Checking the pasteboard for all of the desired patterns
        let detectedPatterns = try await UIPasteboard.general.detectedPatterns(for: Set(keyPathsToDetect))

        // If no desired patterns have been found returning nil
        guard !detectedPatterns.isEmpty else { return nil }

        // Accessing the values for the detected patterns.
        // Note that this is when iOS displays an access warning to the user.
        let values = try await UIPasteboard.general.detectedValues(for: detectedPatterns)

        // Creating the array to be returned
        var detectedValues: [DetectableValues] = []

        // looping over the valuesToDetect and filling the array with the DetectableValues + associated values
        valuesToDetect.forEach {
            switch $0 {
            case .calendarEvents:
                if values.calendarEvents.isEmpty { break }
                detectedValues.append(.calendarEvents(values.calendarEvents))
            case .emailAddresses:
                if values.emailAddresses.isEmpty { break }
                detectedValues.append(.emailAddresses(values.emailAddresses))
            case .flightNumbers:
                if values.flightNumbers.isEmpty { break }
                detectedValues.append(.flightNumbers(values.flightNumbers))
            case .links:
                if values.links.isEmpty { break }
                detectedValues.append(.links(values.links))
            case .moneyAmounts:
                if values.moneyAmounts.isEmpty { break }
                detectedValues.append(.moneyAmounts(values.moneyAmounts))
            case .number:
                if values.number == nil { break }
                detectedValues.append(.number(values.number))
            case .phoneNumbers:
                if values.phoneNumbers.isEmpty { break }
                detectedValues.append(.phoneNumbers(values.phoneNumbers))
            case .postalAddresses:
                if values.postalAddresses.isEmpty { break }
                detectedValues.append(.postalAddresses(values.postalAddresses))
            case .probableWebSearch:
                if values.probableWebSearch.isEmpty { break }
                detectedValues.append(.probableWebSearch(values.probableWebSearch))
            case .probableWebURL:
                if values.probableWebURL.isEmpty { break }
                detectedValues.append(.probableWebURL(values.probableWebURL))
            case .shipmentTrackingNumbers:
                if values.shipmentTrackingNumbers.isEmpty { break }
                detectedValues.append(.shipmentTrackingNumbers(values.shipmentTrackingNumbers))
            }
        }
        return detectedValues

    }
}
