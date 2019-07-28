//
//  TweetTableViewCell.swift
//  Combine-Debounce
//
//  Created by Sagar More on 27/07/19.
//  Copyright © 2019 Sagar More. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblTweet : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = imgView.bounds.size.height / 2
        imgView.clipsToBounds = true
    }

    func setupUI(_ data : Tweet) {
        lblName.text = data.user.name
        lblTweet.text = data.text
        ImageService.getImageWith(data.user.profileImageUrl.replacingOccurrences(of: "http", with: "https")) { [weak self] (img) in
            self?.imgView.image = img
        }
    }

}
