//
//  UIPasteboardTests.swift
//  UIPasteboardTests
//
//  Created by Marco Boerner on 11.02.22.
//

import XCTest
@testable import UIPasteboard

class UIPasteboardTests: XCTestCase {

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
     .number,
     .phoneNumbers,
     .postalAddresses,
     .probableWebSearch,
     .probableWebURL,
     .shipmentTrackingNumbers
     */

    func testEmailAddresses() async throws {

        // given
        let valueInPasteboard = "mail@marcoboerner.com"
        UIPasteboard.general.string = valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchEmail()

        // then
        XCTAssertNotNil(foundValue)
        XCTAssert(foundValue.count == 1)
        let unwrappedFirstValue = try XCTUnwrap(foundValue.first)
        XCTAssertEqual(valueInPasteboard, unwrappedFirstValue.emailAddress)
    }

    func testEmailAddressesWithNumber() async throws {

        // given
        let valueInPasteboard = "mail+1984@marcoboerner.com"
        UIPasteboard.general.string = valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchEmail()

        // then
        XCTAssertNotNil(foundValue)
        XCTAssert(foundValue.count == 1)
        let unwrappedFirstValue = try XCTUnwrap(foundValue.first)
        XCTAssertEqual(valueInPasteboard, unwrappedFirstValue.emailAddress)
    }

    func testEmailAddressesStrict() async throws {

        // given
        let valueInPasteboard = "mail@marcoboerner.com 20249859"
        UIPasteboard.general.string = valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchEmail()

        // then
        XCTAssertNotNil(foundValue)
        XCTAssert(foundValue.isEmpty)
    }

    func testEmailAddressesNotStrict() async throws {

        // given
        let emailString = "mail@marcoboerner.com"
        let valueInPasteboard = "ertht " + emailString + " rhtyty 20249859"
        UIPasteboard.general.string = valueInPasteboard

        // when
        let foundValue = try await Pasteboard.searchEmail(strict: false)

        // then
        XCTAssertNotNil(foundValue)
        let unwrappedFirstValue = try XCTUnwrap(foundValue.first)
        XCTAssertEqual(emailString, unwrappedFirstValue.emailAddress)
    }

}
