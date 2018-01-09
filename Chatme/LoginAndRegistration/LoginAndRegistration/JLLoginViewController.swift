//
//  JLLoginViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class JLLoginViewController: JLLoginAndRegBaseViewController,JLLoginProtocol, JLRegisterProtocol {
    //login button init
    let loginButton: UIButton = {
        let tempLoginButton = UIButton(type: .custom)
        tempLoginButton.translatesAutoresizingMaskIntoConstraints = false
        tempLoginButton.setTitle(NSLocalizedString("Login", comment: "login button in login view controller"), for: .normal)
        tempLoginButton.setTitleColor(UIColor.darkGray, for: .normal)
        tempLoginButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        tempLoginButton.backgroundColor = UIColor.white
        tempLoginButton.layer.borderColor = UIColor.lightGray.cgColor
        tempLoginButton.layer.cornerRadius = 5.0
        tempLoginButton.clipsToBounds = true
        tempLoginButton.addTarget(self, action: #selector(JLLoginViewController.didLoginAction), for: .touchUpInside)
        return tempLoginButton
    }()
    
    //register button init
    let registerButton: UIButton = {
        let tempRegisterButton = UIButton(type: .custom)
        tempRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        
        // setup attributed text
        let attributedRegistrationTitle = NSAttributedString(string: "Not a member? Register an account.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                                                                                                                            NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        tempRegisterButton.setAttributedTitle(attributedRegistrationTitle, for: .normal)
        tempRegisterButton.addTarget(self, action: #selector(JLLoginViewController.didRegisterAction), for: .touchUpInside)
        return tempRegisterButton
    }()
    
    // initialize the login manager
    lazy var loginManager: JLLoginManager = {
       let tempLoginManager = JLLoginManager()
        return tempLoginManager
    }()
    
    // initializer method for loginViewController
    init (){
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("de init JLLoginViewController")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()

        contentView.addSubview(loginButton)
        contentView.addSubview(registerButton)
        
        self.setupConstraints() // call the setup constraints
    }
    
    
    private func setupConstraints() {
        
        // login button constraints
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-80-[loginButton]-80-|", options: [], metrics: nil, views: ["loginButton": loginButton]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[passwordTextfield]-50-[loginButton(==50)]", options: [], metrics: nil, views: ["passwordTextfield": passwordTextfield, "loginButton": loginButton]))
        
        // registration button constraints
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[registerButton]-50-|", options: [], metrics: nil, views: ["registerButton": registerButton]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[loginButton]-5-[registrationButton(==40)]", options: [], metrics: nil, views: ["loginButton": loginButton, "registrationButton": registerButton]))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerHeaderLabel.text = NSLocalizedString("Welcome!", comment: "Login welcome header") // override the template and add a more welcoming text
        self.navigationController?.setNavigationBarHidden(true, animated: false) // no need to show the navigationItemBar
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ACTIONS
    
    // login action call
    func didLoginAction() {
        // force dismiss keyboard to get all the values
         self.view.endEditing(true)
       
        // initialize the completion block of loginManager
        loginManager.completion = {[weak self] (data, error) in
            
            guard error == nil else {
                let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Encountered an error"), message: error?.localizedDescription, preferredStyle: .alert)
                let errorAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok for alert cancel button"), style: .cancel, handler: nil)
                errorAlertController.addAction(errorAction)
                self?.present(errorAlertController, animated: true, completion: nil)
                return
            }
            
            if let complete = self?.completionBlock {
                complete?(data, nil)
            }
        }

        loginManager.update(emailAddress: emailAddressTextfield.text, password: passwordTextfield.text)
        //login
        loginManager.loginRequest()
    }
    
    // register action call
    func didRegisterAction() {
        // present the registration viewController
        let registrationViewController = JLRegistrationViewController(withCompletion: completionBlock)
        // put the registrationController on a navigationController
        let registrationNavigationController = UINavigationController(rootViewController: registrationViewController)
        self.navigationController?.present(registrationNavigationController, animated: true, completion: nil)
    }
    
}
