//
//  GistCell.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/11/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import UIKit

final class GistCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var filenameLabel: UILabel!
    @IBOutlet weak var ownerAndCreatedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsBubble: CommentsBubble!
}
