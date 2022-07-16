//
//  SearchViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/13.
//

import UIKit
import Firebase
import FirebaseAuth

class SearchPillViewController: UIViewController {

    @IBOutlet weak var btnPictureSearch: UIButton!
    @IBOutlet weak var btnTypingSearch: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnPictureSearch(_ sender: UIButton) {
        changeView(viewName: "pictureSearch")
    }
    
    @IBAction func btnTypingSearch(_ sender: UIButton) {
        changeView(viewName: "typingSearch")
    }
    

    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "pictureSearch" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "PictureSearchBoard")as? PictureSearchViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen
            vcName.modalTransitionStyle = .crossDissolve
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "typingSearch" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "TypingSearchBoard")as? TypingSearchViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen
            vcName.modalTransitionStyle = .crossDissolve
            self.present(vcName, animated: true, completion: nil)
        }
    }
}
