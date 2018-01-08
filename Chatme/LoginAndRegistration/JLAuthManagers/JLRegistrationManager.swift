//
//  JLRegistrationManager.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias completionBlock = ((_ data: Any?, _ error: Error?)->Void)?

protocol AuthenticationProtocol {
    func validate () -> Bool
}

struct RegistrationError: Error {
    var errorTitle: String
    var errorDescription: String
    var errorCancelButtonTitle: String
    
}

class JLRegistrationManager: AuthenticationProtocol {
    var completion: completionBlock?
    
    private var emailString: String? = nil
    private var passwordString: String? = nil
    private var confirmPasswordString: String? = nil
    
    init() {
        
    }
    deinit {
        print("de init JLRegistrationManager")
    }
    
    // function for cleanly updating the properties
    func update(email eString: String?, password pString: String?, confirmPassword cpString: String?){
        emailString = eString
        passwordString = pString
        confirmPasswordString = cpString
    }
    
    func validate () -> Bool {
        
        if (emailString?.isEmpty == true || passwordString?.isEmpty == true || confirmPasswordString?.isEmpty == true) || (confirmPasswordString != passwordString){
            return false
        }
       return true
    }
    
    //function that will start the registration process
    func registerAccountRequest() {
        //register an account with firebase
        guard validate() == true else{
            let managerError = RegistrationError(errorTitle: NSLocalizedString("Account Creation Error", comment: "title of account creation error"), errorDescription: NSLocalizedString("Encountered an error in creating your account.\nPlease check your input credential", comment: "Error message for missing credential"), errorCancelButtonTitle: NSLocalizedString("Ok", comment: "alert action title"))
           
            if let complete = self.completion {
                complete?(nil, managerError)
            }
            print ("credential error")
            return
        }
        
        // validate input
        Auth.auth().createUser(withEmail: emailString!, password: passwordString!) {[weak self] (user, error) in
            guard error == nil else {
                if let complete = self?.completion {
                    complete?(nil, error)
                }
                return
            }
            
            if let complete = self?.completion { // if completion block is not nil then send it back to the caller
                complete?(user,nil)
            }
            print ("a new user has been created")
        }
    }
}
