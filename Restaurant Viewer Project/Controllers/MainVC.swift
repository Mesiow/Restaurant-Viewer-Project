//
//  MainVC.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import UIKit
import CoreLocation
import Shuffle


class MainVC: UIViewController {
    let prevButton = UIButton()
    let nextButton = UIButton()
    let cardStack = SwipeCardStack()
    let images = [
        UIImage(named: "dune"),
        UIImage(named: "dune"),
        UIImage(named: "dune"),
        UIImage(named: "dune")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        configureCardStack()
        configureButtons()
    }
    
    func configureCardStack(){
        view.addSubview(cardStack)
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cardStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        cardStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        cardStack.heightAnchor.constraint(equalToConstant: 600).isActive = true
        cardStack.dataSource = self
    }
    
    private func configureButtons(){
        prevButton.setTitle("Previous", for: .normal)
        prevButton.backgroundColor = .black
        prevButton.tintColor = .white
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        view.addSubview(prevButton)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = .black
        nextButton.tintColor = .white
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            prevButton.widthAnchor.constraint(equalToConstant: 100),
            prevButton.heightAnchor.constraint(equalToConstant: 50),
            prevButton.leadingAnchor.constraint(equalTo: cardStack.leadingAnchor),
            prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.trailingAnchor.constraint(equalTo: cardStack.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: prevButton.bottomAnchor)
        ])
    }
    
    @objc func previousButtonPressed() {
        cardStack.undoLastSwipe(animated: true)
    }
    
    @objc func nextButtonPressed(){
        cardStack.swipe(.left, animated: true)
    }
    
    func card(fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = UIImageView(image: image)
        
        let footer = RestaurantInfoView()
        footer.set(name: "Dune", rating: 5, imageUrl: "")
        card.footer = footer
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .none
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .none
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
    }
}

extension MainVC: SwipeCardStackDataSource, SwipeCardStackDelegate {
    func cardStack(_ cardStack: Shuffle.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle.SwipeCard {
        return card(fromImage: images[index]!)
    }
    
    func numberOfCards(in cardStack: Shuffle.SwipeCardStack) -> Int {
        return images.count
    }
}
