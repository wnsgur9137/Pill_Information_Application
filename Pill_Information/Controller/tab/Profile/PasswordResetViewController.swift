//
//  PasswordResetViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/06.
//

import UIKit

class PasswordResetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtNewPasswordCheck: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    
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
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "profileUpdate")
    }
    
    
    @IBAction func changePassword(_ sender: UIButton) {
        
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
