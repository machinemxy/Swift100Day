//
//  MemoDetailViewController.swift
//  MemoNote
//
//  Created by Ma Xueyuan on 2020/07/02.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

enum RewindReason {
    case save
    case delete
}

class MemoDetailViewController: UIViewController {
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDetail: UITextView!
    
    var memo: Memo?
    var rewindReason: RewindReason?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure title
        title = "Memo"
        
        // configure txtDetail
        txtDetail.layer.borderWidth = 1
        txtDetail.layer.borderColor = UIColor.placeholderText.cgColor
        txtDetail.layer.cornerRadius = 5
        
        // init data
        if let memo = memo {
            txtTitle.text = memo.title
            txtDetail.text = memo.detail
        }
        
        // set right button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActions))
        
        // keyboard related
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func showActions() {
        let ac = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [unowned self] (_) in
            self.save()
        }))
        
        if memo != nil {
            ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] (_) in
                self.delete()
            }))
        }
        
        ac.addAction(UIAlertAction(title: "Share", style: .default, handler: { [unowned self] (_) in
            self.share()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func save() {
        if memo == nil {
            memo = Memo()
        }
        
        if let title = txtTitle.text {
            memo?.title = title
        }
        if let detail = txtDetail.text {
            memo?.detail = detail
        }
        memo?.editTime = Date()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(memo!)
            let documentDirectory = FileManager.default.getDocumentsDirectory()
            let memoURL = documentDirectory.appendingPathComponent(memo!.id)
            try data.write(to: memoURL)
        } catch {
            print(error.localizedDescription)
        }
        
        self.rewindReason = .save
        self.performSegue(withIdentifier: "unwind", sender: nil)
    }
    
    func delete() {
        guard let memo = memo else { return }
        
        let documentDirectory = FileManager.default.getDocumentsDirectory()
        let memoURL = documentDirectory.appendingPathComponent(memo.id)
        do {
            try FileManager.default.removeItem(at: memoURL)
        } catch {
            print(error.localizedDescription)
        }
        
        self.rewindReason = .delete
        self.performSegue(withIdentifier: "unwind", sender: nil)
    }
    
    func share() {
        var activityItems = [Any]()
        if let title = txtTitle.text {
            activityItems.append(title)
        }
        if let detail = txtDetail.text {
            activityItems.append(detail)
        }
        
        let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            txtDetail.contentInset = .zero
        } else {
            txtDetail.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        txtDetail.scrollIndicatorInsets = txtDetail.contentInset
        
        let selectedRange = txtDetail.selectedRange
        txtDetail.scrollRangeToVisible(selectedRange)
    }
}
