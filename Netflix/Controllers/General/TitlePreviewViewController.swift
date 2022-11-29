//
//  TitlePreviewViewController.swift
//  Netflix
//
//  Created by Anna Shin on 20.09.2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupConstraints()
        
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    private func setupConstraints() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(overviewLabel)
        self.view.addSubview(downloadButton)
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35),
            
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 30),
            downloadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }

    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.overviewTitle
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.webViewElement.id.videoId)") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
