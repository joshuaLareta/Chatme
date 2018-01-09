//
//  JLTableViewBaseViewController.swift
//  Chatme
//
//  Created by Joshua on 9/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class JLTableViewBaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    static let cellIdentifier = "defaultTableCellIdentifier"
    static let cellFooterIdentifier = "defaultTableFooterIdentifier"
 
    var tableView: UITableView = {
        let tempTableView = UITableView(frame: .zero, style: .plain)
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: JLTableViewBaseViewController.cellIdentifier)
        tempTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: JLTableViewBaseViewController.cellFooterIdentifier)
        tempTableView.sectionFooterHeight = 0.1
        return tempTableView
    }()
    
    var refreshController: UIRefreshControl = {
        let tempRefreshController = UIRefreshControl()
        return tempRefreshController
    }()


    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        // add tableview Constraints flushed to the side
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView]))
        // add tableview constraints flushed  to the top and bottom
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView]))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshController.addTarget(self, action: #selector(JLTableViewBaseViewController.refreshTableCallback), for: .valueChanged)
        tableView.addSubview(refreshController)
        // Do any additional setup after loading the view.
    }

    @objc func refreshTableCallback() {
        refreshController.endRefreshing() // just end refreshing
        // child must call super to end refreshing
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tableView delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // must be overriden by child class
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // must be overriden by child class
        let cell = tableView.dequeueReusableCell(withIdentifier: JLTableViewBaseViewController.cellIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: JLTableViewBaseViewController.cellFooterIdentifier)
    }
}
