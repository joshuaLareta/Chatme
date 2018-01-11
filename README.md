# Chatme
Sample chat project using firebase

 # Introduction
 This is a sample project which utilizes firebase as the real-time server. The account may be changed in the future and this does not have a full security check in place. The purpose of this project was for a job application. All message queuing is handled by firebase 
 
 I didn't include the pod library as the podfile is already included, just build from there.
 
 # Tech stack
 - Swift 3
 - Firebase
 - Cocoapods
 # Design Pattern
 - MVVM
 - Facade
 
 # Firebase Structure
 
    mainFirebaseAccountID node
    |-- + conversation node
    |   |-- + client1 UID node
    |       |-- + client2 UID node
    |           |-- + chatId value    
    |           |-- + client1 UID value
    |           |-- + client2 UID value
    |           |-- + isTyping value
    |             
    |-- + conversation info node
    |   |-- + chatId node
    |       |-- + chatId value
    |       |-- + client value
    |       |-- + initiatorClient value
    |
    |-- + messages node
    |   |-- + chatId node
    |       |-- + timestamp node
    |           |-- + message value
    |           |-- + receiver value
    |           |-- + sender value
    |           |-- + timestamp value
    |
    |-- + tempConversation node
    |   |-- + client1 UID node
    |       |-- + client2 UID node
    |           |-- + tempChatId value    
    |           |-- + clientEmail value
    |
    |-- + user node
    |   |-- + info node
    |   |   |-- + clientUID node
    |   |       |-- + email value
    |   |       |-- + uid value
    |   |       |-- + online value
    |   |
    |   |-- + list node
    |       |-- + email value
 
 
 # Steps in building
 1. run cocoapod `pod install`
 2. open workspace and run
 
 > The accounts use here is only temporary and will be changed eventually
 
 # Steps in Using
 1. Create an account ( if already have an account just login)
 2. Select a user to have a conversation with in the contact list
 3. Send a message
 
 # Screenshot
 ![Alt text](screenshots/loginScreenshot.png?raw=false "Login Screen")
 ![Alt text](screenshots/signupScreenshot.png?raw=false "Signup Screen")
 ![Alt text](screenshots/conversationScreenshot.png?raw=false "Conversation Screen")
 
 # Note
 Some of the items not implemented 
 - loading icon
 - images for profile
 - firstname input
 - Conversation list
 - logout functionality
 - read/deliver notification
