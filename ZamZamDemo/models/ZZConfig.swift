//
//  ZZConfig.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 09/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation
import SocketIO

struct ZZConfig {
    
    struct API {
        /// Same APIs as http://blockexplorer.com
        static let socket = "https://insight.bitpay.com/"
        static let rest = "https://insight.bitpay.com/api/"
    }
    /// Maximum number of transactions to keep in memory
    static let maxTransactions: Int = 100
}
