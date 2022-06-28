//
//  profileInitController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/27.
//

import UIKit

class profileInitController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPageControl()
        initTextField()
        
    }
    
    @IBAction func txtBirthClick(_ sender: UITextField) {
        configureDatePicker()
    }
    // DatePicker
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.txtBirthday.inputView = self.datePicker
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy 년 MM 월 dd 일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.txtBirthday.text = formmater.string(from: datePicker.date)
    }
    
    func initPageControl() {
//        pageControl.numberOfPages = 2   // 페이지 총 개수
//        pageControl.currentPage = 0             // 현재 페이지
//        pageControl.pageIndicatorTintColor = UIColor.gray   // 다른 페이지 색상
//        pageControl.currentPageIndicatorTintColor = UIColor.blue    // 현재 페이지 색상
    }
    
    func initTextField() {
        txtName.keyboardType = .default
        txtPhone.keyboardType = .phonePad
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtName.resignFirstResponder()
        self.txtBirthday.resignFirstResponder()
        self.txtPhone.resignFirstResponder()
        self.txtAddress1.resignFirstResponder()
        self.txtAddress2.resignFirstResponder()
    }
    
}
