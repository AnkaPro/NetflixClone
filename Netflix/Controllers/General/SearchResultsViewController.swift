//
//  SearchResultsViewController.swift
//  Netflix
//
//  Created by Anna Shin on 12.09.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public var titles: [Titles] = [Titles]()
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseID)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.searchResultsCollectionView.delegate = self
        self.searchResultsCollectionView.dataSource = self
        setupCollectionViewConstraint()
        
    }
    
    private func setupCollectionViewConstraint() {
        self.view.addSubview(searchResultsCollectionView)
        
        NSLayoutConstraint.activate([
            searchResultsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
    
    func configureTitles(with titles: [Titles]) {
        self.titles = titles
    }
    
    func reloadCollectionViewData() {
        self.searchResultsCollectionView.reloadData()
    }

}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseID, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        let title = self.titles[indexPath.item]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        let titleName = title.original_title ?? ""
        print(titleName)
        
        APIManager.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                print("HARRY")
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: titleName, overviewTitle: title.overview ?? "", webViewElement: videoElement))
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    
}
