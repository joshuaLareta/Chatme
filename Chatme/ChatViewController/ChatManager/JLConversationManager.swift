//
//  JLConversationManager.swift
//  Chatme
//
//  Created by Joshua on 10/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

struct Client {
    var email: String
    var uid: String
}

struct Conversation {
    var client: Client
    var you: Client
    var chatId: String
}

class JLConversationManager {
    
    var firebaseManager: FirebaseManager = {
        let tempFirebaseManager = FirebaseManager()
        return tempFirebaseManager
    }()

    var conversation: Conversation
    var messages: Array<Dictionary<AnyHashable,Any>?> = [Dictionary<AnyHashable,Any>?]()
    var hasStartedListening: Bool = false
    
    init(withClient client: Client, andYou you: Client, andChatId chatId: String){
        conversation = Conversation(client: client, you: you, chatId: chatId)
    }
    
    deinit {
        print("de init JLConversationManager")
    }
    
   private func startConversation (_ callback:(()->Void)?) {
        firebaseManager.startConversation(withEmail: conversation.client.email, andUID: conversation.client.uid, withChatId: conversation.chatId ,hasStartedCallback: {[weak self] (chatId) in
            self?.conversation.chatId = chatId!
            if let completion = callback {
                completion()
            }
        })
    }
    
    func converse(withMessage message: String) {
        startConversation { [weak self] in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss:SSSS"
            //        let date = dateFormatter.string(from: Date())
            let date = Int64((Date().timeIntervalSince1970).rounded())
            self?.firebaseManager.conversation(withYourUID:(self?.conversation.you.uid)!, withClientUID: (self?.conversation.client.uid)!,withChatId: (self?.conversation.chatId)!, timeOfMessage:String(date), sendMessage: message)
        }
    }

    /// start the listening process for the current conversation
    func startConversationListener(withCallback callback: ((_ addedMessage: Dictionary<AnyHashable,Any>?,_ isUpdate: Bool)->Void)?) {
        startConversation { [weak self] in
            self?.firebaseManager.conversationListener(withYourUID: (self?.conversation.you.uid)!, andClientUID: (self?.conversation.client.uid)!, andConversationId: (self?.conversation.chatId)!, conversations:{ [weak self] (messages, isAnUpdate) in
            self?.hasStartedListening = true
            var message:Dictionary<AnyHashable,Any>? = nil
            var _isAnUpdate = isAnUpdate
                if _isAnUpdate == false {
                    self?.messages = messages
                } else {
                    _isAnUpdate = false
                
                    if let totalMessages = self?.messages.count, messages.count > 0 {
                        message = messages[0]
                        if totalMessages > 0 {
                            // if
                            let lastMessage = self?.messages.last
                            if let lastMessageTime = lastMessage!!["time"] as? Int64, let messageTime = message!["time"] as? Int64 {
                                if lastMessageTime == messageTime {
                                    if let completion = callback {
                                        DispatchQueue.main.async {
                                            completion(nil, false)
                                        }
                                    }
                                    return
                                }
                            }
                            _isAnUpdate = true
                            self?.messages.append(message)
                        } else {
                            self?.messages.append(message)
                        }
                    }
                }
                if let completion = callback {
                    DispatchQueue.main.async {
                        completion(message, _isAnUpdate)
                    }
                }
            })
        }
    }
    
    func messageString(atIndex index: Int) -> String {
        if let messageDictionary = messages[index]{
            return (messageDictionary["message"] as? String) ?? "something went wrong" // should not output something went wrong at all
        }
        return "no message" // should not be reached
    }
    
    func stopUpdatingMessage() {
        firebaseManager.removeConversationListener(withYourUID: conversation.you.uid, andClientUID: conversation.client.uid, fromChatId: conversation.chatId)
    }
}
