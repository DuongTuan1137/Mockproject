
import UIKit

class PopularTableViewController: UITableViewController {
    var arrayEvents = [EventsStruct]()
    var pageIndex = 1
    var pageSize = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        getApi()
        registerForCell()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(){
        arrayEvents = []
        pageIndex = 1
        getApi()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    private func getApi(){
        let api = "http://f1fa6ab5.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listPopularEvents?pageIndex=\(pageIndex)&pageSize=\(pageSize)"
        getGenericData(urlString: api) { (json: PopularStruct) in
            DispatchQueue.main.async {
                json.response.events.forEach({ (event) in
                    if event.going_count! > 0 {
                        self.arrayEvents.append(event)
                    }
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
        return arrayEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularTableViewCell", for: indexPath) as! PopularTableViewCell
        cell.setupData(events: arrayEvents[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrayEvents.count - 1{
            loadMore()
        }
    }
    
    private func registerForCell(){
        self.tableView.register(UINib(nibName: "PopularTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularTableViewCell")
    }
}

extension PopularTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventVC = EventsDetailViewController(id: arrayEvents[indexPath.row].id ?? 1)
        present(eventVC, animated: true, completion: nil)
    }
}
