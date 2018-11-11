//
//  ZZBlockchainService.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 10/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation

/// Protocol defining API for getting blocks and transactions from blockchain
protocol ZZBlockchainService: class {
    var onError: ZZErrorClosure? { get set }
    var onConnectionStatus: ZZSocketClient.ConnectionStatusClosure? { get set }
    var onTransaction: ZZTransactionClosure? { get set }
    var onBlock: ZZBlockClosure? { get set }
    
    var transactions: [ZZTransaction] { get }
    var blocks: [ZZBlock] { get }
    
    func startUpdates()
    func stopUpdates()
}

/// Implementation of ZZBlockchainService using socket and rest API of http://blockexplorer.com
class ZZBlockchainServiceImpl: ZZBlockchainService {
    
    let socketClient: ZZSocketClient = ZZBlockExplorerSocketClient()
    let restService: ZZBlockchainAPIService = ZZBlockExplorerAPIService()
    
    /// Notifies about error that should be shown in UI
    var onError: ZZErrorClosure?
    /// Notifies about socket connection status change
    var onConnectionStatus: ZZSocketClient.ConnectionStatusClosure?
    /// Notifies about new transaction
    var onTransaction: ZZTransactionClosure?
    /// Notifies about new block
    var onBlock: ZZBlockClosure?
    
    /// Last transactions 
    var transactions: [ZZTransaction] = []
    /// All blocks loaded from app start
    var blocks: [ZZBlock] = []
    
    /// Sometimes transaction or block ids from socket event are not available yet in rest api
    let allowedStatusCodes = [400, 404, 429]
    /// Helper for parsing data from apis
    let jsonParser = ZZJsonParser()
    
    init() {
        self.socketClient.onEvent = { event in
            switch event.name {
            case .tx:
                self.handleTransactionEvent(data: event.data)
            case .block:
                self.handleBlockEvent(data: event.data)
            default:
                self.onError?(ZZError(text: "unexpected event \(event.name.rawValue)"))
            }
        }
        self.socketClient.onConnectionStatus = { status in
            switch status {
            case .disconnected:
                self.socketClient.connect()
            default:
                break
            }
        }
        self.socketClient.onError = { error in
            self.onError?(error)
        }
    }
    
    /// Starts socket connection and loads last block info
    func startUpdates() {
        self.socketClient.connect()
        self.restService.getLastBlock(success: { (block) in
            self.blocks.append(block)
            self.onBlock?(block)
        }) { (err) in
            self.onError?(err)
        }
    }
    
    /// Stops socket connection
    func stopUpdates() {
        self.socketClient.disconnect()
    }
    
    /// Loads detail info of transaction id from socket message
    ///
    /// - Parameter data: socket event data
    func handleTransactionEvent(data: Any) {
        guard let id = self.jsonParser.transactionId(data: data) else {
            return
        }
        self.restService.getTransaction(id: id, success: { (transaction) in
            
            if self.transactions.count < ZZConfig.maxTransactions {
                self.transactions.insert(transaction, at: 0)
            } else {
                self.transactions.insert(transaction, at: 0)
                self.transactions.removeLast()
            }
            self.onTransaction?(transaction)
        }) { (err) in
            self.handle(error: err)
        }
    }
    
    /// Loads detail info of block id from socket message
    ///
    /// - Parameter data: socket event data
    func handleBlockEvent(data: Any) {
        guard let hash = self.jsonParser.blockHash(data: data) else {
            return
        }
        self.restService.getBlock(hash: hash, success: { (block) in
            self.blocks.insert(block, at: 0)
            self.onBlock?(block)
        }) { (err) in
            self.handle(error: err)
        }
    }
    
    /// Checks if error should be displayed in UI and calls onError if it is
    ///
    /// - Parameter error: error info object
    func handle(error: ZZError) {
        if self.allowedStatusCodes.contains(error.code) {
            //most likely transaction or block info isn't available yet
        } else {
            self.onError?(error)
        }
    }
    
}
