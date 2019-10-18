//
//  MyMoviesTableViewCell.swift
//  MyMovies
//
//  Created by Lambda_School_Loaner_167 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class MyMoviesTableViewCell: UITableViewCell {
    
//    MARK: - Properties & Outlets

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var hasWatchedButton: UIButton!
    
    var movieController: MovieController?
    var movieRep: MovieRepresentation?
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }
    
//     MARK: - View LifeCycle 
    func updateViews() {
        guard let movie = movie else { return }
        movieTitleLabel.text = movie.title
        if movie.hasWatched == true {
            hasWatchedButton.setTitle("Watched", for: .normal)
        } else {
            hasWatchedButton.setTitle("Unwatched", for: .normal)
        }
    }
    
//    MARK: - Actions
    
    @IBAction func hasWatchedButtonPressed(_ sender: Any) {
        
        guard let movie = movie else { return }
        movie.hasWatched = !movie.hasWatched
        movieController?.updateMovie(movie: movie)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
