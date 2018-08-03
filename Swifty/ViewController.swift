//
//  ViewController.swift
//  Swifty
//
//  Created by Oleksii MIROSHNYK on 7/24/18.
//  Copyright © 2018 Oleksii MIROSHNYK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let uid = "b45b4dfbed422177c9877185d4b9103d3a10eef5a4e8adb0d55aa1c58e350e18"
    let secret = "1acb18d21559f4bf503bd77e2a6ddf620aefe3c5c08c6e0ea7a679f0ed390674"
    var token: Token?
    var user: NSDictionary?
    var coalitions: [NSDictionary]?
    var user_id: Int?
    var effect: UIVisualEffect!
    
    struct Token: Codable {
        var access_token: String?
        var created_at: Int?
        var expires_in: Int?
        var scope: String?
        var token_type: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginField.delegate = self
        loginField.autocorrectionType = .no
        
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        self.view.sendSubview(toBack: VisualEffectView)
        errorView.layer.cornerRadius = 5
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    }
    
    func getToken(completionHandler:@escaping (Token?, Error?)->Void) {
        
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else { return }
        let parameters = "grant_type=client_credentials&client_id=" + uid + "&client_secret=" + secret
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                completionHandler(token, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    @IBAction func getTapped(_ sender: UIButton) {
        
        let login = loginField.text!
        if login != "", login != "me" {
            DispatchQueue.main.async {
                self.startActivityIndicator()
            }
            getToken(completionHandler: { (token, error) in
                self.token = token
                self.makeRequest(login: login) { (json, error) in
                    if json != nil && json!["login"] != nil {
                        self.user = json
                        self.getCoalition(completionHandler: { (coalition, error) in
                            self.coalitions = coalition
                            DispatchQueue.main.async {
                                self.stopActivityIndicator()
                                self.performSegue(withIdentifier: "SecondVC", sender: self)
                            }
                        })
                    } else {
                        DispatchQueue.main.async {
                            self.stopActivityIndicator()
                            self.loginField.text = ""
                            self.animatePopUp()
                        }
                    }
                }
            })
        } else {
            self.animatePopUp()
        }
    }
    
    func makeRequest(login: String, completionHandler:@escaping (NSDictionary?, Error?)->Void) {
        
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/" + login) else { return }
        let bearer = "Bearer " + (self.token?.access_token)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let user = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                completionHandler(user, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    func getCoalition(completionHandler:@escaping ([NSDictionary]?, Error?)->Void)  {
        
        if let campus_users = self.user?["campus_users"] as? [NSDictionary] {
            if let user_id = campus_users[0]["user_id"] as? Int {
                self.user_id = user_id
            }
        }
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/" + String(self.user_id!) + "/coalitions") else { return }
        let bearer = "Bearer " + (self.token?.access_token)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let array = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
                completionHandler(array, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }

    func startActivityIndicator() {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func animatePopUp() {
        self.loginField.resignFirstResponder()
        self.view.bringSubview(toFront: VisualEffectView)
        self.view.addSubview(errorView)
        
        errorView.center = self.view.center
        errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.effect = self.effect
            self.errorView.alpha = 1
            self.errorView.transform = CGAffineTransform.identity
        }
    }
    
    func animatePopOut() {
        self.view.sendSubview(toBack: VisualEffectView)
        UIView.animate(withDuration: 0.3, animations: {
            self.errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.errorView.alpha = 0
            self.VisualEffectView.effect = nil
        }, completion: { (success:Bool) in
            self.errorView.removeFromSuperview()
        })
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        self.animatePopOut()
    }
    
    //** overrides **//
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondVC = segue.destination as? SecondVC else { return }
        secondVC.user = self.user
        secondVC.coalitions = self.coalitions
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

