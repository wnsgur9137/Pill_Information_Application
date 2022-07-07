//
//  SearchPasswordViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/07.
//

import UIKit
import Firebase
import FirebaseAuth

class SearchPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailCheck: UILabel!
    @IBOutlet weak var btnResetPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblEmailCheck.text = ""
        btnResetPassword.isEnabled = false
        viewSetting()
    }
    
    
    func viewSetting() {
        txtEmail.delegate = self
        txtEmail.keyboardType = .emailAddress
    }
    
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtEmail.resignFirstResponder()
    }
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtEmail.resignFirstResponder()
            resetPassword(btnResetPassword)
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
    
    
    /// 모든 텍스트필드의 공백을 검사, 이메일 형식검사
    /// 위 경우를 모두 만족할 경우 btnNext 활성화
    /// - Parameter textField: 입력하고 있는 TextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var emailCheck = false
        if textField == txtEmail {
            if !isValid(str: txtEmail.text ?? "") {
                lblEmailCheck.text = "이메일 형식에 맞추어 주십시오."
                emailCheck = false
            } else {
                lblEmailCheck.text = ""
                emailCheck = true
            }
        }
        if txtEmail.text != "" && emailCheck {
            btnResetPassword.isEnabled = true
        } else {
            btnResetPassword.isEnabled = false
        }
    }

    @IBAction func goBack(_ sender: UIButton) {
        changeView(viewName: "emailLoginView")
    }
    
    
    @IBAction func resetPassword(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { (error) in
            if let _ = error {
                self.messageAlert(controllerTitle: "실패", controllerMessage: "비밀번호 변경을 위한 이메일 전송을 실패하였습니다.\n이메일을 다시 입력해 주십시오.", actionTitle: "확인")
            } else {
                self.messageAlert(controllerTitle: "성공", controllerMessage: "비밀번호 변경을 위한 이메일을 전송하였습니다.", actionTitle: "확인")
            }
        }
    }
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "emailLoginView" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "emailLoginBoard")as? EmailLoginController else {return}
            
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
                self.changeView(viewName: "emailLoginView") })
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
        } else {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
        }
    }
}
