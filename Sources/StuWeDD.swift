//
//  StuWeDD.swift
//  StuWeDD
//
//  Created by Kilian Koeltzsch on {TODAY}.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

extension URL {
    static var cardserviceAPIBase: URL {
        return URL(string: "https://kartenservicedaten.studentenwerk-dresden.de:8080/TL1/TLM/KASVC/")!
    }

    static var cardserviceLogin: URL {
        return URL(string: "LOGIN", relativeTo: URL.cardserviceAPIBase)!
    }

    static var cardserviceTransactions: URL {
        return URL(string: "TRANSPOS", relativeTo: URL.cardserviceAPIBase)!
    }
}
