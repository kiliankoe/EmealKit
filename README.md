# 🌯 EmealKit

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkiliankoe%2FEmealKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kiliankoe/EmealKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkiliankoe%2FEmealKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kiliankoe/EmealKit)

Swift library for accessing some of the meal related data the [Studentenwerk Dresden](http://www.studentenwerk-dresden.de/) has to offer.


## Quick Start

### Current meals or available canteens

```swift
let meals = try await Meal.for(canteen: .alteMensa, on: Date())
for meal in meals {
    print(meal.name)
}

let canteens = try await Canteen.all()
for canteen in canteens {
    print(canteen.name)
}
```

A completion block based API and one built on Combine are also available. 

### Cardservice

Talk to the [Cardservice](www.studentenwerk-dresden.de/mensen/kartenservice/) to acquire data about your Emeal card. You will need to have registered for Autoload to have the necessary authentication details.

```swift
let cardservice = try await Cardservice.login(username: "1234567890", password: "hunter2")
let carddata = try await cardservice.carddata()
print(carddata)

let ninetyDaysAgo = Date().addingTimeInterval(-60 * 60 * 24 * 90)
let transactions = try await cardservice.transactions(begin: ninetyDaysAgo)
print(transactions)
```

### NFC Scanning

EmealKit also handles scanning the Emeal card via NFC if your device supports it. Just create an `Emeal` object, conform to `EmealDelegate` and call `beginNFCSession`.

```swift
class YourEmealHandler: EmealDelegate {
    let emeal: Emeal
  
    init() {
        let strings = LocalizedEmealStrings(/*...*/)
        emeal = Emeal(localizedStrings: strings)
        emeal.delegate = self
        
        // Call this to start the NFC session.
        emeal.beginNFCSession()
    }
  
    func readData(currentBalance: Double, lastTransaction: Double) {
        // Gets called on a successful scan.
    }
  
    func invalidate(with error: Error) {
        // Called on errors.
    }
}
```

It's even easier if you use `ObservableEmeal` in your SwiftUI views. It could look something like this.

```swift
struct MyView: View {
    @StateObject private var emeal = ObservableEmeal(localizedStrings: .init(/* ... */))
    
    var body: some View {
        VStack {
            Text("Balance: \(emeal.currentBalance ?? 0.0)")
            Text("Last Transaction: \(emeal.lastTransaction ?? 0.0)")
                
            if let error = emeal.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
            
            Button(action: emeal.beginNFCSession) {
                Text("Scan Emeal")
            }
        }
    }
}
```


## Installation

EmealKit is available through Swift Package Manager.

```swift
.package(url: "https://github.com/kiliankoe/EmealKit.git", from: "<#latest#>")
```


## Used by

This library is currently being used in the following applications:

- [Mensa Dresden](https://github.com/kiliankoe/MensaDresden)
- [MensaPlus](https://apps.apple.com/us/app/mensaplus-dresden-mensa-app/id1182724417)

Know of any others? Please open a PR and add it to the list! 😊
