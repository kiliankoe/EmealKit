//
//  Double+euroString.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 16.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

public extension Double {
    var euroString: String {
        return String(format: "%.2f€", self)
    }
}
