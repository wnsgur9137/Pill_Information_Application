//
//  LoginController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/24.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
//    txtPassword.delegate = self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로그인이 되어있을 시
        checkLogin()
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtEmail.keyboardType = .emailAddress
    }
    
    func checkLogin() {
//        if let user = Auth.auth().currentUser {
//            
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        } else {
            self.txtPassword.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if txtEmail.text == nil || txtEmail.text == "" ||
            txtPassword.text == nil || txtPassword.text == "" {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else {
            // 로그인
            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
                if user != nil {
                    
                } else {
                    
                }
            }
        }
    }
    
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
        let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertCon.addAction(alertAct)
        present(alertCon, animated: true, completion: nil)
    }

}
