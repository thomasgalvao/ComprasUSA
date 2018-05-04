//
//  ProductTableViewCell.swift
//  ThomasGalvao
//
//  Created by Thomas Galvão on 25/04/2018.
//  Copyright © 2018 Thomas Galvao. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDollar: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func prepare(with product: Products) {
        lbTitle.text = product.title ?? ""
        lbDollar.text = String(product.dollar)
        
        if let image = product.cover as? UIImage{
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "cover")
        }
    }

}