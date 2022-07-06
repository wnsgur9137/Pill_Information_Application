//
//  UserDeleteViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/06.
//

import UIKit

class UserDeleteViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordCheck: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
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
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "profileUpdate")
    }
    

    @IBAction func userDelete(_ sender: UIButton) {
        
    }
    
    
    /// Alert 출력
    /// 회원가입 성공 메세지일 경우 로그인 화면으로 전환
    /// - Parameters:
    ///   - controllerTitle: Alert Title
    ///   - controllerMessage: Alert Message
    ///   - actionTitle: action(button content)
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        if controllerTitle == "정보 수정 완료" {
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
