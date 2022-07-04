//
//  ProfileUpdateViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/04.
//

import UIKit

class ProfileUpdateViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func naviBackButton(_ sender: UIBarButtonItem) {
        changeView(viewName: "myProfile")
    }
    
    func changeView(viewName: String) {
        if viewName == "myProfile" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "myProfileBoard")as? UITabBarController else {return}
            
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
