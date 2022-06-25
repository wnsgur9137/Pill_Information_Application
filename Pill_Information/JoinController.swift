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

class JoinController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordCheck: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    let pageCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPageControl()
        // Do any additional setup after loading the view.
    }
    
    func initPageControl() {
        pageControl.numberOfPages = pageCount   // 페이지 총 개수
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
                Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { [self]authResult, error in
                    self.messageAlert(controllerTitle: "회원가입 성공", controllerMessage: "환영합니다.", actionTitle: "로그인")
                }
            }
        }
    }
    
    
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
        let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertCon.addAction(alertAct)
        present(alertCon, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
