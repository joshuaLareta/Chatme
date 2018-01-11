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
    
    var messageObserver: DatabaseHandle!
    var conversationObserver: DatabaseHandle!
    
    /**
     
     Function to register an Account via firebase interface
     
     `email` String that represents the user's email address that will be used to register in firebase.
     
     `password` String that represents the user's chosen password.
     
     **/
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
    
    //Method for initiating a conversation
    func initiateConversation(with email:String, completion completeBlock: ((_ uid: String, _ email: String?, _ tempChatId: String)->Void)?) {
        let uid = Auth.auth().currentUser?.uid
        let yourEmail = Auth.auth().currentUser?.email
        let chatId = String(yourEmail!+"+"+email) // reference of the chat
    
        ref.child("users").child("info").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) {[weak self] (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<AnyHashable,Any> {
                let keys = Array(dictionary.keys) as! Array<String>
                let UIDOfUserToChat = keys[0] // get id from top of the key
                var emailOfUserToChat = "" // this shouldn't be empty at all
                if let subDictionary = dictionary[UIDOfUserToChat] as? Dictionary<AnyHashable,Any> {
                     emailOfUserToChat = (subDictionary["email"]) as! String
                }
                
                //update the temp conversations
                // this is due to not directly accessing a conversations list
                self?.ref.child("temp-conversations").child(uid!).child(UIDOfUserToChat).child("email").setValue(email)
                self?.ref.child("temp-conversations").child(uid!).child(UIDOfUserToChat).child("chatId").setValue(String(chatId.hashValue))

                if let complete = completeBlock {
                    DispatchQueue.main.async {
                         complete(UIDOfUserToChat, emailOfUserToChat, String(chatId.hashValue))
                    }
                }
            }
        }
    }
    
    func startConversation (withEmail email: String, andUID uid: String, withChatId tempChatId: String, hasStartedCallback startedConversationCallback: ((String?)->Void)?) {
        let yourUID = Auth.auth().currentUser?.uid // there will always be a uid
        let yourEmail = Auth.auth().currentUser?.email
        var chatId = tempChatId
        
        
        ref.child("conversations").child(yourUID!).child(uid).observeSingleEvent(of: .value) {[weak self] (snapshot) in
            
            if snapshot.value is NSNull{ // means there is no conversation yet created
                // create the conversation for both user so they can have the same chatID
                
                // your conversation info
                self?.ref.child("conversations-info").child(chatId).child("initiatorClient").setValue(yourEmail)
                self?.ref.child("conversations-info").child(chatId).child("client").setValue(email)
                self?.ref.child("conversations-info").child(chatId).child("chatId").setValue(chatId)
                
                self?.ref.child("conversations").child(yourUID!).child(uid).child("chatId").setValue(chatId)
                self?.ref.child("conversations").child(yourUID!).child(uid).child("client1").setValue(uid)
                self?.ref.child("conversations").child(yourUID!).child(uid).child("client2").setValue(yourUID)
                
                self?.ref.child("conversations").child(uid).child(yourUID!).child("chatId").setValue(chatId)
                self?.ref.child("conversations").child(uid).child(yourUID!).child("client1").setValue(uid)
                self?.ref.child("conversations").child(uid).child(yourUID!).child("client2").setValue(yourUID)
            } else {
                if let snap = snapshot.value as? Dictionary<AnyHashable,Any> {
                    chatId = snap["chatId"] as! String
                }
            }
            
            if let completion = startedConversationCallback {
                completion(chatId)
            }
        }
    }
    
    
    // Return a tuple containing UID and email of the current loggedIn user
    func currentUser () -> (uid: String, email: String) {
        return (Auth.auth().currentUser!.uid, Auth.auth().currentUser!.email!)
    }
    
    func conversationListener(withYourUID yourUID: String, andClientUID clientUID: String, andConversationId chatId: String, conversations conversationCallback:((_ messages:[Dictionary<AnyHashable,Any>?], _ isUpdate: Bool)->Void)?) {
       
        
        //Note:: need to listen to conversation changes
         // fetch all existing messages
        
        ref.child("messages").child(chatId).observeSingleEvent(of: .value) {(snapshot) in
            var messages: [Dictionary<AnyHashable,Any>?] = []
            if snapshot.value is NSNull {
                messages = []
            }else {
                if let dictionaryOfMessages = snapshot.value as? Dictionary<AnyHashable,Any>{
                    for (_, value) in dictionaryOfMessages {
                        if let dictionaryValue = value as? Dictionary<AnyHashable,Any>{
                            messages.append(dictionaryValue)
                        }
                    }
                    // sort it out
                    messages = messages.sorted(by: { $1!["time"] as! Int64 > $0!["time"] as! Int64 })
                }
            }
            
            if let callback = conversationCallback {
                callback(messages, false)
            }
        }
        
            // get the changes one by one
            self.messageObserver = self.ref.child("messages").child(chatId).queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
                var message: [Dictionary<AnyHashable,Any>?] = []
                if let dictionaryOfMessages = snapshot.value as? Dictionary<AnyHashable,Any>{
                    message.append(dictionaryOfMessages)
                }
                
                if let callback = conversationCallback {
                    callback(message, true)
                }
            })
        
       
       
    }
    
    // Method for sending the message to firebase server
    func conversation(withYourUID yourUID:String, withClientUID clientUID: String, withChatId chatId: String, timeOfMessage time: String, sendMessage message: String) {
        ref.child("messages").child(chatId).child(time).child("message").setValue(message)
        ref.child("messages").child(chatId).child(time).child("time").setValue(Int64(time))
        ref.child("messages").child(chatId).child(time).child("sender").setValue(yourUID)
        ref.child("messages").child(chatId).child(time).child("receiver").setValue(clientUID)
    }
    
    
    /**
     listener removal functions
     **/
    
    private func removeMessageListener(fromChatId chatId:String) {
        ref.child("messages").child(chatId).removeObserver(withHandle: messageObserver!)
    }
    
    func removeConversationListener(withYourUID yourUID:String, andClientUID clientUID: String, fromChatId chatId: String) {
        removeMessageListener(fromChatId: chatId)
    }
}
