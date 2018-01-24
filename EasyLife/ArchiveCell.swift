//
//  ArchiveCell.swift
//  EasyLife
//
//  Created by Lee Arromba on 12/04/2017.
//  Copyright © 2017 Pink Chicken Ltd. All rights reserved.
//

import UIKit

class ArchiveCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: TodoItem? {
        didSet {
            if let name = item?.name, !name.isEmpty {
                titleLabel.text = item?.name
                titleLabel.textColor = .black
                return
            }
            titleLabel.text = "[no name]".localized
            titleLabel.textColor = .appleGrey
        }
    }
}
