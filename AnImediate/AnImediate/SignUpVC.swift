//
//  SignUpVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/25.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        userNameTF.delegate = self
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if (user != nil && error == nil) {
                    print("register successed")
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                } else {
                    print("register failed")
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        // キーボードを閉じる処理
        self.view.endEditing(true)
        return true
    }
}
