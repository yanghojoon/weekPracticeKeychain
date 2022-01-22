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
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true, // 얘를 왜 넣어줘야 되는 걸까?
            kSecReturnData as String: true
        ]
        guard let inputPassword = passwordTextField.text else { return }
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item) // item의 reference를 넘겨줌 결과도 item의 reference로
        guard status != errSecItemNotFound else {
            return
            showAlert(message: "비밀번호 생성해줘")
        }
        guard let existingItem = item as? [String:Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let originPassword = String(data: passwordData, encoding: .utf8),
              inputPassword == originPassword else {
                  showAlert(message: "다른 사람의 일기장을 보면 안돼 🖐🏻")
                  return
              }
        
        presentViewController(of: "Diary", style: .fullScreen)
    }
    
    @IBAction func touchUpInsideRegisterPasswordButton(_ sender: UIButton) { // 이미 등록한 것에 대해선 수정이나 삭제를 하고 등록해야 함. account와 password 둘 다 있을 때 비번만 수정해도 다시 실행 안됨 ios에서 keychain이 하나 밖에 없다. 번들 단위(앱 하나)로 키체인이 작동한다. keychain이 하나라는 것은 ios가 훨씬 엄격하다는 것 운영체제를 해킹하지 않는 한 keychain에 접근할 수 없다.
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

