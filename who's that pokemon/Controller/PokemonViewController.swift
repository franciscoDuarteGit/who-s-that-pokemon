//
//  ViewController.swift
//  who's that pokemon
//
//  Created by Usuario on 27/03/23.
//

import UIKit
import Kingfisher

//contiene la logia de la aplicacion
class PokemonViewController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    //colección de botones :o
    @IBOutlet var answerButtons: [UIButton]!
    
    lazy var pokemonManager = PokemonManager()// lazy para que solo se inicie cuando se llame/ocupe
    lazy var imageManager = ImageManager()
    lazy var game = GameModel()
    
    // ejecutas en emetodo para dar titulos en el observable del arreglo de pokemones random
    var randomPokemons : [PokemonModel] = []{
        didSet {
            setButtonTitles()
        }
    } 
    var correctAnswer = ""
    var correctImageUrl = ""
    
    //funcion heredada de UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.delegate = self// le estoy diciendo que le estoy delegando todo el control del contexto al delegate. Así no llamo a la funcion de didUpdate
        imageManager.delegate = self
        
        print(game.getScore())// imprime el valor del score, al principio es 0
        
        createButtons()
        pokemonManager.fetchPokemon()
        
        labelMessage.text=""
        
    }

    //para saber que botón se está presionando
    @IBAction func buttonPressed(_ sender: UIButton) {
        //print(sender)
        //tss, la morra usó el Force 😵
        print(sender.title(for: .normal)!)// Hace referencia al estado básico de un botón
        let userAnswer = sender.title(for: .normal)!
        if game.checkAnswer(userAnswer, correctAnswer){
            labelMessage.text = "Sí, es un \(userAnswer.capitalized)"
            labelScore.text = "Puntaje: \(game.score)"
            
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2
            let url = URL(string: correctImageUrl)
            pokemonImage.kf.setImage(with: url)
            
            Timer.scheduledTimer(withTimeInterval: 0.8,repeats: false){ timer in
                self.pokemonManager.fetchPokemon()
                self.labelMessage.text=""
                sender.layer.borderWidth = 0
                
            }
            
        }else{
            //todo esto era pa testear
//            labelMessage.text = "Noooo, es un \(correctAnswer.capitalized)"
//            sender.layer.borderColor = UIColor.systemRed.cgColor
//            sender.layer.borderWidth = 2
//            let url = URL(string: correctImageUrl)
//            pokemonImage.kf.setImage(with: url)
//
//            Timer.scheduledTimer(withTimeInterval: 0.8,repeats: false){ timer in
//                self.resetGame()
//                sender.layer.borderWidth = 0
//            }
            self.performSegue(withIdentifier: "goToResults", sender: self)
        }
        
    }
    
    func resetGame() {
        self.pokemonManager.fetchPokemon()
        game.setScore(score: 0)
        labelScore.text = "Puntaje : \(game.score)"
        self.labelMessage.text = " "
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "goToResults"{
            let destination = segue.destination as! ResultViewController// para asegurarte que el destino es esa vista
            destination.pokemonName = correctAnswer
            destination.pokemonImgUrl = correctImageUrl
            destination.finalScore = game.getScore()
            
             resetGame()
        }
        // Pass the selected object to the new view controller.
        
    }
     
    func createButtons(){
        //ciclo para iterar a traves de cada botón de la colección de botones creada.
        for button in answerButtons{
            //aplicando los cambios a layer del botón, como sombras, bordeado etc.
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity=1.0
            button.layer.shadowRadius = 0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 10.0
        }
    }
    
    //funcion para dar los titulos a los botones de los pokemon
    func setButtonTitles(){
        for(index, button) in answerButtons.enumerated(){
            DispatchQueue.main.async {[self] in
                button.setTitle(randomPokemons[safe: index]?.name.capitalized, for: .normal)
            }
        }
    }
    
    
    
    
}

//extensin sirve para agregar funcionalidades al archivo
//extensión para implementar los protocolos definidos en el PokemonManager
extension PokemonViewController: PokemonManagerDelegate {
    
    func didUpdatePokemon(pokemons: [PokemonModel]) {
        randomPokemons = pokemons.choose(4)// seleccionar 4 de los 898 pokemon
        let index = Int.random(in: 0...3)// uno de los 4
        let imageData = randomPokemons[index].imgUrl// imagen del pokemon a mostrar
        correctAnswer = randomPokemons[index].name// agarra el nombre del pokemon de los 4 random
        
        imageManager.fetchImage(url: imageData)
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

extension PokemonViewController: ImageManagerDelegate{
    func didUpdateImage(image: ImageModel) {
        print(image.imageUrl)
        correctImageUrl = image.imageUrl
        
        DispatchQueue.main.async {
            let url = URL(string: image.imageUrl)// porque por defecto, el imgview no se puede modificar con una imagen externa, si no con imagenes locales
            let effect = ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0)
            self.pokemonImage.kf.setImage(
                with: url,
                options: [.processor(effect)]
            )
            
        }
        
        
    }
    
    func didFailWithErrorImage(error: Error) {
        print(error)
    }
    
    
}

extension Collection where Indices.Iterator.Element == Index{
    public subscript(safe index: Index) -> Iterator.Element?{
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension Collection{
    func choose(_ n: Int) -> Array<Element> {
        Array(shuffled().prefix(n))// para revolverlos
    }
}

