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
        return tempTabController
    }()
    
    let conversationListNavCon: UINavigationController = {
        let tempConversationListVC = JLConversationListViewController()
        let tempConversationListNavCon = UINavigationController(rootViewController: tempConversationListVC)
        return tempConversationListNavCon
    }()
    
    let contactsNavCon: UINavigationController = {
        let tempContactsVC = JLContactsViewController()
        let tempContactsNavCon = UINavigationController(rootViewController: tempContactsVC)
        return tempContactsNavCon
    }()
    
    var loginNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .black
        self.navigationController?.setNavigationBarHidden(true, animated: false) // no need to show the navigationItemBar
        
        // setup tabController
        tabController.setViewControllers([contactsNavCon,conversationListNavCon], animated: false)
        
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

