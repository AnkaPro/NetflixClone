//
//  DownloadViewController.swift
//  Netflix
//
//  Created by Anna Shin on 01.09.2022.
//

import UIKit

class DownloadViewController: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadedTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.reuseId)
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTableView.delegate = self
        downloadedTableView.dataSource = self
        setupTableViewConstraints()
        fetchLocalStorageFromDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageFromDownload()
        }
    }
    
    private  func fetchLocalStorageFromDownload() {
        DataPersistanceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.downloadedTableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupTableViewConstraints() {
        self.view.addSubview(downloadedTableView)

        NSLayoutConstraint.activate([
            downloadedTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            downloadedTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            downloadedTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            downloadedTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }


}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.reuseId) as? UpcomingTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(posterUrl: title.poster_path ?? "", titleName: title.original_title ?? title.original_name ?? "Unknown title"))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 4
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            
            DataPersistanceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case.success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
}
