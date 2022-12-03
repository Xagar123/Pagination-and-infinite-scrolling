//
//  ViewController.swift
//  infiniting scr
//
//  Created by Admin on 02/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    let apiCaller = APICaller()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        apiCaller.fetchData(pagination: false, completion: {[weak self] result in
            
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func createSpinerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("user scrolled")
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            // fetch more data
            //print("fetching data")
            guard !apiCaller.isPaginating else {return}
            //we are fetching more data
            
            self.tableView.tableFooterView = createSpinerFooter()
         //   self.tableView.tableHeaderView = createSpinerFooter()
            print("fetching data")
            apiCaller.fetchData(pagination: true, completion: {[weak self]result in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                switch result{
                    
                case .success(let moreData):
                //    self?.data.append(contentsOf: moreData)
                    DispatchQueue.main.async {
                        self?.data.append(contentsOf: moreData)
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    print("error")
                    break
                }
            })
        }
    }
    
}

