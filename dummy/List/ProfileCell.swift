//
//  ProfileCell.swift
//  dummy
//
//  Created by Macbook Air on 28.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileCell: UITableViewCell {
    
    private let imageSize: CGSize = .init(width: 48, height: 48)
    
    var userInfo: UserInfo? {
        didSet {
            guard let userInfo = userInfo else { return }
            
            let fullName = userInfo.firstName + " " + userInfo.lastName
            fullNameLabel.text = fullName
            profileImageView.sd_setImage(with: URL(string: userInfo.picture))
        }
    }
    
    var profileImage: UIImage? { return profileImageView.image }
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = min(imageSize.width, imageSize.height)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [profileImageView, fullNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 96),
            profileImageView.widthAnchor.constraint(equalToConstant: 96),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            fullNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            fullNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
