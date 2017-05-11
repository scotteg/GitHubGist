//
//  CellBackground.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/11/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import UIKit

@IBDesignable final class CellBackground: UIView {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
