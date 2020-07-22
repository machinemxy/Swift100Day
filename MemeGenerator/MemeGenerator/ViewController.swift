//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Ma Xueyuan on 2020/07/22.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    var originImage: UIImage? {
        didSet {
            imageView.image = originImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func share() {
        guard let processedImage = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "Please import a image first.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        guard let imgData = processedImage.pngData() else { return }
        
        let vc = UIActivityViewController(activityItems: [imgData], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    @IBAction func apply(_ sender: Any) {
        guard let topString = topText.text else { return }
        guard let bottomString = bottomText.text else { return }
        guard let originImage = originImage else { return }
        
        let renderer = UIGraphicsImageRenderer(size: originImage.size)
        let processedImage = renderer.image { (context) in
            originImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 72), .paragraphStyle: paragraphStyle, .foregroundColor: UIColor.white]
            let attributedTopString = NSAttributedString(string: topString, attributes: attrs)
            let attributedBottomString = NSAttributedString(string: bottomString, attributes: attrs)
            let maxHeight = originImage.size.height
            let maxWidth = originImage.size.width
            attributedTopString.draw(with: CGRect(x: 0, y: 0, width: maxWidth, height: 100), options: .usesLineFragmentOrigin, context: nil)
            attributedBottomString.draw(with: CGRect(x: 0, y: maxHeight - 100, width: maxWidth, height: 100), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = processedImage
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        originImage = image
        dismiss(animated: true)
    }
}
