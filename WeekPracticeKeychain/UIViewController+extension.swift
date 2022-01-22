//
//  UIViewController+extension.swift
//  WeekPracticeKeychain
//
//  Created by 양호준 on 2022/01/22.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "비밀번호 오류",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
