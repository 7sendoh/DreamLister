//
//  ItemCell.swift
//  DreamLister2
//
//  Created by Ping Li on 2016-12-17.
//  Copyright © 2016 Ping Li. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var itemType: UILabel!
    
    func configureCell(item: Item) {
        title.text = item.title
        price.text = "@\(item.price)"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
        itemType.text = item.toItemType?.type
    }
}
