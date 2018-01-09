//
//  JLConversationListViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class JLConversationListViewController: UIViewController {
    
    let chatListTableview = UITableView(frame: .zero, style: .plain)
    
     init() {
        super.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Conversations", comment: "Chat title")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
