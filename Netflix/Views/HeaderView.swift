//
//  HeaderView.swift
//  Netflix
//
//  Created by Anna Shin on 05.09.2022.
//

import UIKit

class HeaderView: UIView {

   private let imageView: UIImageView = {
        let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.image = UIImage(named: "poster")
       return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        addGradient()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        imageView.layer.addSublayer(gradientLayer)
    }
    
    
    private func setupConstraints() {
        
        [imageView, playButton, downloadButton].forEach { element in
            self.addSubview(element)
        }
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),

            playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            playButton.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -30),
            playButton.heightAnchor.constraint(equalToConstant: 30),
            playButton.widthAnchor.constraint(equalToConstant: 100),

            downloadButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            downloadButton.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 30),
            downloadButton.heightAnchor.constraint(equalToConstant: 30),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string:  "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else { return }
        imageView.sd_setImage(with: url)
    }

}
