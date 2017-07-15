# 🎓 StuWeDD

Swift library for accessing some of the data the [Studentenwerk Dresden](http://www.studentenwerk-dresden.de/) has to offer.



## Quick Start

Talk to the [Cardservice](https://kartenservice.studentenwerk-dresden.de/) to acquire data about your Emeal card. You probably need to have enabled AutoLoad to even have login data to begin with, although I'm pretty unsure about that.

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



## Installation

StuWeDD is available through Cocoapods, Carthage/Punic and Swift Package Manager, whatever floats your boat.

```swift
// Cocoapods
pod 'StuWeDD'

// Carthage
github "kiliankoe/StuWeDD"

// Swift Package Manager
.Package(url: "https://github.com/kiliankoe/StuWeDD", majorVersion: 0)
```

