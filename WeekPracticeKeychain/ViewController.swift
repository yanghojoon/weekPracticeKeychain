//
//  ViewController.swift
//  WeekPracticeKeychain
//
//  Created by 양호준 on 2022/01/22.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchUpInsideLookDiaryButton(_ sender: UIButton) {
        presentViewController(of: "Diary", style: .fullScreen)
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

