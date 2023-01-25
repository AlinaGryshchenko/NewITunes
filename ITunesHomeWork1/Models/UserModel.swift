//
//  UserModel.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 10.01.2023.
//

import Foundation

struct User: Codable {
    
    let firstName:  String
    let secondName: String
    let phone:      String
    let email:      String
    let password:   String
    let age:        Date
    
}
