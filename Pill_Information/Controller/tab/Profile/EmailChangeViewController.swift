//
//  EmailChangeViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/06.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EmailChangeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNewEmail: UITextField!
    @IBOutlet weak var txtEmailCheck: UITextField!
    @IBOutlet weak var btnChangeEmail: UIButton!
    @IBOutlet weak var lblEmailWarning: UILabel!
    
    var boolPasswordCheck = false

    
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
        txtNewEmail.delegate = self
        txtEmailCheck.delegate = self
        
        txtPassword.keyboardType = .default
        txtNewEmail.keyboardType = .emailAddress
        txtEmailCheck.keyboardType = .emailAddress
    }
    
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtPassword.resignFirstResponder()
        self.txtNewEmail.resignFirstResponder()
        self.txtEmailCheck.resignFirstResponder()
    }
    
    /// 키보드에서 Return(Enter)를 입력할 경우
    /// - Parameter textField: 현재 선택된 텍스트 필드.
    /// - Returns: 리턴 값(true)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPassword {
            txtNewEmail.becomeFirstResponder()
        } else if textField == txtNewEmail {
            txtEmailCheck.becomeFirstResponder()
        } else if textField == txtEmailCheck {
            txtEmailCheck.resignFirstResponder()
            changeEmail(btnChangeEmail)
        }
        return true
    }
    
    
    /// 텍스트필드 형식 검사 함수
    /// - Parameters:
    ///   - str: 검사할 문자열
    /// - Returns: 형식이 알맞은지 true, false로 반환함.
    func isValid(str: String) -> Bool {
        // 이메일 형식
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtNewEmail.text != txtEmailCheck.text {
            lblEmailWarning.text = "이메일이 일치하지 않습니다."
        } else if !isValid(str: txtNewEmail.text ?? "") {
            lblEmailWarning.text = "이메일 형식에 맞추어 주십시오."
        } else {
            lblEmailWarning.text = ""
        }
    }
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "profileUpdate")
    }
    
    
    @IBAction func changeEmail(_ sender: UIButton) {
        let pwd = UserDefaults.standard.string(forKey: "pwd")
        
        if txtPassword.text == "" || txtNewEmail.text == "" || txtEmailCheck.text == "" {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else if pwd != txtPassword.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        } else if txtNewEmail.text != txtEmailCheck.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "이메일이 일치하지 않습니다.", actionTitle: "확인")
        }else if !isValid(str: txtNewEmail.text ?? "") {
            messageAlert(controllerTitle: "경고", controllerMessage: "이메일 형식에 맞게 입력하십시오.", actionTitle: "확인")
        } else {
//            Auth.auth().sendPasswordReset(withEmail: userEmail!) { (error) in
//                if let _ = error {
//                    self.messageAlert(controllerTitle: "실패", controllerMessage: "비밀번호 변경을 위한 이메일 전송을 실패하였습니다.\n이메일을 재설정해 주십시오.", actionTitle: "확인")
//                } else {
//                    self.messageAlert(controllerTitle: "성공", controllerMessage: "비밀번호 변경을 위한 이메일을 전송하였습니다.", actionTitle: "확인")
//                }
//            }
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
                self.changeView(viewName: "mainBoard") })
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
        }
    }

}
