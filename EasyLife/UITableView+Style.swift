//
//  UITableView+Style.swift
//  EasyLife
//
//  Created by Lee Arromba on 13/04/2017.
//  Copyright © 2017 Pink Chicken Ltd. All rights reserved.
//

import UIKit

extension UITableView {
    func applyDefaultStyleFix() {
        switch style {
        case .grouped:
            tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 1.0))
        case .plain:
            tableFooterView = UIView()
        }
    }
}
