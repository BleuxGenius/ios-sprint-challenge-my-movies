//
//  MovieSearchTableViewController.swift
//  MyMovies
//
//  Created by Dani on 8/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

//completed project submit to github updated

import UIKit

class MovieSearchTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        movieController.searchForMovie(with: searchTerm) { (error) in
            
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieController.searchedMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        cell.textLabel?.text = movieController.searchedMovies[indexPath.row].title
        
        return cell
    }
    
    var movieController = MovieController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addMovieButton(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell,
            let title = cell.textLabel?.text,
                    !title.isEmpty
                    else {
                        print("The movie has not added")
                        return }
        print("Yes \(title) has been added ")
        
        }
   
        
}
