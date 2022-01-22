//
//  ViewController.swift
//  WeekPracticeKeychain
//
//  Created by 양호준 on 2022/01/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lookDiaryButton: UIButton!
    @IBOutlet weak var registerNewPasswordButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchUpInsideLookDiaryButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Diary", bundle: nil)
        let diaryViewController = storyboard.instantiateViewController(withIdentifier: "Diary")
        
        present(diaryViewController, animated: true, completion: nil)
    }
    
}

