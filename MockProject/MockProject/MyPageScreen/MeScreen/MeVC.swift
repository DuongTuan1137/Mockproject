//
//  MeVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/19/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class MeVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewWent: UIButton!
    @IBOutlet weak var viewGoing: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScroll()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for i in 0..<scrollView.subviews.count {
            scrollView.subviews[i].frame = CGRect(x: CGFloat(i) * view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height)
        }
    }
    
    fileprivate func setupScroll() {
        scrollView.contentSize.width = view.frame.width * 2
        scrollView.isPagingEnabled = true
        let myGoingVC = MyGoingVC(nibName: "MyGoingVC", bundle: nil)
        addChild(myGoingVC)
        scrollView.addSubview(myGoingVC.view)
        myGoingVC.didMove(toParent: self)
        myGoingVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.frame.height)
        let myWentVC = MyWentVC(nibName: "MyWentVC", bundle: nil)
        addChild(myWentVC)
        scrollView.addSubview(myWentVC.view)
        myWentVC.didMove(toParent: self)
        myWentVC.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: scrollView.frame.height)
    }
    
    @IBAction func goingButton(_ sender: UIButton) {
        scrollView.contentOffset.x = 0
        viewGoing.setTitleColor(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), for: .normal)
        viewWent.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name("TG"), object: self)
    }
    
    @IBAction func wentButton(_ sender: UIButton) {
        scrollView.contentOffset.x = self.view.frame.width
        viewWent.setTitleColor(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), for: .normal)
        viewGoing.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name("TW"), object: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tab = round(scrollView.contentOffset.x/self.view.frame.width)
        switch tab {
        case 0:
            viewGoing.setTitleColor(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), for: .normal)
            viewWent.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        default:
            viewWent.setTitleColor(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), for: .normal)
            viewGoing.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
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
