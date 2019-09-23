//
//  BrowseVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/19/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class BrowseVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
  
    var categories : [CategoryStruct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    private func getData(){
        let url = "http://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listCategories?pageIndex=1&pageSize=10"
        getGenericData(urlString: url) { (json : BrowseModel) in
            DispatchQueue.main.async {
                 self.categories = json.response.categories
                 self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseTableViewCell", for: indexPath) as! BrowseTableViewCell
        cell.setupCell(category: categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
