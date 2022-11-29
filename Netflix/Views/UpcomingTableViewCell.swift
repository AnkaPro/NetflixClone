//
//  UpcomingTableViewCell.swift
//  Netflix
//
//  Created by Anna Shin on 12.09.2022.
//

import UIKit
import SDWebImage

class UpcomingTableViewCell: UITableViewCell {

    static let reuseId = "UpcomingTableViewCell"
    
    private let upcomingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
//        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(upcomingImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(titleLable)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
       
        
        NSLayoutConstraint.activate([
            upcomingImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            upcomingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upcomingImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            upcomingImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),

            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            
            titleLable.leadingAnchor.constraint(equalTo: upcomingImageView.trailingAnchor, constant: 15),
            titleLable.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -15),
            titleLable.centerYAnchor.constraint(equalTo: upcomingImageView.centerYAnchor)
        
        ])
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string:  "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else { return }
        
        upcomingImageView.sd_setImage(with: url)
        titleLable.text = model.titleName
    }

}
