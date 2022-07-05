//
//  MyProfileViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/30.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class MyProfileViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileLoad()
    }
    

    
    /// 로그아웃 버튼(자동로그인 해제, 로그아웃)
    /// - Parameter sender: 로그아웃 버튼
    @IBAction func logOut(_ sender: UIButton) {
        
        
        logoutTapped()
        changeView(viewName: "login")
    }
    
    func profileLoad() {
        let user = Auth.auth().currentUser
        if user == nil {
            changeView(viewName: "login")
        } else {
            let uid = user?.uid
            self.ref = Database.database().reference()
            
            self.ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                let username = value?["Name"] as? String ?? ""
//                let email = value?["Email"] as? String ?? ""
                
                self.lblName.text = username + "님"

                if username == "" {
                    self.changeView(viewName: "profileInit")
                }
            }) { error in
                self.changeView(viewName: "profileInit")
            }
        }
    }
    
    
    /// 로그아웃 함수
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
    
    @IBAction func btnProfileUpdate(_ sender: UIButton) {
        changeView(viewName: "passwordCheck")
    }
    
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "login" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "loginBoard")as? LoginViewController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "passwordCheck" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "passwordCheckBoard")as? PasswordCheckViewController else {return}
            
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
