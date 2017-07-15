//
//  Date+short.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 16.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

extension Date {
    static var shortGermanFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    var shortGerman: String {
        return Date.shortGermanFormatter.string(from: self)
    }
}
