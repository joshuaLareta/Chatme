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
                    complete?(nil, error)
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
                complete?(user,nil)
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
                complete?(user,nil)
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
                complete?(data,nil)
                
            }
        }
    }
    
    // NOTE: implement pagination request
    func contactListFeed (completion completionBlock: CompletionBlock?) {
       
    }
    
}
