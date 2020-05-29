//
//  MyTabBarController.swift
//  MoviesProject
//
//  Created by Kato on 5/27/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var loggedUsername = ""
    var userAccount = UserAccount()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.fetchUser()
        // Do any additional setup after loading the view.
    }
    
    func fetchUser() {
        let context = AppDelegate.coreDataContainer.viewContext
        
        let request: NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
        
        do {
            let userAccount = try context.fetch(request)

            for i in userAccount {
                if i.username == loggedUsername {
                    self.userAccount = i
                    break
                }
            }
        } catch {}
    }


}
