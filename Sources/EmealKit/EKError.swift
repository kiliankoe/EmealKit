//
//  EKError.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 15.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

public enum EKError: Error {
    case network(Error?)
    case authentication
    case server(statusCode: Int)
    case decoding(description: String)
    case decoding(Error)
    case feed(error: Error)
}
