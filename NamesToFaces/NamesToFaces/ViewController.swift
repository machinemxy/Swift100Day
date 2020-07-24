//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Ma Xueyuan on 2020/06/08.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController {
    var people = [Person]()
    var isLocked = true {
        didSet {
            navigationItem.leftBarButtonItem?.isEnabled = !isLocked
            navigationItem.rightBarButtonItem?.isEnabled = isLocked
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlock", style: .plain, target: self, action: #selector(unlock))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(lock), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func unlock() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self?.isLocked = false
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Not supported", message: "Your device is not supported. Please give up using this app.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func lock() {
        isLocked = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLocked {
            return 0
        }
        
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        cell.imageView.image = FileManager.default.getImageInDocumentsDirectory(imageName: person.image)
        cell.imageView.layer.borderColor = UIColor.systemGray5.cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let sheet = UIAlertController(title: "Method", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { [unowned self] (_) in
            self.getImageFromCamera()
        }))
        sheet.addAction(UIAlertAction(title: "From Library", style: .default, handler: { [unowned self] (_) in
            self.getImageFromLibrary()
        }))
        sheet.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(sheet, animated: true)
    }
    
    func getImageFromCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getImageFromLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "View", style: .default, handler: { [unowned self] _ in
            self.view(at: indexPath)
        }))
        sheet.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [unowned self] _ in
            self.rename(at: indexPath)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] _ in
            self.delete(at: indexPath)
        }))
        sheet.popoverPresentationController?.sourceView = view
        sheet.popoverPresentationController?.sourceRect = collectionView.cellForItem(at: indexPath)!.frame
        present(sheet, animated: true)
    }
    
    func view(at indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else { return }
        let person = people[indexPath.item]
        detailVC.person = person
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func rename(at indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self, unowned ac] (_) in
            guard let newName = ac.textFields?[0].text else { return }
            person.name = newName
            self.save()
            self.collectionView.reloadItems(at: [indexPath])
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func delete(at indexPath: IndexPath) {
        let imageName = people[indexPath.item].image
        let imagePath = FileManager.default.getDocumentsDirectory().appendingPathComponent(imageName)
        people.remove(at: indexPath.item)
        try? FileManager.default.removeItem(at: imagePath)
        self.save()
        collectionView.deleteItems(at: [indexPath])
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = FileManager.default.getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
}
