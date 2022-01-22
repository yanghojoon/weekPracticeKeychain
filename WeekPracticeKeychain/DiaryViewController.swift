//
//  DiaryViewController.swift
//  WeekPracticeKeychain
//
//  Created by 양호준 on 2022/01/22.
//

import UIKit

class DiaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func touchUpInsideLockButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
