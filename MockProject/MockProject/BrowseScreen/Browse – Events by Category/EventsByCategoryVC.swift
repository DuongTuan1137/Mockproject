//
//  EventsByCategoryVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/24/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class EventsByCategoryVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var seg: UISegmentedControl!
    var categoryId : Int?
    var amount : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = false
        setupScroll()
        setTitle()
    }
    
    func setTitle(){
        switch seg.selectedSegmentIndex {
        case 0:
            NotificationCenter.default.addObserver(self, selector: #selector(setTitle1), name: Notification.Name(rawValue: "Title"), object: nil)
        default:
              NotificationCenter.default.addObserver(self, selector: #selector(setTitle2), name: Notification.Name(rawValue: "Date"), object: nil)
        }
    }
    
    @objc func setTitle1(notification: NSNotification){
        titleLabel.text = "Technology(\(notification.userInfo?["Technology"] ?? 0))"
    }
    @objc func setTitle2(notification: NSNotification){
        titleLabel.text = "Technology(\(notification.userInfo?["T"] ?? 0))"
    }
    
    fileprivate func setupScroll() {
        scrollView.contentSize.width = view.frame.width * 2
        let EventsCategory1 = EventsCategoryByPopular(id: categoryId ?? 1)
        addChild(EventsCategory1)
        scrollView.addSubview(EventsCategory1.view)
        EventsCategory1.didMove(toParent: self)
        EventsCategory1.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.frame.height)
        let EventsCategory2 = EventsCategoryByDate(id: categoryId ?? 1)
        addChild(EventsCategory2)
        scrollView.addSubview(EventsCategory2.view)
        EventsCategory2.didMove(toParent: self)
        EventsCategory2.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: scrollView.frame.height)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func swapTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            NotificationCenter.default.addObserver(self, selector: #selector(setTitle1), name: Notification.Name(rawValue: "Title"), object: nil)
            scrollView.contentOffset.x = 0
        default:
              NotificationCenter.default.addObserver(self, selector: #selector(setTitle2), name: Notification.Name(rawValue: "Date"), object: nil)
            scrollView.contentOffset.x = self.view.frame.width
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
}
