//
//  RestaurantInfoView.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import UIKit

class RestaurantInfoView: UIView {
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let ratingLabel = UILabel()
    
    init(){
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        // Set up the layout for the custom view
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false  // Allow shadow outside thcorner radiu
        // Adding the shadow
        self.layer.shadowColor = UIColor.black.cgColor  // Shadow color
        self.layer.shadowOffset = CGSize(width: 0, height: 2)  // Lighshadow, slightly below
        self.layer.shadowOpacity = 0.2  // Light opacity for the shadow
        self.layer.shadowRadius = 4  // Soft radius to blur the shadow edges
        
        // Add and position the name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        // Add and position the image view
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        // Add and position the rating label
        ratingLabel.font = UIFont.systemFont(ofSize: 18)
        ratingLabel.textColor = .darkGray
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)
        
        // Constraints to arrange the elements
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            ratingLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            ratingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func set(name: String, rating: Double) {
        nameLabel.text = name
        ratingLabel.text = "\(rating) stars"
    }
}


