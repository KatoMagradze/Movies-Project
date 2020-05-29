//
//  EditProfileViewController.swift
//  MoviesProject
//
//  Created by Kato on 5/28/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var newFirstNameTextField: UITextField!
    @IBOutlet weak var newLastNameTextField: UITextField!
    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var newPictureImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var userToUpdate = UserAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageVIewTapped))
        newPictureImageView.isUserInteractionEnabled = true
        newPictureImageView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    @objc func onImageVIewTapped() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let t = self.tabBarController as? MyTabBarController
        self.userToUpdate = t!.userAccount
        
        self.newFirstNameTextField.text! = self.userToUpdate.firstname!
        self.newLastNameTextField.text! = self.userToUpdate.lastname!
        self.newUsernameTextField.text! = self.userToUpdate.username!
        self.newEmailTextField.text! = self.userToUpdate.email!
        self.newPasswordTextField.text! = self.userToUpdate.password!
        
        self.newPictureImageView.image = UIImage(data: self.userToUpdate.profilepicture!)
        
        
    }

    @IBAction func onUpdateTapped(_ sender: UIButton) {
        let context = AppDelegate.coreDataContainer.viewContext
        
        self.userToUpdate.firstname = self.newFirstNameTextField.text!
        self.userToUpdate.lastname = self.newLastNameTextField.text!
        self.userToUpdate.username = self.newUsernameTextField.text!
        self.userToUpdate.email = self.newEmailTextField.text!
        self.userToUpdate.password = self.newPasswordTextField.text!
        
        do {
            try context.save()
            print("Updated")
        } catch {}

    }
}

extension EditProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.newPictureImageView.image = image
        }
        
        self.dismiss(animated: true)
    }
}
