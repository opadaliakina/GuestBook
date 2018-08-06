//
//  NewReview.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 31.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

class NewReview: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions

    @IBAction func postReview(_ sender: Any?) {
        if textView.text.isEmpty {
            return
        }
        let newComment = Comment()
        newComment.message = textView.text
        newComment.title = textField.text ?? "Empty Title"
        DataManager.shared.createComment(newComment) { (success) in
            print("success")
            self.textField.text = ""
            self.textView.text = ""
        }
    }
}

extension NewReview: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn  range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
