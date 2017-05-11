//
//  CommentsBubble.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/11/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import UIKit

@IBDesignable final class CommentsBubble: UIView {
    
    @IBInspectable var count: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        GitHubGistStyleKit.drawCommentsBubble(frame: rect, resizing: GitHubGistStyleKit.ResizingBehavior.center, number: "\(count)")
    }
}
