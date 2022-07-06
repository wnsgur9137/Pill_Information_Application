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
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtNewPasswordCheck: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var lblPasswordWarning: UILabel!
    
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
        lblPasswordWarning.text = ""
    }
    
    
    func textFieldSetting() {
        txtPassword.delegate = self
        txtNewPassword.delegate = self
        txtNewPasswordCheck.delegate = self
    }
    
    
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtPassword.resignFirstResponder()
        self.txtNewPassword.resignFirstResponder()
        self.txtNewPasswordCheck.resignFirstResponder()
    }
    
    /// 키보드에서 Return(Enter)를 입력할 경우
    /// - Parameter textField: 현재 선택된 텍스트 필드.
    /// - Returns: 리턴 값(true)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPassword {
            txtNewPassword.becomeFirstResponder()
        } else if textField == txtNewPassword {
            txtNewPasswordCheck.becomeFirstResponder()
        } else if textField == txtNewPasswordCheck {
            txtNewPasswordCheck.resignFirstResponder()
            self.changePassword(btnChangePassword)
        }
        return true
    }
    
    /// 텍스트필드 형식 검사 함수
    /// - Parameters:
    ///   - str: 검사할 문자열
    ///   - textField: 검사할 문자열이 담긴 텍스트 필드(이에 따라 검사 방법이 달라짐)
    /// - Returns: 형식이 알맞은지 true, false로 반환함.
    func isValid(str: String) -> Bool {
        // 비밀번호 형식 (숫자, 문자 포함 8자 이상)
        let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: str)
    }
    
    
    /// 모든 텍스트필드의 공백을 검사, 이메일 형식, 비밀번호 형식 검사
    /// - Parameter textField: 입력하고 있는 TextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtNewPassword.text != txtNewPasswordCheck.text {
            lblPasswordWarning.text = "비밀번호가 일치하지 않습니다."
        } else if !isValid(str: txtNewPasswordCheck.text ?? "") {
            lblPasswordWarning.text = "소문자, 대문자, 숫자를 조합하여 8자 이상"
        } else {
            lblPasswordWarning.text = ""
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "profileUpdate")
    }
    
    
    @IBAction func changePassword(_ sender: UIButton) {
        let pwd = UserDefaults.standard.string(forKey: "pwd")
        
        if txtPassword.text == "" || txtNewPassword.text == "" || txtNewPasswordCheck.text == "" {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else if pwd != txtPassword.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "기존 비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        } else if txtNewPassword.text != txtNewPasswordCheck.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "신규 비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        }else if !isValid(str: txtNewPasswordCheck.text ?? "") {
            messageAlert(controllerTitle: "경고", controllerMessage: "소문자, 대문자, 숫자를 조합하여 8자 이상으로 비밀번호를 설정하십시오.", actionTitle: "확인")
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
    
    
    func changeView(viewName: String) {
        if viewName == "mainBoard" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "mainBoard")as? UITabBarController else {return}

            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "profileUpdate" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "profileUpdateBoard")as? ProfileUpdateViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "passwordCheck" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "passwordCheckBoard")as? PasswordCheckViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "changeEmail" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "emailChangeBoard")as? EmailChangeViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
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
                self.changeView(viewName: "profileUpdate") })
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
