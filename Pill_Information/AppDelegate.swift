//
//  AppDelegate.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var ref: DatabaseReference!
    
    // MARK: - 낱알 정보 API
//
//    struct pillData: Decodable{
//        let header: HeaderData
//        let body: BodyData
//    }
//
//    struct HeaderData: Decodable {
//        let resultCode: String
//        let resultMsg: String
//    }
//
//    struct BodyData: Decodable {
//        let pageNo: Int
//        let totalCount: Int
//        let numOfRows: Int
//        let items: [Data]
//    }
//
//    struct Data: Decodable{
//        let resultCode: String? // 결과 코드
//        let resultMsg: String? // 결과 메세지
//        let numOfRows: String? // 한 페이지 결과 수
//        let pageNo: String? // 페이지 번호
//        let totalCount: String? // 전체 결과 수
//        let entpName: String? // 업체명
//
//        let itemName: String? //제품명
//        let itemSeq: String? //품목기준코드
//
//        let efcyQesitm: String? // 효능
//        let useMethodQesitm:String? // 사용법
//        let atpnWarnQesitm: String? // 주의사항, 경고
//        let atpnQesitm: String? // 주의사항
//        let intrcQesitm: String? // 상호작용
//        let seQesitm: String? // 부작용
//        let depositMethodQesitm: String? // 보관법
//        let openDe: String? // 공개일자
//        let updateDe: String? // 수정일자
//        let itemImage: String? // 낱알 이미지
//    }
//
//
//    func getDrbEasyDrugList() {
//        for i in 1...45 {
//            if let url = URL(string:"http://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=LK5HxMQO7ScyFpgYc6%2BQgNRsqPfAKmnW1fczw8kHYE4BDXCaUX7uBUrZXK6wXoDnS5vivk2h0fYiboTWVjRjvQ%3D%3D&pageNo=1&startPage=\(i)&numOfRows=100&type=json") {
//                let request = URLRequest.init(url: url)
//
//                URLSession.shared.dataTask(with: request) {
//                    (data, response, error) in guard let data = data else {return}
//                    let decoder = JSONDecoder()
//                    do{
//                        let json = try decoder.decode(pillData.self , from: data)
//                        print("json:")
//                        print(json)
//                        self.saveJsonDatabase(json: json)
//                    }
//                    catch{
//                        print("API 에러")
//                        print(error)
//                    }
//                }.resume()
//            }
//        }
//    }
//
//    func saveJsonDatabase(json: AppDelegate.pillData) {
//        let data = json.body.items
//        print("\n\n\nitemName:")
//        print(data[0])
//
////        Database.database().reference().child("Data").child("").setValue(
////            ["itemName":"123"])
//    }

    
    // MARK: - 의약품 정보 API
    
    
//    func getDrbEasyDrugList() {
//        if let url = URL(string:"http://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=LK5HxMQO7ScyFpgYc6%2BQgNRsqPfAKmnW1fczw8kHYE4BDXCaUX7uBUrZXK6wXoDnS5vivk2h0fYiboTWVjRjvQ%3D%3D&pageNo=1&startPage=1&numOfRows=3&type=json") {
//            let request = URLRequest.init(url: url)
//
//            print("url:")
//            URLSession.shared.dataTask(with: request) {
//                (data, response, error) in guard let data = data else {return}
//                let decoder = JSONDecoder()
//                print(response as Any)
//                do{
//                    let json = try decoder.decode(pillData.self , from: data)
//                    print("json:")
//                     print(json)
////                    self.returnData = String(json!)
//                }
//                catch{
//                    print("error")
//                    print(error)
////                    self.returnError = String(error!)
//                }
//            }.resume()
//        }
//    }
//

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // Google 로그인 Delgate 초기화
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
//        getDrbEasyDrugList()
        
//        getDrbEasyDrugList()
        return true
    }
    
    // MARK: - GoogleLogin
    
    // Google 로그인 인증 후 전달된 값 가져오기
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // 에러 처리
        if let error = error {
            print("ERROR Google Sign In \(error.localizedDescription)")
            return
        }
        
        // 사용자 인증값 가져오기
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        // Firebase Auth에 인증정보 등록하기
        Auth.auth().signIn(with: credential) { _, _ in
            self.showMainViewController()   // 메인 화면으로 이동
        }
    }
    
    // 메인 화면으로 이동하기
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "MainBoard", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainBoard")
        mainViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 구글의 인증 프로세스가 끝날 때 앱이 수신하는 url 처리
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

