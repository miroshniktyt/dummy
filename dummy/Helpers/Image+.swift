//
//  Image+.swift
//  dummy
//
//  Created by Macbook Air on 29.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import SwiftUI

extension Image {

    public init(uiImage: UIImage?) {
        guard let uiImage = uiImage else {
            self = Image(systemName: "person")
            return
        }
        self = Image(uiImage: uiImage)
    }
}
