# 🌯 EmealKit

Swift library for accessing some of the meal related data the [Studentenwerk Dresden](http://www.studentenwerk-dresden.de/) has to offer.



## Quick Start

### Current Meal or Canteen Information

```swift
Meal.for(canteen: .alteMensa, on: Date()) { result in
    guard let meals = result.success else { return }
    
    for meal in meals {
        print(meal.name)
    }
}

Canteen.all { result in
    guard let canteens = result.success else { return }
    
    for canteen in canteens {
        print(canteen.name)
    }
}
```

Both of these requests also offer publishers for use with Combine.

### Cardservice

Talk to the [Cardservice](www.studentenwerk-dresden.de/mensen/kartenservice/) to acquire data about your Emeal card. You will need to have registered for Autoload to have the necessary authentication details.

```swift
Cardservice.login(username: "1234567890", password: "hunter2") { result in
    guard let service = result.success else { return }
    
    service.carddata { result in
        guard let data = result.success else { return }
        print(data)
    }
    
    let twoDaysAgo = Date().addingTimeInterval(-60 * 60 * 24 * 2)
    let now = Date()
    service.transactions(begin: twoDaysAgo, end: now) { result in
        guard let transactions = result.success else { return }
        print(transactions)
    }
}
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



## Installation

EmealKit is available through Swift Package Manager.

```swift
.package(url: "https://github.com/kiliankoe/EmealKit.git", from: "<#latest#>")
```
