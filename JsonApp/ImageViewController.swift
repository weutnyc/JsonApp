//
//  ImageViewController.swift
//  JsonApp
//
//  Created by Anton on 30.04.2021.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }
    
    @IBAction func getRandomDogButton(_ sender: Any) {
        fetchImage()
    }
    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    private func fetchImage() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let dog = try JSONDecoder().decode(Dog.self, from: data)
                print(dog)
                guard let imageURL = URL(string: dog.message ?? "") else { return }
                guard let image = try? Data(contentsOf: imageURL) else { return }
                
                DispatchQueue.main.async {
                    self.ImageView.image = UIImage(data: image)
                    self.activityIndicator.stopAnimating()
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
