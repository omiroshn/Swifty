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
    var image: String?
    var email: String?
    var phone: String?
    var bearer: String!
    
    private var user_id: Int?
    var coalitions: [NSDictionary]?
    
    //var wallet: Int?
    //var correctionPoints: Int?
    //var level: Float?
    
    init(user: NSDictionary, bearer: String) {
        
        self.bearer = bearer
        if let displayname = user["displayname"] as? String {
            self.displayname = displayname
        }
        if let image = user["image_url"] as? String {
            self.image = image
        }
        if let email = user["email"] as? String {
            self.email = email
        }
        if let phone = user["phone"] as? String {
            self.phone = phone
        }
        
        if let campus_users = user["campus_users"] as? [NSDictionary] {
            if let user_id = campus_users[0]["user_id"] as? Int {
                self.user_id = user_id
            }
        }
        
        if let cursus_users = user["cursus_users"] as? [NSDictionary] {
            var course = NSDictionary()
            for cursus in cursus_users {
                if (cursus.value(forKey: "cursus_id") as? Int) == 1 {
                    course = cursus
                }
            }
            if let user = course["user"] as? NSDictionary {
                if let login = user["login"] as? String {
                    self.login = login
                }
            }
        }
        DispatchQueue.main.async {
            self.setCoalition { (coalitions, error) in
                self.coalitions = coalitions
                print(self.coalitions)
                print(type(of: self.coalitions))
            }
            print(self.coalitions)
            print(type(of: self.coalitions))
        }
    }
    
    func setCoalition(completionHandler:@escaping ([NSDictionary]?, Error?)->Void)  {
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/" + String(self.user_id!) + "/coalitions") else { return }
        let bearer = "Bearer " + self.bearer
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearer, forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in

            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] {
                    completionHandler(array, nil)
                }
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    func getCoalition() -> NSDictionary {
        var coalition = NSDictionary()
        for c in self.coalitions! {
            if (c.value(forKey: "user_id") as? Int) == self.user_id {
                coalition = c
            }
        }
        print(coalition)
        print(type(of: coalition))
        return coalition
    }
}
