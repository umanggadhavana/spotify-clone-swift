//
//  APICaller.swift
//  Spotify Clone
//
//  Created by Umang Gadhavana on 31/01/22.
//

import Foundation

final class APICaller {
    
    // MARK: INIT
    
    static let shared = APICaller()
    
    init () {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsReseponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(AlbumDetailsReseponse.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    //                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription )
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Browse
    
    public func getNewRelease(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        
    }
    
    public func getFeturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=50"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                        print(result)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>)) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        //                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                        print(result)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    // MARK: - Categories
    
    public func getCategories(completion: @escaping ((Result<[Category], Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        //                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                        print(result.categories.items)
                        completion(.success(result.categories.items))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getCategoryPlaylists(category: Category, completion: @escaping ((Result<[Playlist], Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        //                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                        let playlists = result.playlists.items
                        print(playlists)
                        completion(.success(playlists))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    // MARK: - Search
    
    public func search(with query: String, completion: @escaping ((Result<[SearchResult], Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        //                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                        print(result)
                        var searchResult: [SearchResult] = []
                        searchResult.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                        
                        searchResult.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                        searchResult.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                        searchResult.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))
                        
                        completion(.success(searchResult))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping  (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken { token in
            guard let APIUrl = url else {
                return
            }
            var request = URLRequest(url: APIUrl)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completion(request)
        }
    }
}
