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
        print("Pressed!")
        guard let movie = movieRep else { return }
        movieController?.createMovie(title: movie.title, identifier: UUID())
        addMovieButton.setTitle("Added", for: .normal)
    }

//    MARK: - View Life Cycle
    func updateViews() {
        guard let movie = movieRep else { return }
        movieTitleLabel.text = movie.title
        movieTitleLabel.textColor = .white
    }
}
