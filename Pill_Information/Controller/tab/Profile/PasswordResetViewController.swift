//
//  PasswordResetViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/06.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PasswordResetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordCheck: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    
    var boolPasswordCheck = false
    var valid = false

    
    override func viewDidAppear(_ animated: Bool) {
        if !boolPasswordCheck {
            changeView(viewName: "passwordCheck")
        }
        self.boolPasswordCheck = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldSetting()
    }
    
    
    func textFieldSetting() {
        txtPassword.delegate = self
        txtPasswordCheck.delegate = self
    }
    
    
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtPassword.resignFirstResponder()
        self.txtPasswordCheck.resignFirstResponder()
    }
    
    /// 키보드에서 Return(Enter)를 입력할 경우
    /// - Parameter textField: 현재 선택된 텍스트 필드.
    /// - Returns: 리턴 값(true)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPassword {
            txtPasswordCheck.becomeFirstResponder()
        } else if textField == txtPasswordCheck {
            txtPasswordCheck.resignFirstResponder()
            self.changePassword(btnChangePassword)
        }
        return true
    }
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "profileUpdate")
    }
    
    
    @IBAction func changePassword(_ sender: UIButton) {
        let pwd = UserDefaults.standard.string(forKey: "pwd")
        
        if txtPassword.text == "" || txtPasswordCheck.text == "" {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else if pwd != txtPassword.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        } else if txtPassword.text != txtPasswordCheck.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        } else {
            let userEmail = UserDefaults.standard.string(forKey: "email")
            
            Auth.auth().sendPasswordReset(withEmail: userEmail!) { (error) in
                if let _ = error {
                    self.messageAlert(controllerTitle: "실패", controllerMessage: "비밀번호 변경을 위한 이메일 전송을 실패하였습니다.\n이메일을 재설정해 주십시오.", actionTitle: "확인")
                } else {
                    self.messageAlert(controllerTitle: "성공", controllerMessage: "비밀번호 변경을 위한 이메일을 전송하였습니다.", actionTitle: "확인")
                }
            }
        }
    }
    
    
    func logOut() {
        let firebaseAuth = Auth.auth()

        do {
          // 로그아웃 시도하기
            
            // 자동로그인 제거
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "pwd")
            
            
            try firebaseAuth.signOut()
            changeView(viewName: "login")
            
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
    
    func changeView(viewName: String) {
        if viewName == "mainBoard" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MainBoard")as? UITabBarController else {return}

            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "profileUpdate" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "ProfileUpdateBoard")as? ProfileUpdateViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "passwordCheck" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "PasswordCheckBoard")as? PasswordCheckViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "changeEmail" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "EmailChangeBoard")as? EmailChangeViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "login" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewBoard")as? LoginViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen
            vcName.modalTransitionStyle = .crossDissolve
            self.present(vcName, animated: true, completion: nil)
        }
    }
    
    
    /// Alert 출력
    /// 회원가입 성공 메세지일 경우 로그인 화면으로 전환
    /// - Parameters:
    ///   - controllerTitle: Alert Title
    ///   - controllerMessage: Alert Message
    ///   - actionTitle: action(button content)
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        if controllerTitle == "성공" {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler:  { (action) in
                self.logOut() })
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
        } else if controllerTitle == "실패" {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertActOk = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
            let alertActEmail = UIAlertAction(title: "이메일 재설정", style: UIAlertAction.Style.default, handler:  { (action) in
                self.changeView(viewName: "changeEmail") })
            
            alertCon.addAction(alertActOk)
            alertCon.addAction(alertActEmail)
            present(alertCon, animated: true, completion: nil)
        } else {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
        }
    }
}
