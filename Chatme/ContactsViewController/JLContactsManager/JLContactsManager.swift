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
    
    func initiateConversation(with email:String, conversationStartedBlock: ((_ client: Client, _ you: Client, _ tempChatId: String)->Void)?){
        firebaseManager.initiateConversation(with: email) { [weak self] (uid, email, tempChatId) in
            
            let client = Client(email: email!, uid: uid)
            let userTuple = self?.firebaseManager.currentUser()
            let you = Client(email: userTuple!.email, uid: userTuple!.uid)
            
            // return the two clients created
            if let complete = conversationStartedBlock {
                complete(client, you, tempChatId)
            }
        }
    }
    
}
