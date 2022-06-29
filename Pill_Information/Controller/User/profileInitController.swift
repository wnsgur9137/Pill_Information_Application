//
//  profileInitController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/27.
//

import UIKit
import FirebaseAuth

class profileInitController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var sgSex: UISegmentedControl!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    var email_ = ""
    var pass_ = ""
    var sex_ = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnJoin.isEnabled = false
        initPageControl()
        initTextField()
        
    }
    
    
    /// 페이지 컨트롤 초기 설정
    func initPageControl() {
        pageControl.numberOfPages = 2   // 페이지 총 개수
        pageControl.currentPage = 1             // 현재 페이지
        pageControl.pageIndicatorTintColor = UIColor.gray   // 다른 페이지 색상
        pageControl.currentPageIndicatorTintColor = UIColor.blue    // 현재 페이지 색상
    }
    
    
    /// 텍스트 필드 초기 설정
    func initTextField() {
        txtName.delegate = self
        txtBirthday.delegate = self
        txtPhone.delegate = self
        txtAddress1.delegate = self
        txtAddress2.delegate = self
        txtName.keyboardType = .default
        txtPhone.keyboardType = .phonePad
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtName.text == "" || txtBirthday.text == "" ||
            txtPhone.text == "" || txtAddress1.text == "" ||
            txtAddress2.text == "" {
            btnJoin.isEnabled = false
        } else {
            btnJoin.isEnabled = true
        }
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

    
    @IBAction func changeSex(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sex_ = "남"
        } else {
            sex_ = "여"
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "joinBoard")as? JoinController else {return}
        
        vcName.email_ = email_
        
        vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName, animated: true, completion: nil)
    }
    
    @IBAction func btnJoin(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: email_, password: pass_) { [self]authResult, error in

//            let uid = authResult?.user.uid
            self.messageAlert(controllerTitle: "회원가입 성공", controllerMessage: "환영합니다.", actionTitle: "로그인")
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtName.resignFirstResponder()
        } else if textField == txtPhone {
            txtAddress1.becomeFirstResponder()
        } else if textField == txtAddress1 {
            txtAddress2.becomeFirstResponder()
        } else {
            txtAddress2.resignFirstResponder()
        }
        return true
    }
    
    
    /// Alert 출력
    /// 회원가입 성공 메세지일 경우 로그인 화면으로 전환
    /// - Parameters:
    ///   - controllerTitle: Alert Title
    ///   - controllerMessage: Alert Message
    ///   - actionTitle: action(button content)
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        if controllerTitle == "회원가입 성공" {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler:  { (action) in
                self.goLoginBoard() })
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
        } else {
            let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
            alertCon.addAction(alertAct)
            present(alertCon, animated: true, completion: nil)
        }
    }
    
    func goLoginBoard() {
        guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "loginBoard")as? LoginController else {return}
        
        vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName, animated: true, completion: nil)
    }
}
