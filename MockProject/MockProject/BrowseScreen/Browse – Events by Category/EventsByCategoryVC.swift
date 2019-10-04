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
    var titleCategory: String?
    var categoryId : Int?
    var amount : Int?
    var numberPo : Int?
    var numberDate : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleCategory
        scrollView.isScrollEnabled = false
        scrollView.contentSize.width = view.frame.width * 2
        setTitle()
        setupScroll()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for i in 0..<scrollView.subviews.count {
            scrollView.subviews[i].frame = CGRect(x: CGFloat(i) * view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height)
        }
    }
    
    func setTitle(){
        NotificationCenter.default.addObserver(self, selector: #selector(setTitle1), name: Notification.Name(rawValue: "Po"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setTitle2), name: Notification.Name(rawValue: "Date"), object: nil)
    }
    
    @objc func setTitle1(notification: NSNotification){
        titleLabel.text = titleCategory! + "(\(notification.userInfo?["T1"] ?? 0))"
    }
    @objc func setTitle2(notification: NSNotification){
        titleLabel.text = titleCategory! + "(\(notification.userInfo?["T"] ?? 0))"
    }
    
    fileprivate func setupScroll() {
        
        let EventsCategory1 = EventsCategoryByPopular(id: categoryId ?? 1)
        addChild(EventsCategory1)
        scrollView.addSubview(EventsCategory1.view)
        EventsCategory1.number = {[weak self] count in
            self?.numberPo = count
        }
        EventsCategory1.didMove(toParent: self)
        EventsCategory1.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.frame.height)
        let EventsCategory2 = EventsCategoryByDate(id: categoryId ?? 1)
        addChild(EventsCategory2)
        scrollView.addSubview(EventsCategory2.view)
        EventsCategory2.number = {[weak self] count in
            self?.numberDate = count
        }
        EventsCategory2.didMove(toParent: self)
        EventsCategory2.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: scrollView.frame.height)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func swapTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            titleLabel.text = titleCategory! + "(\(numberPo ?? 0))"
            scrollView.contentOffset.x = 0
        default:
            titleLabel.text = titleCategory! + "(\(numberDate ?? 0))"
           scrollView.contentOffset.x = self.view.frame.width
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
