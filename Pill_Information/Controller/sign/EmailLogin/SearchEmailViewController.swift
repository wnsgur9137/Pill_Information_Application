//
//  SearchEmailViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SearchEmailViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetting()
    }
    
    func viewSetting() {
        txtName.delegate = self
        txtPhone.delegate = self
        
        txtName.keyboardType = .default
        txtPhone.keyboardType = .phonePad
        
    }
    
    
    @IBAction func searchEmail(_ sender: UIButton) {
        
        if txtName.text == "" || txtPhone.text == "" {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else {
            self.ref = Database.database().reference()
            self.ref.child("users").queryOrdered(byChild: txtName.text!).queryOrdered(byChild: txtPhone.text!)
        }
        
    }
    
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "main" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MainBoard")as? UITabBarController else {return}
            
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
