//
//  Date+short.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 16.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

extension Date {
    static var dayMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static var dayMonthYearHourMinute: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static var yearMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    init?(dayMonthYearHourMinute str: String) {
        guard let date = Date.dayMonthYearHourMinute.date(from: str) else {
            return nil
        }
        self = date
    }

    var dayMonthYear: String {
        Self.dayMonthYearFormatter.string(from: self)
    }

    var yearMonthDay: String {
        Self.yearMonthDayFormatter.string(from: self)
    }
}
