//
//  CardData.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 15.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

public struct CardData {
    public let id: Int
    public let cardNumber: String
    public let chargeAmount: Int
    public let chargeThreshold: Int
    public let suspended: Bool
    public let directDebit: Bool
    public let internet: Bool // ?
    public let bankCode: String
    public let bankAccountNumber: String
    public let paypal: Bool
    public let sepaCI: String
    public let sepaMandate: Int
    public let singlepaymentDebit: Bool
    public let singlepaymentPaypal: Bool

    init(from service: CardDataService) {
        self.id = service.id
        self.cardNumber = service.karteNr
        self.chargeAmount = service.betragAufwertung
        self.chargeThreshold = service.abRestguthaben
        self.suspended = service.gesperrt == 1
        self.directDebit = service.bankeinzug == 1
        self.internet = service.internet == 1
        self.bankCode = service.blz
        self.bankAccountNumber = service.bankkonto
        self.paypal = service.payPal == 1
        self.sepaCI = service.sepaCI
        self.sepaMandate = service.sepaMandat
        self.singlepaymentDebit = service.einmalzahlungLastschrift == 1
        self.singlepaymentPaypal = service.einmalzahlungPayPal == 1
    }
}

struct CardDataService: Decodable {
    let id: Int
    let karteNr: String
    let betragAufwertung: Int
    let abRestguthaben: Int
    let gesperrt: Int
    let bankeinzug: Int
    let internet: Int // ?
    let blz: String
    let bankkonto: String
    let payPal: Int
    let sepaCI: String
    let sepaMandat: Int
    let einmalzahlungLastschrift: Int
    let einmalzahlungPayPal: Int
}

extension CardData: CustomStringConvertible {
    public var description: String {
        return "Emeal \(self.cardNumber)"
    }
}
