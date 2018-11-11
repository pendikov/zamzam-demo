//
//  AppDelegate.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 09/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import UIKit
import CoreData
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /// Service providing blocks and transactions
    let blockchainService: ZZBlockchainService = ZZBlockchainServiceImpl()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.configureLog()
        self.window = self.createWindow()
        self.window?.makeKeyAndVisible()
        self.blockchainService.onError = { error in
            self.showError(text: error.text)
        }
        self.blockchainService.startUpdates()
        return true
    }
    
    func showError(text: String) {
        DispatchQueue.main.async {
            guard let controller = self.window?.rootViewController else { return }
            ZZAlert.showError(text: text, controller: controller)
        }
    }
    
    /// Configure SwiftyBeaver for better readable logs
    private func configureLog() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }
    
    /// Create main app window and it's root tab bar view controller
    ///
    /// - Returns: main window
    private func createWindow() -> UIWindow {
        let transactions = ZZTransactionsRouter.createModule(blockchain: self.blockchainService)
        let transactionsNav = UINavigationController(rootViewController: transactions)
        
        let blocks = ZZBlocksRouter.createModule(blockchain: self.blockchainService)
        let blocksNav = UINavigationController(rootViewController: blocks)
        
        let tbc = UITabBarController()
        tbc.viewControllers = [blocksNav, transactionsNav]
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = tbc
        return window
    }

}

