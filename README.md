# TUITestApp

An iOS app built in Swift that helps users find the most convenient and cheapest flight route between two cities.

## ✈️ Features

- Parses connection data from a remote JSON endpoint
- Autocomplete text fields for selecting origin and destination cities
- Calculates the cheapest route, even when no direct flight exists
- Displays total price of the selected route
- Draws the selected route on a map using MapKit
- Places pins for selected cities using geocoding
- Built with UIKit and Combine
- Follows SOLID principles and testable architecture

## 🧪 Tests

- Includes unit tests (with XCTest)
- UI tests for validating user interactions

## 🚀 Getting Started

1. Clone the repo
2. Open `TUITestProject.xcodeproj` in Xcode
3. Run the app on simulator or device
4. Make sure to add the remote JSON URL to `Info.plist` under the key `ConnectionsDataURL`

## 📦 Requirements

- Xcode 15+
- iOS 15+
- Swift 5.9+

### Covered Components:
- `RouteViewModel` tested using `MockRouteFinder`
- Protocols and dependency injection to decouple UI from logic

See test files in `TUITestAppTests/` for reference.
