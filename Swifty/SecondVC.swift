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
    
    @IBOutlet weak var navigationName: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coalitionImageView: UIImageView!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var user: NSDictionary?
    var coalitions: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let student = Student(user: user!, coalitions: coalitions!)

        navigationName.title = student.displayname
        imageView.layer.cornerRadius = imageView.frame.width/4
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        if let url = URL(string: student.image_url!) {
            do {
                let data = try Data(contentsOf: url)
                imageView.image = UIImage(data: data)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        if student.coalition_name == "The Hive" {
            coalitionImageView.image = UIImage(named: "hive_back")
        } else if student.coalition_name == "The Empire" {
            coalitionImageView.image = UIImage(named: "empire_back")
        } else if student.coalition_name == "The Alliance" {
            coalitionImageView.image = UIImage(named: "alliance_back")
        } else if student.coalition_name == "The Union" {
            coalitionImageView.image = UIImage(named: "union_back")
        } else {
            coalitionImageView.image = UIImage(named: "42")
        }
        
        loginLabel.text = student.login
        if let email = student.email {
            emailLabel.text = "✉️: " + email
        }
        if let phone = student.phone {
            phoneLabel.text = "📞: " + phone
        }
        if let points = student.correctionPoints {
            correctionLabel.text = "Points: " + points
        }
        if let wallet = student.wallet {
            walletLabel.text = "Wallet: " + wallet
        }
        locationLabel.text = student.location
    }
    
}
