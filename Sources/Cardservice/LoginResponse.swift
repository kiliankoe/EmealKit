//
//  LoginResponse.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 15.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let authToken: String
    // The rest here is seemingly unecessary
}
