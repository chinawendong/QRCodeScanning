//
//  GroupPhotoCell.swift
//  PhotoSelectorProductSwift
//
//  Created by 云族佳 on 16/4/25.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

import UIKit

enum GroupPhotoCellImageType {
    case Select
    case Nome
}

class GroupPhotoCell: UICollectionViewCell {

//    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var imageV: UIImageView!
    var selectImageBlock : (()->Void)?
    
    var selectType : GroupPhotoCellImageType?
//    {
//        didSet {
//            switch self.selectType! {
//            case .Nome:
//                self.selectImage.image = UIImage.init(named: "Unknown")
//            case .Select:
//                self.selectImage.image = UIImage.init(named: "Unknown-1")
//            default:
//                break
//            }
//        }
//    }
    
    func SelectImageBlock() {
        self.selectImageBlock?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectButton(sender: AnyObject) {
        if self.selectType == .Nome {
            self.selectType = .Select
        }else {
            self.selectType = .Nome
        }
        self.SelectImageBlock()
    }
}
