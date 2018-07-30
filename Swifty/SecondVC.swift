//
//  SecondVC.swift
//  Swifty
//
//  Created by Oleksii MIROSHNYK on 7/30/18.
//  Copyright © 2018 Oleksii MIROSHNYK. All rights reserved.
//

import Foundation
import UIKit

class SecondVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var user: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "User login: \(self.user?["login"] ?? "No login")\nUser name: \(self.user?["first_name"] ?? "Empty")\nUser email: \(self.user?["email"] ?? "Empty")\nUser phone: \(self.user?["phone"] ?? "Empty")\nUser wallet: \(self.user?["wallet"] ?? "Empty")"
    }
    
}
