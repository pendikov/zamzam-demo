//
//  ZZBlock.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 09/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation

/// Blockchain block model
struct ZZBlock: Codable {
    var hash: String
    var height: Int
    var reward: Double?
    var time: Int
    var difficulty: Double?
    /// Size in bytes
    var size: Int
    /// Transaction ids
    var tx: [String]?
    var confirmations: Int?
    
    var date: Date {
        let interval = TimeInterval(self.time)
        return Date(timeIntervalSince1970: interval)
    }
}

/// Blockchain transaction model
struct ZZTransaction: Codable {
    var txid: String
    var blockheight: Int
    var confirmations: Int
}

/// Object describing errors
struct ZZError {
    var text: String
    var code: Int = 0
}

extension ZZError {
    /// Init in extension to keep default initializer
    ///
    /// - Parameter text: error text
    init(text: String) {
        self.text = text
        self.code = 0
    }
}

//Common closure types used throughout the app

typealias ZZTransactionClosure = (ZZTransaction) -> Void
typealias ZZTransactionsClosure = ([ZZTransaction]) -> Void
typealias ZZBlockClosure = (ZZBlock) -> Void
typealias ZZBlocksClosure = ([ZZBlock]) -> Void
typealias ZZErrorClosure = (ZZError) -> Void
