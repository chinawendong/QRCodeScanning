//
//  ButtonCell.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/22.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var labelButton: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func ButtonCells(tableView : UITableView, indexPath: NSIndexPath, identifier : String, title : String) -> ButtonCell {
        let cell = (tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ButtonCell)
        cell.labelButton.text = title
        return cell
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
