//
//  ViewController.swift
//  SOPT_week3_exercise3
//
//  Created by 윤동민 on 2019/10/12.
//  Copyright © 2019 윤동민. All rights reserved.
//

import UIKit

extension UIView {
    func setCornerRadius() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    func setBorderWidth() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idTopContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addKeyboardObserver()
        idTextField.delegate = self
        pwTextField.delegate = self
        loginButton.setCornerRadius()
        loginButton.setBorderWidth()
    }
    @IBAction func doLogin(_ sender: Any) {
        // 로그인 서버 통신 구현 코드
        //guard는 서버 통신이 일어나기 전에
            guard let id = idTextField.text else { return }
            guard let pwd = pwTextField.text else { return }
            
        //shared loginservice 덕분에 아이디와 패스워드 파라메터 값에 넣을 수 있다.
        
            LoginService.shared.login(id, pwd) {
                data in
                
                switch data {
                    
                case .success(let data):
                    
                    // DataClass 에서 받은 유저 정보 반환
                    let user_data = data as! DataClass
                    
                    // 사용자의 토큰, 이름, (이메일), 전화번호 받아오기
                    // 비밀번호는 안 받아와도 됨 -> 사용안하니까. 만약 사용한다면, 비밀번호 변경시에
                    // UserDefaults???
                    UserDefaults.standard.set(user_data.userIdx, forKey: "token")
                    UserDefaults.standard.set(user_data.name, forKey: "name")
                    UserDefaults.standard.set(user_data.phone, forKey: "phone")
                    
//                    let main = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
//                    self.present(main, animated: true)
                    
                case .requestErr(let message): break
//                    self.simpleAlert(title: "로그인 실패", message: "\(message)")
                    
                case .pathErr:
                    print(".pathErr")
                    
                case .serverErr:
                    print(".serverErr")
                    
                case .networkFail: break
                   // self.simpleAlert(title: "로그인 실패", message: "네트워크 상태를 확인해주세요.")
                }
            }
        }
    }


extension ViewController: UITextFieldDelegate {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(upKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func upKeyboard() {
        self.view.frame.origin.y = CGFloat(-UtilValue.keyboardHeight)
        
    }
    
    @objc func downKeyboard() {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
