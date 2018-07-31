//
//  SecondVC.swift
//  Swifty
//
//  Created by Oleksii MIROSHNYK on 7/30/18.
//  Copyright © 2018 Oleksii MIROSHNYK. All rights reserved.
//

import Foundation
import UIKit

struct StudentStruct {
    
    var nickname: String?
    var name: String?
    var surname: String?
    var email: String?
    var phone: String?
    var level: Float?
    var wallet: Int?
    var correctionPoints: Int?
    var image: String?
}

class SecondVC: UIViewController {
    
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationName: UINavigationItem!
    
    var user: NSDictionary?
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let student = Student(user: user!, bearer: token!)
        let coalition = student.getCoalition()
        //parseUser()
        //getCoalition(userID: )
        
        //print(imageView.frame.width)
        //print(imageView.frame.width/4)
        imageView.layer.cornerRadius = imageView.frame.width/4
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        if let image_url = user?["image_url"] {
            if let url = URL(string: image_url as! String) {
                do {
                    let data = try Data(contentsOf: url)
                    imageView.image = UIImage(data: data)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        if let nav_name = user?["displayname"] as? String {
            navigationName.title = nav_name
        }
        
        
        
        //if let correction_point = user?["correction_point"] {
        //    print(correction_point)
        //    print(type(of: correction_point))
        //}

        //textView.text = "User login: \(self.user?["login"] ?? "No login")\nUser name: \(self.user?["first_name"] ?? "Empty")\nUser email: \(self.user?["email"] ?? "Empty")\nUser phone: \(self.user?["phone"] ?? "Empty")\nUser wallet: \(self.user?["wallet"] ?? "Empty")"
    }
    
    
    
}
