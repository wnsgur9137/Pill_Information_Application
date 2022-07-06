//
//  PasswordCheckViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/05.
//

import UIKit
import Firebase
import FirebaseAuth

class PasswordCheckViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtPassword.delegate = self
    }
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtPassword.resignFirstResponder()
    }
    
    /// Return(Enter) 입력 시 키보드 전환 및 닫기
    /// - Parameter textField: 텍스트필드
    /// - Returns: true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtPassword.resignFirstResponder()
        passwordCheck(btnNext)
        return true
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "mainBoard")
    }
    
    
    @IBAction func passwordCheck(_ sender: UIButton) {
        let userPassword = UserDefaults.standard.string(forKey: "pwd")
        
        if txtPassword.text == userPassword {
            changeView(viewName: "profileUpdate")
        } else {
            messageAlert(controllerTitle: "경고", controllerMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        }
    }
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "profileUpdate" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "profileUpdateBoard")as? ProfileUpdateViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "mainBoard" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "mainBoard")as? UITabBarController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
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
