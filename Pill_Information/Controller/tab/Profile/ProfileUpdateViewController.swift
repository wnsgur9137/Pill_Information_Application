//
//  ProfileUpdateViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/04.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileUpdateViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var sgGender: UISegmentedControl!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    var gender = "남"
    var boolPasswordCheck = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        if !boolPasswordCheck {
            print("plz passwordChecking")
            changeView(viewName: "passwordCheck")
        }
        self.boolPasswordCheck = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSetting()
    }
    
    
    /// 외부 터치 시 키보드 닫기
    /// - Parameters:
    ///   - touches: 터치
    ///   - event: 외부
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtName.resignFirstResponder()
        self.txtBirthday.resignFirstResponder()
        self.txtPhone.resignFirstResponder()
        self.txtAddress1.resignFirstResponder()
        self.txtAddress2.resignFirstResponder()
    }
    
    /// 키보드에서 Return(Enter)를 입력할 경우
    /// - Parameter textField: 현재 선택된 텍스트 필드.
    /// - Returns: 리턴 값(true)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtPhone.becomeFirstResponder()
        } else if textField == txtPhone {
            txtPhone.resignFirstResponder()
        } else if textField == txtAddress1 {
            txtAddress2.becomeFirstResponder()
        } else {
            txtAddress2.resignFirstResponder()
            profileUpdate(btnUpdate)
        }
        return true
    }
    
    func txtSetting() {
        txtName.delegate = self
        txtEmail.delegate = self
        txtPhone.delegate = self
        txtBirthday.delegate = self
        txtAddress1.delegate = self
        txtAddress2.delegate = self
        txtName.keyboardType = .default
        txtEmail.keyboardType = .emailAddress
        txtPhone.keyboardType = .phonePad
        
        let user = Auth.auth().currentUser
        if user == nil {
            changeView(viewName: "login")
        } else {
            let uid = user?.uid
            self.ref = Database.database().reference()
            
            self.ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                let username = value?["Name"] as? String ?? ""
                let email = value?["Email"] as? String ?? ""
                let phone = value?["Phone"] as? String ?? ""
                let gender = value?["Gender"] as? String ?? ""
                let birthday = value?["BirthDay"] as? String ?? ""
                let address1 = value?["Address1"] as? String ?? ""
                let address2 = value?["Address2"] as? String ?? ""
                
                self.txtName.text = username
                self.txtEmail.text = email
                self.txtPhone.text = phone
                if gender == "남" {
                    self.sgGender.selectedSegmentIndex = 0
                } else {
                    self.sgGender.selectedSegmentIndex = 1
                }
                self.txtBirthday.text = birthday
                self.txtAddress1.text = address1
                self.txtAddress2.text = address2
                if username == "" {
                    self.changeView(viewName: "profileInit")
                }
            }) { error in
                self.changeView(viewName: "profileInit")
            }
            
            txtEmail.isEnabled = false
        }
    }
    
    
    @IBAction func naviBackButton(_ sender: UIBarButtonItem) {
        changeView(viewName: "mainBoard")
    }
    
    /// 생년월일 텍스트필드 (txtBirthDay) 클릭 시
    /// - Parameter sender: txtBirthDay
    @IBAction func txtBirthClick(_ sender: UITextField) {
        configureDatePicker()
    }
    
    
    /// DatePicker 설정
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.txtBirthday.inputView = self.datePicker
    }
    
    
    /// DatePicker의 값을 설정하여 txtBirthDay에 출력
    /// - Parameter datePicker: configureDatePicker의 datePicker
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy 년 MM 월 dd 일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.txtBirthday.text = formmater.string(from: datePicker.date)
    }
    
    @IBAction func sgSelected(_ sender: UISegmentedControl) {
        if sgGender.selectedSegmentIndex == 0 {
            gender = "남"
        } else {
            gender = "여"
        }
    }
    
    func textFieldNullCheck() -> Bool {
        if txtName.text == "" || txtPhone.text == "" ||
            txtBirthday.text == "" || txtAddress1.text == "" ||
            txtAddress2.text == "" {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func profileUpdate(_ sender: UIButton) {
        let textFieldCheck = textFieldNullCheck()
        if !textFieldCheck {
            messageAlert(controllerTitle: "경고", controllerMessage: "공백이 존재합니다.", actionTitle: "확인")
        } else {
            let user = Auth.auth().currentUser
            
            if user == nil {
                changeView(viewName: "login")
            } else {
                let uid = user?.uid
                Database.database().reference().child("users").child(uid!).setValue(["Name":self.txtName.text!, "Gender":self.gender, "BirthDay":self.txtBirthday.text!, "Phone":self.txtPhone.text!, "Address1":self.txtAddress1.text!, "Address2":self.txtAddress2.text!])
                self.messageAlert(controllerTitle: "정보 수정 완료", controllerMessage: "회원 정보가 수정되었습니다.", actionTitle: "확인")
            }
        }
    }
    
    
    @IBAction func changeEmail(_ sender: UIButton) {
        changeView(viewName: "changeEmail")
    }
    
    
    @IBAction func passwordReset(_ sender: UIButton) {
        changeView(viewName: "passwordReset")
    }
    
    @IBAction func userDelete(_ sender: UIButton) {
        changeView(viewName: "userDelete")
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
        } else if viewName == "passwordCheck" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "passwordCheckBoard")as? PasswordCheckViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "changeEmail" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "emailChangeBoard")as? EmailChangeViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "passwordReset" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "passwordResetBoard")as? PasswordResetViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "userDelete" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "userDeleteBoard")as? UserDeleteViewController else {return}
            
            vcName.boolPasswordCheck = true
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        }
    }
}
