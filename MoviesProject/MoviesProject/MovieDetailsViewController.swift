//
//  MovieDetailsViewController.swift
//  MoviesProject
//
//  Created by Kato on 5/29/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailsViewController: UIViewController {
    
    var moviesArr = [UserMovies]()
    
    var loggedUser = ""

    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var displaytitle = ""
    var titletype = ""
    var year = ""
    var duration = ""
    var rating = ""
    
    var posterimage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = displaytitle
        typeLabel.text = "Type: \(titletype)"
        yearLabel.text = "Year: \(year)"
        durationLabel.text = "Duration: \(duration) minutes"
        ratingLabel.text = "Rating: \(rating)"
        
        moviePoster.image = posterimage

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func addToWatchListTapped(_ sender: UIButton) {
        
        self.save()
        
        //self.navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)

        
    }
    
    func save() {
        let context = AppDelegate.coreDataContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "UserMovies", in: context)
        let userMovieObject = NSManagedObject(entity: entityDescription!, insertInto: context)
        
        userMovieObject.setValue(displaytitle, forKey: "title")
        userMovieObject.setValue(titletype, forKey: "titleType")
        userMovieObject.setValue(year, forKey: "year")
        userMovieObject.setValue(duration, forKey: "duration")
        userMovieObject.setValue(rating, forKey: "rating")
        
        userMovieObject.setValue(loggedUser, forKey: "username")
        
        
        if let binaryImage = posterimage.pngData() {
            userMovieObject.setValue(binaryImage, forKey: "poster")
        }
       
        do {
            try context.save()
            print("success")
        }
        catch {
            print("failed")
        }
    }
    
}


