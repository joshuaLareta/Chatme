//
//  JLConversationViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

/**
 Class that handles the Conversation screen
 **/

class JLConversationViewController: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var conversationManager: JLConversationManager?
    var hasFinishedConversationBlock:(()->Void)?
    static let cellDefaultIdentifier = "cellDefaultIdentifier"
    static let cellHisCellIdentifier = "cellHisCellIdentifier"
    static let cellFooterIdentifier = "cellDefaultFooterIdentifier"
    let bottomBar: UIView = {
        let tempBottomBar = UIView()
        tempBottomBar.translatesAutoresizingMaskIntoConstraints = false
        tempBottomBar.backgroundColor = UIColor.darkGray
        tempBottomBar.isUserInteractionEnabled = true
        return tempBottomBar
    }()
    
    let chatTableView: UITableView = {
        let tempChatTableView = UITableView(frame: .zero, style: .plain)
        tempChatTableView.translatesAutoresizingMaskIntoConstraints = false
        tempChatTableView.sectionFooterHeight = 0.1
        tempChatTableView.separatorColor = UIColor.clear
        tempChatTableView.estimatedRowHeight = 50
        tempChatTableView.register(JLChatConversationYourTableViewCell.self, forCellReuseIdentifier: JLConversationViewController.cellDefaultIdentifier)
        tempChatTableView.register(JLChatConversationHisTableViewCell.self, forCellReuseIdentifier: JLConversationViewController.cellHisCellIdentifier)
        tempChatTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: JLConversationViewController.cellFooterIdentifier)
        return tempChatTableView
    }()
    
    let textView: UITextView = {
        let tempTextView = UITextView(frame: .zero)
        tempTextView.translatesAutoresizingMaskIntoConstraints = false
        tempTextView.clipsToBounds = true
        tempTextView.layer.cornerRadius = 10
        tempTextView.isUserInteractionEnabled = true
        return tempTextView
    }()
    
    let sendButton: UIButton = {
        let tempSendButton = UIButton(type: .custom)
        tempSendButton.translatesAutoresizingMaskIntoConstraints = false
        tempSendButton.setTitleColor(.white, for: .normal)
        tempSendButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        tempSendButton.addTarget(self, action: #selector(JLConversationViewController.sendAction), for: .touchUpInside)
        tempSendButton.setTitle(NSLocalizedString("Send", comment: "Send button"), for: .normal)
        return tempSendButton
    }()
    
    var keyboardLayoutConstraint: NSLayoutConstraint?
    
    var titleView: UIView = {
        let tempTitleView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        tempTitleView.backgroundColor = .clear
        return tempTitleView
    }()
    
    var titleLabel: UILabel = {
        let tempTitleLabel = UILabel()
        tempTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tempTitleLabel.textColor = .darkGray
        tempTitleLabel.textAlignment = .center
        tempTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        return tempTitleLabel
    }()
    
    var subtitleLabel: UILabel = {
        let tempSubtitleLabel = UILabel()
        tempSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tempSubtitleLabel.textColor = .lightGray
        tempSubtitleLabel.textAlignment = .center
        tempSubtitleLabel.font = UIFont.systemFont(ofSize: 10)
        return tempSubtitleLabel
    }()
    
    init(withClient client: Client, andYou you: Client, andChatId chatId: String) {
        super.init(nibName: nil, bundle: nil)
        conversationManager = JLConversationManager(withClient: client, andYou: you, andChatId: chatId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("de init JLConversationViewController")
    }
    override func loadView() {
        super.loadView()
        view.addSubview(chatTableView)
        bottomBar.addSubview(textView)
        bottomBar.addSubview(sendButton)
        view.addSubview(bottomBar)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        // add chatTableView constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView": chatTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]", options: [], metrics: nil, views: ["tableView": chatTableView]))
        
        // add bottomBar constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottomBar]|", options: [], metrics: nil, views: ["bottomBar": bottomBar]))
        // added a -50 diff since we rotated the tableview and now the headerView has a more visible gap
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[tableView][bottomBar(==50)]", options: [], metrics: nil, views: ["tableView": chatTableView,
                                                                                                                                                      "bottomBar": bottomBar]))
        keyboardLayoutConstraint = NSLayoutConstraint(item: bottomBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(keyboardLayoutConstraint!)
        
        bottomBar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[textView]-10@999-[sendButton(==80)]-10-|", options: [], metrics: nil, views: ["sendButton": sendButton, "textView": textView]))
        bottomBar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[textView]-5-|", options: [], metrics: nil, views: ["textView": textView]))
         bottomBar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[sendButton]-5-|", options: [], metrics: nil, views: ["sendButton": sendButton]))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(JLConversationViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JLConversationViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        startListening()
    }
    
    func startListening() {
        // start notification only when view appears
        conversationManager?.startConversationListener(withCallback: { [weak self](addedMessage,isAnUpdate) in
            
            if isAnUpdate == false {
                self?.chatTableView.reloadData()
            }
            else {
                self?.chatTableView.beginUpdates()
                self?.chatTableView.insertRows(at:[IndexPath(row: self?.chatTableView.numberOfRows(inSection: 0) ?? 0, section: 0)], with: UITableViewRowAnimation.fade)
                self?.chatTableView.endUpdates()
                // insert the messages one by one
            }
            self?.scrollTableViewToBottom()
            self?.conversationManager?.clientIsTypingListener({[weak self] (isTyping) in
                if isTyping == true {
                    self?.subtitleLabel.text = NSLocalizedString("Typing...", comment: "user is typing label")
                } else {
                    self?.subtitleLabel.text = nil
                }
            })
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        // add the needed elements
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        // add the constraints
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[titleLabel]-10-|", options: [], metrics: nil, views: ["titleLabel":titleLabel]))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel(==20)]", options: [], metrics: nil, views: ["titleLabel":titleLabel]))
        
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[subtitleLabel]-10-|", options: [], metrics: nil, views: ["subtitleLabel":subtitleLabel]))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel][subtitleLabel(>=1)]-5@999-|", options: [], metrics: nil, views: ["titleLabel":titleLabel,"subtitleLabel":subtitleLabel]))
        titleView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
        titleLabel.text = conversationManager?.conversation.client.email
        subtitleLabel.text = nil
        // special label for the navigation bar
        self.navigationItem.titleView = titleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        conversationManager?.stopUpdatingMessage()
        if self.isMovingFromParentViewController == true {
            if let completionBlock = hasFinishedConversationBlock {
                completionBlock()
            }
        }
    }
    
    //MARK: keyboard callback
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardLayoutConstraint?.constant = -(keyboardSize.height)
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        } else {
            print("something went wrong and didn't managed to get any keyboardSize")
        }
        scrollTableViewToBottom()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
    }
    
    @objc func sendAction () {
        if conversationManager?.hasStartedListening == false {
            // try to restart the listener as it may not have started properly
            startListening()
        }
        var messageString = textView.text
        messageString = messageString?.trimmingCharacters(in: .whitespacesAndNewlines)
        if messageString?.isEmpty == false {
            conversationManager?.converse(withMessage: messageString!)
            textView.text = nil // clear it out
        }
    }
    
    //MARK: tableView datasource and Identifier
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationManager?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// check if the current message that is being displayed is yours
        
        if conversationManager?.isMessageYours(atMessageIndex: indexPath.row) == true {
            let cell: JLChatConversationYourTableViewCell = tableView.dequeueReusableCell(withIdentifier: JLConversationViewController.cellDefaultIdentifier, for: indexPath) as! JLChatConversationYourTableViewCell
            cell.message((conversationManager?.messageString(atIndex: indexPath.row))!)
            return cell
        }
        else {
            let cell: JLChatConversationHisTableViewCell = tableView.dequeueReusableCell(withIdentifier: JLConversationViewController.cellHisCellIdentifier, for: indexPath) as! JLChatConversationHisTableViewCell
            cell.message((conversationManager?.messageString(atIndex: indexPath.row))!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: JLConversationViewController.cellFooterIdentifier)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // is user typing
        conversationManager?.update(isClientTyping: true)
        return true
    }
    
    // custom function
    
    /// make scrollview scroll to the bottom
    func scrollTableViewToBottom() {
        // always perform the UI update on the main thread
        DispatchQueue.main.async {[weak self] in
            var lastRow = (self?.chatTableView.numberOfRows(inSection: 0))!
            if lastRow > 0 {
                lastRow = lastRow - 1
                let lastIndexPath = IndexPath(row: lastRow, section: 0)
                self?.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
        }
    }
}
