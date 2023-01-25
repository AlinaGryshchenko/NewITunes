//
//  ViewController.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 20.12.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: - IBOUTLET
    @IBOutlet weak var firstNameTextField:   UITextField!
    @IBOutlet weak var secondNameTextField:  UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField:       UITextField!
    @IBOutlet weak var passwordTextField:    UITextField!
    @IBOutlet weak var ageTextField:         UITextField!
    @IBOutlet weak var firstNameValidLabel:  UILabel!
    @IBOutlet weak var secondNameValidLabel: UILabel!
    @IBOutlet weak var phoneValidLabel:      UILabel!
    @IBOutlet weak var emailValidLabel:      UILabel!
    @IBOutlet weak var ageValidLabel:        UILabel!
    @IBOutlet weak var passwordValidLabel:   UILabel!
    @IBOutlet weak var signUpButton:         UIButton!
    @IBOutlet weak var scrollView:           UIScrollView!
    @IBOutlet weak var loginLabel:           UILabel!
    
    private let datePicker = UIDatePicker()
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
  
        createButtons()
        createDatePicker()
        setupDelegate()
        registerKeyboardNotification()
    }

    deinit {
       removeKeyboardNotification()
    }
    
    //MARK: - Delegate
        private func setupDelegate() {
            firstNameTextField.delegate    = self
            secondNameTextField.delegate   = self
            emailTextField.delegate        = self
            phoneNumberTextField.delegate  = self
            passwordTextField.delegate     = self
        }
    
    //MARK: - CREATE BUTTON
    private func createButtons() {
        signUpButton.layer.cornerRadius = 20
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - CREATE DATE PICKER
    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        ageTextField.inputView = datePicker
        ageTextField.inputAccessoryView = createToolBar()
    }
    
    private func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        toolbar.setItems([doneButton, space, cancelButton], animated: true)
        return toolbar
    }
    
    @objc func doneButton() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.ageTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
   
    @objc func cancelButton() {
        self.view.endEditing(true)
    }
    
    //MARK: - FUNCTION
    @objc private func signUpButtonTapped() {

        let firstNameText = firstNameTextField.text ?? ""
        let secondNameText = secondNameTextField.text ?? ""
        let emailNameText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneNumberTextField.text ?? ""

        if firstNameText.isValid(validType: nameValidType)
            && secondNameText.isValid(validType: nameValidType)
            && emailNameText.isValid(validType: emailValidType)
            && passwordText.isValid(validType: passwordValidType)
            && phoneText.count == 19
            && ageIsValid() == true {
            
            DataBase.shared.saveUser(firstName: firstNameText,
                                     secondName: secondNameText,
                                     phone: phoneText,
                                     email: emailNameText,
                                     password: passwordText,
                                     age: datePicker.date)
            loginLabel.text = "Registration complete"
        }else{
            loginLabel.text = "Registration"
            alertOk(title: "Error", massage: "Fill in all the filds and you age must be 18+ y.e.")
        }
    }
    
    
    private func setTextField(textField: UITextField, label: UILabel, validType: String.ValidTypes, valideMassage: String, wrongMassage: String, string: String, range: NSRange)
    {
        if string.isValid(validType: nameValidType) {
            print("+")
        }else{
            print("-")
        }
        // не понятно!!!           
        let text = (textField.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        }else{
            result = text
        }
        
        textField.text = result
        
        if result.isValid(validType: validType) {
            label.text = valideMassage
            label.textColor = .green
        }else{
            label.text = wrongMassage
            label.textColor = .red
        }
    }
    
    private func setPhoneNumberMask(textField: UITextField, mask: String, string: String, range: NSRange) -> String {

        let text = textField.text ?? ""
        
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex

        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            }else{
                result.append(character)
            }
        }

        if result.count == 19 {
            phoneValidLabel.text = "Phone number is valid"
            phoneValidLabel.textColor = .green
        }else{
            phoneValidLabel.text = "Phone number is not valid"
            phoneValidLabel.textColor = .red
        }
        return result
    }
    
    private func ageIsValid() -> Bool {
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthday = datePicker.date
        
        let age = calendar.dateComponents([.year], from: birthday, to: dateNow)
        let ageYear = age.year
        guard let ageUser = ageYear else {return false}
        return (ageUser < 18 ? false : true)
    }
    
    //MARK: - ACTION
     @IBAction func signUpButtonAction(_ sender: UIButton) {
        signUpButtonTapped()
    }
}



//MARK: - Extension
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField: setTextField(textField: firstNameTextField,
                                              label: firstNameValidLabel,
                                              validType: nameValidType,
                                              valideMassage: "Name is valid",
                                              wrongMassage: "Only A-Z character",
                                              string: string,
                                              range: range)
        case secondNameTextField: setTextField(textField: secondNameTextField,
                                              label: secondNameValidLabel,
                                              validType: nameValidType,
                                              valideMassage: "Name is valid",
                                              wrongMassage: "Only A-Z character",
                                              string: string,
                                              range: range)
        case emailTextField: setTextField(textField: emailTextField,
                                              label: emailValidLabel,
                                              validType: emailValidType,
                                              valideMassage: "Email is valid",
                                              wrongMassage: "Email is not valid",
                                              string: string,
                                              range: range)
        case passwordTextField: setTextField(textField: passwordTextField,
                                             label: passwordValidLabel,
                                             validType: passwordValidType,
                                             valideMassage: "Password is valid",
                                             wrongMassage: "Password is not valid",
                                             string: string,
                                             range: range)
        case phoneNumberTextField: phoneNumberTextField.text = setPhoneNumberMask(textField: phoneNumberTextField, mask: "+XX (XXX) XXX-XX-XX", string: string, range: range)
            
        default:
            break
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
}

//MARK: - Keyboard hide show
extension SignUpViewController {
    
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

