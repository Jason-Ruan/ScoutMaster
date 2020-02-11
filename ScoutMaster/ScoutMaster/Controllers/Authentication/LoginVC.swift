//
//  LoginVC.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginVC: UIViewController {

//    MARK: UI Objects
    
    lazy var emailTextField: UITextField = {
        let text = UITextField()
        text.text = "email"
        text.borderStyle = .line
        text.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return text
       }()
       
    lazy var passwordTextField: UITextField = {
        let passWord = UITextField()
        passWord.text = "password"
        passWord.borderStyle = .line
        passWord.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return passWord
       }()
    
    lazy var signInError: UILabel = {
        let errorLabel = UILabel()
        return errorLabel
    }()
    
    lazy var loginButton: UIButton = {
        let login = UIButton()
        login.backgroundColor = .white
        login.setTitleColor(.blue, for: .normal)
        login.setTitle("login", for: .normal)
        login.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
        return login
       }()
    
    lazy var signUpButton: UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .white
        signUp.setTitleColor(.blue, for: .normal)
        signUp.setTitle("sign up", for: .normal)
        signUp.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        return signUp
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        addSubViews()
        constraints()

    }
            
    private func addSubViews() {

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
    }
                
    private func constraints() {

        emailTextConstraint()
        passwordTextConstraint()
        signUpContraint()
        loginContraint()
    }
            
    private func emailTextConstraint() {
                
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        [ emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)].forEach{$0.isActive = true}

                
    }
                
    private func passwordTextConstraint() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        [passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 25),
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)].forEach{$0.isActive = true}
                    
    }
                
                
    private func signUpContraint() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        [signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75)].forEach{$0.isActive = true}
    }
            
    private func loginContraint() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        [loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -275)].forEach{$0.isActive = true}
    }
            
//    MARK: Objective C
            
            
    @objc func validateFields() {
        guard emailTextField.hasText, passwordTextField.hasText else {
            loginButton.backgroundColor = .darkGray
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = .darkGray
        }
            
               
    @objc func showSignUp() {
        let signupVC = SignUpVC()
        signupVC.modalPresentationStyle = .currentContext
                   present(signupVC, animated: true, completion: nil)
                
               }
               
            
    @objc func tryLogin() {
                   guard let email = emailTextField.text, let password = passwordTextField.text else {
                       showAlert(with: "Error", and: "Please fill out all fields.")
                       return
                   }
                   
                   //MARK: TODO - remove whitespace (if any) from email/password
                   
                   guard email.isValidEmail else {
                       showAlert(with: "Error", and: "Please enter a valid email")
                       return
                   }
                   
                   guard password.isValidPassword else {
                       showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
                       return
                   }
                   
                   FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
                       self.handleLoginResponse(with: result)
                   }
               }
            

            private func showAlert(with title: String, and message: String) {
                let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertVC, animated: true, completion: nil)
            }
            
            private func handleLoginResponse(with result: Result<(), Error>) {
                switch result {
                case .failure(let error):
                    showAlert(with: "Error", and: "Could not log in. Error: \(error)")
                case .success:
//                    showAlert(with: "Success", and: "User is logged in.")
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                        else {
                            return
                    }

                    UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                         let signupVC = MainTabBarViewController()
                         signupVC.modalPresentationStyle = .fullScreen
                         self.present(signupVC, animated: true, completion: nil)

                                }, completion: nil)
                }
            }
}
