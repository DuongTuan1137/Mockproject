//
//  SearchVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/23/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segEvents: UISegmentedControl!
    var currenEvents = [EventsStruct]()
    var pastEvents = [EventsStruct]()
    var pageSize = 1
    var pageIndex = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForCell()
        getApi(searchTF)
        tabBarController?.tabBar.isHidden = true
    }
    
    fileprivate func getApi(_ textField: UITextField) {
        let url = "http://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/search?token=\(User.instance.token ?? "" )&keyword=\(textField.text ?? "")&pageIndex=\(pageIndex)&pageSize=20"
        getGenericData(urlString: url) { (json: PopularStruct) in
            DispatchQueue.main.async {
                json.response.events.forEach({ (event) in
                    guard let end = event.schedule_end_date else {return}
                    let currentDate  = Date()
                    let dateFormat = "yyyy-MM-dd"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = dateFormat
                    guard let endDate = dateFormatter.date(from: end) else {return}
                    if endDate < currentDate {
                        self.pastEvents.append(event)
                        self.pastEvents.sort(by: { (a, b) -> Bool in
                            a.going_count! > b.going_count!
                        })
                    } else {
                        self.currenEvents.append(event)
                        self.currenEvents.sort(by: { (a, b) -> Bool in
                            a.going_count! > b.going_count!
                        })
                    }
                })
                self.segEvents.setTitle("Current & upcoming (\(self.currenEvents.count))", forSegmentAt: 0)
                self.segEvents.setTitle("Past (\(self.pastEvents.count))", forSegmentAt: 1)
                self.tableview.reloadData()
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        searchTF.text = ""
    }
    
    @IBAction func segAction(_ sender: UISegmentedControl) {
        tableview.reloadData()
    }
    
    private func registerForCell(){
        tableview.register(UINib(nibName: "PopularTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularTableViewCell")
    }

}

extension SearchVC: UITextFieldDelegate {
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getApi(textField)
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pageIndex = 1
        currenEvents = []
        pastEvents = []
        return true
    }
}
extension SearchVC : UITableViewDataSource {
    
    private func loadMore(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pageIndex += 1
            self.getApi(self.searchTF)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segEvents.selectedSegmentIndex == 0 {
            if currenEvents.isEmpty{
                return 1
            } else {
                return currenEvents.count
            }
        } else {
            if pastEvents.isEmpty{
                return 1
            } else {
                return pastEvents.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segEvents.selectedSegmentIndex == 0 {
            if currenEvents.isEmpty {
                let cell = UITableViewCell()
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .black
                cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 18 )
                cell.textLabel?.text = "“Không có sự kiện phù hợp”"
                cell.selectionStyle = .none
                tableView.isScrollEnabled = false
                tableView.separatorStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PopularTableViewCell", for: indexPath) as! PopularTableViewCell
                 cell.setupData(events: currenEvents[indexPath.row])
                tableView.isScrollEnabled = true
                return cell
            }
        } else {
            if pastEvents.isEmpty {
                let cell = UITableViewCell()
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .black
                cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 18 )
                cell.textLabel?.text = "“Không có sự kiện phù hợp”"
                cell.selectionStyle = .none
                tableView.isScrollEnabled = false
                tableView.separatorStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PopularTableViewCell", for: indexPath) as! PopularTableViewCell
                cell.setupData(events: pastEvents[indexPath.row])
                tableView.isScrollEnabled = true
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch segEvents.selectedSegmentIndex {
        case 0:
            if indexPath.row == currenEvents.count - 1 {
                loadMore()
            }
        default:
            if indexPath.row == pastEvents.count - 1 {
                loadMore()
            }
        }
    }
}
extension SearchVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segEvents.selectedSegmentIndex == 0 {
            if currenEvents.isEmpty{
                return
            } else {
                let eventsDetailVC = EventsDetailViewController(id: currenEvents[indexPath.row].id ?? 1)
                present(eventsDetailVC, animated: true, completion: nil)
            }
        } else {
            if pastEvents.isEmpty{
                return
            } else {
                let eventsDetailVC = EventsDetailViewController(id: pastEvents[indexPath.row].id ?? 1)
                present(eventsDetailVC, animated: true, completion: nil)
            }
        }
    }
    

    
}
