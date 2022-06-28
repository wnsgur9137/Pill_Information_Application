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

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordCheck: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    
    var emailBool:Bool = false
    var passBool:Bool = false
    var passCheckBool:Bool = false
    var nextBool:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageControl()
        
        btnNext.isEnabled = false
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordCheck.delegate = self
        txtEmail.keyboardType = .emailAddress
    }
    
    func initPageControl() {
        pageControl.numberOfPages = 2   // 페이지 총 개수
        pageControl.currentPage = 0             // 현재 페이지
        pageControl.pageIndicatorTintColor = UIColor.gray   // 다른 페이지 색상
        pageControl.currentPageIndicatorTintColor = UIColor.blue    // 현재 페이지 색상
    }
    
    @IBAction func join(_ sender: UIButton) {
        if txtEmail.text == nil || txtEmail.text == "" ||
            txtPassword.text == nil || txtPassword.text == "" ||
            txtPasswordCheck.text == nil || txtPasswordCheck.text == "" {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else {
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
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        if txtEmail.text == nil || txtEmail.text == "" {
            emailBool = false
        } else {
            emailBool = true
        }
        checkNextButton()
    }
    
    @IBAction func passChanged(_ sender: UITextField) {
        if txtPassword.text == nil || txtPassword.text == "" {
            passBool = false
        } else {
            passBool = true
        }
        checkNextButton()
    }
    
    @IBAction func passCheckChanged(_ sender: UITextField) {
        if txtPasswordCheck.text == nil || txtPasswordCheck.text == "" {
            passCheckBool = false
        } else {
            passCheckBool = true
        }
        checkNextButton()
    }
    
    func checkNextButton() {
//        print("email: ", txtEmail.text)
//        print("pass: ", txtPassword.text)
//        print("passC: ", txtPasswordCheck.text)
        if emailBool && passBool && passCheckBool {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
    }
    
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
        let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertCon.addAction(alertAct)
        present(alertCon, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtPasswordCheck.resignFirstResponder()
    }
    
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

}
