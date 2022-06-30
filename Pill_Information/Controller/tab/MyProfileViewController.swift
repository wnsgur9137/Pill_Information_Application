//
//  MyProfileViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/30.
//

import UIKit
import Firebase
import FirebaseAuth

class MyProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOut(_ sender: UIButton) {
        logoutTapped()
        changeView(viewName: "ViewController")
    }
    
    func logoutTapped() {
        let firebaseAuth = Auth.auth()

        do {
          // 로그아웃 시도하기
            
            // 자동로그인 제거
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "pwd")
            
            
            try firebaseAuth.signOut()
//            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
    func changeView(viewName: String) {
        if viewName == "ViewController" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "viewBoard")as? ViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        }
    }

}
