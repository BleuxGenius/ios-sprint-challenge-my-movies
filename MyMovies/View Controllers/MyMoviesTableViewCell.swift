//
//  MyMoviesTableViewCell.swift
//  MyMovies
//
//  Created by Lambda_School_Loaner_167 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol MyMovieTableViewCellDelegate: class {
    func toggleHasWatched(cell: MyMoviesTableViewCell)
}

class MyMoviesTableViewCell: UITableViewCell {
    
//    MARK: - Properties & Outlets

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var hasWatchedButton: UIButton!
    
     weak var delegate: MyMovieTableViewCellDelegate?
    
    var movieController: MovieController?
//    var movieRep: MovieRepresentation?
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
        
        delegate?.toggleHasWatched(cell: self)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
