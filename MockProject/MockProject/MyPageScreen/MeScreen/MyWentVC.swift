//
//  MyWentVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/29/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class MyWentVC: UITableViewController {
    let status = 2
    var arrWent = [[EventsStruct]]()
    var count = [EventsStruct]()
    var arrSection = ["Ends Today", "Ends Tomorrow", "Ends At The Week", "Ends At The Next Weeek", "Ends At The End Of The Months", "Ends From The Next Month And Later", "No Deadline Or Ended"]
    var arrForever = [EventsStruct]()
    var arrNextMonth = [EventsStruct]()
    var arrInMonth = [EventsStruct]()
    var arrNextWeek = [EventsStruct]()
    var arrInWeek = [EventsStruct]()
    var arrTomorrow = [EventsStruct]()
    var arrToday = [EventsStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(scrolToTop), name: NSNotification.Name(rawValue: "TW"), object: nil)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        arrWent = [arrToday, arrTomorrow, arrInWeek, arrNextWeek, arrInMonth, arrNextMonth, arrForever]
        registerForCell()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        arrToday.removeAll()
        arrTomorrow.removeAll()
        arrInWeek.removeAll()
        arrNextWeek.removeAll()
        arrInMonth.removeAll()
        arrNextMonth.removeAll()
        arrForever.removeAll()
    }
    override func viewDidAppear(_ animated: Bool) {
        getApi()
    }
    
    @objc func scrolToTop(){
        UIView.animate(withDuration: 0.2) {
            self.tableView.contentOffset.y = 0
        }
    }
    
    func getApi(){
        let url = "https://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listMyEvents?status=\(status)&token=\(User.instance.token ?? "")"
        getGenericData(urlString: url) { (json: PopularStruct) in
            json.response.events.forEach({ (event) in
                self.setupData(event: event)
            })
            self.arrWent = [self.arrToday, self.arrTomorrow, self.arrInWeek, self.arrNextWeek, self.arrInMonth, self.arrNextMonth, self.arrForever]
            for i in 0 ..< self.arrWent.count {
                self.arrWent[i].sort(by: { (a, b) -> Bool in
                    a.schedule_end_date! < b.schedule_end_date!
                })
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        return arrWent.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrWent[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularTableViewCell", for: indexPath) as! PopularTableViewCell
        
        cell.setupData(events: arrWent[indexPath.section][indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arrWent[section].isEmpty {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let EventsDetailVC = EventsDetailViewController(id: arrWent[indexPath.section][indexPath.row].id ?? 1)
        present(EventsDetailVC, animated: true, completion: nil)
    }
    
    
    private func registerForCell(){
        self.tableView.register(UINib(nibName: "PopularTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularTableViewCell")
    }
   
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
