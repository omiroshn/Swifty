//
//  Student.swift
//  Swifty
//
//  Created by Oleksii MIROSHNYK on 7/31/18.
//  Copyright © 2018 Oleksii MIROSHNYK. All rights reserved.
//

import Foundation

class Student {
    
    var login: String?
    var displayname: String?
    var image_url: String?
    var coalition_name: String?
    var email: String?
    var phone: String?
    var location: String?
    var wallet: String?
    var correctionPoints: String?
    var level: String?
    var isStaff: Bool?
    var skills: [(String, String)]?
    
    init(user: NSDictionary, coalitions: [NSDictionary]) {
        
        if let displayname = user["displayname"] as? String {
            self.displayname = displayname
        }
        if let image = user["image_url"] as? String {
            self.image_url = image
        }
        if let email = user["email"] as? String {
            self.email = email
        } else {
            self.email = ""
        }
        if let phone = user["phone"] as? String {
            self.phone = phone
        } else {
            self.phone = ""
        }
        if let location = user["location"] as? String {
            self.location = "Avaliable: " + location
        } else {
            self.location = "Unavaliable"
        }
        if let wallet = user["wallet"] as? Int {
            self.wallet = String(wallet) + "₳"
        }
        if let correctionPoints = user["correction_point"] as? Int {
            self.correctionPoints = String(correctionPoints)
        }
        if let staff = user["staff?"] as? Bool {
            self.isStaff = staff
        }
        
        if let cursus_users = user["cursus_users"] as? [NSDictionary] {
            var mainCourse = false
            var course = NSDictionary()
            for cursus in cursus_users {
                if (cursus.value(forKey: "cursus_id") as? Int) == 1 {
                    course = cursus
                    mainCourse = true
                } else if mainCourse == false {
                    course = cursus
                }
            }
            if let user = course["user"] as? NSDictionary {
                if let login = user["login"] as? String {
                    self.login = login
                }
            }
            
            if let level = course["level"] as? Float {
                self.level = String(format: "%.2f", level)
            } else {
                self.level = "0.0"
            }
            
            /*if let skills = course["skills"] as? [NSDictionary] {
                for s in skills {
                    var tuples = ("", "")
                    if let name = s["name"] as? String {
                        tuples.0 = name
                    }
                    if let level = s["level"] as? Float {
                        tuples.1 = String(format: "%.2f", level)
                    }
                    self.skills?.append(tuples)
                }
            }
            print(self.skills)*/
        }

        if coalitions.count != 0 {
            var coalition = NSDictionary()
            coalition = coalitions[0]
            if let coalition_name = coalition["name"] as? String {
                self.coalition_name = coalition_name
            }
        }
        
        
    }
    
}
