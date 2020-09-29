//
//  ProfileViewModel.swift
//  dummy
//
//  Created by Macbook Air on 29.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewModel: ObservableObject {
    @Published var user: UserInfo
    @Published var uiImage: UIImage?
    
    init(user: UserInfo, image: UIImage?) {
        self.user = user
        self.uiImage = image
        
        if uiImage == nil {
//            loadImage()
        }
    }
    
    private func loadImage() {
        let url = URL(string: user.picture)!
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (img, _, err, _, _, _) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                self.uiImage = img
            }
        }
    }
}
