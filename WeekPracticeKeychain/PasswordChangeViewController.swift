//
//  PasswordChangeViewController.swift
//  WeekPracticeKeychain
//
//  Created by 양호준 on 2022/01/22.
//

import UIKit

class PasswordChangeViewController: UIViewController {
    @IBOutlet weak var originPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpInsideChangePasswordButton(_ sender: UIButton) {
        guard let inputPassword = newPasswordTextfield.text else { return }
        let credential = Keychain.Credentials(password: inputPassword) // 암호화된 정보가 Data
        guard let password = credential.password.data(using: .utf8) else { return }
        var matchQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // 암호화된 정보를 어디에 넣을 지를 정함(어떤 질문인지 정함)
            kSecValueData as String: password // 내가 여기 넣을 데이터는 password야.
        ]
        var updateQuery: [String: Any] = [
            kSecValueData as String: password // 내가 여기 넣을 데이터는 password야.
        ]
        guard let inputOriginPassword = originPasswordTextfield.text else { return }
        var item: CFTypeRef?
        let status = SecItemCopyMatching(matchQuery as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            showAlert(message: "비밀번호 생성해줘")
            return
        }
        guard let existingItem = item as? [String:Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let originPassword = String(data: passwordData, encoding: .utf8),
              inputOriginPassword == originPassword else {
                  showAlert(message: "비밀번호를 다시 확인해주세요")
                  return
              }
        let editstatus = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
        guard editstatus == errSecSuccess else {
            showAlert(message: "비밀번호 변경 실패")
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
}
