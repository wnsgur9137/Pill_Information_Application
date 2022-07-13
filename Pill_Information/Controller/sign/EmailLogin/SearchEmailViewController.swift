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
    @IBOutlet weak var btnSearch: UIButton!
    
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
    
    /// 화면 터치시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtName.resignFirstResponder()
        self.txtPhone.resignFirstResponder()
    }
    
    
    /// Return(Enter) 입력시 키보드 전환 및 닫기.
    /// - Parameter textField: 텍스트필드
    /// - Returns: true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtName {
            self.txtPhone.becomeFirstResponder()
        } else {
            self.txtPhone.resignFirstResponder()
            searchEmail(btnSearch)
        }
        return true
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        changeView(viewName: "emailLogin")
    }
    
    
    @IBAction func searchEmail(_ sender: UIButton) {
        
        if txtName.text == "" || txtPhone.text == "" {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else {
            self.ref = Database.database().reference()
            let result = self.ref.child("users").queryOrderedByValue().queryEqual(toValue: txtName.text!)

            print("\n\n\n------------------------------\n")
            print(result)
        }
        
    }
    
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "emailLogin" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginBoard")as? EmailLoginController else {return}
            
            vcName.modalPresentationStyle = .fullScreen
            vcName.modalTransitionStyle = .crossDissolve
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "searchEmailResult" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "SearchEmailResultBoard")as? SearchEmailResultViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen
            vcName.modalTransitionStyle = .crossDissolve
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
