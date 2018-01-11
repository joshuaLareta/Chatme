//
//  RootViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    let tabController: UITabBarController = {
        let tempTabController = UITabBarController()
        tempTabController.hidesBottomBarWhenPushed = true
        return tempTabController
    }()
    
    var contactsNavCon: UINavigationController?
    var conversationListNavCon: UINavigationController?
    var loginNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .black
        self.navigationController?.setNavigationBarHidden(true, animated: false) // no need to show the navigationItemBar
        
        // initialize contactsVC
        let contactsVC = JLContactsViewController()
        contactsVC.contactStartConversationBlock = {[weak self](hasEndedConversation) in
            self?.tabController.tabBar.isHidden = hasEndedConversation
        }
        contactsNavCon = UINavigationController(rootViewController: contactsVC)
        
        let conversationListVC = JLConversationListViewController()
        conversationListNavCon = UINavigationController(rootViewController: conversationListVC)
        
        // setup tabController
        tabController.setViewControllers([contactsNavCon!], animated: false)
        
        self.navigationController?.present(tabController, animated: false, completion: nil) // present tabcontroller as the base
        
        let loginViewController = JLLoginViewController()
        loginViewController.completionBlock = { [weak self] (data, error) in
            guard error == nil else {
                let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Encountered an error"), message: error?.localizedDescription, preferredStyle: .alert)
                let errorAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok for alert cancel button"), style: .cancel, handler: nil)
                errorAlertController.addAction(errorAction)
                DispatchQueue.main.async {
                    self?.present(errorAlertController, animated: true, completion: nil)
                }
                return
            }
            // no error proceed to main chat page
            print("proceeding to main page")
            self?.loginNavigationController?.dismiss(animated: true, completion: nil)
        }
        
        loginNavigationController = UINavigationController(rootViewController: loginViewController)
        DispatchQueue.main.async { [weak self] in// perform the presenting of view in the main queue
            self?.tabController.present((self?.loginNavigationController)!, animated: false, completion: nil)
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

