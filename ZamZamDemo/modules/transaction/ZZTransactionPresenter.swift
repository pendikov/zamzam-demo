//
//  ZZTransactionPresenter.swift
//  ZamZamDemo
//
//  Created Daniil Pendikov on 10/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ZZTransactionPresenter: ZZTransactionPresenterProtocol {

    weak private var view: ZZTransactionViewProtocol?
    var interactor: ZZTransactionInteractorProtocol?
    private let router: ZZTransactionWireframeProtocol
    
    var transaction: ZZTransaction?

    init(interface: ZZTransactionViewProtocol, interactor: ZZTransactionInteractorProtocol?, router: ZZTransactionWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func start() {
        guard let trans = self.transaction else {
            log.error("\(#function) requires transaction to be set")
            return
        }
        
        var rows = [String]()
        rows.append("id: \(trans.txid.prefix(10))...")
        rows.append("block height height: \(trans.blockheight)")
        rows.append("number of confirmations: \(trans.confirmations)")
        self.view?.update(rows: rows)
    }

}
