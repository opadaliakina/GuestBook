//
//  SignUp.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 02.08.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

class SignUp: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: Any?) {
        if let email = self.emailField.text,
            let pass = self.passwordField.text,
            let name = self.nameField.text {
            DataManager.shared.signUp(withEmail: email, name: name, password: pass) { (user) in
                DataManager.shared.currentUser = user
                if user != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
