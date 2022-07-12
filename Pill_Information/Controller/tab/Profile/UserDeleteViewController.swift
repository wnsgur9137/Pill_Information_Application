//
//  UserDeleteViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/06.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class UserDeleteViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordCheck: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblPasswordWarning: UILabel!
    
    var ref: DatabaseReference!
    var boolPasswordCheck = false

    
    override func viewDidAppear(_ animated: Bool) {
        if !boolPasswordCheck {
            changeView(viewName: "passwordCheck")
        }
        self.boolPasswordCheck = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldSetting()
        lblPasswordWarning.text = ""
    }
    
    
    func textFieldSetting() {
        txtPassword.delegate = self
        txtPasswordCheck.delegate = self
        
        txtPassword.keyboardType = .default
        txtPasswordCheck.keyboardType = .default
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
            userDelete(btnDelete)
        }
        return true
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtPassword.text != txtPasswordCheck.text {
            lblPasswordWarning.text = "비밀번호가 일치하지 않습니다."
        } else {
            lblPasswordWarning.text = ""
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "profileUpdate")
    }
    

    @IBAction func userDelete(_ sender: UIButton) {
        let pwd = UserDefaults.standard.string(forKey: "pwd")
        if txtPassword.text != txtPasswordCheck.text || pwd != txtPassword.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        } else {
            
            // 데이터베이스 데이터 삭제
            let user = Auth.auth().currentUser
            self.ref = Database.database().reference()
            
//            self.ref.child("users").child(user!.uid)
            self.ref.child("users").child(user!.uid).removeValue { error, _  in
                if let _ = error {
                    self.messageAlert(controllerTitle: "경고", controllerMessage: "유저 데이터베이스 데이터를 삭제하지 못했습니다.", actionTitle: "확인")
                } else {
                    user?.delete{ error in
                        if let _ = error {
                            self.messageAlert(controllerTitle: "경고", controllerMessage: "사용자 탈퇴 실패", actionTitle: "확인")
                        } else {
                            // 자동로그인 제거
                            UserDefaults.standard.removeObject(forKey: "email")
                            UserDefaults.standard.removeObject(forKey: "pwd")
                            
                            self.messageAlert(controllerTitle: "탈퇴", controllerMessage: "탈퇴 완료", actionTitle: "확인")
                        }
                    }
                }
            }
        }
    }
    
    
    /// Alert 출력
    /// 회원가입 성공 메세지일 경우 로그인 화면으로 전환
    /// - Parameters:
    ///   - controllerTitle: Alert Title
    ///   - controllerMessage: Alert Message
    ///   - actionTitle: action(button content)
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        if controllerTitle == "탈퇴" {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler:  { (action) in
                self.changeView(viewName: "login") })
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
        } else {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
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
        } else if viewName == "login" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "LoginBoard")as? LoginViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        }
    }
}
