//
//  ResultViewController.swift
//  who's that pokemon
//
//  Created by Usuario on 30/03/23.
//

import UIKit
import Kingfisher

class ResultViewController: UIViewController {

    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultCorrectAnswerLabel: UILabel!
    @IBOutlet weak var resultScoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var pokemonName: String = ""
    var pokemonImgUrl: String = ""
    var finalScore: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultScoreLabel.text = "Perdiste, tu punjate fue de \(finalScore)"
        resultCorrectAnswerLabel.text = "No, es un \(pokemonName)"
        resultImage.kf.setImage(with: URL(string: pokemonImgUrl))
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func playAgainPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
