//
//  Character.swift
//  BBQuotes
//
//  Created by Aman on 28/07/24.
//

import Foundation

//struct Character: Decodable: This defines a struct named Character that conforms to the Decodable protocol, meaning it can be initialized from JSON data.
struct Character: Decodable{
    let name: String
    let birthday: String
    let occupations: [String]
//    SWIFT HAS THE BUILT IN METHOD TO CONVERT STRING TO URL AUTOMATICALLY
//    THATS WHY BELOW URL IS TAKEN AS ARRAY
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String
//    ? is named as optionals it is used when value may be absent, it is not important that it is requiored
//    it will be automatically set to nil
//    var is used instead of nil because death value can be changed from nul to a value in the future
//    for using it, it has multiple ways
//   Text(death ?? 'UNKNOWN') if value is nil then show unknown
//    Text(death!) want it anyhow
//    or use else if conditions
//    or use optional binding, if let deathOG = death{}
//    or use guard, guard let deathOG = death else{}
    var death: Death?
    
//    This enum lists the keys used to decode the JSON data. Each case corresponds to a key in the JSON.
    enum CodingKeys: CodingKey {
        case name
        case birthday
        case occupations
        case images
        case aliases
        case status
        case portrayedBy
    }
    
//    The provided initializer init(from decoder: any Decoder) throws is a custom initializer that allows the Character struct to be created from JSON data. This initializer is required because the struct conforms to the Decodable protocol. Let's go through the initializer step-by-step to understand what it does as a whole:
    

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        birthday = try container.decode(String.self, forKey: .birthday)
        occupations = try container.decode([String].self, forKey: .occupations)
        images = try container.decode([URL].self, forKey: .images)
        aliases = try container.decode([String].self, forKey: .aliases)
        status = try container.decode(String.self, forKey: .status)
        portrayedBy = try container.decode(String.self, forKey: .portrayedBy)
        
         let deathDecoder = JSONDecoder()
        deathDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let deathData = try  Data(contentsOf: Bundle.main.url(forResource: "sampledeath", withExtension: "json")!)
        death = try deathDecoder.decode(Death.self, from: deathData)
    }
}
