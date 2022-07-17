//
//  AlramViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/12.
//

import UIKit

class AlramViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func btnEdit(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addTimer(_ sender: UIButton) {
        changeView(viewName: "addTimer")
    }
    
    @IBAction func addAlram(_ sender: UIButton) {
        changeView(viewName: "addAlram")
    }
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "addTimer" { // 메인 화면 전환
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "AddTimerBoard")as? AddTimerViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "addAlram" { // 이메일 로그인 화면 전환
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "AddAlramBoard")as? AddAlramViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        }
    }
}
