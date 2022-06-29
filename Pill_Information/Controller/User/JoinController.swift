//
//  JoinController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/24.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.isEnabled = false
        initPageControl()
        initTextField()
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
    
    
    /// 다음 버튼
    ///  이메일과 비밀번호를 확인한 뒤 버튼이 활성화 됨.
    /// - Parameter sender: 다음 버튼
    @IBAction func next(_ sender: UIButton) {
        if txtPassword.text != txtPasswordCheck.text {
            messageAlert(controllerTitle: "경고", controllerMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "확인")
        } else {
            let vcName = self.storyboard?.instantiateViewController(withIdentifier: "profileInitBoard")
                    vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
                    vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
                    self.present(vcName!, animated: true, completion: nil)
//                Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { [self]authResult, error in
//                    self.messageAlert(controllerTitle: "회원가입 성공", controllerMessage: "환영합니다.", actionTitle: "로그인")
//                }
        }
    }
    
    
    /// 모든 텍스트필드의 공백을 검사
    /// 공백이 아닐 경우 btnNext 활성화
    /// - Parameter textField: 입력하고 있는 TextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtEmail.text == "" || txtPassword.text == "" || txtPasswordCheck.text == "" {
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
