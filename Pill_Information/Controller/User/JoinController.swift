//
//  JoinController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/24.
//

import UIKit
import SwiftUI
//import Firebase
//import FirebaseAuth
//import FirebaseFirestore

class JoinController: UIViewController, UITextFieldDelegate {
    
    enum CurrentPasswordInputStatus {
        case invaledPassword
        case valedPassword
    }

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordCheck: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblEmailCheck: UILabel!
    @IBOutlet weak var lblPasswordCheck: UILabel!
    
    var email_ = ""
    var emailCheck = false
    var passCheck = false
    var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.isEnabled = false
        initPageControl()
        initTextField()
        
        lblEmailCheck.text = ""
        lblPasswordCheck.text = ""
        
    }
    
    
    /// 페이지 컨트롤 초기 설정
    func initPageControl() {
        pageControl.numberOfPages = 2   // 페이지 총 개수
        pageControl.currentPage = 0             // 현재 페이지
        pageControl.pageIndicatorTintColor = UIColor.gray   // 다른 페이지 색상
        pageControl.currentPageIndicatorTintColor = UIColor.blue    // 현재 페이지 색상
    }
    
    
    /// 텍스트 필드 초기 설정
    func initTextField() {
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordCheck.delegate = self
        txtEmail.keyboardType = .emailAddress
        txtPassword.keyboardType = .default
        txtPasswordCheck.keyboardType = .default
        
        txtEmail.text = email_
    }
    
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtPasswordCheck.resignFirstResponder()
    }
    
    
    /// Return(Enter) 입력 시 키보드 전환 및 닫기
    /// - Parameter textField: 텍스트필드
    /// - Returns: true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtPasswordCheck.becomeFirstResponder()
        } else {
            txtPasswordCheck.resignFirstResponder()
        }
        return true
    }
    
    
    func isValid(str: String, textField:UITextField) -> Bool {
        if textField == txtEmail {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: str)
        } else {
            let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
            return passwordTest.evaluate(with: str)
        }
    }
    
    
    /// 다음 버튼
    ///  이메일과 비밀번호를 확인한 뒤 버튼이 활성화 됨.
    /// - Parameter sender: 다음 버튼
    @IBAction func next(_ sender: UIButton) {
        if txtPassword.text != txtPasswordCheck.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        } else {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "profileInitBoard")as? profileInitController else {return}
            
            vcName.email_ = self.txtEmail.text ?? ""
            vcName.pass_ = self.txtPassword.text ?? ""
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        }
    }
    
    /// 모든 텍스트필드의 공백을 검사, 이메일 형식, 비밀번호 형식 검사
    /// 위 경우를 모두 만족할 경우 btnNext 활성화
    /// - Parameter textField: 입력하고 있는 TextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtEmail {
            emailCheck = isValid(str: txtEmail.text ?? "", textField: txtEmail)
            if emailCheck == false {
                lblEmailCheck.text = "이메일 형식에 맞추어 주십시오."
            } else {
                lblEmailCheck.text = ""
            }
        } else {
            if txtPassword.text != txtPasswordCheck.text {
                lblPasswordCheck.text = "비밀번호가 일치하지 않습니다."
            } else {
                lblPasswordCheck.text = ""
                passCheck = isValid(str: txtPasswordCheck.text ?? "", textField: txtPasswordCheck)
                if passCheck == false {
                    lblPasswordCheck.text = "소문자, 대문자, 숫자를 조합하여 8자 이상"
                }
            }
        }
        
        if txtEmail.text == "" || txtPassword.text == "" || txtPasswordCheck.text == "" ||
            emailCheck == false || passCheck == false {
            btnNext.isEnabled = false
        } else {
            btnNext.isEnabled = true
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
