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
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.isEnabled = false
        initTextField()
    }
    
    
    /// 텍스트 필드 초기 설정
    func initTextField() {
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtEmail.keyboardType = .emailAddress
    }
    
    
    /// 화면 터치시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
    
    
    /// Return(Enter) 입력시 키보드 전환 및 닫기.
    /// - Parameter textField: 텍스트필드
    /// - Returns: true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        } else {
            self.txtPassword.resignFirstResponder()
        }
        return true
    }
    
    
    /// 로그인
    /// - Parameter sender: 로그인 버튼
    @IBAction func btnLogin(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if user != nil {
                guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "mainBoard")as? UITabBarController else {return}
                
                vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
                vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
                self.present(vcName, animated: true, completion: nil)
            } else {
                self.messageAlert(controllerTitle: "로그인 실패", controllerMessage: "로그인 실패", actionTitle: "확인")
            }
        }
    }
    
    
    /// 모든 텍스트필드의 공백을 검사
    /// 공백이 아닐 경우 btnNext 활성화
    /// - Parameter textField: 입력하고 있는 TextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtEmail.text == "" || txtPassword.text == "" {
            btnLogin.isEnabled = false
        } else {
            btnLogin.isEnabled = true
        }
    }
    
    /// Alert 출력
    /// - Parameters:
    ///   - controllerTitle: Alert Title
    ///   - controllerMessage: Alert Message
    ///   - actionTitle: action(button content)
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
        let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertCon.addAction(alertAct)
        present(alertCon, animated: true, completion: nil)
    }

}
