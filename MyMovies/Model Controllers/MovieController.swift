//
//  MovieController.swift
//  MyMovies
//
//  Created by Dani on 8/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class MovieController {
    
    init() {
//        fetchedMoviesFromServer
    }
//    MARK: - Search API Methods
    
    private let apiKey = "4cc920dab8b729a619647ccc4d191d5e"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
    
    func searchForMovie(with searchTerm: String, completion: @escaping (Error?) -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let queryParameters = ["query": searchTerm,
                               "api_key": apiKey]
        
        components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let requestURL = components?.url else {
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error searching for movie with search term \(searchTerm): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let movieRepresentations = try JSONDecoder().decode(MovieRepresentations.self, from: data).results
                self.searchedMovies = movieRepresentations
                completion(nil)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func toggleHasWatched(movie: Movie) {
        movie.hasWatched = !movie.hasWatched
        saveToPersistentStore()
        put(movie: movie)
    }
    
    // MARK: - Properties
    
    var searchedMovies: [MovieRepresentation] = []


// MARK: - Server Methods

typealias completionHandler = (Error?) -> Void

let fireBaseURL = URL(string: "https://mymovies-cc95b.firebaseio.com/")!

func createMovie(title: String) {
    
    let movie = Movie(title: title)
    saveToPersistentStore()
    put(movie: movie)
}

func put(movie: Movie, completionClosure: @escaping completionHandler = { _ in}) {
    
    let uuid = movie.identifier ?? UUID()
    movie.identifier = uuid
    
    let requestURL =
        fireBaseURL.appendingPathComponent(uuid.uuidString)
    .appendingPathExtension("json")
    var request = URLRequest(url: requestURL)
    request.httpMethod = "PUT"
    
    do {
        let representation = movie.movieRepresentation
        try CoreDataStack.shared.save()
        request.httpBody = try JSONEncoder().encode(representation)
    } catch {
        NSLog("Error encoding movie: \(error)")
        completionClosure(error)
        return
    }
    
    URLSession.shared.dataTask(with: request) { (_,_, error) in
        if let error = error {
            NSLog("Error PUTting movie to server: \(error)")
            completionClosure(error)
            return
        }
        completionClosure(nil)
    }.resume()
}

func deleteMovieFromServer(movie: Movie, completionClosure: @escaping completionHandler = { _ in}) {
    let uuid = movie.identifier?.uuidString
    
    let requestURL =
    fireBaseURL.appendingPathComponent(uuid!)
    .appendingPathExtension("json")
    var request = URLRequest(url: requestURL)
    request.httpMethod = "DELETE"
    
    URLSession.shared.dataTask(with: request) { (_,_, error) in
        if let error = error {
            NSLog("Error DELETEing movie from server: \(error)")
            completionClosure(error)
            return
        }
        completionClosure(nil)
    }.resume()
    
}
    
    func fetchedMoviesFromServer(completionClosure: @escaping completionHandler = { _
        in}) {
        
        let requestURL = fireBaseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching movies \(error)")
                completionClosure(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completionClosure(error)
                return
            }
            do {
                let movieRepresentation = Array(try
                    JSONDecoder().decode([String: MovieRepresentation].self,
                        from: data).values)
                let moc = CoreDataStack.shared
                    .container.newBackgroundContext()
                try self.updateMovies(with: movieRepresentation, context: moc)
            } catch {
                NSLog("Error decoding entry representation: \(error)")
                completionClosure(error)
                return
            }
            completionClosure(nil)
        }.resume()
        
        }
    
//    MARK: - Private Functions
    
    private func updateMovies(with representation: [MovieRepresentation],
                              context: NSManagedObjectContext) throws {
        
        var error: Error? = nil
        context.performAndWait {
            for movieRep in representation {
                
                let identifier = movieRep.identifier
                if let movie = self.fetchSingleMovieFromPersistentStore(identifier: identifier!.uuidString, in: context) {
                    self.update(movie:movie, with: movieRep)
                } else {
                    let _ = Movie(movieRepresentation: movieRep, context: context)
                }
            }
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    func update(movie: Movie, with representation: MovieRepresentation) {
        
        movie.title = representation.title
        movie.identifier = representation.identifier
        movie.hasWatched = representation.hasWatched!
    }
    
    private func fetchSingleMovieFromPersistentStore(identifier: String, in context: NSManagedObjectContext) -> Movie? {
        
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        var result: Movie? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching movie with identifier \(identifier): \(error)")
            }
        }
        return result
    }
    
    func updateMovie(movie: Movie) {
        put(movie: movie)
        saveToPersistentStore()
    }
    
    func deleteMovie(movie: Movie) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(movie)
        deleteMovieFromServer(movie: movie)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
