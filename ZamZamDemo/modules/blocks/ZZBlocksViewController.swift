//
//  ZZBlocksViewController.swift
//  ZamZamDemo
//
//  Created Daniil Pendikov on 10/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ZZBlocksViewController: UIViewController, ZZBlocksViewProtocol {

	var presenter: ZZBlocksPresenterProtocol?
    var blocks: [ZZBlock] = []
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "cell"
    
    var isLoading: Bool = false {
        didSet {
            if self.isLoading {
                ZZActivityIndicator.addToView(self.view)
            } else {
                ZZActivityIndicator.removeFromView(self.view)
            }
        }
    }
    
    convenience init() {
        self.init(nibName: String(describing: type(of: self)), bundle: nil)
        self.title = "Blocks"
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.presenter?.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func configureTableView() {
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func add(blocks: [ZZBlock]) {
        self.blocks = blocks + self.blocks
        self.tableView.reloadData()
    }

}

extension ZZBlocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier,
                                                 for: indexPath)
        cell.textLabel?.text = self.blocks[indexPath.row].hash
        return cell
    }
}

extension ZZBlocksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let block = self.blocks[indexPath.row]
        self.presenter?.show(block: block)
    }
    
}