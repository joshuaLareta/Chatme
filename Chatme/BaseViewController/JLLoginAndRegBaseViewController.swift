//
//  JLLoginAndRegBaseViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit


@objc protocol JLLoginProtocol {
   func didLoginAction()
}

@objc protocol JLRegisterProtocol {
      func didRegisterAction()
}

class JLLoginAndRegBaseViewController: UIViewController {
    
    // completion block property
    var completionBlock: CompletionBlock?

    /*
         Will be the view after the mainView this is the parent of the contentView.
         Need to make the contentView scroll whenever it is being hidden by the keyboard
     */
    lazy var mainScrollingView: UIScrollView = {
       let tempMainScrollingView = UIScrollView()
        tempMainScrollingView.translatesAutoresizingMaskIntoConstraints = false
        return tempMainScrollingView
    }()
    
    /*
     ContentView will hold the content of its child controller
     */
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    //emailAddressTextField init
    let emailAddressTextfield: UITextField = {
        let tempEmailAddressTextField = UITextField()
        tempEmailAddressTextField.translatesAutoresizingMaskIntoConstraints = false
        tempEmailAddressTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Email Address", comment: "email Address textfield placeholder"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tempEmailAddressTextField.textColor = .white
        tempEmailAddressTextField.autocorrectionType = .no
        tempEmailAddressTextField.autocapitalizationType = .none
        // add a bottom border via layer
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 49, width:(UIScreen.main.bounds.width-100), height: 0.5)
        bottomLine.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
        tempEmailAddressTextField.borderStyle = UITextBorderStyle.none
        tempEmailAddressTextField.layer.addSublayer(bottomLine)
        return tempEmailAddressTextField
    }()
    
    //password textfield init
    let passwordTextfield: UITextField = {
        let tempPasswordTextfield = UITextField()
        tempPasswordTextfield.translatesAutoresizingMaskIntoConstraints = false
        tempPasswordTextfield.attributedPlaceholder = NSAttributedString(string:  NSLocalizedString("Password", comment: "password textfield placeholder"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tempPasswordTextfield.textColor = .white
        tempPasswordTextfield.isSecureTextEntry = true
        // add a bottom border via layer
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 49, width:(UIScreen.main.bounds.width-100), height: 0.5)
        bottomLine.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
        tempPasswordTextfield.borderStyle = UITextBorderStyle.none
        tempPasswordTextfield.layer.addSublayer(bottomLine)
        return tempPasswordTextfield
    }()

    
    let viewControllerHeaderLabel: UILabel = {
        let tempHeaderLabel = UILabel()
        tempHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tempHeaderLabel.textColor = .white
        tempHeaderLabel.font = UIFont.boldSystemFont(ofSize: 40)
        tempHeaderLabel.textAlignment = .center
        tempHeaderLabel.text = NSLocalizedString("Templated header label!", comment: "HeaderLabel.")
        return tempHeaderLabel
    }()
    

    // bottom gap constraint
    var scrollingViewBottomGapConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override func loadView() {
        super.loadView()
        mainScrollingView.addSubview(contentView)
        contentView.addSubview(viewControllerHeaderLabel)
        contentView.addSubview(emailAddressTextfield)
        contentView.addSubview(passwordTextfield)
        view.addSubview(mainScrollingView)
        setupConstraints()
    }

    // setup the constraints for the base controller
    private func setupConstraints() {
        
        // mainScrollingView constraints
        // flushed to both sides as well as top of the entire screen, the bottom constraint will be different to adjust the main screen if being blocked by keyboard
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainScrollingView]|", options: [], metrics: nil, views: ["mainScrollingView": mainScrollingView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainScrollingView]", options: [], metrics: nil, views: ["mainScrollingView": mainScrollingView]))
        // add a constraint to the bottom of mainScrollingView and the bottom of the view with a constant of 0
        scrollingViewBottomGapConstraint = NSLayoutConstraint(item: mainScrollingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(scrollingViewBottomGapConstraint)
        
        // contentView Constraints
        // contentView is under the mainScrollingView and the constraints needs to be tied up to its super view
        mainScrollingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: ["contentView": contentView]))
        mainScrollingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: ["contentView": contentView]))
        
        // add a default height and width for the contentView, which is supposed to be the entire screen for now
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[contentView(==view)]", options: [], metrics: nil, views: ["contentView": contentView, "view": view]))
        mainScrollingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[contentView(==mainScrollingView)]", options: [], metrics: nil, views: ["contentView": contentView, "mainScrollingView": mainScrollingView]))
        
        //welcome label constraints
        //add a 50 trailing and leading constraints
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[headerLabel]-50-|", options: [], metrics: nil, views: ["headerLabel": viewControllerHeaderLabel]))
        // add a default height to the welcome label
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerLabel(==50)]", options: [], metrics: nil, views: ["headerLabel": viewControllerHeaderLabel]))
        // center the welcome label based on the entire screen - a bit of adjustment so it will be a bit off center
        contentView.addConstraint(NSLayoutConstraint(item: viewControllerHeaderLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: -(UIScreen.main.bounds.size.height/4)-25))
        
        // username textfield constraints
        // leading and trailing constraints
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[emailAddressTextField]-50-|", options: [], metrics: nil, views: ["emailAddressTextField": emailAddressTextfield]))
        // only add the top margin and height of the textfield
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[welcomeLabel]-30-[emailAddressTextField(==50)]", options: [], metrics: nil, views: ["welcomeLabel": viewControllerHeaderLabel,
                                                                                                                                                                        "emailAddressTextField": emailAddressTextfield]))
        
        // password textfield constraints
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[passwordTextfield]-50-|", options: [], metrics: nil, views: ["passwordTextfield": passwordTextfield]))
        // password textfield should be 20 px vertically away from username textfield
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[emailAddressTextField]-20-[passwordTextfield(==50)]", options: [], metrics: nil, views: ["passwordTextfield": passwordTextfield,
                                                                                                                                                                             "emailAddressTextField": emailAddressTextfield]))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // register for keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(JLLoginAndRegBaseViewController.keyboardDidShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JLLoginAndRegBaseViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //add tap gesture for closing of keyboard when user tap's main screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JLLoginAndRegBaseViewController.tapGestureOnMainScreenToCloseKeyboard))
        self.view.addGestureRecognizer(tapGesture) // add it to the main view to be able to be triggered
    }
    
    
    @objc func tapGestureOnMainScreenToCloseKeyboard() {
        // force close keyboard
        self.view.endEditing(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove notification here, before the view actually disappears to be able to handle it properly
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardDidShow(_ notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollingViewBottomGapConstraint.constant = -(keyboardSize.height)
            UIView.animate(withDuration: 0.4) {
                let contentOffset = CGPoint(x: 0, y: 10)
                self.mainScrollingView.setContentOffset(contentOffset, animated: false)
                self.view.layoutIfNeeded()
            }
            
        } else {
            print("something went wrong and didn't managed to get any keyboardSize")
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        scrollingViewBottomGapConstraint.constant = 0 // just assign 0 to the constraint's constant
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
