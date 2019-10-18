//
//  Movie+Convenience.swift
//  MyMovies
//
//  Created by Lambda_School_Loaner_167 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Movie {
    
    convenience init(title: String, hasWatched: Bool = false, identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.identifier = identifier
        self.hasWatched = hasWatched
    }
    
    convenience init?(movieRepresentation: MovieRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let title = movieRepresentation.title
        guard let identifier = movieRepresentation.identifier,
            let hasWatched = movieRepresentation.hasWatched else { return nil}
      
        self.init(title: title, hasWatched: hasWatched, identifier: identifier, context: context)
    }
    
    var movieRepresentation: MovieRepresentation {
        
        guard let title = title else { fatalError() }
        if identifier == nil {
            identifier = UUID()
        }
        
        return MovieRepresentation(title: title, identifier: identifier, hasWatched: hasWatched)
    }
}
