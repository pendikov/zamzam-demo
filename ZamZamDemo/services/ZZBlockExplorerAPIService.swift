//
//  ZZBlockExplorerAPIService.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 11/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation

/// Protocol for blockchain API
protocol ZZBlockchainAPIService {
    
    func getTransaction(id: String,
                        success: @escaping ZZTransactionClosure,
                        error: @escaping ZZErrorClosure)
    func getBlock(hash: String,
                  success: @escaping ZZBlockClosure,
                  error: @escaping ZZErrorClosure)
    func getBlock(height: Int,
                  success: @escaping ZZBlockClosure,
                  error: @escaping ZZErrorClosure)
    func getLastBlock(success: @escaping ZZBlockClosure,
                      error: @escaping ZZErrorClosure)
    
}

/// Implementation of ZZBlockchainAPIService using blockexplorer.com as backend
class ZZBlockExplorerAPIService: ZZRestAPIService {
    
    /// Available API URL routes
    struct Route {
        static let tx = "tx"
        static let blockIndex = "block-index"
        static let block = "block"
        static let status = "status"
        static let blocks = "blocks"
    }
    static let lastBlockHashQueryItem = URLQueryItem(name: "q", value: "getLastBlockHash")
    let jsonParser = ZZJsonParser()
    
}

extension ZZBlockExplorerAPIService: ZZBlockchainAPIService {
    
    func getTransaction(id: String,
                        success: @escaping ZZTransactionClosure,
                        error: @escaping ZZErrorClosure) {
        let string = "\(ZZConfig.API.rest)\(Route.tx)/\(id)"
        let url = URL(string: string)!
        self.request(url: url) { (result) in
            switch result {
            case .error(let err):
                error(err)
            case .response(let data):
                if let transaction = self.jsonParser.transaction(data: data) {
                    success(transaction)
                } else {
                    error(self.parseError(string: "\(#function)"))
                }
            }
        }
    }
    
    func getBlock(hash: String,
                  success: @escaping ZZBlockClosure,
                  error: @escaping ZZErrorClosure) {
        let string = "\(ZZConfig.API.rest)\(Route.block)/\(hash)"
        let url = URL(string: string)!
        self.request(url: url) { (result) in
            switch result {
            case .error(let err):
                error(err)
            case .response(let data):
                if let block = self.jsonParser.block(data: data) {
                    success(block)
                } else {
                    error(self.parseError(string: "\(#function)"))
                }
            }
        }
    }
    
    func getBlock(height: Int,
                  success: @escaping ZZBlockClosure,
                  error: @escaping ZZErrorClosure) {
        let string = "\(ZZConfig.API.rest)\(Route.blockIndex)/\(height)"
        let url = URL(string: string)!
        self.request(url: url) { (result) in
            switch result {
            case .error(let err):
                error(err)
            case .response(let data):
                if let hash = self.jsonParser.blockHash(data: data) {
                    self.getBlock(hash: hash, success: success, error: error)
                } else {
                    error(self.parseError(string: "\(#function)"))
                }
            }
        }
    }
    
    func getLastBlock(success: @escaping ZZBlockClosure,
                      error: @escaping ZZErrorClosure) {
        let string = "\(ZZConfig.API.rest)\(Route.status)"
        let queryItems = [type(of: self).lastBlockHashQueryItem]
        var comps = URLComponents(string: string)!
        comps.queryItems = queryItems
        let url = comps.url!
        self.request(url: url) { (result) in
            switch result {
            case .error(let err):
                error(err)
            case .response(let data):
                if let hash = self.jsonParser.lastBlockHash(data: data) {
                    self.getBlock(hash: hash, success: success, error: error)
                } else {
                    error(self.parseError(string: "\(#function)"))
                }
            }
        }
    }
    
    /// Creates error object describing parsing error
    ///
    /// - Parameter string: additional info
    /// - Returns: error object
    func parseError(string: String) -> ZZError {
        return ZZError(text: "Parse error \(string)")
    }
    
}
