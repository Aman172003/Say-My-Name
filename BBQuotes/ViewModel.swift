//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Aman on 29/07/24.
//

import Foundation

//struct me zruri nhi hai kisi bhi property ko initialize krna par class me zruri hai
// @Observable is used bcs if there will be any state changes in a view it refreshes the view
@Observable
class ViewModel {
    enum FetchStatus{
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
//    other's will be able to see it but not fetch it
//    partially private
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quotes
    var character: Character
    
//    init function runs as soon as we initialize the viewmodel
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        Bundle.main.url(forResource: "samplequote", withExtension: "json"): This attempts to find the URL for the resource named "samplequote.json" in the main bundle (the directory of the app's resources).
 //       Data(contentsOf: ): This creates a Data object by reading the contents of the file at the specified URL. The try! keyword is used to force the expression to try and run, and it will crash if an error is thrown (e.g., if the file is not found).
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quotes.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Character.self, from: characterData)
    }
    
    func getData(for show: String) async {
        status = .fetching
        do {
            quote = try await fetcher.fetchQuote(from: show)
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: character.name)
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
