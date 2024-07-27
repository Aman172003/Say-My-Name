//
//  FetchService.swift
//  BBQuotes
//
//  Created by Aman on 28/07/24.
//

import Foundation

struct FetchService {
//    by default saare ke saare members fetchServices ke public honge, jisko jisko private banana ho bana lo
//     handle any possible error while fetching
    private enum FetchError: Error {
        case badResponse
    }
//   The ! forcibly unwraps the optional, assuming that the URL is valid and not nil.
//    If the URL is invalid and nil, the program will crash at runtime with a fatal error: unexpectedly found nil while unwrapping an Optional value.
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!

    //    from show: String specifies that the function takes a single argument named show of type String. The external parameter name is from, which means you call the function like fetchQuote(from: "Breaking Bad")
//    throws: This keyword indicates that the function can throw errors. When calling this function, you need to handle potential errors using try, try?, or try!.
//    -> Quotes: This indicates the return type of the function, which in this case is Quotes. The function returns an instance of Quotes if it completes successfully.
    
    func fetchQuote(from show: String) async throws -> Quotes {
        //       build fetch url
        //     make a req to this url  https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad
        
        let quoteURL = baseURL.appending(path: "quotes/random");
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        //       fetch data
        //        below is a tuple
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        //        handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
//       decode data
//        JSONDecoder(): Creates an instance of JSONDecoder, which is used to decode JSON data into a Swift struct or class.
        
   //     decode(_:from:) Method: This method of JSONDecoder decodes the data from JSON into the specified type, in this case, Quote.
        let quote = try JSONDecoder().decode(Quotes.self, from: data)
//        return quote
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> Character{
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
//        JSONDecoder class is used to decode JSON data into Swift types
//
        let decoder = JSONDecoder()
//        when decoding JSON data, the decoder will automatically convert keys from snake_case format to camelCase format, which is the convention used in Swift property names
//        map with values in type Characters
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let characters = try decoder.decode([Character].self, from: data)
//       return the first character that matches with name
        return characters[0]
    }
    
//    for character: String: This indicates that the function takes a single parameter named character of type String. The label for is used when calling the function to provide more readability
    func fetchDeath(for character: String) async throws -> Death? {
        let fetchURL = baseURL.appending(path: "deaths")
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let deaths = try decoder.decode([Death ].self, from: data)
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
    }
}

//tuple
//more than one property or value in one result
