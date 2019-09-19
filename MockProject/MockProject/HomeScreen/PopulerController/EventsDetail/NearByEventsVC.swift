//
//  NearByEventsVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/17/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellNearByEvents"

class NearByEventsVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var eventsNear: [EventsStruct] = []
    var latitude: String
    var longitude: String
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        getApi()
    }

    private func getApi(){
        let api = "https://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listNearlyEvents?radius=5000&latitude=\(latitude)&longitue=\(longitude)"
        guard let url = URL(string:api) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            if error == nil {
                do{
                    let json = try JSONDecoder().decode(PopularStruct.self, from: data)
                    DispatchQueue.main.async {
                        self.eventsNear = json.response.events
                        self.collectionView.reloadData()
                    }
                } catch let err {
                    print("error Decode", err.localizedDescription)
                }
            }
        }.resume()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsNear.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellNearByEvents
        cell.setData(events: eventsNear[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventsVC = EventsDetailViewController(id: eventsNear[indexPath.item].id ?? 1)
        present(eventsVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width - 50, height: collectionView.bounds.height)
    }
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
        super.init(nibName: "NearByEventsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
