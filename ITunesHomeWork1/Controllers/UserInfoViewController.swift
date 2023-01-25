//
//  UserInfoViewController.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 14.01.2023.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var firstNameLabel:  UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var phoneLabel:      UILabel!
    @IBOutlet weak var emailLabel:      UILabel!
    @IBOutlet weak var ageLabel:        UILabel!
    @IBOutlet weak var passwordLabel:   UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setModel()
       
    }
    
    private func setModel() {
        guard let activeUser = DataBase.shared.activeUser else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: activeUser.age)
        
        firstNameLabel.text = activeUser.firstName
        secondNameLabel.text = activeUser.secondName
        phoneLabel.text = activeUser.phone
        emailLabel.text = activeUser.email
        ageLabel.text = dateString
        passwordLabel.text = activeUser.password
        
    }
   

}
