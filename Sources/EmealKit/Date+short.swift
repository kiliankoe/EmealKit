//
//  Date+short.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 16.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

extension Date {
    static var shortGermanDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static var shortGermanDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()

    var shortGerman: String {
        Self.shortGermanDateFormatter.string(from: self)
    }

    init?(shortGermanDateTime str: String) {
        guard let date = Date.shortGermanDateTimeFormatter.date(from: str) else {
            return nil
        }
        self = date
    }

    static var yearMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    var yearMonthDay: String {
        Self.yearMonthDayFormatter.string(from: self)
    }
}
