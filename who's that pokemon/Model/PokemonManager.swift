//
//  PokemonManager.swift
//  who's that pokemon
//
//  Created by Usuario on 29/03/23.
//  Toda la logica para el consumo del Api. Por eso es el Manager

import Foundation

/*
 Un protocolo define un blueprint(un diseño, o un plano. Pues hace referencia alo planos azules para construcción del pasado)
 de métodos, propiedades, y otros requerimientos que realizaran una tarea en particular o una pieza de funcionalidad.
 */
protocol PokemonManagerDelegate {
    
    func didUpdatePokemon(pokemons : [PokemonModel])
    func didFailWithError(error : Error)
}

struct PokemonManager {
    
    let pokemonUrl : String = "https://pokeapi.co/api/v2/pokemon?limit=898&offset=0."
    var delegate: PokemonManagerDelegate?// para dar el control al, valga la redundancia, controlador
    
    //función pública para el consumo del api. Las demas funciones son private porque no necesitamos que se puedan acceder desde ningun otro lugar
    func fetchPokemon() {
        performRequest(with: pokemonUrl)
    }
    
    
    // función que hará la request
    
    private func performRequest(with urlString: String)  {
        //Pasos para consumir una API en swift
        //1. Create/get URL
        if let url = URL(string: urlString){//optional binding de toda la vida
            //2. Create the URLSession
            let session = URLSession(configuration: .default)//url sirve para el data transfer con el networking
            //3. Give the session a task
            let task = session.dataTask(with: url){data, response, error in // closure
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //print(error!)// aquí si se puede el Force devido a que en el if si nos aseguramos que tenga o no valor
                }
                // op binding
                if let safeData = data{
                    if let pokemon = self.parseJSON(pokemonData : safeData){
                        //print(pokemon)
                        self.delegate?.didUpdatePokemon(pokemons: pokemon)// "pokemon" es un arreglo de PokemonModel, es lo que regresa la funcion parseJSON
                    }
                }else{
                    
                }
            }
            //4. Start the task
            task.resume()
            
        }else{
            
        }
        
        
    }
    //funcion para parsear un Json
    //Data es un bufer de bytes en memoria
    private func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
            let pokemon = decodeData.results?.map{
                PokemonModel (name: $0.name ?? "", imgUrl: $0.url ?? "")
            }
            return pokemon
        } catch {
            return nil
        }
    }
}

