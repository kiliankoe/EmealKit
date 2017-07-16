//
//  Double+priceValue.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 16.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

extension Double {
    var priceValue: String {
        return String(format: "%.2f€", self)
    }
}
