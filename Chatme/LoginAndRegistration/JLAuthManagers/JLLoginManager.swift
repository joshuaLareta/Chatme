//
//  JLLoginManager.swift
//  Chatme
//
//  Created by Joshua on 9/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

class JLLoginManager: AuthenticationProtocol {
    var completion: CompletionBlock?
    var firebaseManager: FirebaseManager = {
        let tempFirebaseManager = FirebaseManager()
        return tempFirebaseManager
    }()
    private var emailAddressString: String? = nil
    private var passwordString: String? = nil
    
    init () {
        
    }
    
    // initializer with a completion block
    init(withCompletion complete: CompletionBlock?) {
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
        // firebase manager authenticate
        firebaseManager.auth(emailAddress: emailAddressString!, password: passwordString!, completionBlock: completion)
    }
}
