//
//  MainViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/01.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MainViewController: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        checkProfile()
    }
    
    func checkProfile() {
        let user = Auth.auth().currentUser
        if user == nil {
            changeView(viewName: "login")
        } else {
            let uid = user?.uid
            self.ref = Database.database().reference()
            
            self.ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                let username = value?["Name"] as? String ?? ""

                if username == "" {
                    self.changeView(viewName: "profileInit")
                }
                print("\n\nusername: ")
                print(username, "\n\n")
                self.changeView(viewName: "main")
            }) { error in
                self.changeView(viewName: "profileInit")
            }
        }
    }

    
    func changeView(viewName: String) {
        if viewName == "profileInit" {
           print("\n\ngotoProfileInitCotnroller\n\n")
           guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "profileInitBoard")as? profileInitController else {return}
           
           vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
           vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
           self.present(vcName, animated: true, completion: nil)
       }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
