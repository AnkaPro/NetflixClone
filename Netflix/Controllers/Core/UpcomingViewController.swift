//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by Anna Shin on 01.09.2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Titles] = [Titles]()
    
    private let upcomingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.reuseId)
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        setupTableViewConstraints()
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        fetchUpcoming()
        
    }
    
    private func setupTableViewConstraints() {
        self.view.addSubview(upcomingTableView)

        NSLayoutConstraint.activate([
            upcomingTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            upcomingTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            upcomingTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            upcomingTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func fetchUpcoming() {
        APIManager.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APIManager.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, overviewTitle: title.overview ?? "", webViewElement: videoElement))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
