//
//  MovieSearchTableViewCell.swift
//  MyMovies
//
//  Created by Lambda_School_Loaner_167 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class MovieSearchTableViewCell: UITableViewCell {
    
//    MARK: - Properties & Outlets
    
    var movieController: MovieController?
    var movieRep: MovieRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var addMovieButton: UIButton!
    
//    MARK: - Actions
    
    @IBAction func addMovieButtonPressed(_ sender: Any) {
        guard let movieController = movieController, let movie = movieRep else { return }
        
        movieController.createMovie(title: movie.title)
    }

//    MARK: - View Life Cycle
    func updateViews() {
        guard let movie = movieRep else { return }
        
        movieTitleLabel.text = movie.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
