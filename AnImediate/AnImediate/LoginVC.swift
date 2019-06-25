//
//  LoginVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /* ユーザ作成
    if let email = mailAddressText.text, let password = passwordText.text {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            self?.validateAuthenticationResult(user, error: error)
        }
    }*/
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    let alert = UIAlertController(title: "ログインエラー", message: "メールアドレスもしくはパスワードが違います。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
