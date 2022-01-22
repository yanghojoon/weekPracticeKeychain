//
//  ViewController.swift
//  WeekPracticeKeychain
//
//  Created by 양호준 on 2022/01/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchUpInsideLookDiaryButton(_ sender: UIButton) {
        var query: [String: Any] = [ // query 질의 -> 물어보는 것. 듣는 쪽은 키체인이고 말하는 것은 우리
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnData as String: true
        ]
//        guard inputPassword == SecItemCopyMatching(<#T##query: CFDictionary##CFDictionary#>, <#T##result: UnsafeMutablePointer<CFTypeRef?>?##UnsafeMutablePointer<CFTypeRef?>?#>)
        presentViewController(of: "Diary", style: .fullScreen)
    }
    
    @IBAction func touchUpInsideRegisterPasswordButton(_ sender: UIButton) { // 이미 등록한 것에 대해선 수정이나 삭제를 하고 등록해야 함. account와 password 둘 다 있을 때 비번만 수정해도 다시 실행 안됨 ios에서 keychain이 하나 밖에 없다. 번들 단위(앱 하나)로 키체인이 작동한다. 같은
        guard let inputPassword = passwordTextField.text else { return }
        let credential = Keychain.Credentials(password: inputPassword) // 암호화된 정보가 Data
        guard let password = credential.password.data(using: .utf8) else { return }
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // 암호화된 정보를 어디에 넣을 지를 정함(어떤 질문인지 정함)
            kSecValueData as String: password // 내가 여기 넣을 데이터는 password야.
        ]
        print(query)
        let status = SecItemAdd(query as CFDictionary, nil) // itemAdd를 한 후 어떤 상태인지를 표현해줌. 결과값은 OS Status
        // 사후 처리는 Alert를 띄워주던지 아니면 다른 것을 해주던지
        guard status == errSecSuccess else {
            return
        }
    }
    
    @IBAction func touchUpInsideChangePasswordButton(_ sender: Any) {
        presentViewController(of: "PasswordChange", style: .formSheet)
    }
    
    private func presentViewController(of identifier: String, style: UIModalPresentationStyle) {
        let storyboard = UIStoryboard(name: "\(identifier)", bundle: nil)
        let diaryViewController = storyboard.instantiateViewController(
            withIdentifier: "\(identifier)"
        )
        diaryViewController.modalPresentationStyle = style
        
        present(diaryViewController, animated: true, completion: nil)
    }
}

extension ViewController {
    func showAlert() {
        let alert = UIAlertController(
            title: "비밀번호가 틀렸습니다.",
            message: "다른 사람의 일기장을 보면 안돼 🖐🏻",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
