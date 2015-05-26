//
//  ProductViewCell.swift
//  iReserve
//
//  Created by Manuela Bezerra on 10/05/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//


import Parse
import ParseUI

class ProductViewCell: PFTableViewCell {
    
    
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var descLabel: UILabel!

    @IBOutlet var priceLabel: UILabel!

    @IBOutlet var reservarButton: UIButton!


    @IBOutlet var reservadoLabel: UILabel!
    
    
    var productId: String!
    
}