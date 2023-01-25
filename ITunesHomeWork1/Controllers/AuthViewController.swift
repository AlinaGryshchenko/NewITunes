//
//  AuthViewController.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 22.12.2022.
//

import UIKit

class AuthViewController: UIViewController {

    //MARK: - IBOUTLET
    @IBOutlet weak var loginLabel:        UILabel!
    @IBOutlet weak var emailTextField:    UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton:      UIButton!
    @IBOutlet weak var signInButton:      UIButton!
    @IBOutlet weak var scrollView:        UIScrollView!
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

       createButtons()
       setupDelegate()
       registerKeyboardNotification()
        
        
    }
    
    //MARK: - ACTION
    @IBAction func singUpButtonTapped(_ sender: UIButton) {
    signUpButtonAction()
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    signInButtonAction()
    }
    
    //MARK: - FUNCTION
    private func createButtons() {
        signInButton.layer.cornerRadius = 10
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func signUpButtonAction() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signInButtonAction() {
//        let mail = emailTextField.text ?? ""
//        let password = passwordTextField.text ?? ""
//        let user = findUserDataBase(mail: mail)
//
//        if user == nil {
//            loginLabel.text = "user not found"
//        }else if user?.password == password {
//            loginLabel.text = "Login"
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AlbumsViewController") as! AlbumsViewController
            navigationController?.pushViewController(vc, animated: true)
                 
//            guard let activeUser = user else {return}
//            DataBase.shared.saveActiveUser(user: activeUser)
//        }else{
//            loginLabel.text = "Wrong password"
//        }
        
    }
    
    private func setupDelegate() {
        emailTextField.delegate    = self
        passwordTextField.delegate = self
    }
    
    private func findUserDataBase(mail: String) -> User? {
        let dataBase = DataBase.shared.users
        print(dataBase)
        
        for user in dataBase {
            if user.email == mail {
                 return user
            }
        }
        return nil
    }
    
}
    
//MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
//MARK: - Keyboard hide show
extension AuthViewController {
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
  
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
        
    }
}
