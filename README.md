# TUITestApp

An iOS app built in Swift and SwiftUI that helps users find the most convenient and cheapest flight route between two cities.

## ✈️ Features

- Parses connection data from a remote JSON endpoint
- Autocomplete text fields for selecting origin and destination cities
- Calculates the cheapest route, even when no direct flight exists
- Displays total price of the selected route
- Draws the selected route on a map using MapKit
- Built with SwiftUI and Combine
- Follows SOLID principles and testable architecture

## 🧪 Tests

- Includes unit tests (with XCTest)
- UI tests for validating user interactions using XCUIApplication

## 🚀 Getting Started

1. Clone the repo
2. Open `TUITestApp.xcodeproj` in Xcode
3. Run the app on simulator or device
4. Make sure to add the remote JSON URL to `Info.plist` under the key `ConnectionsDataURL`

## 📦 Requirements

- Xcode 16+
- iOS 15+
- Swift 6+

### Covered Components:
- `RouteViewModel` tested using `MockRouteFinder`
- Protocols and dependency injection to decouple UI from logic

See test files in `TUITestAppTests/` for reference.

### Covered TDD Steps:
- Step 1: Write failing test for loading cities  
- Step 2: Implement code to pass the test using mock service  
- Step 3: Add test for route-finding logic  
- Step 4: Implement logic and pass the test  
- Step 5: Integrate all parts and refactor 
