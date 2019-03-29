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
    var skills: [(String, String)] = []
    var projects: [(String, String)] = []
    
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
            if correctionPoints > 5 {
                self.correctionPoints = String(correctionPoints) + "♻"
            } else {
                self.correctionPoints = String(correctionPoints)
            }
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
            
            if let level = course["level"] as? Double {
                self.level = String(format: "%.2f", level)
            } else {
                self.level = "0.0"
            }
            
            if let skills = course["skills"] as? [NSDictionary] {
                
                for triplet in skills {
                    var tuples = ("", "")
                    if let name = triplet["name"] as? String {
                        tuples.0 = name
                    } else {
                        tuples.0 = "Empty"
                        print("Empty name!!")
                    }
                    if let level = triplet["level"] as? Double {
                        tuples.1 = String(format: "%.2f", level)
                    } else {
                        tuples.1 = "0.0"
                        print("Empty level!!")
                    }
                    self.skills.append(tuples)
                }
            }
        }
        
        
        if let projects = user["projects_users"] as? [NSDictionary] {
            for p in projects {
                var tuples = ("", "")
                var parent_id: Int? = nil
                var slug: String? = nil
                if let project = p["project"] as? NSDictionary {
                    if let name = project["name"] as? String {
                        tuples.0 = name
                    }
                    if let pid = project["parent_id"] as? Int {
                        parent_id = pid
                    }
                    if let s = project["slug"] as? String {
                        slug = s
                    }
                }
                if let mark = p["final_mark"] as? Int {
                    tuples.1 = String(mark)
                } else {
                    tuples.1 = "-"
                }
                
                if tuples.0 != "" && (parent_id == nil || parent_id == 61) {
                    if parent_id != 48 && parent_id != 62 {
                        if tuples.0 != "Rushes" && slug?.range(of: "piscine-c") == nil {
                            self.projects.append(tuples)
                        }
                    }
                }
            }
        }

        if coalitions.count != 0 {
            var coalition = NSDictionary()
            coalition = coalitions[0]
            if let coalition_name = coalition["name"] as? String {
                self.coalition_name = coalition_name
            }
        }
    }
    
    func returnSkillsForRadar() -> [(String, String)] {
        var ret : [(String, String)] = []
        for s in self.skills {
            if s.0 == "Object-oriented programming" {
                let tmp = s.0.replacingOccurrences(of: "-", with: "-\n", options: .literal, range: nil)
                ret.append((tmp.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil), s.1))
            }
            else {
                ret.append((s.0.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil), s.1))
            }
        }
        return ret
    }

    
}
