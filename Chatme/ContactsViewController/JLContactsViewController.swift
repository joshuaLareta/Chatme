//
//  JLContactsViewController.swift
//  Chatme
//
//  Created by Joshua on 9/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class JLContactsViewController: JLTableViewBaseViewController {
    var contactStartConversationBlock: ((Bool) -> Void)?
    var contactsManager: JLContactsManager = {
        let tempContactsManager = JLContactsManager()
        return tempContactsManager
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Contacts", comment: "Contact title view controller")
    }
    
    override func loadView() {
        super.loadView()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callRefreshContact()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func callRefreshContact () {
        contactsManager.contactListRequest {[weak self] in
            // call tableViewRefresh here
            self?.tableView.reloadData()// just reload data
        }
    }
    
    override func refreshTableCallback() {
        print("refreshing the table")
        callRefreshContact()
        super.refreshTableCallback() // to end the refreshing
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsManager.contactList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = self.contactsManager.contactList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // just deselect
        
        let startConversationAlert = UIAlertController(title:"", message: NSLocalizedString("Start a conversation with \"\(self.contactsManager.contactList[indexPath.row])\"", comment: "Confirm if user wants to converse with the user"), preferredStyle: .alert)
        let conversationConfirmAction = UIAlertAction(title: NSLocalizedString("Yes", comment: "Confirm conversation start"), style: .default) {[weak self] (action) in
            self?.contactsManager.initiateConversation(with: (self?.contactsManager.contactList[indexPath.row])!, conversationStartedBlock: { (client, you, tempChatId) in
                // push contacts vc
                if let startConversation = self?.contactStartConversationBlock {
                    DispatchQueue.main.async {
                         startConversation(true)
                    }
                }
                
                let conversationViewController = JLConversationViewController(withClient: client, andYou: you, andChatId: tempChatId)
                conversationViewController.hasFinishedConversationBlock = {[weak self] in
                    if let startConversation = self?.contactStartConversationBlock {
                        startConversation(false)
                    }
                }
                self?.navigationController?.pushViewController(conversationViewController, animated: true)
            })
        }
        //  cancel action for the confirmation alert
        let conversationCancelAction = UIAlertAction(title: NSLocalizedString("No", comment: "Cancel conversation"), style: .cancel, handler: nil)
        
        // add the action to the conversation alert
        startConversationAlert.addAction(conversationConfirmAction)
        startConversationAlert.addAction(conversationCancelAction)
        self.present(startConversationAlert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
