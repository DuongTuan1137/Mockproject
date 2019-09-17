//
//  InfoNewsViewController.swift
//  MockProject
//
//  Created by AnhDCT on 9/16/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit
import WebKit
class InfoNewsViewController: UIViewController {
    
    var link : String
    @IBOutlet weak var browse: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: link) else {return}
        let req = URLRequest(url: url)
        browse.load(req)
       
    }
    init(link : String) {
        self.link = link
        super.init(nibName: "InfoNewsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
