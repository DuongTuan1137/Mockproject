//
//  ViewController.swift
//  MockProject
//
//  Created by AnhDCT on 9/11/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var outletNews: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var outletPopular: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScroll()
        scrollView.delegate = self
    }
    
    fileprivate func setupScroll() {
        scrollView.contentSize.width = view.frame.width * 2
        scrollView.isPagingEnabled = true
        let newsVC = TableViewController(nibName: "TableViewController", bundle: nil)
        addChild(newsVC)
        scrollView.addSubview(newsVC.view)
        newsVC.didMove(toParent: self)
        newsVC.view.frame = CGRect(x: 0, y: 0, width: 414, height: 706)
        let popularVC = PopularTableViewController(nibName: "PopularTableViewController", bundle: nil)
        addChild(popularVC)
        scrollView.addSubview(popularVC.view)
        popularVC.didMove(toParent: self)
        popularVC.view.frame = CGRect(x: 414, y: 0, width: 414, height: 706)
    }
    
    @IBAction func buttonNews(_ sender: UIButton) {
        scrollView.contentOffset.x = 0
        outletNews.setTitleColor(#colorLiteral(red: 0.4779872894, green: 0.5049561262, blue: 0.9993677735, alpha: 1), for: .normal)
        outletPopular.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.view1.transform = .identity
        }, completion: nil)
    }
    @IBAction func buttonPopular(_ sender: UIButton) {
        scrollView.contentOffset.x = 414
        outletNews.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        outletPopular.setTitleColor(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), for: .normal)
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
           self.view1.transform = CGAffineTransform(scaleX: 1.36, y: 1).translatedBy(x: 71, y: 0)
            
        }, completion: nil)
        
    }
    
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        switch pageIndex {
        case 0:
            outletNews.setTitleColor(#colorLiteral(red: 0.4779872894, green: 0.5049561262, blue: 0.9993677735, alpha: 1), for: .normal)
            outletPopular.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.view1.transform = .identity
            }, completion: nil)
        default:
            outletNews.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            outletPopular.setTitleColor(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), for: .normal)
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                 self.view1.transform = CGAffineTransform(scaleX: 1.36, y: 1).translatedBy(x: 71, y: 0)
            }, completion: nil)
        }
    }
}
