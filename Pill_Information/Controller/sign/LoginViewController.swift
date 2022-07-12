//
//  ViewController.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/06/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
//import FirebaseStorage
import AuthenticationServices
import CryptoKit
import GoogleSignIn


// MARK: - Apple Login

private var currentNonce: String?
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            /*
             Nonce 란?
             - 암호화된 임의의 난수
             - 단 한번만 사용할 수 있는 값
             - 주로 암호화 통신을 할 때 활용
             - 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
             - 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
             */
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                ///Main 화면으로 보내기
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
                mainViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.show(mainViewController, sender: nil)
            }
        }
    }
}


// Apple Sign in
extension LoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
// 애플 로그인 끝



// MARK: - LoginViewController

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnEmailLogin: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    @IBOutlet weak var btnFaceBookLogin: UIButton!
    @IBOutlet weak var btnGitHubLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
    }
    
    /// 구글 로그인 버튼이 실행될 때 웹 뷰가 필요함.
    override func viewWillAppear(_ animated: Bool) {
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
    }

    
    /// 로그인 체크
    func checkLogin() {
        
        let uid:String?
        let pwd:String?
        
        // 자동 로그인 실행
        if let userEmail = UserDefaults.standard.string(forKey: "email") {
            print("\n\n자동 로그인 체크\n\n")
            uid = userEmail
            pwd = UserDefaults.standard.string(forKey: "pwd")
            Auth.auth().signIn(withEmail: uid!, password: pwd!) { (user, error) in
                if user != nil {
                    self.changeView(viewName: "main")
                } else {
                    self.messageAlert(controllerTitle: "로그인 실패", controllerMessage: "로그인 실패", actionTitle: "확인")
                }
            }
        }
        
        // 로그인이 되어있다면 메인 화면으로 전환
        let user = Auth.auth().currentUser
        if user == nil {
            print("\n\n user is nil \n\n")
        } else {
            changeView(viewName: "main")
        }
    }
    
    
    /// 애플 로그인
    /// - Parameter sender: btnAppleLogin
    @IBAction func appleLogin(_ sender: UIButton) {
        startSignInWithAppleFlow()
    }

    
    /// 구글 로그인
    /// - Parameter sender: btnGoogleLogin
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    /// 이메일 로그인
    /// - Parameter sender: btnEmailLogin
    @IBAction func emailLogin(_ sender: UIButton) {
        changeView(viewName: "email")
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
    
    
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "main" { // 메인 화면 전환
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MainBoard")as? UITabBarController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        } else if viewName == "email" { // 이메일 로그인 화면 전환
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginBoard")as? EmailLoginController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        }
    }

}

