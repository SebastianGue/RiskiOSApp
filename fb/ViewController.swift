//
//  ViewController.swift
//  fb
//
//  Created by Sebastian Guerrero on 11/2/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import Alamofire
import SwiftyJSON

//import FacebookLogin


class ViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    var dict : [String : AnyObject]!
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "user_friends"]
        return button
    }()

    
    @IBOutlet weak var getUsersButton: UIButton!
    @IBOutlet weak var sendDataButton: UIButton!
    @IBOutlet weak var profileDataButton: UIButton!
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
//        print("please work wowowo")
//        getUsersButton.isEnabled = false
//        getUsersButton.isHidden = true
//        sendDataButton.isEnabled = false
//        sendDataButton.isHidden = true
//        profileDataButton.isEnabled = false
//        profileDataButton.isHidden = true
        
    }
    
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fetchProfile()
//        getUsersButton.isEnabled = true
//        getUsersButton.isHidden = false
//        sendDataButton.isEnabled = true
//        sendDataButton.isHidden = false
//        profileDataButton.isEnabled = true
//        profileDataButton.isHidden = false
        
    }

    func fetchProfile() {
        print("fetching profile")
        let parameters = ["fields": "id, name, first_name, last_name, email"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {(connection, result, error) -> Void in
            if error == nil {
                self.dict = result as! [String : AnyObject]
                print(result!)
                print(self.dict)
            }
        })
    }
    
    
    @IBAction func getUsersAction(_ sender: Any) {
        let headers: HTTPHeaders = ["AuthorizationToken": self.dict["id"]! as! String]
        
        Alamofire.request("http://localhost:3000/users", headers: headers).responseJSON {response in
            
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
            print("JSON: \(JSON)")
            }
        }
        
    }

    @IBAction func sendDataAction(_ sender: Any) {
        let parameters: Parameters = ["user[auth_token]": self.dict["id"]!, "user[full_name]": self.dict["name"]!, "user[email]": self.dict["email"]!, "user[role]": "memeber"]
        
        print(parameters)
        
        Alamofire.request("http://localhost:3000/users",  method: .post ,parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            
        }
    }
    
    @IBAction func profileDataAction(_ sender: Any) {
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(loginButton);
        loginButton.center = view.center
        
        if let token = FBSDKAccessToken.current() {
//            getUsersButton.isEnabled = true
//            getUsersButton.isHidden = false
//            sendDataButton.isEnabled = true
//            profileDataButton.isEnabled = true
            fetchProfile()
        }
        else {
//            getUsersButton.isEnabled = false
//            getUsersButton.isHidden = true
//            sendDataButton.isEnabled = false
//            profileDataButton.isEnabled = false
        }
        
        
//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
//        loginButton.center = view.center
//        
//        view.addSubview(loginButton)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

