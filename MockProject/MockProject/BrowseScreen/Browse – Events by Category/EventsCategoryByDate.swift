//
//  EventsCategoryByDate.swift
//  MockProject
//
//  Created by AnhDCT on 9/24/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class EventsCategoryByDate: UITableViewController {
    var id : Int
    var count = [EventsStruct]()
    var arrData = [[EventsStruct]]()
    var arrSection = ["Ends Today", "Ends Tomorrow", "Ends At The Week", "Ends At The Next Weeek", "Ends At The End Of The Months", "Ends From The Next Month And Later", "No Deadline Or Ended"]
    var arrForever = [EventsStruct]()
    var arrNextMonth = [EventsStruct]()
    var arrInMonth = [EventsStruct]()
    var arrNextWeek = [EventsStruct]()
    var arrInWeek = [EventsStruct]()
    var arrTomorrow = [EventsStruct]()
    var arrToday = [EventsStruct]()
    var pageSize = 10
    var pageIndex = 1
    var number: ((Int) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        arrData = [arrToday, arrTomorrow, arrInWeek, arrNextWeek, arrInMonth, arrNextMonth, arrForever]
        registerForCell()
        getApi()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(){
        arrToday.removeAll()
        arrTomorrow.removeAll()
        arrInWeek.removeAll()
        arrNextWeek.removeAll()
        arrInMonth.removeAll()
        arrNextMonth.removeAll()
        arrForever.removeAll()
        count.removeAll()
        pageIndex = 1
        getApi()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func getApi() {
        let url = "http://f1fa6ab5.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listEventsByCategory?token=\(User.instance.token ?? "")&category_id=\(id)&pageSize=\(pageSize)&pageIndex=\(pageIndex)"
//
        getGenericData(urlString: url) { (json: PopularStruct) in
            DispatchQueue.main.async {
                json.response.events.forEach({ (event) in
                   self.setupData(event: event)
                    self.count.append(event)
                })
                
                self.arrData = [self.arrToday, self.arrTomorrow, self.arrInWeek, self.arrNextWeek, self.arrInMonth, self.arrNextMonth, self.arrForever]
                
                self.number?(self.count.count)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Date"), object: self, userInfo: ["T" : self.count.count])
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
    
    private func setupData(event:EventsStruct){
        guard let end = event.schedule_end_date else {
            arrForever.append(event)
            return
        }
        let currentDate  = Date()
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let endDate = dateFormatter.date(from: end)
        let myCalendar = Calendar(identifier: .gregorian)
        let endMonthDay = myCalendar.component(.month, from: endDate!)
        let currentMonthDay = myCalendar.component(.month, from: currentDate)
        let endWeekDay = myCalendar.component(.weekdayOrdinal, from: endDate!)
        let currentWeekDay = myCalendar.component(.weekdayOrdinal, from: currentDate)
        let endDay = myCalendar.component(.weekday, from: endDate!)
        let currentDay = myCalendar.component(.weekday, from: currentDate)
        let units = Set<Calendar.Component>([.year,.month,.day,.weekOfYear,.hour])
        let endComponents = Calendar.current.dateComponents(units, from: currentDate, to: endDate!)
        if endComponents.year! > 0 {
            arrNextMonth.append(event)
        } else if endComponents.month! > 0 {
            arrNextMonth.append(event)
        } else if endComponents.weekOfYear! > 0 {
            if endMonthDay == currentMonthDay {
                if endComponents.weekOfYear == 1, endComponents.day == 0 {
                    arrNextWeek.append(event)
                } else {
                    arrInMonth.append(event)
                }
            } else {
                if endComponents.weekOfYear == 1, endComponents.day == 0 {
                    arrNextWeek.append(event)
                } else {
                    arrNextMonth.append(event)
                }
            }
        } else if endComponents.day! > 0 {
            if endWeekDay == currentWeekDay {
                if endComponents.day == 1, endDay - currentDay == 1 || endDay - currentDay == -6 {
                    arrTomorrow.append(event)
                } else {
                    arrInWeek.append(event)
                }
            } else {
                if endComponents.day == 1, endDay - currentDay == 1 || endDay - currentDay == -6 {
                    arrTomorrow.append(event)
                } else {
                    arrNextWeek.append(event)
                }
            }
        } else if endComponents.hour! > 0 {
            if endDay == currentDay {
                arrToday.append(event)
            } else {
                arrTomorrow.append(event)
            }
        } else {
            arrForever.append(event)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularTableViewCell", for: indexPath) as! PopularTableViewCell

        cell.setupData(events: arrData[indexPath.section][indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arrData[section].isEmpty {
            return 0
        }
        else {
            return 35
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8099890351, green: 0.8459287286, blue: 0.8642898798, alpha: 1)
        let label = UILabel()
        label.text = arrSection[section]
        label.textColor = #colorLiteral(red: 0.4826424122, green: 0.5511180758, blue: 0.5746853352, alpha: 1)
        label.frame = CGRect(x: 5, y: 5, width: self.view.frame.width - 10 , height: 25)
        view.addSubview(label)
        return view
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            loadMore()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let EventsDetailVC = EventsDetailViewController(id: arrData[indexPath.section][indexPath.row].id ?? 1)
        present(EventsDetailVC, animated: true, completion: nil)
    }
    
    private func registerForCell(){
        self.tableView.register(UINib(nibName: "PopularTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularTableViewCell")
    }
    
    init(id: Int) {
        self.id = id
        super.init(nibName: "EventsCategoryByDate", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
