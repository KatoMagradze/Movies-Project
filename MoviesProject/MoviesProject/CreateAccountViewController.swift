//
//  CreateAccountViewController.swift
//  MoviesProject
//
//  Created by Kato on 5/27/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var backToLogInButton: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 5
            userImageView.layer.borderColor = UIColor.gray.cgColor
            userImageView.layer.borderWidth = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAccountButton.layer.cornerRadius = 5
        backToLogInButton.layer.cornerRadius   = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageVIewTapped))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    @objc func onImageVIewTapped() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        
        self.save()
        
        if let accountVC = self.navigationController?.viewControllers.first {
            
            self.navigationController?.popToViewController(accountVC, animated: true)
        }
    }

    @IBAction func backToLogInTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension CreateAccountViewController {
    func save() {
        let context = AppDelegate.coreDataContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "UserAccount", in: context)
        let userObject = NSManagedObject(entity: entityDescription!, insertInto: context)
        
        userObject.setValue(firstNameTextField.text!, forKey: "firstname")
        userObject.setValue(lastNameTextField.text!, forKey: "lastname")
        userObject.setValue(usernameTextField.text!, forKey: "username")
        userObject.setValue(emailTextField.text!, forKey: "email")
        userObject.setValue(passwordTextField.text!, forKey: "password")
        
        if let binaryImage = userImageView.image?.pngData() {
            userObject.setValue(binaryImage, forKey: "profilepicture")
        }
        
        do {
            try context.save()
            print("account created")
        }
        catch {
            print("failed")
        }
        
    }
}

extension CreateAccountViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.userImageView.image = image
        }
        
        self.dismiss(animated: true)
    }
}
