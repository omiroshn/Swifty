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
    

    let uid = "b45b4dfbed422177c9877185d4b9103d3a10eef5a4e8adb0d55aa1c58e350e18"
    let secret = "1acb18d21559f4bf503bd77e2a6ddf620aefe3c5c08c6e0ea7a679f0ed390674"
    var token: Token?
    var user: NSDictionary?
    var effect: UIVisualEffect!
    
    struct Token: Codable {
        var access_token: String?
        var created_at: Int?
        var expires_int: Int?
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
        
        getToken { (token, error) in
            self.token = token
        }
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
        if login != "" {
            makeRequest(login: login) { (json, error) in
                DispatchQueue.main.async {
                    if json != nil && json!["login"] != nil {
                        self.user = json
                        self.performSegue(withIdentifier: "SecondVC", sender: self)
                    } else {
                        self.loginField.text = ""
                        self.animatePopUp()
                    }
                }
            }
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
        secondVC.token = self.token?.access_token
        secondVC.user = self.user
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

