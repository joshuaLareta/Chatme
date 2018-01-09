//
//  JLContactsManager.swift
//  Chatme
//
//  Created by Joshua on 9/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

class JLContactsManager {
    typealias ContactsManagerCompletion = (()->Void)?
    
    var firebaseManager: FirebaseManager = {
        let tempFirebaseManager = FirebaseManager()
        return tempFirebaseManager
    }()
    
    var contactList:Array = [String]()

    init () {
        
    }
    
    deinit {
        print("deinit JLContacts Manager")
    }
    
    private func listRequest(completion completionBlock: ContactsManagerCompletion?){
        firebaseManager.contactListRequest {[weak self] (data, _) in
            // the data list
            if data is Array<String> {
                self?.contactList = data as! Array
                if let complete = completionBlock {
                    complete?() // no need to pass aything
                }
            }
        }
    }
    
    func contactListRequest(completion completionBlock: ContactsManagerCompletion?){
        listRequest(completion: completionBlock)
    }
    
    func startConversation(with email:String, conversationStartedBlock: (()->Void)?){
        firebaseManager.startConversation(with: email,completion: conversationStartedBlock)
    }
    
}
