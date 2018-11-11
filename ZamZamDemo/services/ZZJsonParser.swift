//
//  ZZJsonParser.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 10/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation

class ZZJsonParser {
    
    struct JsonKeys {
        static let txid = "txid"
        static let blockHash = "blockHash"
        static let hash = "hash"
        static let lastblockhash = "lastblockhash"
    }
    
    func transaction(data: Data) -> ZZTransaction? {
        do {
            return try JSONDecoder().decode(ZZTransaction.self, from: data)
        } catch {
            return nil
        }
    }
    
    func block(data: Data) -> ZZBlock? {
        do {
            return try JSONDecoder().decode(ZZBlock.self, from: data)
        } catch {
            return nil
        }
    }
    
    func blocks(data: Data) -> [ZZBlock]? {
        do {
            return try JSONDecoder().decode([ZZBlock].self, from: data)
        } catch {
            return nil
        }
    }
    
    func transactionId(data: Any) -> String? {
        guard let transaction = data as? [String: Any] else {
            return nil
        }
        return transaction[JsonKeys.txid] as? String
    }
    
    func blockHash(data: Any) -> String? {
        guard let block = data as? [String: Any] else {
            return nil
        }
        return block[JsonKeys.hash] as? String
    }
    
    func lastBlockHash(data: Data) -> String? {
        do {
            guard let block = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return nil
            }
            return block[JsonKeys.lastblockhash] as? String
        } catch {
            return nil
        }
    }
    
}
