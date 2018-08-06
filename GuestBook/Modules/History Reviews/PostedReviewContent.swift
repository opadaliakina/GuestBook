//
//  PostedReviewContent.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 31.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

class PostedReviewContent: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var createAnswerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var adminTextView: UITextView!
    
    var pageIndex : Int = 0
    var comment: Comment?
    var answers: [Answer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.text = self.comment?.title
        self.textView.text = self.comment?.message ?? ""
        
        if !DataManager.shared.currentUser!.isAdmin {
            stackView.arrangedSubviews[0].isHidden = true
        }

        self.loadAnswers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(answerAdded(_:)), name: Notification.Name.init("answer_added_\(self.comment!.id!)"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func answerAdded(_ notification: NSNotification) {
        guard let answer = notification.userInfo?["answer"] as? Answer else {
            return
        }
        self.answers.insert(answer, at: 0)
        self.tableView.reloadData()
    }
    
    func loadAnswers() {
        guard let comment = self.comment else {
            return
        }
        DataManager.shared.getAnswers(for: comment) { (result) in
            self.answers = result
            self.tableView.reloadData()
        }
    }

    @IBAction func sendAnswer(_ sender: Any?) {
        guard !adminTextView.text.isEmpty else {
            return
        }
        let answer = Answer()
        answer.message = adminTextView.text
        guard self.comment?.id != nil else {
            return
        }
        DataManager.shared.createAnswer(answer, for: self.comment!) { (success) in
            if success {
                self.adminTextView.text = ""
                self.loadAnswers()
            }
        }
    }
}

extension PostedReviewContent: UITableViewDelegate {
    
}

extension PostedReviewContent: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        let textView = cell.viewWithTag(101) as? UITextView
        let answer = self.answers[indexPath.row]
        textView?.text = answer.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension PostedReviewContent: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn  range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
