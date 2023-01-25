//
//  AlbumCell.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 15.01.2023.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumLogo: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
