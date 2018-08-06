//
//  ApplicationLoader.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 02.08.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

class ApplicationLoader: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if DataManager.shared.currentUser == nil {
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "SignIn", sender: self)
        } else {
            WebSocketManager.shared.connect()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
