//
//  ZZSocketClient.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 09/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation
import SocketIO

/// Status of socket connection
enum ZZConnectionStatus {
    case disconnected
    case connecting
    case connected
}

struct ZZSocketEvent {
    /// Types of blockexplorer socket events
    ///
    /// - subscribe: client event for connecting to rooms
    /// - tx: server transaction event
    /// - block: server block event
    enum Name: String {
        case subscribe = "subscribe"
        case tx = "tx"
        case block = "block"
    }
    
    var name: Name
    var data: Any
}

/// Protocol for blockchain socket API
protocol ZZSocketClient: class {
    typealias EventClosure = (ZZSocketEvent) -> Void
    typealias ConnectionStatusClosure = (ZZConnectionStatus) -> Void
    
    var connectionStatus: ZZConnectionStatus { get }
    
    func connect()
    func disconnect()
    
    var onEvent: EventClosure? { get set }
    var onError: ZZErrorClosure? { get set }
    var onConnectionStatus: ConnectionStatusClosure? { get set }
}

/// ZZSocketClient implementation using http://blockexplorer.com socket API
class ZZBlockExplorerSocketClient: ZZSocketClient {
    
    static let apiUrlString = ZZConfig.API.socket
    static let config: SocketIOClientConfiguration = [.compress, .reconnects(false)]
    static let room = "inv"
    
    private var manager: SocketManager
    private var socket: SocketIOClient
    var connectionStatus: ZZConnectionStatus = .disconnected {
        didSet {
            self.onConnectionStatus?(self.connectionStatus)
        }
    }
    var onEvent: ZZSocketClient.EventClosure?
    var onError: ZZErrorClosure?
    var onConnectionStatus: ZZSocketClient.ConnectionStatusClosure?
    
    init() {
        let url = URL(string: type(of: self).apiUrlString)!
        
        self.manager = SocketManager(socketURL: url,
                                     config: type(of: self).config)
        self.socket = self.manager.defaultSocket
        
        self.subscribeToBlockEvents()
        self.subscribeToTransactionEvents()
        
        self.socket.on(clientEvent: .connect, callback: { (_, _) in
            log.info("\(SocketClientEvent.connect)")
            self.connectionStatus = .connected
            self.socket.emit(ZZSocketEvent.Name.subscribe.rawValue, type(of: self).room)
        })
        
        self.socket.on(clientEvent: .disconnect) { (data, ack) in
            log.error("\(SocketClientEvent.disconnect)")
            self.connectionStatus = .disconnected
        }
    }
    
    func subscribeToBlockEvents() {
        self.socket.on(ZZSocketEvent.Name.block.rawValue) { (data, _) in
            log.verbose(ZZSocketEvent.Name.tx)
            guard let first = data.first else {
                return
            }
            let event = ZZSocketEvent(name: ZZSocketEvent.Name.block, data: first)
            self.onEvent?(event)
        }
    }
    
    func subscribeToTransactionEvents() {
        self.socket.on(ZZSocketEvent.Name.tx.rawValue) { (data, _) in
            log.verbose(ZZSocketEvent.Name.tx)
            guard let first = data.first else {
                return
            }
            let event = ZZSocketEvent(name: ZZSocketEvent.Name.tx, data: first)
            self.onEvent?(event)
        }
    }
    
    /// Connect socket
    func connect() {
        self.connectionStatus = .connecting
        self.socket.connect()
    }
    
    /// Disconnect socket
    func disconnect() {
        self.socket.disconnect()
    }
    
}
