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
    
    
    struct hospitalData: Decodable{
        let currentCount: Int
        let data: [Data]
    }

    struct Data: Decodable{
        var resultCode: String? // 결과 코드
        var resultMsg: String? // 결과 메세지
        var numOfRows: String? // 한 페이지 결과 수
        var pageNo: String? // 페이지 번호
        var totalCount: String? // 전체 결과 수
        var entpName: String? // 업체명
        
        var itemName: String? //제품명
        var itemSeq: String? //품목기준코드
        
        var efcyQesitm: String? // 효능
        var useMethodQesitm:String? // 사용법
        var atpnWarnQesitm: String? // 주의사항, 경고
        var atpnQesitm: String? // 주의사항
        var intrcQesitm: String? // 상호작용
        var seQesitm: String? // 부작용
        var depositMethodQesitm: String? // 보관법
        var openDe: String? // 공개일자
        var updateDe: String? // 수정일자
        var itemImage: String? // 낱알 이미지
    }
    
//    var returnData: String
//    var returnError: String
    
    func getDrbEasyDrugList() {
        if let url = URL(string:"http://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=LK5HxMQO7ScyFpgYc6%2BQgNRsqPfAKmnW1fczw8kHYE4BDXCaUX7uBUrZXK6wXoDnS5vivk2h0fYiboTWVjRjvQ%3D%3D&pageNo=1&startPage=1&numOfRows=3&type=json") {
            let request = URLRequest.init(url: url)

            print("url:")
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in guard let data = data else {return}
                let decoder = JSONDecoder()
                print(response as Any)
                do{ let json = try decoder.decode(hospitalData.self , from: data)
                    print("json:")
                     print(json)
//                    self.returnData = String(json!)
                }
                catch{
                    print("error")
                    print(error)
//                    self.returnError = String(error!)
                }
            }.resume()
        }
    }
    
    
    
    var ref: DatabaseReference!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkProfile()
//        var DKey = ApiKeys.getDrbEasyDrugListKey()
        print("----------------\n\n\n\n\n")
        getDrbEasyDrugList()
        print("\n\n\n\n\n----------------")
//        testLabel.text = returnData
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
           guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInitBoard")as? profileInitController else {return}
           
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
