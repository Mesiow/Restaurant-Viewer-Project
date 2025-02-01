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
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var businesses: [Business] = []
    var pageOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        configureCardStack()
        configureButtons()
        configureLocationManager()
        
        self.showActivityLoadingView()
    }
    
    func showFetchedRestaurants(){
        DispatchQueue.main.async {
            //Remove activity view and reload card stack to show our fetched data
            self.removeActivityLoadingView()
            self.cardStack.reloadData()
        }
    }
    
    func startFetchingMoreRestuarantData(){
        self.showActivityLoadingView()
        pageOffset += 1
        locationManager.startUpdatingLocation()
    }
    
    //Restaurant data fetch
    func fetchRestaurantDataAtLocation(latitude: Double, longitude: Double){
        NetworkManager.shared.fetchRestaurantsAtLocation(lat: latitude, long: longitude, offset: pageOffset) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.businesses = response.businesses //add new results to end of array
                    showFetchedRestaurants()
                
                case .failure(let error):
                    DispatchQueue.main.async { self.removeActivityLoadingView() }
                    self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue)
            }
        }
    }
    
    private func configureLocationManager(){
        locationManager.delegate = self
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
        cardStack.delegate = self
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
        self.cardStack.undoLastSwipe(animated: true)
    }
    
    @objc func nextButtonPressed(){
        cardStack.swipe(.left, animated: true)
    }
    
    func card(index: Int) -> SwipeCard {
        if self.businesses.count > 0 {
            let card = SwipeCard()
            card.swipeDirections = [.left, .right]
            
            let business = self.businesses[index]
            //Download image onto card
            let url = self.businesses[index].image_url
            if let url = URL(string: url){
                NetworkManager.shared.downloadImage(from: url) { image in
                    DispatchQueue.main.async {
                        card.content = UIImageView(image: image)
                    }
                }
            }
            
            let footer = RestaurantInfoView()
            footer.set(name: business.name, rating: business.rating)
            card.footer = footer
            
            let leftOverlay = UIView()
            leftOverlay.backgroundColor = .none
            
            let rightOverlay = UIView()
            rightOverlay.backgroundColor = .none
            
            card.setOverlays([.left: leftOverlay, .right: rightOverlay])

            return card
        }
        return SwipeCard()
    }
}

extension MainVC: SwipeCardStackDataSource, SwipeCardStackDelegate {
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        self.startFetchingMoreRestuarantData()
    }
    
    func cardStack(_ cardStack: Shuffle.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle.SwipeCard {
        return card(index: index)
    }
    
    func numberOfCards(in cardStack: Shuffle.SwipeCardStack) -> Int {
        return businesses.count
    }
}
