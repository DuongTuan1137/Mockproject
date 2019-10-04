//
//  EventsCategoryByPopular.swift
//  MockProject
//
//  Created by AnhDCT on 9/24/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class EventsCategoryByPopular: UITableViewController {
    var id : Int
    var pageIndex = 1
    var pageSize = 10
    var arrData = [EventsStruct]()
    var number : ((Int) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForCell()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        getApi()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(){
        arrData = []
        pageIndex = 1
        getApi()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func getApi() {
        let url = "http://f1fa6ab5.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listEventsByCategory?token=\(User.instance.token ?? "")&pageIndex=\(pageIndex)&category_id=\(id)&pageSize=\(pageSize)"
        getGenericData(urlString: url) { (json: PopularStruct) in
            DispatchQueue.main.async {
                json.response.events.forEach({ (event) in
                    self.arrData.append(event)
                    self.arrData.sort(by: { (a, b) -> Bool in
                        a.going_count! > b.going_count!
                    })
                    self.number?(self.arrData.count)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Po"), object: self, userInfo: ["T1": self.arrData.count])
                })
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadMore(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pageIndex += 1
            self.getApi()
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularTableViewCell", for: indexPath) as! PopularTableViewCell
        cell.setupData(events: arrData[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrData.count - 1{
            loadMore()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventsDetailVC = EventsDetailViewController(id: arrData[indexPath.row].id ?? 1)
        present(eventsDetailVC, animated: true, completion: nil)
    }
    
    private func registerForCell(){
        self.tableView.register(UINib(nibName: "PopularTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularTableViewCell")
    }
    
    init(id: Int) {
        self.id = id
        super.init(nibName: "EventsCategoryByPopular", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
