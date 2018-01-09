//
//  FirebaseManager.swift
//  Chatme
//
//  Created by Joshua on 9/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase


class FirebaseManager {
    
    var ref: DatabaseReference! = {
        let tempRef = Database.database().reference()
        return tempRef
    }()
    
    // Handles firebase registration of account
    func registerAccount(emailAddress email: String, password pword: String, completionBlock completion: CompletionBlock?){
        Auth.auth().createUser(withEmail: email, password: pword) {[weak self] (user, error) in
            guard error == nil else {
                if let complete = completion {
                    DispatchQueue.main.async {
                        complete?(nil, error)
                    }
                }
                return
            }
            // store username to firebase contact list
            self?.ref.child("users").child("list").child(user!.uid).setValue(user?.email)
            
            // store user's info node
            self?.ref.child("users").child("info").child(user!.uid).child("email").setValue(user?.email)
            self?.ref.child("users").child("info").child(user!.uid).child("id").setValue(user?.uid)
            self?.ref.child("users").child("info").child(user!.uid).child("online").setValue(true)
            
            if let complete = completion { // if completion block is not nil then send it back to the caller
                DispatchQueue.main.async {
                    complete?(user,nil)
                }
            }
            print ("a new user has been created")
        }
    }
    
    // Handles authentication to firebase
    func auth(emailAddress email: String, password pword: String, completionBlock completion: CompletionBlock?){
        Auth.auth().signIn(withEmail: email, password: pword) {[weak self] (user, error) in
            guard error == nil else {
                if let complete = completion {
                    complete?(nil, error)
                }
                return
            }
            self?.ref.child("users").child("info").child(user!.uid).child("online").setValue(true)
            if let complete = completion { // if completion block is not nil then send it back to the caller
                DispatchQueue.main.async {
                    complete?(user,nil)
                }
            }
            print("successfully signed in")
        }
    }
    
    // Handles the listener in the contact list and reuses the callback block
    func contactListRequest (completion completionBlock: CompletionBlock?) {
       let initialContactQuery = self.ref.child("users").child("list").queryOrderedByValue().queryLimited(toFirst: 100) // first 100 users
        initialContactQuery.observeSingleEvent(of: DataEventType.value) { (snapshot) in
           let uid = Auth.auth().currentUser?.uid
            var data:[String] = []
            if (snapshot.value is Dictionary<AnyHashable,Any>){
                // handle the data
                var dataDictionary = snapshot.value as? Dictionary<AnyHashable,Any>
                if dataDictionary?.values.isEmpty == false{
                    dataDictionary?.removeValue(forKey: uid!)
                   data = Array(dataDictionary!.values) as! Array<String>
                }
            }
            if let complete = completionBlock {
                DispatchQueue.main.async {
                    complete?(data,nil)
                }
                
            }
        }
    }
    
    // NOTE: implement pagination request
    func contactListFeed (completion completionBlock: CompletionBlock?) {
       
    }
    
    //Method for starting a conversation
    func startConversation(with email:String, completion completeBlock: (()->Void)?) {
        let uid = Auth.auth().currentUser?.uid
    
        ref.child("users").child("info").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) {[weak self] (snapshot) in
            print("the snapshot \(snapshot.key,snapshot)")
            if let dictionary = snapshot.value as? Dictionary<AnyHashable,Any> {
                let keys = Array(dictionary.keys) as! Array<String>
                let UIDOfUserToChat = keys[0] // get id from top of the key
                
                //update the conversations
                self?.ref.child("users").child("conversations").child(uid!).child(UIDOfUserToChat).child("email").setValue(email)
                
                if let complete = completeBlock {
                    DispatchQueue.main.async {
                         complete()
                    }
                }
            }
        }
    }
    
}
