//
//  AlertOk.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 11.01.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertOk(title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
        
    }
    
}

