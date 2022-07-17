//
//  AddTimerViewController.swift
//  Pill_Information
//
//  Created by 한소희 on 2022/07/15.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class AddTimerViewController: UIViewController {
    @IBOutlet var TimerPicker: UIDatePicker!
    @IBOutlet var lblLeftTime: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var ProgressView: UIProgressView!
    
    var duration = 60
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStartButton()
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.lblLeftTime.isHidden = isHidden
        self.ProgressView.isHidden = isHidden
    }
    
    func configureStartButton() {
        self.startButton.setTitle("시작", for: .normal)
        self.startButton.setTitle("일시정지", for: .selected)
    }
    
    func startTimer() {
        if self.timer == nil
        {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: {[weak self] in
                guard let self = self else {return}
                self.currentSeconds -= 1
                
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                
                self.lblLeftTime.text = String(format: "%02d : %02d : %02d", hour, minutes, seconds)
                self.ProgressView.progress = Float(self.currentSeconds) / Float(self.duration)
                
                if self.currentSeconds <= 0
                {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                }
                
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        if self.timerStatus == .pause
        {
            self.timer?.resume()
        }
        
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.lblLeftTime.alpha = 0
            self.ProgressView.alpha = 0
            self.TimerPicker.alpha = 1
        })
        self.startButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
    }
    
    @IBAction func btnStart(_ sender: UIButton) {
        self.duration = Int(self.TimerPicker.countDownDuration)
        
        switch self.timerStatus
        {
        case .end :
            self.currentSeconds = self.duration
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5, animations: {
                self.lblLeftTime.alpha = 1
                self.ProgressView.alpha = 1
                self.TimerPicker.alpha = 0
            })
            self.startButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
            
        case .start :
            self.timerStatus = .pause
            self.startButton.isSelected = false
            self.timer?.suspend()
            
        case .pause :
            self.timerStatus = .start
            self.startButton.isSelected = true
            self.timer?.resume()
            
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        switch self.timerStatus
        {
        case .start, .pause : self.stopTimer()
        default : break
        }
    }
    
    @IBAction func btnGoBack(_ sender: UIBarButtonItem) {
        changeView(viewName: "Alram")
    }
     
    /// 화면 전환 함수
    /// - Parameter viewName: 어떤 화면을 전환할지 정할 문자열
    func changeView(viewName: String) {
        if viewName == "Alram" {
            guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MainBoard")as? UITabBarController else {return}
            
            vcName.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            vcName.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(vcName, animated: true, completion: nil)
        }
    }
}


    /// Alert 출력
    /// - Parameters:
    ///   - controllerTitle: Alert Title
    ///   - controllerMessage: Alert Message
    ///   - actionTitle: action(button content)
    ///   /*
   /* func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
        let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertCon.addAction(alertAct)
        present(alertCon, animated: true, completion: nil)
    }
*/

