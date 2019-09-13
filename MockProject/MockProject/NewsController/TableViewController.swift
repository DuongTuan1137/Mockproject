//
//  TableViewController.swift
//  MockProject
//
//  Created by AnhDCT on 9/11/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var arrayNews = [NewsStruct]()
    var pageIndex = 1
    var pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
        registerForCell()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func getApi(){
        let api = "http://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listNews?pageIndex=\(pageIndex)&pageSize=\(pageSize)"
        guard let url = URL(string: api) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            do{
                let json = try JSONDecoder().decode(JsonStruct.self, from: data)
                DispatchQueue.main.async {
                    json.response.news.forEach({ (news) in
                        self.arrayNews.append(news)
                    })
                    self.tableView.reloadData()
                }
            } catch{
                print("loi")
            }
        }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.setData(news: arrayNews[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrayNews.count - 1 {
            loadMore()
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pageIndex += 1
            self.getApi()
        }
    }
    
    @objc func refreshData(){
        arrayNews.removeLast(arrayNews.count - pageSize)
        pageIndex = 1
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    private func registerForCell(){
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
}
