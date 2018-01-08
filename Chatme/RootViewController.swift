//
//  RootViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit
import Firebase

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .black
        
        FirebaseApp.configure() // start firebase
                
        DispatchQueue.main.async {// perform the presenting of view in the main queue
            
            let loginViewController = JLLoginViewController(withCompletion: {[weak self] (data, error) in
                guard error == nil else {
                    let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Encountered an error"), message: error?.localizedDescription, preferredStyle: .alert)
                    let errorAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok for alert cancel button"), style: .cancel, handler: nil)
                    errorAlertController.addAction(errorAction)
                    self?.present(errorAlertController, animated: true, completion: nil)

                    return
                }
                // no error proceed to main chat page
                print("proceeding to main page")
                
                
            })
            let navigationController = UINavigationController(rootViewController: loginViewController)
            self.navigationController?.present(navigationController, animated: false, completion: nil)
            
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

