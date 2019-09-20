//
//  TabBarVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/19/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    static let instance = TabBarVC()
    lazy var homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
    lazy var nearVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NearVC")
    lazy var browseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowseVC")
    lazy var signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVC")
    lazy var meVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeVC")

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    func setTabBar() {
        let naviMyPage = UINavigationController.init(rootViewController: signupVC)
        naviMyPage.navigationBar.isHidden = true
        let naviBrowse = UINavigationController.init(rootViewController: browseVC)
        naviBrowse.navigationBar.isHidden = true
        homeVC.tabBarItem.title = "Home"
        nearVC.tabBarItem.title = "Near"
        naviBrowse.tabBarItem.title = "Browse"
        naviMyPage.tabBarItem.title = "My Page"
        meVC.tabBarItem.title = "Me"
        if User.user.login == false {
            viewControllers = [homeVC, nearVC, naviBrowse, naviMyPage]
        } else {
            viewControllers = [homeVC, nearVC, naviBrowse, meVC]
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
