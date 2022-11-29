//
//  APIManager.swift
//  Netflix
//
//  Created by Anna Shin on 08.09.2022.
//

import Foundation

struct Constants {
    static let TMDB_APIKey = "d4678e662f302452340e5e6aba0943a7"
    static let baseURL = "https://api.themoviedb.org"
    static let Youtube_APIKey = "AIzaSyDxCVS1Lytw4iFalFoLD-PDTOuEMOYpmyg"
    static let Youtube_baseURL =  "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APIManager {
    
    static let shared = APIManager()
    
    //MARK: - get trending movies
    
    func getTrendingMovies(completion: @escaping (Result<[Titles], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.TMDB_APIKey)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let results = try? JSONDecoder().decode(TitlesResponse.self, from: data) else { return }
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    //MARK: - get trending tvs
    
    func getTrendingTVs(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.TMDB_APIKey)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let results = try? JSONDecoder().decode(TitlesResponse.self, from: data) else { return }
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - get popular movies
    
    func getPopularMovies(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.TMDB_APIKey)&language=en-US&page=1") else { return }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let results = try? JSONDecoder().decode(TitlesResponse.self, from: data) else { return }
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - get upcoming movies
    
    func getUpcomingMovies(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.TMDB_APIKey)&language=en-US&page=1") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let results = try? JSONDecoder().decode(TitlesResponse.self, from: data) else { return }
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - get top rated movies
    
    func getTopRatedMovies(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.TMDB_APIKey)&language=en-US&page=1") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let results = try? JSONDecoder().decode(TitlesResponse.self, from: data) else { return }
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - get discover movies
    
    func getDiscoverMovie(completion: @escaping (Result<[Titles], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.TMDB_APIKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let results = try? JSONDecoder().decode(TitlesResponse.self, from: data) else { return }
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - get search with query
    
    func search(with query: String, completion: @escaping (Result<[Titles], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.TMDB_APIKey)&query=\(query)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let results = try? JSONDecoder().decode(TitlesResponse.self, from: data) else { return }
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.Youtube_baseURL)q=\(query)&key=\(Constants.Youtube_APIKey)") else { return }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                guard let result = try? JSONDecoder().decode(YoutubeSearchResponse.self, from: data) else { return }
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

