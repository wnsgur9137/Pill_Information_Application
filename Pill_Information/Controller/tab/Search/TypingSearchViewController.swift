//
//  TypingSearchViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/15.
//

import UIKit

class TypingSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "searchPillView")
    }
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "searchPillView" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "SearchPillBoard")as? SearchPillViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen
            vcName.modalTransitionStyle = .crossDissolve
            self.present(vcName, animated: true, completion: nil)
        }
    }

}
