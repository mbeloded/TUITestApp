//
//  TUITestAppUITests.swift
//  TUITestAppUITests
//
//  Created by Michael Bielodied on 01.04.2025.
//

import XCTest

final class TUITestAppUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testMainViewCheapestRouteCalculation() throws {
        let fromField = app.textFields["From"]
        let toField = app.textFields["To"]
        let findButton = app.buttons["Find Cheapest Route"]

        XCTAssertTrue(fromField.waitForExistence(timeout: 5))
        XCTAssertTrue(toField.exists)
        XCTAssertTrue(findButton.exists)

        // Tap and type "Lon"
        fromField.tap()
        fromField.typeText("Lon")

        // Wait and select suggestion "London"
        let londonSuggestion = app.buttons["London"]
        XCTAssertTrue(londonSuggestion.waitForExistence(timeout: 3))
        londonSuggestion.tap()

        // Tap and type "Tok"
        toField.tap()
        toField.typeText("Tok")

        // Wait and select suggestion "Tokyo"
        let tokyoSuggestion = app.buttons["Tokyo"]
        XCTAssertTrue(tokyoSuggestion.waitForExistence(timeout: 3))
        tokyoSuggestion.tap()

        // Tap find
        findButton.tap()

        // Look for label that includes price
        let priceLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Total Price:'")).firstMatch
        XCTAssertTrue(priceLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(priceLabel.label.contains("Total Price:"))
    }
}
