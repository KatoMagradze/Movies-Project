//
//  WatchListViewController.swift
//  MoviesProject
//
//  Created by Kato on 5/28/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class WatchListViewController: UIViewController {
    
    var userMoviesArr = [UserMovies]()
    var loggedUser = UserAccount()
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tabbar = self.tabBarController as? MyTabBarController
        self.loggedUser = tabbar!.userAccount
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.fetch()
        
    }
    
    
    func fetch() {
        let container = AppDelegate.coreDataContainer
        
        let context = container.viewContext
        let request: NSFetchRequest<UserMovies> = UserMovies.fetchRequest()
        
        self.userMoviesArr.removeAll()
        
        do {
            let result = try context.fetch(request)
            guard let data = result as? [NSManagedObject] else {return}
            
            
            for item in data {
                if let p = item as? UserMovies {
                    
                    if p.username == self.loggedUser.username {
                       self.userMoviesArr.append(p)
                    }
                }
            }
        }
        catch {}
        tableView.reloadData()
    }
    
    func fetchUser(username: String) {
        let context = AppDelegate.coreDataContainer.viewContext
        
        let request: NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
        
        do {
            let userAccount = try context.fetch(request)

            for i in userAccount {
                if i.username == username {
                    self.loggedUser = i
                    break
                }
            }
        } catch {}

    }
    
    func deleteMovie(movie: UserMovies) {
        let context = AppDelegate.coreDataContainer.viewContext

        context.delete(movie)

        do {
            try context.save()
        } catch {}
    }
    
}

extension WatchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMoviesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlist_cell", for: indexPath) as! WatchListCell
        
        cell.titleLabel.text = userMoviesArr[indexPath.row].title
        cell.typeLabel.text = userMoviesArr[indexPath.row].titleType
        cell.yearLabel.text = "Year: " + String(userMoviesArr[indexPath.row].year!)
        cell.durationLabel.text = "Duration: " + String(userMoviesArr[indexPath.row].duration!) + " mins"
        cell.ratingLabel.text = "Rating: " + String(userMoviesArr[indexPath.row].rating!)
        
        cell.moviePoster.image = UIImage(data: userMoviesArr[indexPath.row].poster!)
        
        
        return cell
    }
    
}

extension WatchListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            self.deleteMovie(movie: self.userMoviesArr[indexPath.row])
            
            self.userMoviesArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        
        return config
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//            let cell = tableView.cellForRow(at: indexPath) as? WatchListCell
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//             let displayVC = storyboard.instantiateViewController(withIdentifier: "movie_details_vc")
//
//            if let vc = displayVC as? MovieDetailsViewController {
//
//
//                vc.displaytitle = self.userMoviesArr[indexPath.row].title!
//                vc.titletype = self.userMoviesArr[indexPath.row].titleType!
//                vc.year = String(self.userMoviesArr[indexPath.row].year!)
//                vc.duration = String(self.userMoviesArr[indexPath.row].runningTimeInMinutes)
//                vc.rating = String(self.topRatedMovies[indexPath.row].chartRating)
//
//                let tabbar = self.tabBarController as? MyTabBarController
//
//                vc.loggedUser = tabbar!.loggedUsername
//
//                vc.posterimage = cell?.posterImageView.image as! UIImage
//
//            }
//            present(displayVC, animated: true, completion: nil)
//        }
        
}
