//
//  HomePageViewController.swift
//  MoviesProject
//
//  Created by Kato on 5/28/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    var topRatedMovies = [TopMovies]()
    var movieDetails = [MovieDetails]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopRatedMovies()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func getTopRatedMovies() {

        let headers = [
            "x-rapidapi-host": "imdb8.p.rapidapi.com",
            "x-rapidapi-key": "c1408f2aa2msh05973b4decb393dp1f669ejsn6af1e9706577"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://imdb8.p.rapidapi.com/title/get-top-rated-movies")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
                
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        guard let resdata = data else {return}
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: resdata, options: [])
            guard let jsonArray = jsonResponse as? [[String: Any]] else {
                  return
            }
            for dic in jsonArray{
                self.topRatedMovies.append(TopMovies(dic)) // adding now value in Model array
            }
            DispatchQueue.main.async {
                self.getDetailedArray()
            }

        } catch {print(error.localizedDescription)}
        })

        dataTask.resume()
        

    }
    
    func getDetailedArray() {
        
        var counter = 0
        let maxCounter = 10

        for item in self.topRatedMovies {
            counter += 1
            self.getDetails(movieIndex: item.id)
            if counter >= maxCounter {
                break
            }
        }
//        self.getDetails(movieIndex: topRatedMovies[0].id)
    }
    
    func getDetails(movieIndex: String) {
        let headers = [
            "x-rapidapi-host": "imdb8.p.rapidapi.com",
            "x-rapidapi-key": "c1408f2aa2msh05973b4decb393dp1f669ejsn6af1e9706577"
        ]
        let movieShortIndex = movieIndex.replacingOccurrences(of: "/title/", with: "")
        let request = NSMutableURLRequest(url: NSURL(string: "https://imdb8.p.rapidapi.com/title/get-details?tconst="+movieShortIndex)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let decoder = JSONDecoder()
                guard let resdata = data else {return}
                let details = try decoder.decode(MovieDetails.self, from: resdata)

                self.movieDetails.append(details)

                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }

            } catch {print(error)}

        })

        dataTask.resume()
    }
    
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homepage_cell", for: indexPath) as! HomePageCell
        
        cell.titleLabel.text = movieDetails[indexPath.row].title
        cell.typeLabel.text = "Type: " + movieDetails[indexPath.row].titleType
        cell.yearLabel.text = "Year: " + String(movieDetails[indexPath.row].year)
        cell.durationLabel.text = "Duration: " + String(movieDetails[indexPath.row].runningTimeInMinutes) + " mins"
        cell.ratingLabel.text = "Rating: " + String(topRatedMovies[indexPath.row].chartRating)
        
        movieDetails[indexPath.row].image.url.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.posterImageView.image = image
            }
        }
 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? HomePageCell
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         
        let displayVC = storyboard.instantiateViewController(withIdentifier: "movie_details_vc")
        
        if let vc = displayVC as? MovieDetailsViewController {
           
            
            vc.displaytitle = self.movieDetails[indexPath.row].title
            vc.titletype = self.movieDetails[indexPath.row].titleType
            vc.year = String(self.movieDetails[indexPath.row].year)
            vc.duration = String(self.movieDetails[indexPath.row].runningTimeInMinutes)
            vc.rating = String(self.topRatedMovies[indexPath.row].chartRating)
            
            let tabbar = self.tabBarController as? MyTabBarController
            
            vc.loggedUser = tabbar!.loggedUsername

            vc.posterimage = cell?.posterImageView.image as! UIImage

        }
        present(displayVC, animated: true, completion: nil)
    }
        
    
}


//extension to download an image via url

extension String {
    
    func downloadImage(completion: @escaping (UIImage?) -> ()) {

        guard let url = URL(string: self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
    
}

struct MovieDetails: Codable {
    
    struct Image: Codable {
        var height: Int
        var id: String
        var url: String
        var width: Int
        
        enum codingKeys: String, CodingKey {
            case height = "height"
            case id = "id"
            case url = "url"
            case width = "width"
        }
    }

    var id: String
    var image: Image
    var runningTimeInMinutes: Int
    var title: String
    var titleType: String
    var year: Int
    
    enum codingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case runningTimeInMinutes = "runningTimeInMinutes"
        case title = "title"
        case titleType = "titleType"
        case year = "year"
    }
    
}


struct TopMovies {
      var id: String
      var chartRating: Double
init(_ dictionary: [String: Any]) {
      self.id = dictionary["id"] as? String ?? ""
      self.chartRating = dictionary["chartRating"] as? Double ?? 0
    }
}



