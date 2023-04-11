//
//  ImageManager.swift
//  who's that pokemon
//
//  Created by Usuario on 29/03/23.
import Foundation

protocol ImageManagerDelegate {
    func didUpdateImage(image: ImageModel)
    func didFailWithErrorImage(error: Error)
}

struct ImageManager {
    
    var delegate : ImageManagerDelegate?
    
    func fetchImage(url: String){
        performRequest(with: url)
    }
    
    func performRequest(with imgUrl : String){
        //Paso 1 (mirar el pokemon manager para la info completa de los pasos
        
        if  let url = URL(string: imgUrl){
            //paso 2
            let session = URLSession(configuration: .default)
            //paso 3
            let task  = session.dataTask(with: url){data ,response, error in
                if error != nil{
                    //print(error)
                    self.delegate?.didFailWithErrorImage(error: error!)
                }
                
                if let safeData = data{
                    if let image = self.parseJSON(imageData: safeData){
                        self.delegate?.didUpdateImage(image: image)
                    }
                }
            }
            task.resume()
        }
    }
    
    //Ajustado el parseJson para que devuelva un ImageModel, lo que necesita es el url. Se ve como sacarlo
    func parseJSON (imageData : Data) -> ImageModel?{
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(ImageData.self, from: imageData)
            let image = decodeData.sprites?.other?.officialArtwork?.frontDefault ?? ""//Se hizo un mapeo con el pokemonManager porque era un arreglo de pokemons
            return ImageModel(imageUrl: image)
        } catch {
            return nil
        }
    }

}

