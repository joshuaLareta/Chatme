//
//  JLChatConversationTableViewCell.swift
//  Chatme
//
//  Created by Joshua on 11/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

protocol ConversationCellProtocol {
    func message(_ message: String)
}


// your style
class JLChatConversationBaseTableViewCell: UITableViewCell,ConversationCellProtocol {
    
    var containerView: UIView =  {
        let tempContainerView = UIView()
        tempContainerView.translatesAutoresizingMaskIntoConstraints = false
        tempContainerView.backgroundColor = .black
        tempContainerView.layer.cornerRadius = 10
        tempContainerView.clipsToBounds = true
        return tempContainerView
    }()
    
    var messageContainer: UILabel = {
        let tempMessageContainer = UILabel()
        tempMessageContainer.translatesAutoresizingMaskIntoConstraints = false
        tempMessageContainer.numberOfLines = 0
        tempMessageContainer.lineBreakMode = .byWordWrapping
        tempMessageContainer.textAlignment = .justified
        tempMessageContainer.textColor = .white
        return tempMessageContainer
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("using this")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        containerView.addSubview(messageContainer)
        self.contentView.addSubview(containerView)
        self.selectionStyle = .none
        setupContraints()
    }
    
    func setupContraints() {
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[messageContainer]-10-|", options: [], metrics: nil, views: ["messageContainer": messageContainer]))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[messageContainer]-5-|", options: [], metrics: nil, views: ["messageContainer": messageContainer]))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func message(_ message: String) {
        messageContainer.text = message
    }
}


// his style
class JLChatConversationHisTableViewCell: JLChatConversationBaseTableViewCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("using this")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        containerView.backgroundColor = UIColor.init(red: 50.0/255.0, green: 205.0/255.0, blue: 50.0/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setupContraints() {
        super.setupContraints()
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[containerView(>=5@999)]->=80-|", options: [], metrics: nil, views: ["containerView": containerView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[containerView(>=50@999)]-5-|", options: [], metrics: nil, views: ["containerView": containerView]))
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func message(_ message: String) {
        super.message(message)
    }
}

// your style
class JLChatConversationYourTableViewCell: JLChatConversationBaseTableViewCell {
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("using this")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        containerView.backgroundColor = UIColor.init(red: 30.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setupContraints() {
        super.setupContraints()
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=80-[containerView(>=5@999)]-10-|", options: [], metrics: nil, views: ["containerView": containerView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[containerView(>=50@999)]-5-|", options: [], metrics: nil, views: ["containerView": containerView]))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func message(_ message: String) {
        super.message(message)
    }
}
