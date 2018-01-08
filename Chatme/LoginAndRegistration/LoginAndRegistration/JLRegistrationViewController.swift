//
//  JLRegistrationViewController.swift
//  Chatme
//
//  Created by Joshua on 8/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class JLRegistrationViewController: JLBaseViewController {
    
    init() { // default initializer
        super.init(nibName: nil, bundle: nil)
    }
    
    init(withCompletion completion: completionBlock?) { // initialize with a completion block
        super.init(nibName: nil, bundle: nil)
        registrationManager.completion = {[weak self](data, error) in
            guard error == nil else {
                var errorAlertController: UIAlertController
                var errorAction: UIAlertAction
                if error is RegistrationError {
                    let regError = error as? RegistrationError
                     errorAlertController = UIAlertController(title: regError?.errorTitle, message: regError?.errorDescription, preferredStyle: .alert)
                     errorAction = UIAlertAction(title: regError?.errorCancelButtonTitle, style: .cancel, handler: nil)
   
                } else {// error is a regular error object
                    errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Encountered an error"), message: error?.localizedDescription, preferredStyle: .alert)
                    errorAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok for alert cancel button"), style: .cancel, handler: nil)
                }
                
                errorAlertController.addAction(errorAction)
                self?.present(errorAlertController, animated: true, completion: nil)
                print("encountered an error during registration")
                return
            }
            // proceed to call the registered completion
            if let complete = completion {
                complete?(data, nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var registrationManager: JLRegistrationManager = {
        var tempRegistrationManager = JLRegistrationManager()
        return tempRegistrationManager
    }()
    
    deinit {
        print("de init JLRegistrationViewController")
    }
    
    
    //close button init
    let backButton: UIButton = {
        let tempBackButton = UIButton(type: .custom)
        tempBackButton.translatesAutoresizingMaskIntoConstraints = false
        tempBackButton.setTitle(NSLocalizedString("Back", comment: "registration close button"), for: .normal)
        tempBackButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        tempBackButton.setTitleColor(UIColor.white, for: .normal)
        tempBackButton.addTarget(self, action: #selector(JLRegistrationViewController.backAction), for: .touchUpInside)
        return tempBackButton
    }()
    
    //password textfield init
    let confirmPasswordTextfield: UITextField = {
        let tempConfirmPasswordTextfield = UITextField()
        tempConfirmPasswordTextfield.translatesAutoresizingMaskIntoConstraints = false
        tempConfirmPasswordTextfield.attributedPlaceholder = NSAttributedString(string:  NSLocalizedString("Confirm Password", comment: "confirm password textfield placeholder"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tempConfirmPasswordTextfield.textColor = .white
        tempConfirmPasswordTextfield.isSecureTextEntry = true
        // add a bottom border via layer
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 49, width:(UIScreen.main.bounds.width-100), height: 0.5)
        bottomLine.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
        tempConfirmPasswordTextfield.borderStyle = UITextBorderStyle.none
        tempConfirmPasswordTextfield.layer.addSublayer(bottomLine)
        return tempConfirmPasswordTextfield
    }()
    
    // register button init
    let registerButton: UIButton = {
        let tempRegisterButton = UIButton(type: .custom)
        tempRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        tempRegisterButton.setTitle(NSLocalizedString("Register", comment: "register button in registration Screen"), for: .normal)
        tempRegisterButton.setTitleColor(UIColor.darkGray, for: .normal)
        tempRegisterButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        tempRegisterButton.backgroundColor = UIColor.white
        tempRegisterButton.layer.borderColor = UIColor.lightGray.cgColor
        tempRegisterButton.layer.cornerRadius = 5.0
        tempRegisterButton.clipsToBounds = true
        tempRegisterButton.addTarget(self, action: #selector(JLRegistrationViewController.registerAction), for: .touchUpInside)
        return tempRegisterButton
    }()

    override func loadView() {
        super.loadView()
        contentView.addSubview(backButton)
        contentView.addSubview(confirmPasswordTextfield)
        contentView.addSubview(registerButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        //cancel button constraint
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[backButton(==80)]", options: [], metrics: nil, views: ["backButton": backButton]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[backButton(==50)]", options: [], metrics: nil, views: ["backButton": backButton]))
        
        // confirm password constraint
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[confirmPasswordTextfield]-50-|", options: [], metrics: nil, views: ["confirmPasswordTextfield": confirmPasswordTextfield]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[passwordTextfield]-20-[confirmPasswordTextfield(==50)]", options: [], metrics: nil, views: ["passwordTextfield": passwordTextfield, "confirmPasswordTextfield": confirmPasswordTextfield]))
        
        //register button constraints
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-80-[registerButton]-80-|", options: [], metrics: nil, views: ["registerButton": registerButton]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[confirmPasswordTextfield]-30-[registerButton(==50)]", options: [], metrics: nil, views: ["confirmPasswordTextfield": confirmPasswordTextfield, "registerButton": registerButton]))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        self.navigationController?.setNavigationBarHidden(true, animated: false) // no need to show the navigation bar
        viewControllerHeaderLabel.text = NSLocalizedString("Almost there!", comment: "registration header")
        // Do any additional setup after loading the view.
    }

    
    //MARK: Action Calls
    
    // triggers when back button is pressed
    @objc func backAction () {
        self.dismiss(animated: true, completion: nil)
    }
    
    // triggers when register button is pressed
    @objc func registerAction () {
        
        // force close keyboard
       
        // update the values
        registrationManager.update(email: emailAddressTextfield.text, password: passwordTextfield.text, confirmPassword: confirmPasswordTextfield.text)
        // validate input
        registrationManager.registerAccountRequest() // begin registration
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
