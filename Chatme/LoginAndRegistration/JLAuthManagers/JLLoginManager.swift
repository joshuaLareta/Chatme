//
//  JLLoginManager.swift
//  Chatme
//
//  Created by Joshua on 9/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation
import FirebaseAuth

class JLLoginManager: AuthenticationProtocol {
    var completion: completionBlock?
    private var emailAddressString: String? = nil
    private var passwordString: String? = nil
    
    init () {
        
    }
    
    // initializer with a completion block
    init(withCompletion complete: completionBlock?) {
        completion = complete
    }
    
    deinit {
        print ("de init JLLoginManager")
    }
    
    func update(emailAddress eString: String?, password pString: String?){
        emailAddressString = eString
        passwordString = pString
    }
    
    //Mark: Protocol implementation
    func validate() -> Bool {
        if emailAddressString?.isEmpty == true || passwordString?.isEmpty == true {
            return false
        }
        return true
    }
    
    func loginRequest () {
        // validate the inputs
        guard validate() == true else {
            return
        }
        
        Auth.auth().signIn(withEmail: emailAddressString!, password: passwordString!) { [weak self] (user, error) in
            guard error == nil else {
                if let complete = self?.completion {
                    complete?(nil, error)
                }
                return
            }

            if let complete = self?.completion { // if completion block is not nil then send it back to the caller
                complete?(user,nil)
            }
            print("successfully signed in")
        }
    }
}
