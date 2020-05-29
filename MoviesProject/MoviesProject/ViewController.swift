//
//  ViewController.swift
//  MoviesProject
//
//  Created by Kato on 5/27/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.cornerRadius          = 5
        createAccountButton.layer.cornerRadius  = 5
        // Do any additional setup after loading the view.
    }

    @IBAction func logInTapped(_ sender: UIButton) {
        
        if getUser(username: usernameTextField.text!, password: passwordTextField.text!) {
                   
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let temp = storyboard.instantiateViewController(withIdentifier: "tab_bar_vc")
                   
            if let vc = temp as? MyTabBarController {
                vc.loggedUsername = usernameTextField.text!
            }
                   
            self.navigationController?.pushViewController(temp, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Try Again", message: "Incorrect username or password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func createNewAccountTapped(_ sender: UIButton) {
        
    }
    
}

extension ViewController {
    func getUser(username: String, password: String) -> Bool {
        
        var returnValue = false
        
        let container = AppDelegate.coreDataContainer
        
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAccount")
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let data = result as? [NSManagedObject] else {return false}
            
            for item in data {
                if let p = item as? UserAccount {
                    if username == p.username && password == p.password {
                        returnValue = true
                        break
                    }
                }
            }
        }
        catch {}
        
        
        return returnValue
    }
}

