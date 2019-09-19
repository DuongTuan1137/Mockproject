//
//  EventsDetailViewController.swift
//  MockProject
//
//  Created by AnhDCT on 9/16/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit
extension UIView {
    func constraintToAllSides(of container: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
    }
}

class EventsDetailViewController: UIViewController {
    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageEvents: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var lableNameEvent: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAddress2: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelContact: UILabel!
   
    @IBOutlet weak var viewNearBy: UIView!
    
    var id : Int
    var events:EventsStr?
    var blurEffectView = UIVisualEffectView()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        getApi()
        setStatusLabelDescription()
    }
    
    func addSubViewForViewNearByEvents(){
       let NearEventVC = NearByEventsVC(latitude: events?.venue.geo_lat ?? "1", longitude: events?.venue.geo_long ?? "1")
        addChild(NearEventVC)
        viewNearBy.addSubview(NearEventVC.view)
        NearEventVC.view.constraintToAllSides(of: viewNearBy)
        NearEventVC.didMove(toParent: self)
    }
    
    
    func getApi() {
        let api = "https://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/getDetailEvent?event_id=\(id)"
        guard let url = URL(string:api) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            if error == nil {
                do{
                    let json = try JSONDecoder().decode(EventsModel.self, from: data)
                    DispatchQueue.main.async {
                        self.events = json.response.events
                        self.setupData(events: self.events!)
                        self.addSubViewForViewNearByEvents()

                    }
                } catch let err {
                    print("error Decode", err.localizedDescription)
                }
            }
            }.resume()
    }
    
    func setupData(events: EventsStr){
        guard let url = URL(string: events.photo ?? "") else {return}
        do {
            let data =  try Data(contentsOf: url)
            imageEvents.image = UIImage(data: data)
        } catch  {
            print("loi data")
        }
        labelAddress.text = events.venue.name
        lableNameEvent.text = events.name
        guard let start = events.schedule_start_date else {return}
        let currentDate  = Date()
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let startDate = dateFormatter.date(from: start) else {return}
        if startDate < currentDate {
            labelTime.text = events.schedule_start_date! + " - \(String(describing: events.going_count!)) người tham gia"
        } else {
            labelTime.text = events.schedule_end_date! + " - \(String(describing: events.going_count!)) người tham gia"
        }
        labelDescription.text = events.description_html
        labelAddress2.text = events.venue.name
        labelCategories.text = events.category.name
        labelLocation.text = events.venue.contact_address
        labelContact.text = events.artist
    }
    fileprivate func addBlurView() {
        let blurEffect = UIBlurEffect(style: .prominent)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        labelDescription.addSubview(blurEffectView)
        labelDescription.sendSubviewToBack(blurEffectView)
        blurEffectView.frame = CGRect(x: labelDescription.bounds.minX, y: labelDescription.bounds.maxY * 2, width: labelDescription.bounds.width, height: labelDescription.bounds.height/2)
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setStatusLabelDescription() {
        labelDescription.numberOfLines = 4
        labelDescription.isUserInteractionEnabled = true
        addBlurView()
        
        let pan = UITapGestureRecognizer(target: self, action: #selector(swapLine))
        labelDescription.addGestureRecognizer(pan)
    }
    @objc func swapLine() {
        switch labelDescription.numberOfLines {
        case 4:
            blurEffectView.alpha = 0
            labelDescription.numberOfLines = 0
            labelDescription.reloadInputViews()
        default:
            blurEffectView.alpha = 0.8
            labelDescription.numberOfLines = 4
            labelDescription.reloadInputViews()
        }
    }

    @IBAction func followButton(_ sender: UIButton) {

    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func goingButton(_ sender: UIButton) {
    }
    
    @IBAction func wentButton(_ sender: UIButton) {
    }
    
    init(id: Int) {
        self.id = id
        super.init(nibName: "EventsDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension EventsDetailViewController: UIScrollViewDelegate {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightImg = imageEvents.frame.height
        scrollView.contentInset = UIEdgeInsets(top: heightImg , left: 0, bottom: 0, right: 0)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        if offSetY < 0 {
            imageEvents.frame.size.height = -offSetY
            stackView.frame.origin.y = UIApplication.shared.statusBarFrame.height + 54 + imageEvents.frame.size.height
        }
    }
}
