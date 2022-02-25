//
//  PasteboardNUmberTests.swift
//  UIPasteboardTests
//
//  Created by Marco Boerner on 11.02.22.
//

import XCTest
@testable import UIPasteboard

class PasteboardNUmberTests: XCTestCase {

    override func setUpWithError() throws {
        UIPasteboard.general.strings = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /*
     .calendarEvents,
     .flightNumbers,
     .links,
     .moneyAmounts,
     .phoneNumbers,
     .postalAddresses,
     .probableWebSearch,
     .probableWebURL,
     .shipmentTrackingNumbers
     */

    func testNumbers() async throws {

        // given
        let intValue = 435345435434
        let valueInPasteboard = String(intValue)
        UIPasteboard.general.string = valueInPasteboard //valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchNumbers()

        // then
        XCTAssertNotNil(foundValue)
        XCTAssertEqual(Double(intValue), foundValue)
    }

    func testNumbersWithText() async throws {

        // given
        let valueInPasteboard = "RANDOM 42543534 TEXT"
        UIPasteboard.general.string = valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchNumbers()

        // then
        XCTAssertNil(foundValue)
        //XCTAssertEqual(valueInPasteboard, unwrappedFirstValue.emailAddress)
    }

    func testNumbersStrict() async throws {

        // given
        let valueInPasteboard = "RANDOM 42543534 TEXT"
        UIPasteboard.general.string = valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchNumbers()

        // then
        XCTAssertNil(foundValue)
    }

    func testNumbersNotStrict() async throws {

        // given
        let intValue = 435345435434
        let valueInPasteboard = " \(intValue) HELLO WORLD"
        UIPasteboard.general.string = valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchNumbers(strict: false)

        // then
        XCTAssertNotNil(foundValue)
        XCTAssertEqual(Double(intValue), foundValue)
    }
}
