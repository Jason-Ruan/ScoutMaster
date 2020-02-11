//
//  SignUpVC.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 2/3/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {

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
    
    lazy var cancelButton: UIButton = {
        let login = UIButton()
        login.setTitle("cancel", for: .normal)
        login.addTarget(self, action: #selector(cancelSignUp), for: .touchUpInside)
        return login
    }()
    
    lazy var signInError: UILabel = {
        let errorLabel = UILabel()
        return errorLabel
    }()
    
    lazy var signUpButton: UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .blue
        signUp.setTitle("sign up", for: .normal)
        signUp.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        return signUp
    }()
    
    lazy var defaultImage: UIImageView = {
    let defaultImage = UIImageView()
        defaultImage.image = UIImage(named: "defaultpicture")
        return defaultImage
    }()
    
// MARK: ObjectiveC
    
        @objc func validateFields() {
              guard emailTextField.hasText, passwordTextField.hasText else {
                signUpButton.backgroundColor = .darkGray
                  signUpButton.isEnabled = false
                  return
              }
              signUpButton.isEnabled = true
        signUpButton.backgroundColor = .darkGray
          }
        
        @objc func trySignUp() {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                showAlert(with: "Error", and: "Please fill out all fields.")
                return
            }
            
            guard email.isValidEmail else {
                showAlert(with: "Error", and: "Please enter a valid email")
                return
            }
            
            guard password.isValidPassword else {
                showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
                return
            }
            
            FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
                self?.handleCreateAccountResponse(with: result)
            }
        }
    
    @objc func cancelSignUp() {
        dismiss(animated: true, completion: nil)
    }
        
    
   // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        addSubViews()
        constraints()
        // Do any additional setup after loading the view.
    }
    
// MARK: -- Constraints, SubViews
        
        private func setDelegates() {
            
        }
        
        private func addSubViews() {
            view.addSubview(emailTextField)
    //        view.addSubview(defaultImage)
            view.addSubview(passwordTextField)
            view.addSubview(signUpButton)
            view.addSubview(cancelButton)
            
        }
        
        private func constraints() {
            emailTextConstraint()
    //        defaultImageConstraint()
            passwordTextConstraint()
            signInConstraint()
            cancelConstraint()
            
        }
        
    //    private func usernameConstraint() {
    //
    //    }
        
        private func defaultImageConstraint() {
            defaultImage.translatesAutoresizingMaskIntoConstraints = false
            [defaultImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
             defaultImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
             defaultImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
             defaultImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant:  300)].forEach{$0.isActive = true}
        }
        
        private func emailTextConstraint() {
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            [emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
        
        
        private func signInConstraint() {
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            [signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
                 signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
                 signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)].forEach{$0.isActive = true}
        }
    
    private func cancelConstraint() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        [cancelButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -275)].forEach{$0.isActive = true}
    }
    
// MARK: Private Funcs
    
        private func showAlert(with title: String, and message: String) {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
        
        
        private func handleCreateAccountResponse(with result: Result<User, Error>) {
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let user):
                    FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                        
    //                    self?.showAlert(with: "Congrats!", and: "You've Joined this App")
                    self?.handleCreatedUserInFirestore(result: newResult)
                    }
                case .failure(let error):
                    self?.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
                }
            }
        }
        
        private func handleCreatedUserInFirestore(result: Result<(), Error>) {
            switch result {
            case .success:
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
            case .failure(let error):
                self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
            }
        }


        
        
       
   
}
