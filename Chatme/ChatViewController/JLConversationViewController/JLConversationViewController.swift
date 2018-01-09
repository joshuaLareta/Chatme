//
//  JLConversationViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class JLConversationViewController: UIViewController {
    
    var hasFinishedConversationBlock:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController == true {
            if let completionBlock = hasFinishedConversationBlock {
                completionBlock()
            }
        }
    }
}
