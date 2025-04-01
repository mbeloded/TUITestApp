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

    func testCheapestRouteCalculationWithSuggestions() throws {
        let fromField = app.textFields["From"]
        let toField = app.textFields["To"]
        let findButton = app.buttons["Find Cheapest Route"]
        let resultLabel = app.staticTexts["resultLabel"]

        XCTAssertTrue(fromField.waitForExistence(timeout: 5))
        XCTAssertTrue(toField.exists)
        XCTAssertTrue(findButton.exists)

        // Tap and type "Lon"
        fromField.tap()
        fromField.typeText("Lon")

        // Select suggestion "London"
        let londonCell = app.tables.cells.staticTexts["London"]
        XCTAssertTrue(londonCell.waitForExistence(timeout: 2))
        londonCell.tap()

        // Tap and type "Tok"
        toField.tap()
        toField.typeText("Tok")

        let tokyoCell = app.tables.cells.staticTexts["Tokyo"]
        XCTAssertTrue(tokyoCell.waitForExistence(timeout: 2))
        tokyoCell.tap()

        // Tap find
        findButton.tap()

        // Wait for label update
        let existsPredicate = NSPredicate(format: "label CONTAINS[c] 'Total Price:'")
        expectation(for: existsPredicate, evaluatedWith: resultLabel, handler: nil)
        waitForExpectations(timeout: 5)

        XCTAssertTrue(resultLabel.label.contains("Total Price:"))
    }
}
