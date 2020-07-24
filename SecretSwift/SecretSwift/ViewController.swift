//
//  ViewController.swift
//  SecretSwift
//
//  Created by Ma Xueyuan on 2020/07/24.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var secret: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @IBAction func authenticate(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Enter password!", message: nil, preferredStyle: .alert)
            ac.addTextField { (textField) in
                textField.textContentType = .password
                textField.isSecureTextEntry = true
            }
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned ac, unowned self] (action) in
                guard let input = ac.textFields?.first?.text else { return }
                guard let password = KeychainWrapper.standard.string(forKey: "Password") else { return }
                if input == password {
                    self.unlockSecretMessage()
                } else {
                    let ac2 = UIAlertController(title: "Wrong password", message: "Please try again.", preferredStyle: .alert)
                    ac2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac2, animated: true)
                }
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(ac, animated: true)
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        doneButton.isEnabled = true
        title = "Secret stuff!"

        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @IBAction func saveSecretMessage() {
        guard secret.isHidden == false else { return }

        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        doneButton.isEnabled = false
        title = "Nothing to see here"
    }
}

