//
//  UITableView+.swift
//  dummy
//
//  Created by Macbook Air on 29.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

extension UITableView {
    func deselectAllRows() {
        let selectedRows = self.indexPathsForSelectedRows
        selectedRows?.forEach { self.deselectRow(at: $0, animated: true) }
    }
}
