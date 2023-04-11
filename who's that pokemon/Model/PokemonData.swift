//
//  PokemonData.swift
//  who's that pokemon
//
//  Created by Usuario on 28/03/23.
//  Clase para la estructura de datos del api
//  Se le va a decir como interpretar la api. La respuesta viene en JSON

//import Foundation
//
//struct PokemonData: Codable {
//    let result : [Result]?// de ese tipo por venir en el pokeApi.
//}
//
//struct Result : Codable {
//    let name : String
//    let url : String
//}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pokemonData = try? JSONDecoder().decode(PokemonData.self, from: jsonData)

import Foundation

// MARK: - PokemonData
struct PokemonData: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String?
    let url: String?
}
