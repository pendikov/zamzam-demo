//
//  ZZTransactionsRouter.swift
//  ZamZamDemo
//
//  Created Daniil Pendikov on 09/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ZZTransactionsRouter: ZZTransactionsWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(blockchain: ZZBlockchainService)
        -> UIViewController {
            let view = ZZTransactionsViewController()
            let interactor = ZZTransactionsInteractor()
            let router = ZZTransactionsRouter()
            let presenter = ZZTransactionsPresenter(interface: view, interactor: interactor, router: router)
            
            view.presenter = presenter
            interactor.presenter = presenter
            router.viewController = view
            
            interactor.blockchain = blockchain
            
            return view
    }
    
    func show(transaction: ZZTransaction, blockchain: ZZBlockchainService) {
        let controller = ZZTransactionRouter.createModule(transaction: transaction,
                                                  blockchain: blockchain)
        self.viewController?.navigationController?.pushViewController(controller,
                                                                      animated: true)
    }
}
